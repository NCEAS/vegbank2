"""Authentication module for the VegBank API.

Implements OIDC / OAuth 2.0 login via Keycloak using authlib.
"""

import json
import os

from authlib.integrations.flask_client import OAuth
from flask import Blueprint

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

# Placeholder routes for the OIDC login flow.
@auth_bp.route("/login", methods=["GET"])
def login():
    """Initiate the OIDC login flow. (TODO: implement)"""
    raise NotImplementedError

# This is the callback endpoint that Keycloak will redirect to after authentication.
@auth_bp.route("/authorize", methods=["GET"])
def authorize():
    """OIDC authorization callback. (TODO: implement)"""
    raise NotImplementedError
