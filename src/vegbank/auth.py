"""Authentication module for the VegBank API.

Implements OIDC / OAuth 2.0 login via a configurable OIDC provider using authlib.

Deployment Modes
----------------
The API supports three access modes controlled by the ``VB_ACCESS_MODE`` environment variable:

``read_only``
    Authentication disabled. All endpoints are public. File uploads disabled.

``open``
    Authentication disabled. All endpoints are public. File uploads allowed.

``authenticated``
    Full authentication and authorization enabled. Protected endpoints require valid JWT tokens with appropriate scopes.

Decorator overview
--------------------------------------------------
``require_token``
    Protects an endpoint that requires *any* valid, unexpired JWT issued by
    the configured OIDC provider.

``require_scope(scope)``
    Same as ``require_token`` but additionally asserts that the token contains the
    correct Vegbank scope (e.g. ``"vegbank:admin"``, ``"vegbank:contributor"``,
    ``"vegbank:user"``).

"""

import functools
import json
import os
import logging
from requests import RequestException

import requests as _requests

from authlib.integrations.base_client.errors import OAuthError
from authlib.integrations.flask_client import OAuth
from authlib.jose import JsonWebKey, jwt
from authlib.jose.errors import BadSignatureError, DecodeError, InvalidTokenError
from authlib.oauth2 import OAuth2Error
from authlib.oauth2.rfc6749.errors import InvalidGrantError, InvalidClientError

from flask import Blueprint, g, jsonify, request, session, url_for
from werkzeug.middleware.proxy_fix import ProxyFix

_DEFAULT_SECRETS_PATH = "/etc/vegbank/oidc/client_secrets.json"
MAX_TOKEN_LEN = 16_384  # Token length limit in characters (~16 KB) to prevent DoS attacks

class MissingParameterError(Exception):
    """Raised when a required request parameter is missing."""

# VegBank-specific scopes
SCOPE_ADMIN = "vegbank:admin"
SCOPE_CONTRIBUTOR = "vegbank:contributor"
SCOPE_USER = "vegbank:user"

# Deployment modes
ACCESS_MODE_READ_ONLY = "read_only"       # Read-only mode: no uploads, no auth
ACCESS_MODE_OPEN = "open"                 # Open mode: uploads allowed, no auth
ACCESS_MODE_AUTHENTICATED = "authenticated"  # Authenticated mode: auth required, full access control

# Initialize module-level logger
logger = logging.getLogger(__name__)

oauth = OAuth()
auth_bp = Blueprint("auth", __name__)


def load_client_secrets(filepath: str | None = None) -> dict:
    """Load client secrets from a JSON file.

    Args:
        filepath: Optional explicit path. Falls back to the
                    ``OIDC_CLIENT_SECRETS_FILE`` environment variable

    Returns:
        Parsed dict of client credentials.
    """
    # accept either explicit filepath argument or environment variable, with a default fallback
    resolved = (
        filepath
        or os.getenv("OIDC_CLIENT_SECRETS_FILE")
        or _DEFAULT_SECRETS_PATH
    )
    with open(resolved, "r") as f:
        return json.load(f)


def init_oauth(app) -> bool:
    """Initialise the OAuth client and register the OIDC provider.

    Call once at app startup, after creating the Flask instance.

    Args:
        app: The Flask application instance.

    Returns:
        True on success, False if the secrets file is missing (auth unavailable).
    """
    # In read_only or open mode, skip OAuth initialization
    mode = get_access_mode()
    if mode != ACCESS_MODE_AUTHENTICATED:
        logger.warning("Access mode '%s': skipping OAuth initialisation.", mode)
        return True

    try:
        secrets = load_client_secrets()
    except (FileNotFoundError, json.JSONDecodeError) as exc:
        logger.warning("Could not load client secrets (%s). Auth unavailable.", exc)
        return False

    # Trust X-Forwarded-Proto / X-Forwarded-Host headers injected by nginx
    # so Flask builds correct https:// redirect URIs behind the ingress.
    # Only apply ProxyFix once to avoid nested wrapping.
    if not isinstance(app.wsgi_app, ProxyFix):
        app.wsgi_app = ProxyFix(app.wsgi_app, x_proto=1, x_host=1)

    oauth.init_app(app)
    oauth.register(
        name="vegbank_oidc",
        client_id=secrets.get("client_id"),
        client_secret=secrets.get("client_secret"),
        server_metadata_url=secrets.get("server_metadata_url"),
        client_kwargs={"scope": secrets.get("scope_request", "openid email profile vegbank:admin vegbank:contributor vegbank:user")},
    )

    logger.info("OAuth client initialised.")
    return True


@functools.lru_cache(maxsize=1)
def get_jwks_keys():
    """Fetch and cache the JWKS signing keys from the OIDC provider.

    These keys are used to validate JWT token signatures. Care must be taken to fetch
    them only from trustworthy sources (via the OIDC provider's metadata endpoint over
    HTTPS). The keys may change periodically, so the cache will be invalidated and keys
    will be refetched on the next call after the application is restarted.

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
        token = auth_header[7:]

        # caps the token length to prevent huge tokens from causing DoS issues in downstream processing.
        if len(token) > MAX_TOKEN_LEN:
            return None       # triggers 401
        return token
    return None


def _decode_and_validate_token(token_str: str):
    """Decode *and* full-validate a JWT against the OIDC provider's JWKS.

    Validates signature, issuer (``iss``), audience (``aud``), and authorized-party (``azp``) claims.

    Args:
        token_str: Raw JWT string

    Returns:
        The validated claims object.

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

    client_id = load_client_secrets().get("client_id")

    claims = jwt.decode(
        token_str,
        jwks,
        claims_options={
            "iss": {"essential": True, "value": issuer},
            "aud": {"essential": True, "value": client_id},
            "azp": {"essential": True, "value": client_id},
        },
    )
    claims.validate()
    return claims


def _auth_error_response(message, status, details=None):
    """Generate a uniform JSON error response for authentication/authorization errors.

    All auth-related error responses should use this helper to guarantee a consistent ``{"error": {"message": ..., "details": ...}}`` object.

    Args:
        message: Error description.
        status: HTTP status code.
        details: Optional additional context (``str(exc)``).  Omitted from the response when *None*.

    Returns:
        Tuple of (JSON response, status code).
    """
    error = {"message": message}
    if details is not None:
        error["details"] = details
    return jsonify({"error": error}), status


def _token_error_response(exc):
    """Produce a uniform JSON error response for token validation/exchange failures."""
    error_map = {
        DecodeError: ("Token decoding failed", 401),
        InvalidClientError: ("OIDC client authentication failed", 401),
        InvalidTokenError: ("Token validation failed", 401),
        InvalidGrantError: ("Invalid or expired refresh token", 401),
        BadSignatureError: ("Token signature verification failed", 401),
        OAuthError: ("Authorization failed", 401),
        OAuth2Error: ("An OAuth2 error occurred", 401),
        KeyError: ("Invalid token structure", 401),
        TypeError: ("Invalid token structure", 401),
        MissingParameterError: ("Missing required parameter", 400),
        ValueError: ("OIDC provider configuration error", 500),
        _requests.RequestException: ("Failed to fetch OIDC provider keys", 502),
    }
    for exc_types, (message, status) in error_map.items():
        if isinstance(exc, exc_types):
            return _auth_error_response(message, status, details=str(exc))
    # Unexpected exception — treat as server error
    return _auth_error_response("Internal authentication error", 500, details=str(exc))


def _token_response(token: dict, message: str = "Token exchange successful"):
    """Produce a uniform JSON response with access and refresh tokens.
    
    Args:
        token: Dict containing token data with 'access_token' and 'refresh_token' keys.
        message: Optional message to include in response.
        
    Returns:
        Tuple of (JSON response, 200 status code).
    """
    return (
        jsonify(
            {
                "message": message,
                "token": {
                    "access_token": token.get("access_token"),
                    "refresh_token": token.get("refresh_token"),
                },
            }
        ),
        200,
    )


def _store_user_context(claims):
    """Store decoded token claims in request and session context."""
    g.token_claims = claims
    session["userinfo"] = {
        "sub": claims.get("sub"),
        "preferred_username": claims.get("preferred_username"),
        "email": claims.get("email"),
        "name": claims.get("name"),
    }


def _validate_and_extract_claims(required_scope=None):
    """Validate bearer token and optionally check required scope.
    
    Args:
        required_scope: Optional scope string to validate.
        
    Returns:
        Tuple of (claims_dict, error_response_tuple) where error_response_tuple is None on success.
    """
    token_str = _extract_bearer_token()
    if not token_str:
        return None, _auth_error_response("Missing or invalid Authorization header", 401)

    try:
        claims = _decode_and_validate_token(token_str)
    except (DecodeError, InvalidTokenError, BadSignatureError, ValueError, RequestException) as exc:
        return None, _token_error_response(exc)
    
    # Scope check if required
    if required_scope:
        token_scopes = claims.get("scope", "").split()
        if required_scope not in token_scopes:
            return None, _auth_error_response(
                f"Insufficient scope. Required: {required_scope}",
                403,
                details=f"Available scopes: {' '.join(token_scopes)}",
            )
    
    return claims, None



def require_token(methods=None):
    """Decorator – protect an endpoint that requires *any* valid JWT.

    **Only enforces authentication when accessMode='authenticated'.**
    In 'read_only' and 'open' modes, this decorator allows all requests.

    Returns ``401`` if the token is missing, expired, or otherwise invalid.
    
    Can enforce auth on specific HTTP methods only. If ``methods`` is None,
    protects all methods.

    Args:
        methods: Optional list of HTTP method names (e.g., ``['POST', 'PUT', 'DELETE']``) to protect.
                 If None, all methods are protected.
                 If the current request method is not in the list, auth is skipped.

    Example:
        ``@require_token(methods=['POST', 'PUT', 'DELETE'])`` – only protect write operations
    """
    def decorator(f):
        @functools.wraps(f)
        def decorated(*args, **kwargs):
            mode = get_access_mode()
            
            # In read_only or open mode, skip auth entirely
            if mode != ACCESS_MODE_AUTHENTICATED:
                logger.warning("Access mode '%s': skipping token validation", mode)
                return f(None, *args, **kwargs)
            
            # If methods are specified, only enforce auth for those methods
            if methods is not None and request.method not in methods:
                # No auth required for this method; pass None as claims
                return f(None, *args, **kwargs)
            
            claims, error = _validate_and_extract_claims()
            if error:
                return error

            _store_user_context(claims)
            return f(claims, *args, **kwargs)

        return decorated

    return decorator


def require_scope(required_scope: str, methods=None):
    """Decorator factory – protect an endpoint that requires a specific scope.

    **Only enforces authorization when accessMode='authenticated'.**
    In 'read_only' and 'open' modes, this decorator allows all requests.

    Supported VegBank scopes:

    * ``vegbank:admin``       – admin ops
    * ``vegbank:contributor`` – create/update access for vegbank data
    * ``vegbank:user``        – create/update access for user datasets

    Returns ``401`` for missing / invalid tokens, ``403`` if the required scope
    is absent from the token.
    
    Can enforce auth on specific HTTP methods only. If ``methods`` is None,
    protects all methods.

    **Claims Parameter Injection:**
    
    This decorator injects a ``claims`` keyword argument into wrapped functions.
    The ``claims`` dict contains user info (e.g., preferred_username, email, scopes)
    extracted from the JWT token. Claims are only populated in 'authenticated' mode;
    in other modes, claims is None. Route handlers that need audit logging should
    accept a ``claims=None`` parameter and check it before use.

    Args:
        required_scope: Valid OAuth 2.0 scope string that must be present in the token's ``scope`` claim.
        methods: Optional list of HTTP method names (e.g., ``['POST', 'PUT', 'DELETE']``) to protect.
                 If None, all methods are protected.
                 If the current request method is not in the list, auth is skipped.

    Example:
        ``@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])`` – only protect POST operations
        
    Handler Example:
        ``def my_handler(vb_code, claims=None):`` – claims are injected as kwargs
    """
    def decorator(f):
        @functools.wraps(f)
        def decorated(*args, **kwargs):
            mode = get_access_mode()
            
            # In read_only or open mode, skip auth entirely
            if mode != ACCESS_MODE_AUTHENTICATED:
                logger.warning("Access mode '%s': skipping scope validation", mode)
                # Store None in g for consistency
                g.token_claims = None
                return f(*args, **kwargs)
            
            # If methods are specified, only enforce auth for those methods
            if methods is not None and request.method not in methods:
                # No auth required for this method; store None as claims
                g.token_claims = None
                return f(*args, **kwargs)
            
            claims, error = _validate_and_extract_claims(required_scope=required_scope)
            if error:
                return error

            _store_user_context(claims)
            # Pass claims as keyword argument for explicit access in handlers
            kwargs['claims'] = claims
            return f(*args, **kwargs)

        return decorated

    return decorator


@auth_bp.route("/login", methods=["GET"])
def login():
    """Initiate the OIDC login flow.

    Sends the user to the provider's login page. After successful
    authentication the provider redirects back to the ``/authorize``
    callback.

    Args:
        (None)

    Returns:
        302 redirect to the provider's authorization endpoint.
        401/500 JSON error response if login fails.
        403 JSON response if authentication is disabled for the current access mode.

    """
    mode = get_access_mode()
    if mode != ACCESS_MODE_AUTHENTICATED:
        return _auth_error_response(f"Authentication is disabled in '{mode}' mode.", 403)

    try:
        return oauth.vegbank_oidc.authorize_redirect(url_for("main.auth.authorize", _external=True))
    except (OAuthError, RequestException) as exc:
        logger.warning("OIDC authorize_redirect error: %s", exc)
        return _token_error_response(exc)


@auth_bp.route("/authorize", methods=["GET"])
def authorize():
    """OIDC authorization callback endpoint.

    Keycloak redirects here after a successful login with a short-lived
    authorization code. This endpoint exchanges that code for an access
    token, stores the token and returns it to the caller.

    Returns:
        200 JSON with ``token`` on success.
        401 JSON with error details on failure.
        403 JSON response if authentication is disabled for the current access mode.
    """
    mode = get_access_mode()
    if mode != ACCESS_MODE_AUTHENTICATED:
        return _auth_error_response(f"Authentication is disabled in '{mode}' mode.", 403)

    try:
        token = oauth.vegbank_oidc.authorize_access_token()
    except (OAuthError, RequestException) as exc:
        logger.debug("OIDC token exchange error: %s", exc)
        return _token_error_response(exc)

    return _token_response(token, message="Authorization successful")


@auth_bp.route("/refresh", methods=["POST"])
def refresh_token():
    """Re-validate the user session and return a new access token using the refresh token.

    When an access token expires, the client can call this endpoint with the refresh token 
    to obtain a new access token without requiring the user to log in again. The client 
    can also pass the desired scopes for the new access token, which must be a subset 
    of the original scopes granted to the refresh token.

    Parameters (in JSON body):
    - ``refresh_token`` (string, required): The refresh token issued by the OIDC provider.
    - ``scope`` (string, optional): Space-separated list of scopes to request for the new access token. If omitted, the new access token will have the same scopes as the original token.

    Returns:
    200 JSON with new ``access_token`` and ``refresh_token`` on success.
    400 JSON if the request is missing required parameters.
    401 JSON if the refresh token is invalid, expired, or if client authentication fails.
    500 JSON for unexpected server errors.
    """
    # Get the refresh token and desired scopes from the JSON body
    data = request.get_json(silent=True)
    if not data:
        return _token_error_response(MissingParameterError("refresh_token"))

    user_refresh_token = data.get("refresh_token")
    if not user_refresh_token:
        return _token_error_response(MissingParameterError("refresh_token"))

    # The client should pass the scopes that it would like to request for the
    # new access token. If no scopes are provided, we will attempt to get a
    # new access token with the same scopes as the original token. The
    # requested scopes must match or be a subset of the original scopes granted
    # to the token, otherwise the OIDC provider will reject the request.
    requested_scope = data.get("scope")

    # Use Authlib to exchange the refresh token for a new access token
    try:
        if not requested_scope:
            # If no scope is provided, omit the scope parameter to get the same scopes as the original token
            new_tokens = oauth.vegbank_oidc.fetch_access_token(
                grant_type="refresh_token",
                refresh_token=user_refresh_token,
            )
        else:
            new_tokens = oauth.vegbank_oidc.fetch_access_token(
                grant_type="refresh_token",
                refresh_token=user_refresh_token,
                scope=requested_scope,
            )
        return _token_response(new_tokens, message="Authorization successful")
    except InvalidGrantError as exc:
        # The refresh token was invalid, expired, or revoked by the provider
        logger.debug("The refresh token is invalid or expired: %s", exc)
        return _token_error_response(exc)
    except InvalidClientError as exc:
        # The client_id or client_secret is wrong
        logger.warning("OIDC client authentication failed: %s", exc)
        return _token_error_response(exc)
    except OAuth2Error as exc:
        logger.debug("An OAuth2 error occurred: %s", exc)
        return _token_error_response(exc)
    except Exception as exc:
        # A safety net for non-OAuth errors (e.g., network issues)
        logger.error("Unexpected Exception during refresh: %s", exc, exc_info=True)
        return _token_error_response(exc)


def get_access_mode() -> str:
    """Get the current access mode from environment.
    
    Returns:
        str: One of 'read_only', 'open', or 'authenticated'. Defaults to 'authenticated'.
    """
    mode = os.getenv("VB_ACCESS_MODE", ACCESS_MODE_AUTHENTICATED).lower()
    if mode not in (ACCESS_MODE_READ_ONLY, ACCESS_MODE_OPEN, ACCESS_MODE_AUTHENTICATED):
        logger.warning(f"Invalid access mode '{mode}', falling back to '{ACCESS_MODE_AUTHENTICATED}'")
        return ACCESS_MODE_AUTHENTICATED
    return mode