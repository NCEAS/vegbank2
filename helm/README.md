# Introduction

This document describes how to deploy the helm charts for VegBank API and the VegBank Postgres Cluster. After installing the helm charts, you should see one or more instances of the VegBank python pod, which houses the flask app that powers the API (ex. `https://api-dev.vegbank.org/plant-concepts/pc.92413`) and three CloudNative PostgreSQL (CNPG) pods which contain the postgres database used by the API. The CNPG pods consist of a primary read-write pod and two replica read-only pods.

### See also:

- [./docs/prod-deployment.md](./docs/prod-deployment.md) for details on production deployment
- [./docs/db-recovery.md](./docs/db-recovery.md) for details on database backup and recovery
- [./admin/bootstrap/README.md](./admin/bootstrap/README.md) for an automated method of restoring from a data-only dump file taken from the original VegBank database.

## Table of Contents
- [Introduction](#introduction)
- [Requirements](#requirements)
- [Prerequisite: CNPG Cluster Deployment](#prerequisite-cnpg-cluster-deployment)
- [Prerequisite: Secret Creation](#prerequisite-secret-creation)
- [API Application Deployment](#api-application-deployment)
  - [Step 1: Getting the Dump File (if Deploying With Data)](#step-1-getting-the-dump-file-if-deploying-with-data)
  - [Step 2: Helm Install and Uninstall](#step-2-helm-install-and-uninstall)
  - [Step 3: Watch the `initContainers`](#step-3-watch-the-initcontainers)
  - [Step 4: Applying New Flyway Migration Files](#step-4-applying-new-flyway-migration-files)
- [Parameters](#parameters)

## Requirements
- Helm 4.x
- Kubernetes 1.26+
- A target Kubernetes cluster with:
  - a suitable namespace (ex. `vegbank`, `vegbank-dev`)
  - CloudNative PG Operator 1.27.0+ installed

## Prerequisite: CNPG Cluster Deployment

Before deploying the VegBank API helm chart, first deploy a PostgreSQL database, using the `cnpg` helm chart. This will initialize 3 postgres pods - wait for all three pods to be ready - and check their logs are free of errors - before proceeding.

> [!CAUTION]
> This is only a one-time deployment. DO NOT helm uninstall or helm delete this chart, unless you really need to! Doing so will result in the dynamically provisioned PVCs being deleted (You won't lose the PVs or the data, but re-binding new PVCs to the existing data is non-trivial.) If you chose to have CNPG auto-generate a DB credentials secret, that will also be deleted.

1. Database Credentials

   You may manually create a K8s Secret containing the PostgreSQL username and password, or you can allow the `cnpg` chart to automatically generate a secret for you. If you choose to create a secret manually, update the `values-cnpg.yaml` file with the name of your secret. See the [dataone-cnpg chart documentation](https://github.com/DataONEorg/dataone-cnpg?tab=readme-ov-file#secrets--credentials) for details.

> [!IMPORTANT]
> Either way, be sure to save the credentials; if lost, you will need to uninstall and reinstall the chart which could result in data loss if you have not taken a backup. Production and shared-dev credentials should be kept GPG-encrypted in our security repo.

2. Install the cnpg chart with the appropriate overrides file.

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

3. Database Backup & Recovery

    Scheduled backups can be enabled as described in the `dataone-cnpg` [helm chart documentation](https://github.com/DataONEorg/dataone-cnpg?tab=readme-ov-file#scheduled-backup). This is disabled by default, but can be overridden in [`./admin/values-cnpg.yaml`](./admin/values-cnpg.yaml)
    
    See the [database recovery documentation at `./docs/db-recovery.md`](./docs/db-recovery.md) for details of how to recover the database from backups.

## Prerequisite: Secret Creation

### 1. Flask Session-Signing Secret for the API Application

This secret MUST be stable across pod restarts so that user sessions remain valid after a deployment or pod reschedule. Without it, a new random key is generated every restart, invalidating all active sessions. The secret is consumed by the deployment as the `FLASK_SECRET_KEY` environment variable. Steps:

```shell
# 1. Generate a strong random key locally:
RND_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")

# 2. Create the secret:
kubectl create secret generic vegbank-flask-secret \
    --from-literal=secret_key=$RND_KEY
```

### 2. OIDC Client Secret for the API Application

This secret will be mounted into the pod at `/etc/vegbank/oidc/client_secrets.json` and read by the app via the `OIDC_CLIENT_SECRETS_FILE` environment variable. Steps:

1. Either obtain the keycloak-client-secrets-prod.json file from our private NCEAS GH Enterprise security repo, or use the template `helm/admin/client-secrets.json` as a starting point to fill in your own details (`client_id`, `client_secret`, `server_metadata_url`, `redirect_uris`)

2. Create the secret from this file:

    ```shell
    kubectl create secret generic vegbank-oidc-config \
        --from-file=client_secrets.json=path/to/my-client-secrets.json
   ```

## API Application Deployment

Once CNPG is up and running, VegBank API can be deployed with or without data.

> [!NOTE]
> Data from the original VegBank database was used to bootstrap the production deployment. The process is documented in the [./docs/prod-deployment.md](./docs/prod-deployment.md) file.

### Step 1: Getting the Dump File (if Deploying With Data)

To deploy with data, you will need a `pg_dump` file that contains both the data (DML) and the schema definition (DDL). Such files are available for development purposes on the `knbvm (knbvm.nceas.ucsb.edu)` VM, under `/mnt/ceph/repos/vegbank/`, and can be accessed via PV+PVC mounts in both `vegbank-dev` and `vegbank` namespaces; e.g:

```sh
$ kc get pvc -n vegbank-dev
NAME                    STATUS   VOLUME                        CAPACITY   ACCESS MODES   AGE
vegbankdb-init-pgdata   Bound    cephfs-vegbankdb-init-pgdata  100Gi      RWO            182d

# Admin access is needed for additional PV creation
```

### Step 2: Helm Install and Uninstall

For a fresh database installation with no data, leave `databaseRestore.enabled` as `false`.

To restore the database using a dump file containing both the schema and data definitions, set `databaseRestore.enabled` to `true` and set `databaseRestore.filepath` to the name of the dump file.

> [!NOTE]
> 1. Double check that the postgres image in the `databaseRestore.postgresImage` section in `values.yaml` has the same major version as the `cnpg`. Postgres major versions must match otherwise the restore process will not be able to proceed with connecting and restoring.

Now deploy the helm chart by running one of the following commands from the root folder of this repo:

```sh
# Deploy the latest published helm chart
$ helm upgrade --install vegbankapi -n vegbank oci://ghcr.io/nceas/charts/vegbank
# deploy a specific version by adding: --version <version-#>
# See more info by adding: --debug

# Deploy from the local helm chart in this repo (e.g. for testing changes to the chart)
$ helm upgrade --install vegbankapi ./helm
```

To uninstall, use:

```sh
$ helm uninstall vegbankapi -n vegbank
```

#### Development Values File: `values-overrides-dev.yaml`

The above commands deploy VegBank API on the Kubernetes cluster in the default configuration that is defined by the parameters in the [values.yaml file](./values.yaml). The [Parameters](#parameters) section, below, lists the parameters that can be configured during installation.

You may need to override some of these default parameters. This can be achieved by creating a YAML file that specifies only those values that need to be overridden, and providing that file as part of the helm install command. For example, using the overrides defined in `values-overrides-dev.yaml`:

```shell
$ helm upgrade --install vegbankapi -n vegbank oci://ghcr.io/nceas/charts/vegbank \
      -f `./helm/values-overrides-dev.yaml`
```
(where `values-overrides-dev.yaml` contains only the values you wish to override.)

Parameters may also be provided on the command line to override those in [values.yaml](./values.yaml); e.g.

```shell
$ helm upgrade --install vegbankapi -n vegbank oci://ghcr.io/nceas/charts/vegbank \
                        --set database.existingSecret=myrelease-secret-name
```

The `values-overrides-dev.yaml` overrides file disables the database restore process and the ingress.

```sh
$ helm install vegbankapi . -f values-overrides-dev.yaml

# Alternatively, without using the overrides file:
$ helm install vegbankapi . --set ingress.enabled=false
```

> [!TIP]
> If you wish to access the API without ingress, you can do so by port forwarding to the API service.
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
> $ curl -s https://localhost:8080/plant-concepts/pc.92413
> ```

### Step 3: Watch the `initContainers`

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

### API Access Mode

| Name         | Description                           | Value           |
| ------------ | ------------------------------------- | --------------- |
| `accessMode` | Access mode controlling API behavior. | `authenticated` |

### OIDC Configuration

| Name                    | Description                                                  | Value                 |
| ----------------------- | ------------------------------------------------------------ | --------------------- |
| `oidcConfig.secretName` | Name of the Kubernetes secret containing client_secrets.json | `vegbank-oidc-config` |

### Database

| Name                            | Description                                                                | Value                                     |
| ------------------------------- | -------------------------------------------------------------------------- | ----------------------------------------- |
| `database.name`                 | The name of the postgres database to be used by VegBank                    | `vegbank`                                 |
| `database.host`                 | hostname of database to be used by VegBank (RW svc name of CNPG or pooler) | `vegbankdb2-cnpg-rw`                      |
| `database.port`                 | port to connect to the database (Must match CNPG or pooler port number)    | `5432`                                    |
| `databaseRestore.enabled`       | Restores a full (schema+data) database dump file defined below             | `false`                                   |
| `databaseRestore.pvc`           | PVC containing the (schema+data) database dump file to restore             | `vegbankdb-init-pgdata`                   |
| `databaseRestore.mountpath`     | Mount path inside the container for the pvc/dump file volume               | `/tmp/databaseRestore`                    |
| `databaseRestore.filepath`      | dump file path, relative to databaseRestore.mountpath                      | `vegbank_full_fc_v1.9_pg16_20250924.dump` |
| `databaseRestore.postgresImage` | postgres image used by initContainer (*must match CNPG postgres version*)  | `postgres:17`                             |
| `flyway.image.repository`       | docker image repository for flyway, used in initContainer                  | `flyway/flyway`                           |
| `flyway.image.pullPolicy`       | How often should flyway image be pulled from repository?                   | `IfNotPresent`                            |
| `flyway.image.tag`              | The tag of the flyway image to use in the initContainer                    | `12.0.2`                                  |
| `flyway.dbpath`                 | The path to the directory containing the flyway migration files            | `/opt/local/flyway/db`                    |
| `flyway.dbHost`                 | hostname for flyway's direct connection to the database (not via pooler!)  | `vegbankdb2-cnpg-rw`                      |
| `flyway.dbPort`                 | port for flyway's direct connection to the database (not via pooler!)      | `5432`                                    |

### VegBank API Docker Image

| Name                 | Description                                                         | Value                   |
| -------------------- | ------------------------------------------------------------------- | ----------------------- |
| `image.repository`   | GitHub remote image repository address for the VegBank Docker Image | `ghcr.io/nceas/vegbank` |
| `image.pullPolicy`   | How often should the image be pulled from the repository?           | `IfNotPresent`          |
| `imagePullSecrets`   |                                                                     | `[]`                    |
| `nameOverride`       |                                                                     | `""`                    |
| `fullnameOverride`   |                                                                     | `""`                    |
| `podAnnotations`     | currently unused                                                    | `{}`                    |
| `podLabels`          |                                                                     | `{}`                    |
| `podSecurityContext` |                                                                     | `{}`                    |
| `securityContext`    |                                                                     | `{}`                    |

### Service

| Name           | Description                                    | Value       |
| -------------- | ---------------------------------------------- | ----------- |
| `service.type` | The type of service to create.                 | `ClusterIP` |
| `service.port` | The port on which the service will be exposed. | `80`        |

### Ingress

| Name                                                 | Description                                            | Value                     |
| ---------------------------------------------------- | ------------------------------------------------------ | ------------------------- |
| `ingress.enabled`                                    | Enable ingress to allow web traffic                    | `true`                    |
| `ingress.className`                                  | The class of the ingress controller to use.            | `nginx`                   |
| `ingress.annotations.cert-manager.io/cluster-issuer` |                                                        | `letsencrypt-prod`        |
| `ingress.hosts[0].host`                              | The host names for the ingress.                        | `api-dev.vegbank.org`     |
| `ingress.hosts[0].paths[0].path`                     | The path for the ingress.                              | `/`                       |
| `ingress.hosts[0].paths[0].pathType`                 | The type of path matching to use.                      | `Prefix`                  |
| `ingress.tls[0].hosts`                               | The host names for the TLS certification.              | `["api-dev.vegbank.org"]` |
| `ingress.tls[0].secretName`                          | The name of the secret containing the TLS certificate. | `ingress-nginx-tls-cert`  |
| `resources`                                          |                                                        | `{}`                      |

### Probes

| Name                          | Description                              | Value |
| ----------------------------- | ---------------------------------------- | ----- |
| `livenessProbe.httpGet.path`  | The path to use for the liveness probe.  | `/`   |
| `livenessProbe.httpGet.port`  | The port to use for the liveness probe.  | `80`  |
| `readinessProbe.httpGet.path` | The path to use for the readiness probe. | `/`   |
| `readinessProbe.httpGet.port` | The port to use for the readiness probe. | `80`  |

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
