# VegBank API Authorization and Authentication

## Table of Contents

- [For API Users](#for-api-users)
  - [Authentication Scopes](#authentication-scopes)
  - [Obtaining a Token](#obtaining-a-token)
  - [Using Your Token](#using-your-token)
  - [Example Requests](#example-requests)
- [For Developers](#for-developers)
  - [Environment Configuration](#environment-configuration)
  - [Protecting Endpoints](#protecting-endpoints)

---

## For API Users

### Authentication Scopes

VegBank API uses three authorization scopes that determine what operations user can perform:

| Scope | Purpose | Operations |
|-------|---------|-----------|
| `vegbank:user` | Create/update datasets | Create/update datasets from existing vegbank observations|
| `vegbank:contributor` | Create/update access | Upload new data, submit plot observations, create new records |
| `vegbank:admin` | Administrative access | All operations, including administrative functions |

Your token can contain one or more scopes, granting you highest level of access associated with your scopes.

### Obtaining a Token

VegBank uses Keycloak for token management. To obtain a token:

#### Log In via ORCID

Visit the VegBank [login endpoint](https://api.vegbank.org/login), and it will redirect you to ORCID authentication page. Login with your ORCID credentials. Once login is successful you'll receive a JSON response containing your OAuth access token

   Response example:
   ```json
   {
     "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI...",
   }
   ```

### Using Your Token

Include your token in the `Authorization` header of your requests to api.vegbank.org:

```http
Authorization: Bearer <YOUR_TOKEN_HERE>
```

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

Protects an endpoint to require a specific scope:

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

Protects specific HTTP methods for an endpoint that require a specific scope:

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
