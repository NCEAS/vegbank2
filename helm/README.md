# Introduction

This document describes how to deploy the helm charts for VegBank API and the VegBank Postgres Cluster. After installing the helm charts, you should see one or more instances of the VegBank python pod, which hosts the flask app that powers the API (ex. `https://api-dev.vegbank.org/plant-concepts/pc.92413`) and three CloudNative PostgreSQL (CNPG) pods which contain the postgres database used by the API. The CNPG pods consist of a primary read-write pod and two replica read-only pods.

### See also:

- **API Authorization Guide**: [api-authorization.md](./docs/api-authorization.md) – Detailed authentication, token usage, and scope system
- **Production Deployment to Kubernetes**: [prod-deployment.md](./docs/prod-deployment.md) - Details on production deployment
- **Database Recovery from Backups**: [db-recovery.md](./docs/db-recovery.md) - Details on database backup and recovery
- **VegBank Database Bootstrap**: [README](./admin/bootstrap/README.md) - Automated method of restoring from a data-only dump file taken from the original VegBank database.

## Quick Reference: NCEAS Dev Deployments

From the `vegbank2` repo root directory, either:

- ```shell
  # Deploy the local helm chart to the `dev-vegbank` context:
  helm upgrade vegbankapi -n vegbank ./helm -f ./helm/examples/values-overrides-dev-vb.yaml \
          --set image.tag="docker-img-tag-#"    # set to the Docker image version you wish to deploy
  ```
...or:

- ```shell
  # Deploy the local helm chart to the `dev-vegbank-dev` context:
  helm upgrade vegbankapi -n vegbank-dev ./helm -f ./helm/examples/values-overrides-dev-vb-dev.yaml \
          --set image.tag="docker-img-tag-#"    # set to the Docker image version you wish to deploy
  ```

## Table of Contents
- [Introduction](#introduction)
- [Quick Reference: NCEAS Dev Deployments](#quick-reference-nceas-dev-deployments)
- [Requirements](#requirements)
- [Prerequisites](#prerequisites)
- [API Application Deployment](#api-application-deployment)
  - [Step 1: Values Configuration](#step-1-values-configuration)
  - [Step 2: Deploying the Helm Chart](#step-2-deploying-the-helm-chart)
  - [Step 3: Watch the `initContainers`](#step-3-watch-the-initcontainers)
  - [Step 4: Applying New Flyway Migration Files](#step-4-applying-new-flyway-migration-files)
- [Parameters](#parameters)
- [Packaging and Publishing the Helm Chart](#packaging-and-publishing-the-helm-chart)
  - [Package the Chart](#package-the-chart)
  - [Publish the Chart to the GitHub Container Registry](#publish-the-chart-to-the-github-container-registry)
- [Appendix 1: Prerequisite: Install a PostgreSQL Database ](#appendix-1-prerequisite-install-a-postgresql-database)
- [Appendix 2: Prerequisite: Create K8s Secrets](#appendix-2-prerequisite-create-k8s-secrets)
- [Appendix 3: Initial Database Population with a Dump File](#appendix-3-initial-database-population-with-a-dump-file)

## Requirements
- Helm 4.x
- Kubernetes 1.26+
- A target Kubernetes cluster with:
  - a suitable namespace (ex. `vegbank`, `vegbank-dev`)
  - CloudNative PG Operator 1.27.0+ installed (or you can provide your own PostgreSQL database, but this approach is not tested or supported)

## Prerequisites

Before the initial deployment of the VegBank API helm chart, these prerequisites must be met:

1. A PostgreSQL database must be deployed and running in the cluster. At NCEAS, we use the [`dataone-cnpg` helm chart](https://github.com/DataONEorg/dataone-cnpg) to deploy a CloudNative PostgreSQL cluster. See [Appendix 1](#appendix-1-prerequisite-install-a-postgresql-database) for details.
2. The necessary Kubernetes secrets must be created. See [Appendix 2](#appendix-2-prerequisite-create-k8s-secrets).
3. If you wish to pre-populate the database with data from an existing dump file, that file must be made accessible to the helm chart via a PVC, and the appropriate parameters in `values.yaml` must be overridden to enable the restore process. See [Appendix 3](#appendix-3-initial-database-population-with-a-dump-file) for details.

## API Application Deployment

### Step 1: Values Configuration

> [!TIP]
> Values overrides for deployments on the NCEAS k8s dev cluster are kept in the [`helm/examples` directory](./examples). These files show the necessary overrides for different dev deployment contexts (e.g. [`dev-vegbank`](./examples/values-overrides-dev-vb.yaml) vs [`dev-vegbank-dev`](./examples/values-overrides-dev-vb-dev.yaml)), and can be used for reference when creating your own overrides files.

- **Values Overrides**

  It will be necessary to override a few of the default parameters in the [values.yaml file](./values.yaml), to match your deployment environment. The recommended approach is to create (and keep a versioned copy of) a YAML file that specifies only those values that need to be overridden. The [Parameters](#parameters) section, below, lists the parameters that can be configured during installation.

  - For example, to deploy the VegBank instance in our `dev-vegbank` K8s context, we use the overrides defined in [`helm/examples/values-overrides-dev-vb.yaml`](./examples/values-overrides-dev-vb.yaml):

    ```shell
    $ helm upgrade --install vegbankapi -n vegbank oci://ghcr.io/nceas/charts/vegbank \
          -f ./helm/examples/values-overrides-dev-vb.yaml
    ```

    where `values-overrides-dev-vb.yaml` contains only the values we wish to override. Similarly, we would use the [`helm/examples/values-overrides-dev-vb-dev.yaml`](./examples/values-overrides-dev-vb-dev.yaml) file when deploying in the `dev-vegbank-dev` context.

  - Parameters may also be overridden on the command line; e.g.

    ```shell
    $ helm upgrade --install vegbankapi -n vegbank oci://ghcr.io/nceas/charts/vegbank \
          -f ./helm/examples/values-overrides-dev-vb.yaml --set image.tag="2.0.0-beta01"
    ```

- **Values Overrides for Database Population**

  If you wish to populate the database from a `pg_dump` file on startup, see [Appendix 3](#appendix-3-initial-database-population-with-a-dump-file) for the necessary values overrides.

### Step 2: Deploying the Helm Chart

This example uses the `dev-vegbank` context and the `values-overrides-dev-vb.yaml` overrides file:

- Deploy the latest published helm chart

  ```shell
  $ helm upgrade --install vegbankapi -n vegbank oci://ghcr.io/nceas/charts/vegbank \
        -f ./helm/examples/values-overrides-dev-vb.yaml
  ```

  - Deploy a specific version by adding: `--version <version-#>` ([List of published chart versions](https://github.com/NCEAS/metacat/pkgs/container/charts%2Fvegbank))
  - See more info by adding: `--debug`
  - `--dry-run` can be used to test the installation without actually deploying

- Deploy from the local helm chart in this repo (e.g. for testing changes to the chart)

  ```shell
  $ helm upgrade --install vegbankapi ./helm \
        -f ./helm/examples/values-overrides-dev-vb.yaml --debug
  ```

- To uninstall:

  ```sh
  $ helm uninstall vegbankapi -n vegbank
  ```


> [!TIP]
> If you wish to access the API without ingress (i.e. if `ingress.enabled` is `false`), you can do so by port-forwarding to the API service.
>
> ```sh
> # 1. Find the name of the API service
> #
> $  kubectl get svc | grep api    # or grep for your vegbank api release name
>
>    vegbankapi           ClusterIP   10.104.197.36    <none>     80/TCP     26d
>
> # 2. Set up port forwarding using kubectl port-forward service/<svc-name> <local-port>:80
> #
> $ kubectl port-forward service/vegbankapi 8080:80
>
> # 3. Access the API on localhost via the port you specified:
> #
> $ curl -s http://localhost:8080/plant-concepts/pc.92413
> ```

### Step 3: Watch the   `initContainers`

There are two `initContainers`:
1) `vegbank-reconcile-postgres`
   - This waits until the `postgres` pod is accepting connections before proceeding with the next `initContainer`
   - If `databaseRestore.enabled` is set to `true` in `values.yaml`, the dump file defined in `databaseRestore` is restored to the empty cluster
2) `vegbank-apply-flyway`
   - This executes `flyway migrate`, which applies the migration files found in `/db/migrations`

> [!TIP]
> To monitor what's happening, you can use the following commands:
>
> ```sh
> # Monitor pod readiness:
> $ kubectl get pods --watch
> NAME                          READY   STATUS     RESTARTS   AGE
> vegbankapi-bb94bf498-6fpw4    0/1     Init:0/2   0          12s
> vegbankdb-cnpg-1              1/1     Running    0          5m4s
> vegbankdb-cnpg-2              1/1     Running    0          3m36s
> vegbankdb-cnpg-3              1/1     Running    0          2m19s
>
> # Watch the container logs:
> $ kubectl logs -f vegbankapi-bb94bf498-6fpw4 -c vegbankapi-reconcile-postgres
> # or:
> $ kubectl logs -f vegbankapi-bb94bf498-6fpw4 -c vegbankapi-apply-flyway
> ```

After the `initContainers` complete, you will now have an up-to-date copy of the current `vegbank` postgres database - which has applied all migrations found in `helm/db/mgrations`.

### Step 4: Applying New Flyway Migration Files

If you are testing new schema updates, add them to `helm/db/migrations` with the correct naming convention and run a `helm` upgrade command, as described above.

> [!IMPORTANT]
> Before upgrading or redeploying, don't forget to change the `databaseRestore.enabled` value back to `false` if you enabled it earlier.

## Parameters

### API Access - Authentication and Authorization

| Name                        | Description                                                         | Value                  |
| --------------------------- | ------------------------------------------------------------------- | ---------------------- |
| `auth.accessMode`           | Controls authentication & upload behavior (RW or RO) for API access | `read_only`            |
| `auth.oidcSecretName`       | Name of the Kubernetes secret containing client_secrets.json        | `vegbank-oidc-config`  |
| `auth.oidcDefaultScopes`    | Space-separated standard OIDC scopes requested during login.        | `openid email profile` |
| `auth.roleName.admin`       | Scope name for the admin role                                       | `vegbank:admin`        |
| `auth.roleName.contributor` | Scope name for the contributor role                                 | `vegbank:contributor`  |
| `auth.roleName.user`        | Scope name for the user role                                        | `vegbank:user`         |

### Database

| Name                            | Description                                                                | Value                                     |
| ------------------------------- | -------------------------------------------------------------------------- | ----------------------------------------- |
| `database.name`                 | The name of the postgres database to be used by VegBank                    | `vegbank`                                 |
| `database.host`                 | hostname of database to be used by VegBank (RW svc name of CNPG or pooler) | `vegbankdb-cnpg-rw`                       |
| `database.port`                 | port to connect to the database (Must match CNPG or pooler port number)    | `5432`                                    |
| `database.existingSecret`       | Secret containing the database username and password.                      | `vegbankdbcreds`                          |
| `databaseRestore.enabled`       | Restores a full (schema+data) database dump file defined below             | `false`                                   |
| `databaseRestore.pvc`           | PVC containing the (schema+data) database dump file to restore             | `vegbankdb-init-pgdata`                   |
| `databaseRestore.mountpath`     | Mount path inside the container for the pvc/dump file volume               | `/tmp/databaseRestore`                    |
| `databaseRestore.filepath`      | dump file path, relative to databaseRestore.mountpath                      | `vegbank_full_fc_v1.9_pg16_20250924.dump` |
| `databaseRestore.postgresImage` | postgres image used by initContainer (*must match CNPG postgres version*)  | `postgres:17`                             |
| `flyway.image.repository`       | docker image repository for flyway, used in initContainer                  | `flyway/flyway`                           |
| `flyway.image.pullPolicy`       | How often should flyway image be pulled from repository?                   | `IfNotPresent`                            |
| `flyway.image.tag`              | The tag of the flyway image to use in the initContainer                    | `12.1`                                    |
| `flyway.dbpath`                 | The path to the directory containing the flyway migration files            | `/opt/local/flyway/db`                    |
| `flyway.dbHost`                 | hostname for flyway's direct connection to the database (not via pooler!)  | `vegbankdb-cnpg-rw`                       |
| `flyway.dbPort`                 | port for flyway's direct connection to the database (not via pooler!)      | `5432`                                    |

### EZID Configuration

| Name                    | Description                                                         | Value                       |
| ----------------------- | ------------------------------------------------------------------- | --------------------------- |
| `ezid.baseUrl`          | Base URL of the EZID API                                            | `https://ezid.cdlib.org`    |
| `ezid.doiPrefix`        | DOI prefix (e.g. doi:10.5072 for test, doi:10.xxxxx for production) | `doi:10.5072`               |
| `ezid.doiShoulder`      | DOI shoulder for minting (e.g. FK2 for test)                        | `FK2`                       |
| `ezid.defaultTargetUrl` | Default target URL for minted DOIs                                  | `https://vegbank.org/cite/` |

### VegBank API Docker Image

| Name               | Description                                                                 | Value                   |
| ------------------ | --------------------------------------------------------------------------- | ----------------------- |
| `image.repository` | GitHub remote image repository address for the VegBank Docker Image         | `ghcr.io/nceas/vegbank` |
| `image.pullPolicy` | How often should the image be pulled from the repository?                   | `IfNotPresent`          |
| `image.tag`        | version/tag of the VB Docker Image to use. Leave blank to use Chart default | `""`                    |
| `resources`        |                                                                             | `{}`                    |

### Probes

| Name                              | Description                                                | Value  |
| --------------------------------- | ---------------------------------------------------------- | ------ |
| `startupProbe.enabled`            | Enable startupProbe                                        | `true` |
| `startupProbe.httpGet.path`       | The url path to probe during startup                       | `/`    |
| `startupProbe.httpGet.port`       | The named containerPort to probe                           | `http` |
| `startupProbe.successThreshold`   | Min consecutive successes for probe to be successful       | `1`    |
| `startupProbe.failureThreshold`   | No. of consecutive failures before the container restarted | `36`   |
| `startupProbe.periodSeconds`      | Interval (in seconds) between startup checks               | `5`    |
| `startupProbe.timeoutSeconds`     | Timeout (in seconds) for each startup check                | `3`    |
| `livenessProbe.enabled`           | Enable livenessProbe                                       | `true` |
| `livenessProbe.httpGet.path`      | The url path to probe                                      | `/`    |
| `livenessProbe.httpGet.port`      | The named containerPort to probe                           | `http` |
| `livenessProbe.periodSeconds`     | Period seconds for livenessProbe                           | `20`   |
| `livenessProbe.timeoutSeconds`    | Timeout seconds for livenessProbe                          | `10`   |
| `livenessProbe.successThreshold`  | Min consecutive successes for probe to be successful       | `1`    |
| `livenessProbe.failureThreshold`  | No. consecutive failures before container restarted        | `15`   |
| `readinessProbe.enabled`          | Enable readinessProbe                                      | `true` |
| `readinessProbe.httpGet.path`     | The url path to probe                                      | `/`    |
| `readinessProbe.httpGet.port`     | The named containerPort to probe                           | `http` |
| `readinessProbe.periodSeconds`    | Period seconds for readinessProbe                          | `10`   |
| `readinessProbe.timeoutSeconds`   | Timeout seconds for readinessProbe                         | `5`    |
| `readinessProbe.successThreshold` | Min consecutive successes for probe to be successful       | `1`    |
| `readinessProbe.failureThreshold` | No. consecutive failures before container marked unhealthy | `3`    |

### Service

| Name           | Description                                    | Value       |
| -------------- | ---------------------------------------------- | ----------- |
| `service.type` | The type of service to create.                 | `ClusterIP` |
| `service.port` | The port on which the service will be exposed. | `8000`      |

### Gunicorn Server

| Name                             | Description                                                                                                                                  | Value   |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `gunicorn.workers`               | Number of worker processes for handling requests.                                                                                            | `5`     |
| `gunicorn.timeout`               | Workers silent for more than this many seconds are killed and restarted                                                                      | `2400`  |
| `gunicorn.logLevel`              | Granularity of gunicorn logs (debug|info|warning|error|critical)                                                                             | `info`  |
| `gunicorn.limitRequestFieldSize` | The maximum size of HTTP request header fields in bytes. Default is 8KB, but this is upped to 16kb to match the limit set at the auth stage. | `16384` |

### Ingress

| Name                                                 | Description                                                               | Value                    |
| ---------------------------------------------------- | ------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`                                    | Enable ingress to allow web traffic. Ingress settings ignored if 'false'  | `false`                  |
| `ingress.className`                                  | The class of the ingress controller to use.                               | `traefik`                |
| `ingress.hostname`                                   | Simple hostname mode: ingress auto-generated if `ingress.hosts` empty     | `localhost`              |
| `ingress.hosts`                                      | Full ingress host/path subtree (advanced mode).                           | `[]`                     |
| `ingress.tlsEnabled`                                 | Set to 'false', to disable rendering Ingress TLS (HTTP-only).             | `true`                   |
| `ingress.tlsSecretName`                              | Secret name used by inferred TLS when `ingress.tls` is empty.             | `ingress-nginx-tls-cert` |
| `ingress.annotations.cert-manager.io/cluster-issuer` | cert-manager cluster issuer                                               | `letsencrypt-prod`       |
| `ingress.tls`                                        | Full TLS subtree (advanced mode). Ignored unless ingress.enabled is true. | `[]`                     |

### Miscellaneous

| Name                                         | Description                                                  | Value   |
| -------------------------------------------- | ------------------------------------------------------------ | ------- |
| `serviceAccount.create`                      | Specifies whether a service account should be created        | `true`  |
| `serviceAccount.automount`                   | Automatically mount a ServiceAccount's API credentials?      | `true`  |
| `serviceAccount.annotations`                 | Annotations to add to the service account                    | `{}`    |
| `serviceAccount.name`                        | The name of the service account to use.                      | `""`    |
| `autoscaling.enabled`                        |                                                              | `false` |
| `autoscaling.minReplicas`                    |                                                              | `1`     |
| `autoscaling.maxReplicas`                    |                                                              | `100`   |
| `autoscaling.targetCPUUtilizationPercentage` |                                                              | `80`    |
| `volumeMounts`                               | Additional volumeMounts on the output Deployment definition. | `[]`    |
| `nodeSelector`                               |                                                              | `{}`    |
| `tolerations`                                |                                                              | `[]`    |
| `affinity`                                   |                                                              | `{}`    |
| `imagePullSecrets`                           |                                                              | `[]`    |
| `nameOverride`                               |                                                              | `""`    |
| `fullnameOverride`                           |                                                              | `""`    |
| `podAnnotations`                             | currently unused                                             | `{}`    |
| `podLabels`                                  |                                                              | `{}`    |
| `podSecurityContext`                         |                                                              | `{}`    |
| `securityContext`                            |                                                              | `{}`    |

## Packaging and Publishing the Helm Chart

### Package the Chart

1. Edit `Chart.yaml` as follows:
   1. Update the `version` field to the new version number (e.g. `0.1.0`). This version number uses [semantic versioning](https://semver.org/), and should be updated according to the type of changes made to the chart since the last version.
   2. Ensure the `appVersion` field is set to match the version of the VegBank API that you wish to deploy with this chart. This should be a valid docker image tag for the VegBank API image in the [GitHub Container Registry](https://github.com/NCEAS/vegbank2/pkgs/container/vegbank).
2. Use the `helm package` command:

    ```shell
    helm package -u ./helm
    ```

    ...which will create a file named `vegbank-<x.x.x>.tgz` in the current directory, where `<x.x.x>` is the version number you set in `Chart.yaml`.

### Publish the Chart to the GitHub Container Registry

1. Prerequisite: you will need a GitHub Personal Access Token (PAT) with the appropriate permissions to publish to the GitHub Container Registry. See the [Docker README](../docker/README.md) for details on how to create a PAT and use it to log in.

2. Once you have authenticated with the GitHub Container Registry, you can use the `helm push` command to publish the packaged chart:

    ```shell
    helm push vegbank-<x.x.x>.tgz oci://ghcr.io/nceas/charts
    ```

## Appendix 1: Prerequisite: Install a PostgreSQL Database

Before deploying the VegBank API helm chart, first deploy a PostgreSQL database, using the `cnpg` helm chart. This will initialize 3 postgres pods - wait for all three pods to be ready - and check their logs are free of errors - before proceeding.

> [!CAUTION]
> This is only a one-time deployment. DO NOT helm uninstall or helm delete this chart, unless you really need to! Doing so will result in the dynamically provisioned PVCs being deleted (You won't lose the PVs or the data, but re-binding new PVCs to the existing data is non-trivial.) If you chose to have CNPG auto-generate a DB credentials secret, that will also be deleted.

1. **Database Credentials**

   You may manually create a K8s Secret containing the PostgreSQL username and password, or you can allow the `cnpg` chart to automatically generate a secret for you. If you choose to create a secret manually, ensure the `values-cnpg.yaml` file contains the name of your secret. See the [dataone-cnpg chart documentation](https://github.com/DataONEorg/dataone-cnpg?tab=readme-ov-file#secrets--credentials) for details.

> [!IMPORTANT]
> Either way, be sure to save the credentials; if lost, you will need to uninstall and reinstall the chart which could result in data loss if you have not taken a backup. NCEAS production and shared-dev credentials should be kept GPG-encrypted in our security repo.

2. **Install the cnpg chart with the appropriate overrides file**

    ```sh
    # Deploy the latest version of the chart by leaving out the --version parameter.
    # Using the deployment name 'vegbankdb':
    #
    $ helm install vegbankdb oci://ghcr.io/dataoneorg/charts/cnpg -f ./helm/admin/values-cnpg.yaml

    $ kubectl -n dev-vegbank get pods
    NAME                         READY   STATUS    RESTARTS   AGE
    vegbankdb-cnpg-1             1/1     Running   0          5m
    vegbankdb-cnpg-2             1/1     Running   0          6m
    vegbankdb-cnpg-3             1/1     Running   0          7m
    ```

3. **Database Backup & Recovery**

   Scheduled backups can be enabled as described in the `dataone-cnpg` [helm chart documentation](https://github.com/DataONEorg/dataone-cnpg?tab=readme-ov-file#scheduled-backup). This is disabled by default, but can be overridden in [`./admin/values-cnpg.yaml`](./admin/values-cnpg.yaml)

   See the [database recovery documentation at `./docs/db-recovery.md`](./docs/db-recovery.md) for details of how to recover the database from backups.

## Appendix 2: Prerequisite: Create K8s Secrets

1. **Flask Session-Signing Secret for the API Application**

   This secret MUST be stable across pod restarts so that user sessions remain valid after a deployment or pod reschedule. Without it, a new random key is generated every restart, invalidating all active sessions. The secret is consumed by the deployment as the `FLASK_SECRET_KEY` environment variable. Steps:

   ```shell
   # 1. Generate a strong random key locally:
   RND_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")

   # 2. Create the secret:
   kubectl create secret generic vegbank-flask-secret \
       --from-literal=secret_key=$RND_KEY
   ```

2. **OIDC Client Secret for the API Application**

   This secret will be mounted into the pod at `/etc/vegbank/oidc/client_secrets.json` and read by the app via the `OIDC_CLIENT_SECRETS_FILE` environment variable. Steps:

   1. Either obtain the keycloak-client-secrets-prod.json file from our private NCEAS GH Enterprise security repo, or use the template `helm/admin/client-secrets.json` as a starting point to fill in your own details (`client_id`, `client_secret`, `server_metadata_url`, `redirect_uris`)

   2. Create the secret from this file:

      ```shell
      kubectl create secret generic vegbank-oidc-config \
          --from-file=client_secrets.json=path/to/my-client-secrets.json
      ```

3. **EZID API Credentials for DOI Minting**

   The EZID username and password are required for minting DOIs and are consumed by the application
   via the `EZID_USERNAME` and `EZID_PASSWORD` environment variables. They are stored in the K8s
   secret defined in [`helm/admin/secret.yaml`](./admin/secret.yaml). Edit that file to add your
   credentials, then apply it to your cluster:

   ```shell
   RELEASE_NAME=vegbankapi envsubst < helm/admin/secret.yaml | kubectl apply -n <mynamespace> -f -
   ```

   For development and test deployments, credentials can be found on our private NCEAS dev team documentation site.
   For production deployments, obtain credentials from the GPG-encrypted secrets file in our private
   NCEAS GH Enterprise security repo.

  > [!NOTE]
  > The DOI prefix and shoulder for production are documented in
  > [NCEAS/vegbank2#305](https://github.com/NCEAS/vegbank2/issues/305). Configure them via the
  > `ezid.doiPrefix` and `ezid.doiShoulder` parameters in your values overrides file. The defaults
  > in `values.yaml` are the EZID test/sandbox values (`doi:10.5072` / `FK2`).

## Appendix 3: Initial Database Population with a Dump File

> [!NOTE]
> A data-only (DML) `pg_dump` from the original VegBank database was used to bootstrap the production deployment. This process is documented in the [./docs/prod-deployment.md](./docs/prod-deployment.md) file

- If you only need a "clean" installation with an empty database, this step can be skipped.

- If you wish to pre-populate with data from an existing database, you will need a `pg_dump` file that contains both the data (DML) and the schema definition (DDL). Such files are available for development purposes on the `knbvm (knbvm.nceas.ucsb.edu)` VM, under `/mnt/ceph/repos/vegbank/`, and can be accessed via PV+PVC mounts in both `vegbank-dev` and `vegbank` namespaces; e.g:

    ```sh
    $ kc get pvc -n vegbank-dev
    NAME                    STATUS   VOLUME                        CAPACITY   ACCESS MODES   AGE
    vegbankdb-init-pgdata   Bound    cephfs-vegbankdb-init-pgdata  100Gi      RWO            182d

    # Admin access is needed for additional PV creation
    ```

- Override the following values in `values.yaml` to enable the restore process and specify the dump file to use:

  ```yaml
  databaseRestore:
    enabled: true                   # (default is 'false')
    pvc: "vegbankdb-init-pgdata"    # must match name of PVC containing dump file (see above)
    filepath: "vegbank_full_fc_v1.9_pg16_20250924.dump"   # path to dump file from PVC mount-point
    postgresImage: postgres:17      # must match cnpg major version - see below
  ```

> [!IMPORTANT]
> The restore process will fail unless the major version of the postgres image defined in `databaseRestore.postgresImage` matches the `cnpg` major version.
