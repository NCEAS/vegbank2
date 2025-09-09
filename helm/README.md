# Introduction

This document describes how to deploy the helm chart for VegBank, which includes at this time the API (python pod with flask) and database component (postgres pod). After installing the helm chart, you should see two pods. The vegbank python pod - which houses the flask app that powers the API (ex. `https://api-dev.vegbank.org/taxon-observations/VB.TO.64992.VACCINIUMBOREAL`) and the postgres pod which contains the database that the API accesses and queries.

## Requirements

The original VegBank database and web interface (ex. `http://vegbank.org/vegbank/index.jsp`) is currently maintained by NCEAS - however, there have been no new contributions in several years. This means that the data-only dump file used in this process described below (that's currently stored in a ceph directory) is relevant and applicable for testing. The production deployment may start from a new dump file/starting point which includes schema migrations and updates, so do not use the dump file for production purposes without consulting the appropriate stakeholders.
- Note: Should you need to restore the original database that's currently maintained, you can find instructions in this repo's `INSTALL.md` document and additional information at `src/database/flyway/README.md`. 

You need to have the following things set up/installed: 

- A Kubernetes cluster and a namespace you wish to deploy the chart on (ex. dev-vegbank, dev-vegbank-dev)
- kubectl installed locally
- Helm installed locally

# Deploying to Kubernetes

This section will walk you through deploying VegBank to an empty kubernetes namespace. The required data to perform a postgres restore is already available in a directory that can be accessed by mounting a PV/PVC.

## Step 1: Apply the PV/PVC

Unless you are starting completely from scratch, you will not need to apply the PV/PVC because they are already applied in the `dev-vegbank` and `dev-vegbank-dev` namespace. You can check what PV/PVCs are applied like such:

```sh
$ kubectl get pvc | grep 'vegbank'

data-vegbankdb-postgresql-0         Bound    pvc-aca31174-4a56-4a73-b38d-a27272af938b   100Gi      RWX            csi-cephfs-sc   289d
data-vegbankdb-write-postgresql-0   Bound    pvc-bf87eec5-742c-41f2-8d3b-34d1bd228e60   100Gi      RWX            csi-cephfs-sc   66d
vegbankdb-init-pgdata               Bound    cephfs-vegbankdb-init-pgdata-dev-vegbank   100Gi      RWO            csi-cephfs-sc   45h
```

- Note: PV/PVCs cannot be shared amongst namespaces - there can only be one PV for one PVC claim. This is why you will see under `helm/admin` two sets of PV and PVC documents: one is for the namespace `dev-vegbank` and the other is for `dev-vegbank-dev`. 

If you have a new namespace (ex. `dev-dou-vegbank`), then you will need to duplicate and apply the existing PV/PVC documents in `helm/admin`.
- The pv.yaml file should be renamed, and you'll have to update `metadata.name`
- The pvc.yaml file should also be renamed, and you'll have to update `metadata.namespace` to be the user of your namespace, and `spec.volumeName` to be the `metadata.name` that you used in the pv.yaml

  ```sh
  # Apply the PV as k8s admin
  $ kubectl config use-context `dev-k8s`
  $ kubectl apply -n dev-k8s -f '/Users/doumok/Code/vegbank2/helm/admin/pvc--vegbankdb-init-douvgdb.yaml' 

  # Apply the PVC in your namespace
  $ kubectl config use-context `dev-dou-vegbank`
  $ kubectl apply -n dev-dou-vegbank -f '/Users/doumok/Code/vegbank2/helm/admin/pv--vegbankdb-init-cephfs-douvgdb.yaml' 
  ```


## Step 2: Helm Install (and Uninstall...)

If we're starting from nothing (ex. the namespace/context we're working in is completely empty), we need to first update the helm `values.yaml` section for `databaseRestore.enabled` to be `true`:

```sh
# values.yaml

databaseRestore:
  enabled: true # This needs to be changed from `false` to `true`
  target: "1.4"
  pvc: "vegbankdb-init-pgdata" # Name of the PVC
  mountpath: "/tmp/databaseRestore" # Path where you can find the PVC contents
  filepath: "vegbank_dataonly_fc_20250904.dump" # Name of the file to be used in the restoration process
```
- The target `V1.4__create_vegbank_views.sql` is the migration point which `flyway` will migrate to before restoring data, after which `V1.5__add_constraints.sql` will be applied, followed by any new migrations which are considered new schema updates.

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

The `Postgres` pod only has a fresh installation of `PostgreSQL`, without any databases or users - and now needs to be restored with the dump file.

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

There are five `initContainers`:
1) vegbankdb-init-postgres
   - This waits until the `postgres` pod is active before allowing the next `initContainer` to execute
2) vegbankdb-setup-postgres
   - If `databaseRestore.enabled` is set to `true` in `values.yaml`, this creates the `vegbank` database in your empty `postgres` instance, along with the additional roles required for flyway to apply the migration (schema) files.
3) vegbankdb-init-flyway
   - If `databaseRestore.enabled` is set to:
      - `true`, it will `flyway target=#.# migrate` to the specified point, and then stop.
      - `false`, it will `flyway migrate` which will apply all the migration files
4) vegbankdb-init-pg-restore
   - If `databaseRestore.enabled` is set to `true` it will proceed to look for the data-only dump file, which should already be present and mounted via the PV/PVC step specified earlier - and then execute it.
5) vegbankdb-apply-flyway
   - This executes `flyway migrate`, which applies any remaining migrations. 


Tip: To get a pulse of what's happening, you can run the following commands:

```sh
$ kubectl -n dev-vegbank get pods
vegbankdb-6966f945c6-xgq4l   0/1     Init:Error   1 (10s ago)   14s
vegbankdb-postgresql-0       1/1     Running      0             14s

# This will show you information about the pod, and if you scroll all the way down, where it's at in the initialization process 
$ kubectl -n dev-vegbank describe pod vegbankdb-6966f945c6-xgq4l
...

# You can get the logs of the initContainer like such, replacing the argument after the '-c' flag with the initContainer you want to check
$ kubectl logs vegbankdb-9d5859886-5bj5x -c vegbank-init-postgres --timestamps                                                                          
2025-09-05T11:50:25.467808361-07:00 Server:    10.96.0.10
2025-09-05T11:50:25.467903801-07:00 Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local
2025-09-05T11:50:25.467916402-07:00 
2025-09-05T11:50:25.467925898-07:00 Name:      vegbankdb-postgresql.vegbank-dev.svc.cluster.local
2025-09-05T11:50:25.467936056-07:00 Address 1: 10.101.158.44 vegbankdb-postgresql.vegbank-dev.svc.cluster.local

$ kubectl logs vegbankdb-9d5859886-5bj5x -c vegbank-setup-postgres --timestamps                                                                         
2025-09-05T11:51:06.697770708-07:00 ## Checking DB env vars
2025-09-05T11:51:06.700517826-07:00 VB_DB_PASS=IT_MUST_NOT_BE_SHOWN
2025-09-05T11:51:06.700572711-07:00 VB_DB_HOST=vegbankdb-postgresql
2025-09-05T11:51:06.700584740-07:00 VB_DB_USER=vegbank
2025-09-05T11:51:06.700593488-07:00 VB_DB_PORT=5432
2025-09-05T11:51:06.700601444-07:00 VB_DB_NAME=vegbank
2025-09-05T11:51:06.703446094-07:00 POSTGRES_PASSWORD=IT_MUST_NOT_BE_SHOWN
2025-09-05T11:51:06.703954976-07:00 ## Creating Vegbank database and roles
2025-09-05T11:51:06.898518198-07:00 CREATE ROLE
2025-09-05T11:51:07.455743823-07:00 CREATE DATABASE
2025-09-05T11:51:07.459641265-07:00 GRANT
2025-09-05T11:51:07.466845957-07:00 GRANT

$ kubectl logs vegbankdb-9d5859886-5bj5x -c vegbank-init-flyway --timestamps                                                                            
2025-09-05T11:51:08.469416530-07:00 ## Flyway Env
2025-09-05T11:51:08.474832435-07:00 FLYWAY_PASSWORD=IT_MUST_NOT_BE_SHOWN
2025-09-05T11:51:08.474870917-07:00 FLYWAY_USER=vegbank
2025-09-05T11:51:08.474878533-07:00 FLYWAY_URL=jdbc:postgresql://vegbankdb-postgresql:5432/vegbank
2025-09-05T11:51:08.474883935-07:00 FLYWAY_LOCATIONS=filesystem:/opt/local/flyway/db/migrations
2025-09-05T11:51:08.475426832-07:00 ## Listing Migrations
2025-09-05T11:51:08.479394569-07:00 V1.0__vegbank.sql
2025-09-05T11:51:08.479425690-07:00 V1.1__create_aggregrates.sql
2025-09-05T11:51:08.479431940-07:00 V1.2__create_extras.sql
2025-09-05T11:51:08.479437102-07:00 V1.3__create_indices.sql
2025-09-05T11:51:08.479442045-07:00 V1.4__create_vegbank_views.sql
2025-09-05T11:51:08.479447229-07:00 V1.5__add_constraints.sql
2025-09-05T11:51:08.479454324-07:00 V1.6__backfill_party_null_values.sql
2025-09-05T11:51:08.479912811-07:00 Running partial migrate to 1.4
2025-09-05T11:51:08.479937608-07:00 ## Note: If there is no flyway CLI arguments, or conf file, it will default to ENV variables
2025-09-05T11:51:10.464715855-07:00 A more recent version of Flyway is available. Find out more about Flyway 11.12.0 at https://rd.gt/3rXiSlV
2025-09-05T11:51:10.464757691-07:00 
2025-09-05T11:51:10.464767821-07:00 Flyway OSS Edition 10.17.0 by Redgate
2025-09-05T11:51:10.464788145-07:00 
2025-09-05T11:51:10.464904514-07:00 See release notes here: https://rd.gt/416ObMi
2025-09-05T11:51:10.663386908-07:00 Database: jdbc:postgresql://vegbankdb-postgresql:5432/vegbank (PostgreSQL 16.4)
2025-09-05T11:51:10.737531780-07:00 Schema history table "public"."flyway_schema_history" does not exist yet
2025-09-05T11:51:10.743367291-07:00 Successfully validated 7 migrations (execution time 00:00.033s)
2025-09-05T11:51:10.770431317-07:00 Creating Schema History table "public"."flyway_schema_history" ...
2025-09-05T11:51:11.010507209-07:00 Current version of schema "public": /</< Empty Schema />/>
2025-09-05T11:51:11.138804302-07:00 Migrating schema "public" to version "1.0 - vegbank"
2025-09-05T11:51:18.249508762-07:00 Migrating schema "public" to version "1.1 - create aggregrates"
2025-09-05T11:51:18.315983544-07:00 Migrating schema "public" to version "1.2 - create extras"
2025-09-05T11:51:18.426745450-07:00 Migrating schema "public" to version "1.3 - create indices"
2025-09-05T11:51:27.975142863-07:00 Migrating schema "public" to version "1.4 - create vegbank views"
2025-09-05T11:51:28.262490104-07:00 Successfully applied 5 migrations to schema "public", now at version v1.4 (execution time 00:16.614s)

$ kubectl logs vegbankdb-9d5859886-5bj5x -c vegbank-pg-restore --timestamps
2025-09-05T11:51:29.648359785-07:00 ## Checking DB env vars
2025-09-05T11:51:29.652135859-07:00 VB_DB_PASS=IT_MUST_NOT_BE_SHOWN
2025-09-05T11:51:29.652163546-07:00 VB_DB_HOST=vegbankdb-postgresql
2025-09-05T11:51:29.652169544-07:00 VB_DB_USER=vegbank
2025-09-05T11:51:29.652174535-07:00 VB_DB_PORT=5432
2025-09-05T11:51:29.652179064-07:00 VB_DB_NAME=vegbank
2025-09-05T11:51:29.652414949-07:00 ## Database Restore Requested, executing data-only dump file

$ kubectl logs vegbankdb-9d5859886-5bj5x -c vegbank-apply-flyway --timestamps
2025-09-05T12:26:39.474175256-07:00 ## Flyway Env
2025-09-05T12:26:39.477416816-07:00 FLYWAY_PASSWORD=IT_MUST_NOT_BE_SHOWN
2025-09-05T12:26:39.477449351-07:00 FLYWAY_USER=vegbank
2025-09-05T12:26:39.477457799-07:00 FLYWAY_URL=jdbc:postgresql://vegbankdb-postgresql:5432/vegbank
2025-09-05T12:26:39.477463014-07:00 FLYWAY_LOCATIONS=filesystem:/opt/local/flyway/db/migrations
2025-09-05T12:26:39.477838142-07:00 ## Listing Migrations
2025-09-05T12:26:39.479655876-07:00 V1.0__vegbank.sql
2025-09-05T12:26:39.479677716-07:00 V1.1__create_aggregrates.sql
2025-09-05T12:26:39.479681354-07:00 V1.2__create_extras.sql
2025-09-05T12:26:39.479691117-07:00 V1.3__create_indices.sql
2025-09-05T12:26:39.479694215-07:00 V1.4__create_vegbank_views.sql
2025-09-05T12:26:39.479698005-07:00 V1.5__add_constraints.sql
2025-09-05T12:26:39.479701282-07:00 V1.6__backfill_party_null_values.sql
2025-09-05T12:26:39.479823299-07:00 Applying all migrations in db/migrations
2025-09-05T12:26:41.389386373-07:00 A more recent version of Flyway is available. Find out more about Flyway 11.12.0 at https://rd.gt/3rXiSlV
2025-09-05T12:26:41.389441446-07:00 
2025-09-05T12:26:41.389446352-07:00 Flyway OSS Edition 10.17.0 by Redgate
2025-09-05T12:26:41.389449242-07:00 
2025-09-05T12:26:41.389463465-07:00 See release notes here: https://rd.gt/416ObMi
2025-09-05T12:26:41.623125321-07:00 Database: jdbc:postgresql://vegbankdb-postgresql:5432/vegbank (PostgreSQL 16.4)
2025-09-05T12:26:43.430193165-07:00 Successfully validated 7 migrations (execution time 00:00.442s)
2025-09-05T12:26:43.524264740-07:00 Current version of schema "public": 1.4
2025-09-05T12:26:43.637810377-07:00 Migrating schema "public" to version "1.5 - add constraints"
2025-09-05T12:28:33.399376226-07:00 Migrating schema "public" to version "1.6 - backfill party null values"
2025-09-05T12:28:33.857676384-07:00 Successfully applied 2 migrations to schema "public", now at version v1.6 (execution time 01:49.502s)

$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
vegbankdb-9d5859886-5bj5x   1/1     Running   0          40m
vegbankdb-postgresql-0      1/1     Running   0          40m
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
