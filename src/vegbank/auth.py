"""Authentication module for the VegBank API.

Implements OIDC / OAuth 2.0 login via Keycloak using authlib.
"""

import json
import os
import logging
from requests import RequestException

from authlib.integrations.base_client.errors import OAuthError
from authlib.integrations.flask_client import OAuth

from flask import Blueprint, jsonify, session, url_for
from werkzeug.middleware.proxy_fix import ProxyFix

_DEFAULT_SECRETS_PATH = "/etc/vegbank/oidc/client_secrets.json"

oauth = OAuth()
auth_bp = Blueprint("auth", __name__)

# Initialize  module-level logger
logger = logging.getLogger(__name__)


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
        logger.warning("Could not load client secrets (%s). Auth unavailable.", exc)
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

    logger.info("OAuth client initialised.")
    return True

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
    except (OAuthError, RequestException) as exc:
        logger.warning("OIDC token exchange error: %s", exc)
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
