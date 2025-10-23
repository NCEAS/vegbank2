# Introduction

This document describes how to deploy the helm charts for VegBank API and the VegBank Postgres Cluster. After installing the helm charts, you should see four pods. The vegbank python pod - which houses the flask app that powers the API (ex. `https://api-dev.vegbank.org/taxon-observations/VB.TO.64992.VACCINIUMBOREAL`) and the postgres pods which contains the database that the API accesses and queries. The postgres pods consist of a primary read-write pod and two replica read-only pods.

- Note #1: The original VegBank database and web interface (ex. `http://vegbank.org/vegbank/index.jsp`) is currently maintained by NCEAS - however, there have been no new contributions in several years. This means that the data-only dump file used in this process described below (that's currently stored in a ceph directory) is relevant and applicable for testing. The production deployment may start from a new dump file/starting point which includes schema migrations and updates, so do not use the dump file for production purposes without consulting the appropriate stakeholders.
- Note #2: Should you need to restore the original database that's currently maintained, you can find instructions in this repo's `INSTALL.md` document and additional information at `src/database/flyway/README.md`. 

## Requirements

You need to have the following things set up/installed: 

- A Kubernetes cluster and a namespace you wish to deploy the chart on (ex. vegbank, dev-vegbank)
- kubectl installed locally
- Helm installed locally

# Deploying to Kubernetes - Development Server

This section will walk you through deploying VegBank to an empty kubernetes namespace. You can deploy vegbank with data, or without data - and the required dump file to perform a postgres restore has been made available via mounting of a static PV/PVC to both `dev-vegbank` and `vegbank` namespaces.

Any additional requests for further mounts must be requested via the development team. 

## Step 1: Getting your dump file

As progress is made, postgres dump files will be created, updated and made available to the team. These dump files currently live in the shared development CephFS folder that's mounted in the `knbvm (knbvm.nceas.ucsb.edu)` under `/mnt/ceph/repos/vegbank`.

A dump file is already available for development purposes. In production, this process may differ.

## Step 2: Helm Install (and Uninstall...)

If we're starting from nothing (ex. the namespace/context we're working in is completely empty), we need to determine if we should update the helm `values.yaml` section for `databaseRestore`.

`databaseRestore.enabled` should be set to `true` if you want to restore the database using a dump file. If you want a fresh database installation with no data, leave this as `false`.

```sh
# values.yaml

databaseRestore:
  enabled: true # This needs to be changed from `false` to `true` if you want to restore data
  pvc: "vegbankdb-init-pgdata" # Name of the PVC
  mountpath: "/tmp/databaseRestore" # Path where you can find the PVC contents
  filepath: "vegbank_full_fc_v1.9_pg16_20250924.dump" # Name of the file to be used in the restoration process
```

Before we deploy this Vegbank API helm chart, we must ensure that postgres is available. So we first deploy the `cnpg` helm chart. This will initialize 3 postgres pods - wait for all three pods to be ready before proceeding to deploy the Vegbank API helm chart.
- Note: Double check that the postgres image in the `databaseRestore.postgres_image` section in `values.yaml` has the same major version as the `cnpg`. Postgres major versions must match otherwise the restore process will not be able to proceed with connecting and restoring.

```sh
# IMPORTANT: The chart name we will use to be consistent is `vegbankdb`.
# We are using a dataone cnpg image so the postgres cluster will deploy with the prefix 'vegbankdb'. Thus, the host of the primary postgres pod will be 'vegbankdb-cnpg-rw'
#
# If you experience issues with deployment, double check that you have the latest chart version.
$ helm install vegbankdb oci://ghcr.io/dataoneorg/charts/cnpg -f values-cnpg.yaml

# If you would like to install a specific version, this is how you can do so
# where the latest [version#] can be found at https://github.com/DataONEorg/dataone-cnpg/pkgs/container/charts%2Fcnpg
$ helm install vegbankdb oci://ghcr.io/dataoneorg/charts/cnpg --version [version#] -f values-cnpg.yaml

$ kubectl -n dev-vegbank get pods
NAME                         READY   STATUS    RESTARTS   AGE
vegbankdb-cnpg-1             1/1     Running   0          5m
vegbankdb-cnpg-2             1/1     Running   0          6m
vegbankdb-cnpg-3             1/1     Running   0          7m
```

Now we can deploy the helm chart. This can be done simply by opening a terminal in the root folder of this repo, then running the following command: 

```sh
# Or if you're in the helm folder
$ helm install vegbankapi . -f values.yaml --set ingress.enabled=true
```

If you are on a namespace without ingress (ex. `dev-vegbank-dev`), be sure to adjust the ingress.enabled option to false to prevent ingress errors:

```sh
# If you do not have ingress
# Note: Please see the section 'Connecting to API via kubectl port forwarding' if you wish to access the API without ingress
$ helm install vegbankapi . -f values.yaml --set ingress.enabled=false
```

This will install the python API pod (based on the `docker/Dockerfile` in this repo) on the namespace you have selected as your current context (ex. `dev-vegbank`), and give the pod the starting prefix of `vegbankapi` in its name. You can change the name `vegbankapi` to whatever you like.

- Tip: If you are clearing out an existing namespace (ex. `dev-vegbank-dev`), or need to restart this process - you can start fresh by uninstalling the chart. If you run into conflicts, be sure to double check that the associated PVCs, references and charts to old dependencies are removed (ex. The .tgz file under `charts/` may need to be deleted)

  ### CAUTION: Uninstalling Charts -  Be Careful!

  The `cnpg` chart we are deploying is extended from the [`dataone-cnpg` chart](https://github.com/DataONEorg/dataone-cnpg/blob/main/README.md) with our `values-cnpg` overrides file. If you uninstall the chart, you will be deleting the associated PVC and the automatically generated secret if you did not supply one - and will likely lose all your data. Please proceed with caution and backup data and secrets.

## Step 3: Watch the `initContainers`

At this point, your namespace is empty and you have a fresh installation of `postgres`. There is nothing left for you to do but sit and wait for the `initContainers` to finish executing.

There are two `initContainers`:
1) vegbankdb-reconcile-postgres
   - This waits until the `postgres` pod is accepting connections before proceeding with the next `initContainer`
   - If `databaseRestore.enabled` is set to `true` in `values.yaml`:
       - This then takes the dump file associated in `values.yaml` and restores it to the empty cluster
2) vegbankdb-apply-flyway
   - This executes `flyway migrate`, which applies the migration files found in `/db/migrations`


Tip: To get a pulse of what's happening, you can run the following commands:

```sh
$ kubectl -n dev-vegbank get pods
NAME                          READY   STATUS     RESTARTS   AGE
vegbankapi-bb94bf498-6fpw4    0/1     Init:0/2   0          12s
vegbankdb-cnpg-1              1/1     Running    0          5m4s
vegbankdb-cnpg-2              1/1     Running    0          3m36s
vegbankdb-cnpg-3              1/1     Running    0          2m19s

# This will show you information about the pod, and if you scroll all the way down, where it's at in the initialization process 
$ kubectl -n dev-vegbank describe pod vegbankapi-bb94bf498-6fpw4
...

# You can get the logs of the initContainer like below, replace the argument after the '-c' flag with the initContainer you want to check
$ kubectl -n dev-vegbank logs vegbankapi-bb94bf498-6fpw4 -c vegbankapi-reconcile-postgres --timestamps                                                                          
2025-09-25T10:10:11.129037693-07:00 vegbankdb-cnpg-rw:5432 - accepting connections
2025-09-25T10:10:11.129130874-07:00 CNPG is acception connections.
2025-09-25T10:10:11.129146915-07:00 Database Restore Requested, restoring from specific dump file

$ kubectl -n dev-vegbank logs vegbankapi-bb94bf498-6fpw4 -c vegbankapi-apply-flyway --timestamps
2025-09-25T10:35:06.910428714-07:00 ## Flyway Env
2025-09-25T10:35:06.914609424-07:00 FLYWAY_PASSWORD=NO_PASSWORDS_SHOULD_BE_SHARED
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

$ kubectl -n dev-vegbank get pods
NAME                         READY   STATUS    RESTARTS   AGE
vegbankapi-bb94bf498-6fpw4   1/1     Running   0          3h28m
vegbankdb-cnpg-1             1/1     Running   0          4h10m
vegbankdb-cnpg-2             1/1     Running   0          4h8m
vegbankdb-cnpg-3             1/1     Running   0          4h7m
```

After the `initContainers` complete, you will now have an up-to-date copy of the current `vegbank` postgres database - which has applied all migrations found in `helm/db/mgrations`.

## Step 4: Applying new migration files 

If you are testing new schema updates, add them to `helm/db/migrations` with the correct naming convention and run a `helm` upgrade command. Example:

```sh
# If you have ingress enabled
$ helm upgrade vegbankapi . -f values.yaml --set ingress.enabled=true

# If you don't have an ingress
$ helm upgrade vegbankapi . -f values.yaml --set ingress.enabled=false
```

- Note: Do not forget to change the `databaseRestore.enabled` value back to `false` if you've set it to `true`.

  ```sh
  # values.yaml

  databaseRestore:
    enabled: false # Set this back to false! 
    pvc: "vegbankdb-init-pgdata"
    mountpath: "/tmp/databaseRestore"
    filepath: "vegbank_full_fc_v1.9_pg16_20250924.dump"
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

Then you can access the API on localhost via the port you specified. Full example below:
```sh
$ kubectl -n dev-vegbank port-forward vegbank-745779dccd-994r6 2580:80
# And then access it like such: http://localhost:2580/taxon-observations/VB.TO.64992.VACCINIUMBOREAL
```


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
