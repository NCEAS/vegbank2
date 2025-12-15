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
- Note #2: The `cnpg` deployment has default values which can be found [here](https://github.com/DataONEorg/dataone-cnpg/blob/main/values.yaml). When you install the vegbank `values-cnpg.yaml` configuration file, these default values get overridden by what is defined in `values-cnpg.yaml`.

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
$ pwd
/Users/doumok/Code/vegbank2/helm
$ helm install vegbankapi .
```

### Development Values File: 'values-overrides-dev.yaml' 

If you are on a namespace without ingress (ex. `dev-vegbank-dev`), deploying the `vegbankapi` chart will result in errors. To help reduce confusion and for development purposes, we have a `values-overrides-dev.yaml` file which contains components that you'll likely want to take control over. By default, this overrides file' override values turns the database restoration process off and disables ingress.

```sh
$ helm install vegbankapi . -f values-overrides-dev.yaml

# If you do not wish to use the overrides file, you may manually turn ingress off like such
$ helm install vegbankapi . --set ingress.enabled=false

# Note: Please see the section 'Connecting to API via kubectl port forwarding' if you wish to access the API without ingress
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
$ helm upgrade vegbankapi .

# If you don't have an ingress
# Option 1: Use the `values-overrides-dev.yaml` file, which deactivates ingress and the database restoration
$ helm upgrade vegbankapi . -f values-overrides-dev.yaml
# Option 2: Manually turn off ingress
$ helm upgrade vegbankapi . --set ingress.enabled=false
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

# Recovery & Backup

The vegbank DB will be backed up using the `cnpg` `ScheduledBackUp` custom resource. To learn more about this, view our `cnpg` operator documentation [here](https://github.com/DataONEorg/k8s-cluster/blob/main/operators/postgres/postgres.md#database-backups).

The default values or settings for the backups generated can be found [here](https://github.com/DataONEorg/dataone-cnpg/blob/main/values.yaml). For example, if you do not define 'schedule' in `values-cnpg.yaml` - it will default to "0 0 21 * * *" which is 9PM UTC Daily (1PM PST). Note - this may change overtime as improvements are made to the `cnpg` deployment.

## Recovering from a ScheduledBackup

If you wish to deploy a `cnpg` cluster via a `ScheduledBackup`, you can do so by:
- Changing the `init.enabled` section in `values.yaml` to `true`
- Changing the `init.method` section to `recovery`
- Providing a specific volume snapshot/backup to recover from for `init.recoverFromBackup`.
- Important Note: if you are redeploying after a disaster, you will also need to enable the `ScheduledBackup` process to begin creating volume snapshots once again. To do this, change `backup.enabled` in `values.yaml` to `true` before executing `helm install ...`

  ```
  ## @section CNPG Init - Bootstrap the CNPG cluster via different init options.
  init:
    enabled: true
    method: recovery
    recoverFromBackup: vegbankdb-scheduled-backup-20251205210000

  backup:
    enabled: true
  ```

  Tip: You can check if there is an existing `ScheduledBackup` by executing the following:

  ```sh
  # Note, you must have admin privileges to check for `ScheduledBackup`s
  $ kubectl get scheduledbackup -n vegbank-dev --context=dev-k8s 

  NAME                         AGE   CLUSTER          LAST BACKUP
  vegbankdb-scheduled-backup   57s   vegbankdb-cnpg   57s
  ```

  Tip #2: You can check for specific backups/volumesnapshots by executing the following:

  ```sh
  $ kubectl get backups -n vegbank-dev
  ```

Once you've updated your configuration, please install your `cnpg` `helm` chart as you would normally. Example:

```sh
$ helm install vegbankvelero oci://ghcr.io/dataoneorg/charts/cnpg -f '/Users/doumok/Code/vegbank2/helm/values-cnpg.yaml' --debug
```

Check to see that the process has begun by executing the following, and looking for the `snapshot` pod:
```sh
$ kubectl get pods -n dev-vegbank
NAME                                           READY   STATUS    RESTARTS      AGE
vegbankapi-54b85649c6-2pwcm                    1/1     Running   0             4d19h
vegbankdb-cnpg-1                               1/1     Running   2             52d
vegbankdb-cnpg-2                               1/1     Running   1 (16d ago)   52d
vegbankdb-cnpg-3                               1/1     Running   1 (16d ago)   52d
vegbankvelero-cnpg-1-snapshot-recovery-pqsl9   0/1     Pending   0             2s
```

It takes approximately 10 minutes for the pods to be assigned, after which the recovery process will begin. For example:
```sh
$ kubectl describe pod vegbankvelero-cnpg-1-snapshot-recovery-pqsl9 -n dev-vegbank
...
Events:
  Type     Reason            Age                    From               Message
  ----     ------            ----                   ----               -------
  Warning  FailedScheduling  12m                    default-scheduler  0/6 nodes are available: pod has unbound immediate PersistentVolumeClaims. preemption: 0/6 nodes are available: 6 Preemption is not helpful for scheduling..
  Warning  FailedScheduling  2m46s (x2 over 7m46s)  default-scheduler  0/6 nodes are available: pod has unbound immediate PersistentVolumeClaims. preemption: 0/6 nodes are available: 6 Preemption is not helpful for scheduling..
  Normal   Scheduled         67s                    default-scheduler  Successfully assigned vegbank-dev/vegbankvelero-cnpg-1-snapshot-recovery-pqsl9 to k8s-dev-node-4
  Normal   Pulled            64s                    kubelet            Container image "ghcr.io/cloudnative-pg/cloudnative-pg:1.27.0" already present on machine
  Normal   Created           63s                    kubelet            Created container bootstrap-controller
  Normal   Started           63s                    kubelet            Started container bootstrap-controller
  Normal   Pulled            59s                    kubelet            Container image "ghcr.io/cloudnative-pg/postgresql:17.5" already present on machine
  Normal   Created           58s                    kubelet            Created container snapshot-recovery
  Normal   Started           57s                    kubelet            Started container snapshot-recovery
```

To watch the process execute, you can run `watch kubectl get pods`

```sh
$ watch kubectl get pods -n dev-vegbank
NAME                                           READY   STATUS      RESTARTS      AGE
vegbankapi-54b85649c6-2pwcm                    1/1     Running     0             4d19h
vegbankdb-cnpg-1                               1/1     Running     2             52d
vegbankdb-cnpg-2                               1/1     Running     1 (16d ago)   52d
vegbankdb-cnpg-3                               1/1     Running     1 (16d ago)   52d
vegbankvelero-cnpg-1                           1/1     Running     0             6m25s
vegbankvelero-cnpg-1-snapshot-recovery-pqsl9   0/1     Completed   0             18m
vegbankvelero-cnpg-2                           1/1     Running     0             105s
vegbankvelero-cnpg-2-join-dhq22                0/1     Completed   0             5m58s
vegbankvelero-cnpg-3-join-swdfb                1/1     Running     0             81s

$ kubectl get pods - n dev-vegbank
NAME                          READY   STATUS    RESTARTS      AGE
vegbankapi-54b85649c6-2pwcm   1/1     Running   0             4d19h
vegbankdb-cnpg-1              1/1     Running   2             52d
vegbankdb-cnpg-2              1/1     Running   1 (16d ago)   52d
vegbankdb-cnpg-3              1/1     Running   1 (16d ago)   52d
vegbankvelero-cnpg-1          1/1     Running   0             9m37s
vegbankvelero-cnpg-2          1/1     Running   0             4m57s
vegbankvelero-cnpg-3          1/1     Running   0             78s
```

And then finally, to confirm that `ScheduledBackups` are being run once again:

```sh
$ kubectl get backup -n dev-vegbank
...
vegbankdb-scheduled-backup-20251207210000       22h     vegbankdb-cnpg       volumeSnapshot   completed   
vegbankvelero-scheduled-backup-20251208192351   2m20s   vegbankvelero-cnpg   volumeSnapshot   completed  
```

### How to recover a deleted `ScheduledBackup` via `velero`

If you have accidentally deleted and need to recover a specific backup, you can use `velero` to do so. `velero` is what we use to back up `kubernetes` resources, which includes `cnpg` resources like `ScheduledBackup`s.

To begin and see the available `velero` backups that we can recover from, run the following command:

```sh
$ velero backup get
# You will see a list of available backups that you can select from
...
full-backup-20251203030015           PartiallyFailed   1        2          2025-12-02 19:00:15 -0800 PST   87d       default            <none>
...
```

After you've found the `velero` backup you wish to restore from, you can recover the `cnpg` backup/snapshot like this:

```sh
# velero restore create [give_your_restore_a_name]
$ velero restore create restore-cnpg-bkup-dou-test \                                                                                               
  --from-backup full-backup-20251203030015 \
  --include-resources=backups.postgresql.cnpg.io \
  --include-namespaces=dev-vegbank-dev
Restore request "restore-cnpg-bkup-dou-test" submitted successfully.
Run `velero restore describe restore-cnpg-bkup-dou-test` or `velero restore logs restore-cnpg-bkup-dou-test` for more details.
```

Check whether the backup worked, by running the following command:

```sh
$ velero restore get                                                                                                                               
NAME                         BACKUP                       STATUS       STARTED                         COMPLETED   ERRORS   WARNINGS   CREATED                         SELECTOR
restore-cnpg-bkup-dou-test   full-backup-20251203030015   InProgress   2025-12-05 13:19:23 -0800 PST   <nil>       0        0          2025-12-05 13:19:23 -0800 PST   <none>

$ velero restore get 
NAME                         BACKUP                       STATUS      STARTED                         COMPLETED                       ERRORS   WARNINGS   CREATED                         SELECTOR
restore-cnpg-bkup-dou-test   full-backup-20251203030015   Completed   2025-12-05 13:19:23 -0800 PST   2025-12-05 13:25:30 -0800 PST   0        0          2025-12-05 13:19:23 -0800 PST   <none>
```

Now that we've restored the missing or accidentally deleted backup, you can proceed with the normal recovery process defined above with ScheduledBackups.

## Recovery using data folders in a file system (Cumbersome, but it works)

If for whatever reason we do not have `ScheduledBackups` available to us after a disaster occurs, and we have literally nothing but a physical directory of the `postgres` data that can be found from a backup of physical files on disk - we can still get a working version of the `postgres` database with Docker.

**Step 1: Copy the data folder to your local directory and navigate to it**

To get the `vegbank` db back up and running, we will first copy that postgres data folder to our local directory and navigate to it.
```sh
doumok@Dou-NCEAS-MBP14.local:~ $ cd /Code/testing/pgrecoverytesting/pgdata
```

Now, we modify the following settings because the setup for `cnpg` does not match what we are trying to achieve with a Docker instance. 
- Adjust the log directory and create a `log` directory in your `pgdata` folder - or set this folder to another location of your choice. You can choose a new `log_filename` if you desire it
  ```sh
  # custom.conf
  ...
  log_directory = './log'
  log_filename
  ...
  ```or a local docker instance
  ```sh
  # custom.conf
  ...
  # ssl = 'on'
  # ssl_ca_file = '/controller/certificates/client-ca.crt'
  # ssl_cert_file = '/controller/certificates/server.crt'
  # ssl_key_file = '/controller/certificates/server.key'
  # ssl_max_protocol_version = 'TLSv1.3'
  # ssl_min_protocol_version = 'TLSv1.3'
  # unix_socket_directories = '/controller/run'
  ...
  ```

**Step 2: Get a running `postgres` instance via `docker`**
```sh
# Note: You must be in the data folder where you see `/base`, `global`, etc. when running this docker command.
## This will mount the current directory to the path you specified (ex. `/var/lib/postgresql/data`)
doumok@Dou-NCEAS-MBP14.local:~/Code/testing/pgrecoverytesting/pgdata $ docker run -it --rm -e POSTGRES_PASSWORD=postgres -v $(pwd):/var/lib/postgresql/data -p 5432:5432 postgres:17
```

**Step 3: Test that it's working**
```sh
# Note: The password is the secret originally used in the kubernetes cluster (i.e. `vegbankdbcreds`).
## You can get the password from this secret by getting the yaml output and then base64 decoding it
### `kubectl get secrets vegbankdbcreds -o yaml`
### `echo 'the_hashed_password_' | base64 --decode
$ psql -h localhost -U vegbank

Password for user vegbank:
WARNING:  database "vegbank" has a collation version mismatch
DETAIL:  The database was created using collation version 153.14, but the operating system provides version 153.120.
HINT:  Rebuild all objects in this database that use the default collation and run ALTER DATABASE vegbank REFRESH COLLATION VERSION, or build PostgreSQL with the right library version.
psql (14.11 (Homebrew), server 17.5 (Debian 17.5-1.pgdg120+1))
WARNING: psql major version 14, server major version 17.
         Some psql features might not work.
Type "help" for help.

\dt
# This lists all the tables which shows a successful recovery
```

**Step 4: Restore the `cnpg` cluster**

From here, we can get a dump file, mount it to a path, and use the existing steps to launch a `cnpg` cluster.

```sh
$ pg_dump -h localhost -U vegbank -d vegbank -Fc -f vegbank_20251105.dump
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
