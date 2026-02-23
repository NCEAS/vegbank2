"""Authentication module for the VegBank API.

Implements OIDC / OAuth 2.0 login via Keycloak using authlib.

Decorator overview
------------------
``require_token``
    Protects an endpoint that requires *any* valid, unexpired JWT issued by Keycloak.
"""

import functools
import json
import os

import requests as _requests

from authlib.integrations.flask_client import OAuth
from authlib.jose import JsonWebKey, jwt
from authlib.jose.errors import BadSignatureError, DecodeError, InvalidTokenError
from flask import Blueprint, g, jsonify, request, session, url_for
from werkzeug.middleware.proxy_fix import ProxyFix

_DEFAULT_SECRETS_PATH = "/etc/vegbank/oidc/client_secrets.json"

oauth = OAuth()
auth_bp = Blueprint("auth", __name__)


# Loading client secrets from file
def load_client_secrets(filepath: str | None = None) -> dict:
    """Load client secrets from a JSON file.

    Args:
        filepath: Optional explicit path. Falls back to KEYCLOAK_CLIENT_SECRETS_FILE
                    env var, then the default Kubernetes mount path.

    Returns:
        Parsed dict of client credentials.
    """
    resolved = filepath or os.getenv("KEYCLOAK_CLIENT_SECRETS_FILE", _DEFAULT_SECRETS_PATH)
    with open(resolved, "r") as f:
        return json.load(f)


# Initialize the OAuth client and register the OIDC provider
def init_oauth(app) -> bool:
    """Initialise the OAuth client and register the OIDC provider.

    Call once at app startup, after creating the Flask instance.

    Args:
        app: The Flask application instance.

    Returns:
        True on success, False if the secrets file is missing (auth unavailable).
    """
    try:
        secrets = load_client_secrets()
    except (FileNotFoundError, json.JSONDecodeError) as exc:
        print(f"[auth] WARNING: Could not load client secrets ({exc}). Auth unavailable.")
        return False

    # Trust X-Forwarded-Proto / X-Forwarded-Host headers injected by nginx
    # so Flask builds correct https:// redirect URIs behind the ingress.
    app.wsgi_app = ProxyFix(app.wsgi_app, x_proto=1, x_host=1)

    oauth.init_app(app)
    oauth.register(
        name="vegbank_oidc",
        client_id=secrets.get("client_id"),
        client_secret=secrets.get("client_secret"),
        server_metadata_url=secrets.get("server_metadata_url"),
        client_kwargs={"scope": secrets.get("scope_request", "openid email")},
    )

    print("[auth] OAuth client initialised.")
    return True


@functools.lru_cache(maxsize=1)
def get_jwks_keys():
    """Fetch and cache the JWKS signing keys from the OIDC provider.

    Returns:
        authlib.jose.JsonWebKey: A ``JsonWebKeySet`` ready for ``jwt.decode``.

    Raises:
        ValueError: If the OIDC server metadata does not expose a ``jwks_uri``.
        requests.RequestException: If errors while fetching the JWKS.
    """
    metadata = oauth.vegbank_oidc.load_server_metadata()
    jwks_uri = metadata.get("jwks_uri")
    if not jwks_uri:
        raise ValueError("OIDC provider metadata does not contain 'jwks_uri'")

    response = _requests.get(jwks_uri, timeout=10)
    response.raise_for_status()
    return JsonWebKey.import_key_set(response.json())


def _extract_bearer_token():
    """Extract the raw JWT string from the 
    ``Authorization: Bearer …`` header.

    Returns:
        str | None: The token string, or ``None`` if the header is absent / malformed.
    """
    auth_header = request.headers.get("Authorization", "")
    if auth_header.startswith("Bearer "):
        return auth_header[7:]
    return None


def _decode_and_validate_token(token_str: str) -> dict:
    """Decode *and* full-validate a JWT against the OIDC provider's JWKS.

    Validates signature, issuer (``iss``), and authorized-party (``azp``) claims.

    Args:
        token_str: Raw JWT string

    Returns:
        The validated claims dict.

    Raises:
        DecodeError: Token could not be decoded.
        InvalidTokenError: Signature is valid but one or more claims are
            invalid (such as expired tokens).
        BadSignatureError: JWKS signature verification failed.
        ValueError: ``jwks_uri`` missing from OIDC metadata.
        requests.RequestException: Network / HTTP error fetching JWKS.
    """
    jwks = get_jwks_keys()
    metadata = oauth.vegbank_oidc.load_server_metadata()
    issuer = metadata.get("issuer")

    # load_client_secrets is cheap (file read) but we only need client_id.
    secrets = load_client_secrets()

    claims = jwt.decode(
        token_str,
        jwks,
        claims_options={
            "iss": {"essential": True, "value": issuer},
            "azp": {"essential": True, "value": secrets.get("client_id")},
        },
    )
    claims.validate()
    return claims


def _token_error_response(exc):
    """Produce a uniform JSON error response for token validation failures."""
    error_map = {
        DecodeError: ("Token decoding failed", 401),
        InvalidTokenError: ("Token validation failed", 401),
        BadSignatureError: ("Token signature verification failed", 401),
        ValueError: ("OIDC provider configuration error", 500),
        _requests.RequestException: ("Failed to fetch OIDC provider keys", 502),
        (KeyError, TypeError): ("Invalid token structure", 401),
    }
    for exc_types, (message, status) in error_map.items():
        if isinstance(exc, exc_types):
            return jsonify({"error": message, "details": str(exc)}), status
    # Unexpected exception — treat as server error
    return jsonify({"error": "Internal authentication error", "details": str(exc)}), 500



def require_token(f):
    """Decorator – protect an endpoint that requires *any* valid JWT.

    Returns ``401`` if the token is missing, expired, or otherwise invalid.
    """
    @functools.wraps(f)
    def decorated(*args, **kwargs):
        token_str = _extract_bearer_token()
        if not token_str:
            return jsonify({"error": "Missing or invalid Authorization header"}), 401

        try:
            claims = _decode_and_validate_token(token_str)
        except Exception as exc:  # pylint: disable=broad-except
            return _token_error_response(exc)

        # Store in request-scoped context for downstream helpers
        g.token_claims = claims
        # Sync a lightweight subset into session for browser-based flows
        session["userinfo"] = {
            "sub": claims.get("sub"),
            "preferred_username": claims.get("preferred_username"),
            "email": claims.get("email"),
            "name": claims.get("name"),
        }
        return f(claims, *args, **kwargs)

    return decorated


@auth_bp.route("/login", methods=["GET"])
def login():
    """Initiate the OIDC login flow.

    Redirects the user to the Keycloak login page. After successful
    authentication, Keycloak redirects back to the /authorize callback.

    The redirect URI can be set explicitly via the ``OIDC_REDIRECT_URI``

    Returns:
        302 redirect to the Keycloak login page.
    """
    redirect_uri = os.getenv("OIDC_REDIRECT_URI") or url_for("auth.authorize", _external=True)
    return oauth.vegbank_oidc.authorize_redirect(redirect_uri)


@auth_bp.route("/authorize", methods=["GET"])
def authorize():
    """OIDC authorization callback endpoint.

    Keycloak redirects here after a successful login with a short-lived
    authorization code. This endpoint exchanges that code for an access
    token, stores both the token and the user-info claims in the session,
    and returns them to the caller.

    Returns:
        200 JSON with ``token`` and ``userinfo`` on success.
        401 JSON with error details on failure.
    """
    try:
        token = oauth.vegbank_oidc.authorize_access_token()
    except Exception as exc:  # pylint: disable=broad-except
        return jsonify({"error": "Authorization failed", "details": str(exc)}), 401

    session["token"] = token
    session["userinfo"] = token.get("userinfo", {})

    return (
        jsonify(
            {
                "message": "Authorization successful",
                "userinfo": session["userinfo"],
                "token": {
                    "access_token": token.get("access_token"),
                    "token_type": token.get("token_type"),
                    "refresh_token": token.get("refresh_token"),
                    "expires_in": token.get("expires_in"),
                    "scope": token.get("scope"),
                },
            }
        ),
        200,
    )
