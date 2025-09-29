# Introduction

This document describes how to deploy the helm chart for VegBank, which includes at this time the API (python pod with flask) and database component (postgres pod). After installing the helm chart, you should see two pods. The vegbank python pod - which houses the flask app that powers the API (ex. `https://api-dev.vegbank.org/taxon-observations/VB.TO.64992.VACCINIUMBOREAL`) and the postgres pod which contains the database that the API accesses and queries.

## Requirements

The original VegBank database and web interface (ex. `http://vegbank.org/vegbank/index.jsp`) is currently maintained by NCEAS - however, there have been no new contributions in several years. This means that the data-only dump file used in this process described below (that's currently stored in a ceph directory) is relevant and applicable for testing. The production deployment may start from a new dump file/starting point which includes schema migrations and updates, so do not use the dump file for production purposes without consulting the appropriate stakeholders.
- Note: Should you need to restore the original database that's currently maintained, you can find instructions in this repo's `INSTALL.md` document and additional information at `src/database/flyway/README.md`. 

You need to have the following things set up/installed: 

- A Kubernetes cluster and a namespace you wish to deploy the chart on (ex. dev-vegbank, dev-vegbank-dev)
- kubectl installed locally
- Helm installed locally

# Deploying to Kubernetes - Development Server

This section will walk you through deploying VegBank to an empty kubernetes namespace. The required dump file to perform a postgres restore has been made available via mounting of a static PV/PVC to both `dev-vegbank` and `vegbank` namespaces.

Any additional requests for further mounts must be requested via the development team. 

## Step 1: Getting your dump file

TBD - A dump file is already available for development purposes. In production, this may differ.

## Step 2: Helm Install (and Uninstall...)

If we're starting from nothing (ex. the namespace/context we're working in is completely empty), we need to first update the helm `values.yaml` section for `databaseRestore`:
- `databaseRestore.setup` should be set to `true` so that a new vegbank database can be created in the postgres instance, along with the expected roles
- `databaseRestore.enabled` should be set to `true` if you want to restore the database using a dump file. If you want a fresh database installation with no data, leave this as `false`.

```sh
# values.yaml

databaseRestore:
  setup: true # This needs to be changed from `false` to `true`
  enabled: true # This needs to be changed from `false` to `true`
  pvc: "vegbankdb-init-pgdata" # Name of the PVC
  mountpath: "/tmp/databaseRestore" # Path where you can find the PVC contents
  filepath: "vegbank_full_fc_v1.9_pg16_20250924.dump" # Name of the file to be used in the restoration process
```

Now we can deploy the helm chart. This can be done simply by opening a terminal in the root folder of this repo, then running the following command: 

```sh
# If you're in the root folder
$ helm install vegbankdb helm

# Or if you're in the helm folder
$ helm install vegbankdb .
```

If you are on a namespace without ingress (ex. `dev-vegbank-dev`), be sure to provide the custom arguments `--set ingress.enabled=false` to prevent ingress errors:

```sh
$ helm install vegbankdb . --set ingress.enabled=false
```

This will install both the python pod (based on the `docker/Dockerfile` in this repo) and the Postgres pod (using the `bitnami` image) on the namespace you have selected as your current context (ex. `dev-vegbank`), and give the pods the starting prefix of `vegbankdb` in its name. You can change the name vegbankdb to whatever you like.

The `Postgres` pod only has a fresh installation of `PostgreSQL`, without any databases or users - and now needs to be set-up and then restored using the dump file.

- Tip: If you are clearing out an existing namespace (ex. `dev-vegbank-dev`), or need to restart this process - you can start fresh by first uninstalling the chart, and then deleting the PVC associated with the `postgres` pod. The PVC that is created (ex. `data-vegbankdb-postgresql-0`) is defined by the chart - and houses all data associated with the `postgres` instance.

  ```sh
  # Uninstall the chart
  $ helm uninstall vegbankdb

  # Get the PVC
  $ kubectl get pvc -n dev-vegbank
  NAME                                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
  data-vegbankdb-postgresql-0         Bound    pvc-e4de48bf-8ada-45f1-945d-a285881f9cfc   100Gi      RWX            csi-cephfs-sc   7m41s
  vegbankdb-init-pgdata               Bound    cephfs-vegbankdb-init-pgdata               100Gi      RWO                            2d22h

  # Delete the PVC
  $ kubectl delete -n dev-vegbank pvc data-vegbankdb-postgresql-0
  ```

  Helm uninstall will delete all the pods, and deleting the PVC associated with `postgres` provides a clean slate for helm to initialize the chart. If you don't delete this PVC, and simply try to remove the `postgres` data by accessing the `postgres` pod and running `rm -rf /bitnami/postgresql/data` which pulls the rug out on the `postgres` container, you may run into permissions issues such as passwords retrieved from secrets not matching.

## Step 3: Watch the `initContainers`

At this point, your namespace is empty and you have a fresh installation of `postgres`. There is nothing left for you to do but sit and wait for the `initContainers` to execute.

There are three `initContainers`:
1) vegbankdb-init-postgres
   - This waits until the `postgres` pod is active before allowing the next `initContainer` to execute
2) vegbankdb-restore-postgres
   - If `databaseRestore.enabled` is set to `true` in `values.yaml`:
       - This creates the `vegbank` database in your empty `postgres` instance, along with the additional roles required for flyway to apply the migration (schema) files.
       - It will then proceed to look for the data-only dump file, which should already be present and mounted via the PV/PVC step specified earlier - and then execute it.
5) vegbankdb-apply-flyway
   - This executes `flyway migrate`, which applies the migration files found in `/db/migrations`


Tip: To get a pulse of what's happening, you can run the following commands:

```sh
$ kubectl -n dev-vegbank get pods
NAME                        READY   STATUS     RESTARTS      AGE
vegbankdb-95bf7c577-9m2rs   0/1     Init:1/3   2 (11m ago)   11m
vegbankdb-postgresql-0      1/1     Running    0             11m

# This will show you information about the pod, and if you scroll all the way down, where it's at in the initialization process 
$ kubectl -n dev-vegbank describe pod vegbankdb-95bf7c577-9m2rs
...

# You can get the logs of the initContainer like such, replacing the argument after the '-c' flag with the initContainer you want to check
$ kubectl logs vegbankdb-9d5859886-5bj5x -c vegbank-init-postgres --timestamps                                                                          
2025-09-25T10:10:11.129037693-07:00 Server:    10.96.0.10
2025-09-25T10:10:11.129130874-07:00 Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local
2025-09-25T10:10:11.129146915-07:00 
2025-09-25T10:10:11.129157691-07:00 Name:      vegbankdb-postgresql.vegbank.svc.cluster.local
2025-09-25T10:10:11.129169307-07:00 Address 1: 10.109.137.103 vegbankdb-postgresql.vegbank.svc.cluster.local

$ kubectl logs vegbankdb-9d5859886-5bj5x -c vegbank-restore-postgres --timestamps                                                                         
2025-09-25T10:10:28.289144504-07:00 ## Checking DB env vars
2025-09-25T10:10:28.293308086-07:00 VB_DB_PASS=DO_NOT_SHOW_THIS_BAD!
2025-09-25T10:10:28.293331099-07:00 VB_DB_HOST=vegbankdb-postgresql
2025-09-25T10:10:28.293335931-07:00 VB_DB_USER=vegbank
2025-09-25T10:10:28.293339535-07:00 VB_DB_PORT=5432
2025-09-25T10:10:28.293342931-07:00 VB_DB_NAME=vegbank
2025-09-25T10:10:28.297146056-07:00 POSTGRES_PASSWORD=RANDOMIZES!
2025-09-25T10:10:28.297623585-07:00 ## Creating Vegbank database and roles
2025-09-25T10:10:28.457981764-07:00 CREATE ROLE
2025-09-25T10:10:29.175171154-07:00 CREATE DATABASE
2025-09-25T10:10:29.178242612-07:00 GRANT
2025-09-25T10:10:29.193205738-07:00 GRANT
2025-09-25T10:10:29.194673189-07:00 ## Database Restore Requested, restoring from specific dump file

$ kubectl logs vegbankdb-9d5859886-5bj5x -c vegbank-apply-flyway --timestamps
2025-09-25T10:35:06.910428714-07:00 ## Flyway Env
2025-09-25T10:35:06.914609424-07:00 FLYWAY_PASSWORD=SecretVeggies2092
2025-09-25T10:35:06.914645452-07:00 FLYWAY_USER=vegbank
2025-09-25T10:35:06.914652983-07:00 FLYWAY_URL=jdbc:postgresql://vegbankdb-postgresql:5432/vegbank
2025-09-25T10:35:06.914658864-07:00 FLYWAY_LOCATIONS=filesystem:/opt/local/flyway/db/migrations
2025-09-25T10:35:06.914887785-07:00 ## Listing Migrations
2025-09-25T10:35:06.917932660-07:00 V1.0__vegbank.sql
2025-09-25T10:35:06.917977643-07:00 V1.1__create_aggregrates.sql
2025-09-25T10:35:06.917983649-07:00 V1.2__create_extras.sql
2025-09-25T10:35:06.917988364-07:00 V1.3__create_indices.sql
2025-09-25T10:35:06.918010462-07:00 V1.4__create_vegbank_views.sql
2025-09-25T10:35:06.918015460-07:00 V1.5__add_constraints.sql
2025-09-25T10:35:06.918021412-07:00 V1.6__backfill_party_null_values.sql
2025-09-25T10:35:06.918026325-07:00 V1.7__create_identifiers_table.sql
2025-09-25T10:35:06.918031538-07:00 V1.8__populate_acc_identifiers_procedure.sql
2025-09-25T10:35:06.918036127-07:00 V1.9__populate_vb_identifiers_procedure.sql
2025-09-25T10:35:06.918273573-07:00 Applying all migrations in db/migrations
2025-09-25T10:35:08.781050529-07:00 A more recent version of Flyway is available. Find out more about Flyway 11.13.1 at https://rd.gt/3rXiSlV
2025-09-25T10:35:08.781118232-07:00 
2025-09-25T10:35:08.781141330-07:00 Flyway OSS Edition 10.17.0 by Redgate
2025-09-25T10:35:08.781150048-07:00 
2025-09-25T10:35:08.781156363-07:00 See release notes here: https://rd.gt/416ObMi
2025-09-25T10:35:08.971432146-07:00 Database: jdbc:postgresql://vegbankdb-postgresql:5432/vegbank (PostgreSQL 16.4)
2025-09-25T10:35:09.700179135-07:00 Successfully validated 10 migrations (execution time 00:00.308s)
2025-09-25T10:35:09.767308757-07:00 Current version of schema "public": 1.9
2025-09-25T10:35:09.774330631-07:00 Schema "public" is up to date. No migration necessary.

$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
vegbankdb-95bf7c577-9m2rs   1/1     Running   0          53m
vegbankdb-postgresql-0      1/1     Running   0          53m
```

After the `initContainers` complete, you will now have an up-to-date copy of the current `vegbank` postgres database - which has applied all migrations found in `helm/db/mgrations`.

## Step 4: Applying new migration files 

If you are testing new schema updates, add them to `helm/db/migrations` with the correct naming convention and run a `helm` upgrade command. Example:

```sh
$ helm upgrade vegbankdb . -f values.yaml
```

- Note: Do not forget to change the `databaseRestore.enabled` value back to `false` if you've set it to `true`.

  ```
  # values.yaml

  databaseRestore:
    enabled: false
    target: "1.4"
    pvc: "vegbankdb-init-pgdata"
    mountpath: "/tmp/databaseRestore"
    filepath: "vegbank_dataonly_fc_20250904.dump"
  ```

# Connecting to API via kubectl port forwarding

Once you're in the k8s dev-vegbank context, you can find the name of the API pod via the following command: 

```sh
$ kubectl -n dev-vegbank get pods
```

The API pod is the one with the werid alphanumeric name. After that, all you need is this command: 

```sh
$ kubectl -n dev-vegbank port-forward <API pod name> <desired port on your machine>:80
```

Then you can access the API on localhost via the port you specified. 


## Parameters

### Image 

| Name               | Description                                                           | Value                   |
| ------------------ | --------------------------------------------------------------------- | ----------------------- |
| `image.repository` | - github remote image repository address for the VegBank Docker Image | `ghcr.io/nceas/vegbank` |
| `image.pullPolicy` | - How often should the image be pulled from the repository?           | `IfNotPresent`          |
| `image.tag`        | - The tag of the image to use.                                        | `""`                    |
| `imagePullSecrets` |                                                                       | `[]`                    |
| `nameOverride`     |                                                                       | `""`                    |
| `fullnameOverride` |                                                                       | `""`                    |

### serviceAccount

| Name                         | Description                                             | Value  |
| ---------------------------- | ------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created   | `true` |
| `serviceAccount.automount`   | Automatically mount a ServiceAccount's API credentials? | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account               | `{}`   |
| `serviceAccount.name`        | The name of the service account to use.                 | `""`   |
| `podAnnotations`             | currently unused                                        | `{}`   |
| `podLabels`                  |                                                         | `{}`   |
| `podSecurityContext`         |                                                         | `{}`   |
| `securityContext`            |                                                         | `{}`   |

### Service

| Name           | Description                                      | Value       |
| -------------- | ------------------------------------------------ | ----------- |
| `service.type` | - The type of service to create.                 | `ClusterIP` |
| `service.port` | - The port on which the service will be exposed. | `80`        |

### ingress

| Name                | Description                                   | Value   |
| ------------------- | --------------------------------------------- | ------- |
| `ingress.enabled`   | - Should the ingress be enabled?              | `true`  |
| `ingress.className` | - The class of the ingress controller to use. | `nginx` |

### ingress.annotations - Annotations to add to the ingress resource.

| Name                                                 | Description | Value              |
| ---------------------------------------------------- | ----------- | ------------------ |
| `ingress.annotations.cert-manager.io/cluster-issuer` |             | `letsencrypt-prod` |

### ingress.hosts Host name information for the ingress. 

| Name                    | Description                       | Value                 |
| ----------------------- | --------------------------------- | --------------------- |
| `ingress.hosts[0].host` | - The host names for the ingress. | `api-dev.vegbank.org` |

### ingress.hosts[0].paths - The paths for the ingress.

| Name                                 | Description                         | Value    |
| ------------------------------------ | ----------------------------------- | -------- |
| `ingress.hosts[0].paths[0].path`     | - The path for the ingress.         | `/`      |
| `ingress.hosts[0].paths[0].pathType` | - The type of path matching to use. | `Prefix` |

### tls 

| Name                        | Description                                              | Value                     |
| --------------------------- | -------------------------------------------------------- | ------------------------- |
| `ingress.tls[0].hosts`      | - The host names for the TLS certification.              | `["api-dev.vegbank.org"]` |
| `ingress.tls[0].secretName` | - The name of the secret containing the TLS certificate. | `ingress-nginx-tls-cert`  |
| `resources`                 |                                                          | `{}`                      |

### livenessProbe


### livenessProbe.httpGet

| Name                         | Description                               | Value |
| ---------------------------- | ----------------------------------------- | ----- |
| `livenessProbe.httpGet.path` | - The path to use for the liveness probe. | `/`   |
| `livenessProbe.httpGet.port` | - The port to use for the liveness probe. | `80`  |

### readinessProbe


### readinessProbe.httpGet

| Name                          | Description                                | Value |
| ----------------------------- | ------------------------------------------ | ----- |
| `readinessProbe.httpGet.path` | - The path to use for the readiness probe. | `/`   |
| `readinessProbe.httpGet.port` | - The port to use for the readiness probe. | `80`  |

### autoscaling

| Name                                         | Description                                                  | Value   |
| -------------------------------------------- | ------------------------------------------------------------ | ------- |
| `autoscaling.enabled`                        |                                                              | `false` |
| `autoscaling.minReplicas`                    |                                                              | `1`     |
| `autoscaling.maxReplicas`                    |                                                              | `100`   |
| `autoscaling.targetCPUUtilizationPercentage` |                                                              | `80`    |
| `volumes`                                    | Additional volumes on the output Deployment definition.      | `[]`    |
| `volumeMounts`                               | Additional volumeMounts on the output Deployment definition. | `[]`    |
| `nodeSelector`                               |                                                              | `{}`    |
| `tolerations`                                |                                                              | `[]`    |
| `affinity`                                   |                                                              | `{}`    |

### PostgreSQL

| Name                 | Description                                  | Value  |
| -------------------- | -------------------------------------------- | ------ |
| `postgresql.enabled` | - Should the PostgreSQL database be enabled? | `true` |

### postgresql.primary

| Name                                    | Description                                                                       | Value                                                                                                                                                                                                                                                            |
| --------------------------------------- | --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `postgresql.primary.resourcesPreset`    | A preset of resources to use for the PostgreSQL pod defined in the bitnami chart. | `small`                                                                                                                                                                                                                                                          |
| `postgresql.primary.resources`          | Space for manually defining resources. If used, remove resourcesPreset.           | `{}`                                                                                                                                                                                                                                                             |
| `postgresql.primary.pgHbaConfiguration` | How can users access the postgresql database?                                     | `host        vegbank       vegbank       0.0.0.0/0       password
host        vegbank       vegbank       ::0/0           password
local       all           all                           trust
host        all           all           127.0.0.1/32    trust
` |

### Persistence

| Name                                          | Description                                                            | Value               |
| --------------------------------------------- | ---------------------------------------------------------------------- | ------------------- |
| `postgresql.primary.persistence.enabled`      | - Should persistence be enabled for the PostgreSQL database?           | `true`              |
| `postgresql.primary.persistence.storageClass` | - The storage class to use for the PostgreSQL database.                | `csi-cephfs-sc`     |
| `postgresql.primary.persistence.size`         | - The size of the storage space available for the PostgreSQL database. | `100Gi`             |
| `postgresql.primary.persistence.accessModes`  | - The access modes for the PostgreSQL database storage.                | `["ReadWriteMany"]` |
