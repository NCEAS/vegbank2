# VegBank API Authorization and Authentication

## Table of Contents

- [For API Users](#for-api-users)
  - [Authorization Scopes](#authorization-scopes)
  - [Obtaining a Token](#obtaining-a-token)
  - [Using Your Token](#using-your-token)
  - [Refreshing Your Token](#refreshing-your-token)
  - [Example Requests](#example-requests)
- [For Developers](#for-developers)
  - [Environment Configuration](#environment-configuration)
  - [Protecting Endpoints](#protecting-endpoints)

---

## For API Users

### Authorization Scopes

VegBank API uses three authorization scopes that determine what operations user can perform:

| Scope | Purpose | Operations |
|-------|---------|-----------|
| `vegbank:user` | Create/update datasets | Create/update datasets from existing vegbank observations|
| `vegbank:contributor` | Create/update access | Upload new data, submit plot observations, create new records |
| `vegbank:admin` | Administrative access | All operations, including administrative functions |

When you authenticate, you may request one or more scopes to be included in your OIDC token. These scopes then determine the levels of access you have for the various Vegbank API methods.

#### Overview

VegBank API uses OAuth 2.0 with OpenID Connect (OIDC) for secure authentication and authorization. When you log in, you receive a token that grants you access to specific API operations based on your requested scopes. For more information on these standards, see the [OAuth 2.0 Authorization Framework](https://tools.ietf.org/html/rfc6749) and [OpenID Connect Core documentation](https://openid.net/specs/openid-connect-core-1_0.html).


### Obtaining a Token

VegBank uses Keycloak for token management. To obtain a token:

#### Log In via ORCID

Visit the VegBank [login endpoint](https://api.vegbank.org/login), and it will redirect you to the ORCID authentication page. Login with your ORCID credentials.

#### Response

On success (`200 OK`):

```json
{
  "message": "Authorization successful",
  "token": {
    "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI..."
  }
}
```

Store both tokens. The `access_token` is used for API requests and has a short expiry. The `refresh_token` is long-lived and can be used to obtain a new access token without logging in again (see [Refreshing Your Token](#refreshing-your-token)).

**Error responses:**

| Status | Cause |
|--------|-------|
| `401` | Authentication failed   |
| `500` | Unexpected server error |

### Using Your Token

Include your token in the `Authorization` header of your requests to api.vegbank.org:

```http
Authorization: Bearer <YOUR_TOKEN_HERE>
```

### Refreshing Your Token

Access tokens are short-lived. When your access token expires, use the `POST /refresh` endpoint to obtain a new access token and refresh token without requiring the user to log in again.

#### Request

```bash
curl -s -L -X POST 'https://api.vegbank.org/refresh' \
  -H "Content-Type: application/json" \
  -d "{
    \"refresh_token\": \"${REFRESH}\",
    \"scope\": \"openid web-origins acr offline_access profile basic email vegbank:contributor vegbank:user\"
  }"
```

**Request body (JSON):**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `refresh_token` | string | Yes | The refresh token returned from `/login` or a previous `/refresh` call |
| `scope` | string | No | Space-separated list of scopes for the new access token. If no scopes are provided, the new access token will have the same scopes as the original token. The requested scopes must match or be a subset of the original scopes granted. |

> **Note:** In most cases, you can safely omit the `scope` parameter. The OIDC provider will reissue the token with the same scopes that were originally granted, which is typically the desired behavior. 

#### Response

On success (`200 OK`):

```json
{
  "message": "Authorization successful",
  "token": {
    "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI..."
  }
}
```

Replace your stored tokens with the new values returned. Because each refresh token can only be used once, each refresh call issues a new refresh token, and so the old one must be discarded.

**Error responses:**

| Status | Cause |
|--------|-------|
| `400` | `refresh_token` field missing from the request body |
| `401` | Refresh token is invalid, expired, or revoked; or client authentication failed |
| `500` | Unexpected server error |

### Example Requests

#### Create/Upload Access (vegbank:contributor scope)

Upload new plot observations (requires `vegbank:contributor` scope):

```bash
curl -X POST \
  -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI..." \
  -F "plot_observations=@plot_data.parquet" \
  https://api.vegbank.org/plot-observations
```

#### Retrieve Plot Observations
```bash
curl -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI..." \
  https://api.vegbank.org/plot-observations
```

---

## For Developers


### Environment Configuration

To enable auth support we require the following environment variables. See [helm/admin/secret-oidc.yaml](helm/admin/secret-oidc.yaml) and [helm/admin/secret-flask.yaml](helm/admin/secret-flask.yaml) for more details.

```bash
# Flask secret key
FLASK_SECRET_KEY=your-secret-key

# OIDC/Keycloak configuration
OIDC_CLIENT_SECRETS_FILE=/path/to/client_secrets.json
```

#### Client Secrets File format

The `client_secrets.json` file is required for communication with the OIDC provider. 

```json
{
  "client_id": "vegbank-api-client",
  "client_secret": "your-client-secret-from-keycloak",
  "server_metadata_url": "https://auth.vegbank.org/auth/realms/vegbank/.well-known/openid-configuration",
  "scope_request": "openid email profile vegbank:admin vegbank:contributor vegbank:user"
}
```

The `server_metadata_url` tells the system where to find OIDC keys, token endpoints, and other config.


### Protecting Endpoints

#### Using `@require_token`

Protects an endpoint to require any valid, unexpired JWT:

```python
from vegbank.auth import require_token

@app.route("/taxon-observations", defaults={'vb_code': None}, methods=['GET', 'POST'])
@require_token
def taxon_observations(claims, vb_code):
    """
    Facilitates retrieving and uploading of new taxon observations
    """
```

#### Using `@require_scope(scope)`

Protects an endpoint to require a valid token and a specific scope:

```python
from vegbank.auth import require_scope, SCOPE_CONTRIBUTOR, SCOPE_ADMIN

@app.route("/taxon-observations", defaults={'vb_code': None}, methods=['GET', 'POST'])
@require_scope(SCOPE_CONTRIBUTOR)
def taxon_observations(claims, vb_code):
    """
    Facilitates retrieving and uploading of new taxon observations
    """
```

#### Using `@require_scope(scope, methods)`

Protects specific HTTP methods for an endpoint that require a valid token and a specific scope:

```python
from vegbank.auth import require_scope, SCOPE_CONTRIBUTOR, SCOPE_ADMIN

@app.route("/taxon-observations", defaults={'vb_code': None}, methods=['GET', 'POST'])
@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])
def taxon_observations(claims, vb_code):
    """
    Facilitates retrieving and uploading of new taxon observations
    """
```
The require scope only applies to the list of HTTP methods passed to the decorator. If no methods are passed the scope requirement is applied to all methods. 

## Support

For questions or issues with the API authorization:

- Check the [VegBank GitHub Issues](https://github.com/NCEAS/vegbank2/issues)
- Ask questions in [VegBank Discussions](https://github.com/NCEAS/vegbank2/discussions)
- Email help@vegbank.org
