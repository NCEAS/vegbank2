# Introduction

This document describes how to deploy the helm chart and database for the PostgreSQL pod component of VegBank. After installing the helm chart, you should see two pods. The vegbankdb python pod - which houses the flask app that powers the API (ex. `https://api-dev.vegbank.org/taxon-observations/VB.TO.64992.VACCINIUMBOREAL`) and the postgres pod which contains the database that the API accesses and queries.

## Requirements

The original VegBank database and web interface (ex. `http://vegbank.org/vegbank/index.jsp`) is currently maintained by NCEAS - however, there have been no new contributions in several years. This means that the data-only dump file used in this process described below (that's currently stored in a ceph directory) is relevant and applicable for testing and for the initial production deployment. Should you need to restore the original database that's currently maintained, you can find instructions in this repo's `INSTALL.md` document and additional information at `src/database/flyway/README.md`. 

You need to have the following things set up/installed: 

- A Kubernetes cluster and a namespace you wish to deploy the chart on (ex. dev-vegbank, dev-vegbank-dev)
- kubectl installed locally
- Helm installed locally

# Deploying to Kubernetes

This section will walk you through deploying VegBank to an empty kubernetes namespace. Reminder - the required data to perform a postgres restore is already available in a directory that can be accessed by mounting a PV/PVC.

## Step 1: Apply the PV/PVC
- Note: PV/PVCs cannot be shared amongst namespaces - there can only be one PV for one PVC claim. This is why you will see under `helm/admin` two sets of PV and PVC documents: one is for the namespace `dev-vegbank` and the other is for `dev-vegbank-dev`.

Unless you are starting completely from scratch, you will not need to apply the PV/PVC because they are already applied in the `dev-vegbank` and `dev-vegbank-dev` namespace. You can check what PV/PVCs are applied like such:

```sh
$ kubectl get pvc | grep 'vegbank'

data-vegbankdb-postgresql-0         Bound    pvc-aca31174-4a56-4a73-b38d-a27272af938b   100Gi      RWX            csi-cephfs-sc   289d
data-vegbankdb-write-postgresql-0   Bound    pvc-bf87eec5-742c-41f2-8d3b-34d1bd228e60   100Gi      RWX            csi-cephfs-sc   66d
vegbankdb-init-pgdata               Bound    cephfs-vegbankdb-init-pgdata-dev-vegbank   100Gi      RWO            csi-cephfs-sc   45h
```

If you have a new namespace (ex. `dev-dou-vegbank`), then you will need to duplicate and apply the existing PV/PVC documents in `helm/admin`.
- The pv.yaml file should be renamed, and you'll have to update `metadata.name`
- The pvc.yaml file should also be renamed, and you'll have to update `metadata.namespace` to be the user of your namespace, and `spec.volumeName` to be the `metadata.name` that you used in the pv.yaml

  ```sh
  # Apply the PV as k8s admin
  $ kubectl config use-context `dev-k8s`
  $ kubectl apply -n dev-vegbank -f '/Users/doumok/Code/vegbank2/helm/admin/pvc--vegbankdb-init-douvgdb.yaml' 

  # Apply the PVC in your namespace
  $ kubectl config use-context `dev-dou-vegbank`
  $ kubectl apply -n dev-vegbank -f '/Users/doumok/Code/vegbank2/helm/admin/pv--vegbankdb-init-cephfs-douvgdb.yaml' 
  ```


## Step 2: Helm Install (and Uninstall...)

If we're starting from nothing (ex. the namespace/context we're working in is completely empty), we need to first update the helm `values.yaml` section for `databaseRestore.enabled` to be `true`:

```sh
# values.yaml

databaseRestore:
  enabled: true # This needs to be changed from `false` to `true`
  target: "1.6"
  pvc: "vegbankdb-init-pgdata" # Name of the PVC
  mountpath: "/tmp/databaseRestore" # Path where you can find the PV contents
  filepath: "vegbank_dataonly_20240814.sql" # Name of the file to be used in the restoration process
```
- The target `1.6` is the migration point which `flyway` will migrate until. Any new migrations after this are considered new schema updates and need to be applied after the data restore.

Now we can deploy the helm chart. This can be done simply by opening a terminal in the root folder of this repo, then running the following command: 

```sh
# If you're in the root folder
$ helm install vegbankdb helm

# Or if you're in the helm folder
$ helm install vegbankdb .
```

If you are on a namespace without ingress (ex. `dev-vegbank-dev`), be sure to set the flag to prevent ingress errors:

```sh
$ helm install vegbankdb . --set ingress.enabled=false
```

This will install both the python pod (based on the `docker/Dockerfile` in this repo) and the Postgres pod (using the `bitnami` image) on the namespace you have selected as your current context (ex. `dev-vegbank`), and give the pods the starting prefix of `vegbankdb` in its name. You can change the name vegbankdb to whatever you like. The `Postgre` pod only has a fresh installation of `PostgreSQL`, without any databases or users - and now needs to be restored with the dump file.

- Tip: If you are clearing out an existing namespace, or need to restart this process - you can do this by uninstalling the helm chart and deleting the existing postgres content.

  ```sh
  $ kubectl exec -it vegbankdb-postgresql-0 -- /bin/sh
  # Remove all associated database data
  # This will cause your pod to be forcefully restarted - and you will be booted out of the pod
  $ rm -rf /bitnami/postgresql/data
  # Exit the shell (ctrl+d) if you aren't automatically booted
  $ helm uninstall vegbankdb
  ```

  This will delete all the pods and give you a fresh start. The `PostgreSQL` pod will start up and point to an empty directory, ready for you to restart this process (ex. creating a new `vegbank` user, a new database `vegbank`, etc.)


## Step 3: `initContainers` - Don't Panic!

At this point, your pod will not be able to start up successfully. This is because the helm chart utilizes `initContainers` to restore data and/or apply migrations. You can check what's happening by looking at the logs for the python container like such:

```sh
$ kubectl -n dev-vegbank get pods
vegbankdb-6966f945c6-xgq4l   0/1     Init:Error   1 (10s ago)   14s
vegbankdb-postgresql-0       1/1     Running      0             14s

# This will show you information about the pod, and if you scroll all the way down, where it's at in the initialization process 
$ kubectl -n dev-vegbank describe pod vegbankdb-6966f945c6-xgq4l
```

There are three `initContainers`:
1) vegbankdb-init-postgres
   - This waits until the `postgres` pod is active before allowing the next `initContainer` to execute
2) vegbankdb-init-flyway
   - This checks the `databaseRestore` section in `values.yaml` to see whether `databaseReestore.enabled` is set to true or false.
   - If true, it will `flyway target=#.# migrate` to the specified point, and then stop.
   - If false, it will `flyway migrate` which will apply all the migration files
3) vegbankdb-init-pg-restore
   - If `databaseRestore.enabled` is set to `true` it will proceed to look for the data-only dump file, which should already be present and mounted via the PV/PVC step specified earlier - and then execute it.

Upon installing the chart, the `initContainer` that runs after we confirm the Postgres pod is active, `vegbankdb-init-flyway`, will fail and error out. It uses `flyway` to apply migrations, which attempts to connect to the the `PostgresSQL` pod that does not have any database or data. So we will need to exec into the `PostgresQL` pod and get it set up so that the helm startup process with `flyway` and `postgres` can execute with the correct credentials/faculties in place.


## Step 4: Postgres Pod Set-up

First, double check that you see the postgres pod:

```sh
$ kubectl -n dev-vegbank get pods

vegbankdb-6966f945c6-xgq4l   0/1     Init:Error   1 (10s ago)   14s
vegbankdb-postgresql-0       1/1     Running      0             14s
```

Now let's set up the postgres instance (in our case, a fresh installation of PG16)

```sh
# Shell into the pod
$ kubectl -n dev-vegbank exec -it vegbankdb-postgresql-0 -- /bin/sh
# Access postgres as user `postgres`
$ psql -U postgres
psql (16.4)
Type "help" for help.

# Create the vegbank role, and replace the password with the actual secret
CREATE ROLE vegbank WITH LOGIN PASSWORD 'PASSWORD_PLACEHOLDER';
CREATE DATABASE vegbank
WITH
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8';
# Give database-level privileges (ex. connect, create schema, temp, etc.)
GRANT ALL PRIVILEGES ON DATABASE vegbank TO vegbank;
# Give schema-level privileges (ex. to create public.flyway_history)
GRANT USAGE, CREATE ON SCHEMA public TO vegbank;
```
- Note: `PASSWORD_PLACEHOLDER` must be replaced with the actual secret, which gets applied as an environment variable upon startup of the pod. You can get this by running the following command:

  ```sh
  $ kubectl -n dev-vegbank exec -it vegbankdb-6966f945c6-xgq4 -- env
  ```

## Step 4: Restarting the Pod & Restoring Data

Now that `postgres` has been configured, we need to restart the pod so that the `initContainers` can execute again, and proceed with the data restore process. The command below will restart the pods, allowing the `initContainers` to move forward (with the database now set up). 

```sh
$ helm upgrade vegbankdb .
```

The `initContainer` `vegbankdb-init-flyway` will complete its migration to the specified target. Then, the `initContainer` `vegbankdb-init-pg-restore` will begin the restoration process.

the To check the status, you can view the `initContainer` logs by running the following command (and its respective output included for context)

```sh
$ kubectl -n dev-vegbank logs vegbankdb-5b6956f48d-xgq4l -c vegbankdb-init-pg-restore --timestamps

2025-08-27T12:50:48.311616452-07:00 ## Checking DB env vars
2025-08-27T12:50:48.318224468-07:00 VB_DB_PASS=HIDDEN_DO_NOT_LOOK
2025-08-27T12:50:48.318273888-07:00 VB_DB_HOST=vegbankdb-postgresql
2025-08-27T12:50:48.318285168-07:00 VB_DB_USER=vegbank
2025-08-27T12:50:48.318293773-07:00 VB_DB_PORT=5432
2025-08-27T12:50:48.318301494-07:00 VB_DB_NAME=vegbank
2025-08-27T12:50:48.318681067-07:00 ## Database Restore Requested, executing data-only dump file
2025-08-27T12:50:48.514063409-07:00 SET
2025-08-27T12:50:48.515233506-07:00 SET
2025-08-27T12:50:48.516568703-07:00 SET
2025-08-27T12:50:48.518125183-07:00 SET
2025-08-27T12:50:48.519532102-07:00 SET
2025-08-27T12:50:48.522046465-07:00  set_config 
2025-08-27T12:50:48.522076079-07:00 ------------
2025-08-27T12:50:48.522084489-07:00  
2025-08-27T12:50:48.522092562-07:00 (1 row)
2025-08-27T12:50:48.522099332-07:00 
2025-08-27T12:50:48.523328121-07:00 SET
2025-08-27T12:50:48.525069196-07:00 SET
2025-08-27T12:50:48.526477305-07:00 SET
2025-08-27T12:50:48.527877926-07:00 SET
2025-08-27T12:50:48.754109944-07:00 COPY 4024
2025-08-27T12:50:48.819201375-07:00 COPY 621
2025-08-27T12:50:48.839692179-07:00 COPY 21
2025-08-27T12:50:48.867970199-07:00 COPY 220
2025-08-27T12:50:48.903502433-07:00 COPY 470
2025-08-27T12:50:48.916298956-07:00 COPY 31
2025-08-27T12:50:55.221163626-07:00 COPY 115277
2025-08-27T12:50:55.246371679-07:00 COPY 261
2025-08-27T12:50:57.192204298-07:00 COPY 34610
2025-08-27T12:50:57.212768032-07:00 COPY 21
2025-08-27T12:51:22.278050357-07:00 COPY 115624
2025-08-27T12:51:34.638140437-07:00 COPY 102425
2025-08-27T12:51:45.634684694-07:00 COPY 48584
2025-08-27T12:51:53.048854066-07:00 COPY 123701
2025-08-27T12:51:58.443253691-07:00 COPY 38961
2025-08-27T12:52:03.890018721-07:00 COPY 39041
2025-08-27T12:52:06.496049468-07:00 COPY 34377
2025-08-27T12:52:14.657145080-07:00 COPY 102951
2025-08-27T12:52:14.659530433-07:00 COPY 0
2025-08-27T12:52:42.935897995-07:00 COPY 146761
2025-08-27T12:52:43.066841559-07:00 COPY 398
2025-08-27T12:52:43.111990263-07:00 COPY 8
2025-08-27T12:52:43.183009293-07:00 COPY 19
2025-08-27T12:52:43.211905131-07:00 COPY 19
2025-08-27T12:52:43.279555430-07:00 COPY 9
2025-08-27T12:52:43.313788639-07:00 COPY 1
2025-08-27T12:52:43.393301818-07:00 COPY 2658
2025-08-27T12:52:43.490271899-07:00 COPY 594
2025-08-27T12:52:43.545101852-07:00 COPY 866
2025-08-27T12:52:43.628843848-07:00 COPY 1
2025-08-27T12:53:06.678188205-07:00 COPY 2233737
2025-08-27T12:53:06.791128713-07:00 COPY 55
2025-08-27T12:55:30.302290461-07:00 COPY 114063
2025-08-27T12:55:30.618103851-07:00 COPY 35
2025-08-27T12:55:31.842699711-07:00 COPY 49566
2025-08-27T12:55:49.072805627-07:00 COPY 37531
2025-08-27T12:55:51.700938690-07:00 COPY 1502
2025-08-27T12:55:51.707698028-07:00 COPY 0
2025-08-27T12:55:58.231964328-07:00 COPY 410177
2025-08-27T12:55:58.439178981-07:00 COPY 44949
2025-08-27T12:56:01.788866499-07:00 COPY 64563
2025-08-27T12:56:04.971375118-07:00 COPY 64722
2025-08-27T12:56:04.974091656-07:00 COPY 0
2025-08-27T12:56:04.976574903-07:00 COPY 0
2025-08-27T12:56:43.617250798-07:00 COPY 165021
2025-08-27T12:56:44.737694143-07:00 COPY 3814
2025-08-27T12:56:44.743201223-07:00 COPY 0
2025-08-27T12:57:07.457765873-07:00 COPY 234827
2025-08-27T12:57:34.153169684-07:00 COPY 450175
2025-08-27T12:58:07.861680870-07:00 COPY 293172
2025-08-27T12:58:52.368172181-07:00 COPY 273779
2025-08-27T12:59:02.533936556-07:00 COPY 131380
2025-08-27T12:59:02.537048666-07:00 COPY 0
2025-08-27T13:01:54.636306656-07:00 COPY 931997
2025-08-27T13:01:55.540961127-07:00 COPY 191
2025-08-27T13:01:55.544391491-07:00 COPY 0
2025-08-27T13:01:55.889087453-07:00 COPY 152
2025-08-27T13:01:56.220104175-07:00 COPY 206
2025-08-27T13:01:57.081623661-07:00 COPY 39607
2025-08-27T13:02:13.001729014-07:00 COPY 66900
2025-08-27T13:02:13.210348063-07:00 COPY 204
2025-08-27T13:02:57.936146693-07:00 COPY 347097
2025-08-27T13:12:01.272122875-07:00 COPY 1884790
2025-08-27T14:26:42.154120436-07:00 COPY 3604899
2025-08-27T14:27:39.620175633-07:00 COPY 600241
2025-08-27T14:27:40.544069911-07:00 COPY 8371
2025-08-27T16:44:12.649939607-07:00 COPY 2526264
2025-08-27T16:44:19.023165318-07:00 COPY 768
2025-08-27T16:44:19.223509549-07:00 COPY 404
2025-08-27T16:44:19.277194983-07:00 COPY 125
2025-08-27T16:44:19.886884226-07:00 COPY 24099
2025-08-27T16:44:23.367168900-07:00 COPY 293137
2025-08-27T16:44:23.571128480-07:00 COPY 1033
2025-08-27T16:44:23.762441039-07:00 COPY 106
2025-08-27T16:44:23.981888823-07:00 COPY 578
2025-08-27T16:46:01.971155970-07:00 COPY 1372162
2025-08-27T16:46:01.996748199-07:00 COPY 0
2025-08-27T16:46:01.998681399-07:00 COPY 0
2025-08-27T16:46:02.001708272-07:00 COPY 0
2025-08-27T16:46:02.004245708-07:00 COPY 0
2025-08-27T16:46:02.006864099-07:00 COPY 0
2025-08-27T16:46:02.009456904-07:00 COPY 0
2025-08-27T16:46:02.340532679-07:00  setval 
2025-08-27T16:46:02.340611961-07:00 --------
2025-08-27T16:46:02.340624147-07:00   83465
2025-08-27T16:46:02.340633095-07:00 (1 row)
2025-08-27T16:46:02.340639898-07:00 
2025-08-27T16:46:02.375295040-07:00  setval 
2025-08-27T16:46:02.375357738-07:00 --------
2025-08-27T16:46:02.375367862-07:00      55
2025-08-27T16:46:02.375376071-07:00 (1 row)
2025-08-27T16:46:02.375382898-07:00 
2025-08-27T16:46:02.407431517-07:00  setval 
2025-08-27T16:46:02.407480806-07:00 --------
2025-08-27T16:46:02.407490456-07:00   53019
2025-08-27T16:46:02.407498616-07:00 (1 row)
2025-08-27T16:46:02.407505643-07:00 
2025-08-27T16:46:02.436095401-07:00  setval 
2025-08-27T16:46:02.436141141-07:00 --------
2025-08-27T16:46:02.436150360-07:00  167422
2025-08-27T16:46:02.436163104-07:00 (1 row)
2025-08-27T16:46:02.436170100-07:00 
2025-08-27T16:46:02.481743232-07:00  setval 
2025-08-27T16:46:02.481790486-07:00 --------
2025-08-27T16:46:02.481799577-07:00   53849
2025-08-27T16:46:02.481807891-07:00 (1 row)
2025-08-27T16:46:02.481814948-07:00 
2025-08-27T16:46:02.514597183-07:00  setval 
2025-08-27T16:46:02.514643517-07:00 --------
2025-08-27T16:46:02.514653151-07:00   34406
2025-08-27T16:46:02.514661113-07:00 (1 row)
2025-08-27T16:46:02.514667959-07:00 
2025-08-27T16:46:02.637652193-07:00  setval 
2025-08-27T16:46:02.637709955-07:00 --------
2025-08-27T16:46:02.637719632-07:00  114107
2025-08-27T16:46:02.637727785-07:00 (1 row)
2025-08-27T16:46:02.637734555-07:00 
2025-08-27T16:46:02.679454107-07:00  setval 
2025-08-27T16:46:02.679536182-07:00 --------
2025-08-27T16:46:02.679558259-07:00       1
2025-08-27T16:46:02.679578888-07:00 (1 row)
2025-08-27T16:46:02.679596584-07:00 
2025-08-27T16:46:02.724013873-07:00  setval 
2025-08-27T16:46:02.724072644-07:00 --------
2025-08-27T16:46:02.724081920-07:00  176530
2025-08-27T16:46:02.724089685-07:00 (1 row)
2025-08-27T16:46:02.724096619-07:00 
2025-08-27T16:46:02.761937433-07:00  setval 
2025-08-27T16:46:02.761985478-07:00 --------
2025-08-27T16:46:02.761995232-07:00   53806
2025-08-27T16:46:02.762041864-07:00 (1 row)
2025-08-27T16:46:02.762050368-07:00 
2025-08-27T16:46:02.808890528-07:00  setval 
2025-08-27T16:46:02.808959648-07:00 --------
2025-08-27T16:46:02.808978551-07:00  178678
2025-08-27T16:46:02.808990241-07:00 (1 row)
2025-08-27T16:46:02.809000370-07:00 
2025-08-27T16:46:02.852713354-07:00  setval 
2025-08-27T16:46:02.852778544-07:00 --------
2025-08-27T16:46:02.852788056-07:00    9864
2025-08-27T16:46:02.852796333-07:00 (1 row)
2025-08-27T16:46:02.852803337-07:00 
2025-08-27T16:46:02.897768503-07:00  setval 
2025-08-27T16:46:02.897848823-07:00 --------
2025-08-27T16:46:02.897868417-07:00    1634
2025-08-27T16:46:02.897883979-07:00 (1 row)
2025-08-27T16:46:02.897896412-07:00 
2025-08-27T16:46:02.941458963-07:00  setval 
2025-08-27T16:46:02.941522656-07:00 --------
2025-08-27T16:46:02.941573720-07:00      36
2025-08-27T16:46:02.941610659-07:00 (1 row)
2025-08-27T16:46:02.941633277-07:00 
2025-08-27T16:46:02.972299974-07:00  setval 
2025-08-27T16:46:02.972368406-07:00 --------
2025-08-27T16:46:02.972372865-07:00      36
2025-08-27T16:46:02.972376456-07:00 (1 row)
2025-08-27T16:46:02.972379799-07:00 
2025-08-27T16:46:03.018941055-07:00  setval 
2025-08-27T16:46:03.019016981-07:00 --------
2025-08-27T16:46:03.019038930-07:00       9
2025-08-27T16:46:03.019045548-07:00 (1 row)
2025-08-27T16:46:03.019113104-07:00 
2025-08-27T16:46:03.157047228-07:00  setval 
2025-08-27T16:46:03.157147345-07:00 --------
2025-08-27T16:46:03.157157904-07:00       1
2025-08-27T16:46:03.157166338-07:00 (1 row)
2025-08-27T16:46:03.157172994-07:00 
2025-08-27T16:46:03.249991504-07:00  setval 
2025-08-27T16:46:03.250083616-07:00 --------
2025-08-27T16:46:03.250093096-07:00    2658
2025-08-27T16:46:03.250101085-07:00 (1 row)
2025-08-27T16:46:03.250107858-07:00 
2025-08-27T16:46:03.283188805-07:00  setval 
2025-08-27T16:46:03.283239380-07:00 --------
2025-08-27T16:46:03.283249431-07:00    1782
2025-08-27T16:46:03.283257588-07:00 (1 row)
2025-08-27T16:46:03.283264190-07:00 
2025-08-27T16:46:03.335902254-07:00  setval 
2025-08-27T16:46:03.335957785-07:00 --------
2025-08-27T16:46:03.335968244-07:00    2596
2025-08-27T16:46:03.335977135-07:00 (1 row)
2025-08-27T16:46:03.335983935-07:00 
2025-08-27T16:46:03.383402608-07:00  setval 
2025-08-27T16:46:03.383487176-07:00 --------
2025-08-27T16:46:03.383496387-07:00       1
2025-08-27T16:46:03.383505316-07:00 (1 row)
2025-08-27T16:46:03.383512252-07:00 
2025-08-27T16:46:03.410647592-07:00  setval  
2025-08-27T16:46:03.410700479-07:00 ---------
2025-08-27T16:46:03.410709297-07:00  2233737
2025-08-27T16:46:03.410717510-07:00 (1 row)
2025-08-27T16:46:03.410724477-07:00 
2025-08-27T16:46:03.466193912-07:00  setval 
2025-08-27T16:46:03.466257796-07:00 --------
2025-08-27T16:46:03.466267566-07:00    1248
2025-08-27T16:46:03.466275627-07:00 (1 row)
2025-08-27T16:46:03.466282443-07:00 
2025-08-27T16:46:03.516193490-07:00  setval 
2025-08-27T16:46:03.516246569-07:00 --------
2025-08-27T16:46:03.516256202-07:00     165
2025-08-27T16:46:03.516264418-07:00 (1 row)
2025-08-27T16:46:03.516271799-07:00 
2025-08-27T16:46:03.586202808-07:00  setval 
2025-08-27T16:46:03.586321124-07:00 --------
2025-08-27T16:46:03.586342836-07:00   49566
2025-08-27T16:46:03.586358346-07:00 (1 row)
2025-08-27T16:46:03.586372123-07:00 
2025-08-27T16:46:03.626044111-07:00  setval 
2025-08-27T16:46:03.626129514-07:00 --------
2025-08-27T16:46:03.626174863-07:00   42135
2025-08-27T16:46:03.626184546-07:00 (1 row)
2025-08-27T16:46:03.626191436-07:00 
2025-08-27T16:46:03.671116969-07:00  setval 
2025-08-27T16:46:03.671167871-07:00 --------
2025-08-27T16:46:03.671176129-07:00    1509
2025-08-27T16:46:03.671183208-07:00 (1 row)
2025-08-27T16:46:03.671188927-07:00 
2025-08-27T16:46:03.714456100-07:00  setval 
2025-08-27T16:46:03.714538114-07:00 --------
2025-08-27T16:46:03.714548810-07:00       1
2025-08-27T16:46:03.714557411-07:00 (1 row)
2025-08-27T16:46:03.714564167-07:00 
2025-08-27T16:46:03.751464845-07:00  setval 
2025-08-27T16:46:03.751518254-07:00 --------
2025-08-27T16:46:03.751528140-07:00   64627
2025-08-27T16:46:03.751536618-07:00 (1 row)
2025-08-27T16:46:03.751543411-07:00 
2025-08-27T16:46:03.825517466-07:00  setval 
2025-08-27T16:46:03.825592770-07:00 --------
2025-08-27T16:46:03.825602414-07:00  126301
2025-08-27T16:46:03.825610510-07:00 (1 row)
2025-08-27T16:46:03.825617336-07:00 
2025-08-27T16:46:03.856431744-07:00  setval 
2025-08-27T16:46:03.856477073-07:00 --------
2025-08-27T16:46:03.856488177-07:00       1
2025-08-27T16:46:03.856496467-07:00 (1 row)
2025-08-27T16:46:03.856503480-07:00 
2025-08-27T16:46:03.899689688-07:00  setval 
2025-08-27T16:46:03.899746118-07:00 --------
2025-08-27T16:46:03.899755768-07:00       1
2025-08-27T16:46:03.899764522-07:00 (1 row)
2025-08-27T16:46:03.899771415-07:00 
2025-08-27T16:46:03.961312145-07:00  setval 
2025-08-27T16:46:03.961438035-07:00 --------
2025-08-27T16:46:03.961464395-07:00  206488
2025-08-27T16:46:03.961481864-07:00 (1 row)
2025-08-27T16:46:03.961495954-07:00 
2025-08-27T16:46:03.996961603-07:00  setval 
2025-08-27T16:46:03.997044893-07:00 --------
2025-08-27T16:46:03.997055938-07:00  195158
2025-08-27T16:46:03.997063615-07:00 (1 row)
2025-08-27T16:46:03.997069879-07:00 
2025-08-27T16:46:04.033137200-07:00  setval 
2025-08-27T16:46:04.033248445-07:00 --------
2025-08-27T16:46:04.033274527-07:00    4639
2025-08-27T16:46:04.033290155-07:00 (1 row)
2025-08-27T16:46:04.033303210-07:00 
2025-08-27T16:46:04.100357992-07:00  setval 
2025-08-27T16:46:04.100403783-07:00 --------
2025-08-27T16:46:04.100407646-07:00  199633
2025-08-27T16:46:04.100410868-07:00 (1 row)
2025-08-27T16:46:04.100413556-07:00 
2025-08-27T16:46:04.133527529-07:00  setval 
2025-08-27T16:46:04.133570123-07:00 --------
2025-08-27T16:46:04.133578280-07:00       1
2025-08-27T16:46:04.133584988-07:00 (1 row)
2025-08-27T16:46:04.133591026-07:00 
2025-08-27T16:46:04.174057344-07:00  setval 
2025-08-27T16:46:04.174119600-07:00 --------
2025-08-27T16:46:04.174129862-07:00  250506
2025-08-27T16:46:04.174138482-07:00 (1 row)
2025-08-27T16:46:04.174145499-07:00 
2025-08-27T16:46:04.208364387-07:00  setval 
2025-08-27T16:46:04.208439501-07:00 --------
2025-08-27T16:46:04.208449558-07:00  402424
2025-08-27T16:46:04.208458025-07:00 (1 row)
2025-08-27T16:46:04.208464946-07:00 
2025-08-27T16:46:04.255356660-07:00  setval 
2025-08-27T16:46:04.255435091-07:00 --------
2025-08-27T16:46:04.255464058-07:00  131381
2025-08-27T16:46:04.255480978-07:00 (1 row)
2025-08-27T16:46:04.255497906-07:00 
2025-08-27T16:46:04.299969339-07:00  setval 
2025-08-27T16:46:04.300023516-07:00 --------
2025-08-27T16:46:04.300033109-07:00       1
2025-08-27T16:46:04.300041823-07:00 (1 row)
2025-08-27T16:46:04.300049285-07:00 
2025-08-27T16:46:04.342749063-07:00  setval 
2025-08-27T16:46:04.342854818-07:00 --------
2025-08-27T16:46:04.342866827-07:00  462227
2025-08-27T16:46:04.342874890-07:00 (1 row)
2025-08-27T16:46:04.342881756-07:00 
2025-08-27T16:46:04.378885627-07:00  setval 
2025-08-27T16:46:04.379005488-07:00 --------
2025-08-27T16:46:04.379029584-07:00  275371
2025-08-27T16:46:04.379157966-07:00 (1 row)
2025-08-27T16:46:04.379202771-07:00 
2025-08-27T16:46:04.441764211-07:00  setval 
2025-08-27T16:46:04.441825319-07:00 --------
2025-08-27T16:46:04.441836388-07:00  933732
2025-08-27T16:46:04.441844942-07:00 (1 row)
2025-08-27T16:46:04.441851865-07:00 
2025-08-27T16:46:04.482526487-07:00  setval 
2025-08-27T16:46:04.482575224-07:00 --------
2025-08-27T16:46:04.482585251-07:00  208747
2025-08-27T16:46:04.482593267-07:00 (1 row)
2025-08-27T16:46:04.482600354-07:00 
2025-08-27T16:46:04.529753561-07:00  setval 
2025-08-27T16:46:04.529804507-07:00 --------
2025-08-27T16:46:04.529814675-07:00   11129
2025-08-27T16:46:04.529822878-07:00 (1 row)
2025-08-27T16:46:04.529829420-07:00 
2025-08-27T16:46:04.573992761-07:00  setval 
2025-08-27T16:46:04.574084857-07:00 --------
2025-08-27T16:46:04.574105650-07:00    6854
2025-08-27T16:46:04.574127513-07:00 (1 row)
2025-08-27T16:46:04.574142769-07:00 
2025-08-27T16:46:04.608691530-07:00  setval 
2025-08-27T16:46:04.608745380-07:00 --------
2025-08-27T16:46:04.608753598-07:00   87577
2025-08-27T16:46:04.608761086-07:00 (1 row)
2025-08-27T16:46:04.608766699-07:00 
2025-08-27T16:46:04.642368064-07:00  setval 
2025-08-27T16:46:04.642440873-07:00 --------
2025-08-27T16:46:04.642451038-07:00       1
2025-08-27T16:46:04.642459405-07:00 (1 row)
2025-08-27T16:46:04.642466432-07:00 
2025-08-27T16:46:04.676601814-07:00  setval 
2025-08-27T16:46:04.676650972-07:00 --------
2025-08-27T16:46:04.676709244-07:00   14610
2025-08-27T16:46:04.676718553-07:00 (1 row)
2025-08-27T16:46:04.676725583-07:00 
2025-08-27T16:46:04.717157218-07:00  setval 
2025-08-27T16:46:04.717239523-07:00 --------
2025-08-27T16:46:04.717264440-07:00     222
2025-08-27T16:46:04.717302034-07:00 (1 row)
2025-08-27T16:46:04.717327351-07:00 
2025-08-27T16:46:04.738767560-07:00  setval 
2025-08-27T16:46:04.738812903-07:00 --------
2025-08-27T16:46:04.738822673-07:00   14561
2025-08-27T16:46:04.738831216-07:00 (1 row)
2025-08-27T16:46:04.738838681-07:00 
2025-08-27T16:46:04.802272471-07:00  setval 
2025-08-27T16:46:04.802382085-07:00 --------
2025-08-27T16:46:04.802392393-07:00  153910
2025-08-27T16:46:04.802400947-07:00 (1 row)
2025-08-27T16:46:04.802407971-07:00 
2025-08-27T16:46:04.827770818-07:00  setval 
2025-08-27T16:46:04.827857878-07:00 --------
2025-08-27T16:46:04.827868307-07:00   68564
2025-08-27T16:46:04.827878153-07:00 (1 row)
2025-08-27T16:46:04.827891445-07:00 
2025-08-27T16:46:04.897984403-07:00  setval 
2025-08-27T16:46:04.898045647-07:00 --------
2025-08-27T16:46:04.898055203-07:00   35998
2025-08-27T16:46:04.898063199-07:00 (1 row)
2025-08-27T16:46:04.898070028-07:00 
2025-08-27T16:46:04.938381932-07:00  setval  
2025-08-27T16:46:04.938431954-07:00 ---------
2025-08-27T16:46:04.938441918-07:00  1174914
2025-08-27T16:46:04.938451093-07:00 (1 row)
2025-08-27T16:46:04.938458497-07:00 
2025-08-27T16:46:04.983167505-07:00  setval 
2025-08-27T16:46:04.983607443-07:00 --------
2025-08-27T16:46:04.983628647-07:00   35929
2025-08-27T16:46:04.983642771-07:00 (1 row)
2025-08-27T16:46:04.983654823-07:00 
2025-08-27T16:46:05.016592071-07:00  setval 
2025-08-27T16:46:05.016716437-07:00 --------
2025-08-27T16:46:05.016735544-07:00  756060
2025-08-27T16:46:05.016743388-07:00 (1 row)
2025-08-27T16:46:05.016749476-07:00 
2025-08-27T16:46:05.071088792-07:00  setval 
2025-08-27T16:46:05.071138905-07:00 --------
2025-08-27T16:46:05.071150722-07:00    2084
2025-08-27T16:46:05.071158508-07:00 (1 row)
2025-08-27T16:46:05.071165397-07:00 
2025-08-27T16:46:05.131684815-07:00  setval 
2025-08-27T16:46:05.131715972-07:00 --------
2025-08-27T16:46:05.131721262-07:00  218064
2025-08-27T16:46:05.131725070-07:00 (1 row)
2025-08-27T16:46:05.131727957-07:00 
2025-08-27T16:46:05.172844172-07:00  setval 
2025-08-27T16:46:05.172865246-07:00 --------
2025-08-27T16:46:05.172869560-07:00    1008
2025-08-27T16:46:05.172873182-07:00 (1 row)
2025-08-27T16:46:05.172876271-07:00 
2025-08-27T16:46:05.216587189-07:00  setval  
2025-08-27T16:46:05.216646490-07:00 ---------
2025-08-27T16:46:05.216705595-07:00  6320366
2025-08-27T16:46:05.216714875-07:00 (1 row)
2025-08-27T16:46:05.216721095-07:00 
2025-08-27T16:46:05.259379434-07:00  setval  
2025-08-27T16:46:05.259427149-07:00 ---------
2025-08-27T16:46:05.259438393-07:00  3764529
2025-08-27T16:46:05.259447442-07:00 (1 row)
2025-08-27T16:46:05.259454335-07:00 
2025-08-27T16:46:05.305134254-07:00  setval  
2025-08-27T16:46:05.305195779-07:00 ---------
2025-08-27T16:46:05.305206204-07:00  3527277
2025-08-27T16:46:05.305215690-07:00 (1 row)
2025-08-27T16:46:05.305222987-07:00 
2025-08-27T16:46:05.349062274-07:00  setval 
2025-08-27T16:46:05.349150527-07:00 --------
2025-08-27T16:46:05.349180359-07:00   10181
2025-08-27T16:46:05.349198222-07:00 (1 row)
2025-08-27T16:46:05.349211898-07:00 
2025-08-27T16:46:05.383296007-07:00  setval 
2025-08-27T16:46:05.383345286-07:00 --------
2025-08-27T16:46:05.383354902-07:00       1
2025-08-27T16:46:05.383363509-07:00 (1 row)
2025-08-27T16:46:05.383370239-07:00 
2025-08-27T16:46:05.444640808-07:00  setval 
2025-08-27T16:46:05.444753279-07:00 --------
2025-08-27T16:46:05.444764262-07:00       1
2025-08-27T16:46:05.444772161-07:00 (1 row)
2025-08-27T16:46:05.444778928-07:00 
2025-08-27T16:46:05.574875857-07:00  setval 
2025-08-27T16:46:05.574969229-07:00 --------
2025-08-27T16:46:05.574979918-07:00     131
2025-08-27T16:46:05.574989394-07:00 (1 row)
2025-08-27T16:46:05.574996377-07:00 
2025-08-27T16:46:05.662901910-07:00  setval 
2025-08-27T16:46:05.662978843-07:00 --------
2025-08-27T16:46:05.662988168-07:00  203673
2025-08-27T16:46:05.662995839-07:00 (1 row)
2025-08-27T16:46:05.663002112-07:00 
2025-08-27T16:46:05.751309583-07:00   setval  
2025-08-27T16:46:05.751410282-07:00 ----------
2025-08-27T16:46:05.751435339-07:00  30705768
2025-08-27T16:46:05.751455390-07:00 (1 row)
2025-08-27T16:46:05.751471360-07:00 
2025-08-27T16:46:05.853279131-07:00  setval 
2025-08-27T16:46:05.853367498-07:00 --------
2025-08-27T16:46:05.853380055-07:00   20307
2025-08-27T16:46:05.853388522-07:00 (1 row)
2025-08-27T16:46:05.853395328-07:00 
2025-08-27T16:46:05.935852742-07:00  setval 
2025-08-27T16:46:05.935910831-07:00 --------
2025-08-27T16:46:05.935921163-07:00       1
2025-08-27T16:46:05.935930131-07:00 (1 row)
2025-08-27T16:46:05.935937298-07:00 
2025-08-27T16:46:05.969375307-07:00  setval 
2025-08-27T16:46:05.969427062-07:00 --------
2025-08-27T16:46:05.969436528-07:00       1
2025-08-27T16:46:05.969444364-07:00 (1 row)
2025-08-27T16:46:05.969480484-07:00 
2025-08-27T16:46:06.010555608-07:00  setval 
2025-08-27T16:46:06.010617998-07:00 --------
2025-08-27T16:46:06.010627838-07:00       1
2025-08-27T16:46:06.010635934-07:00 (1 row)
2025-08-27T16:46:06.010642493-07:00 
2025-08-27T16:46:06.055281297-07:00  setval 
2025-08-27T16:46:06.055351429-07:00 --------
2025-08-27T16:46:06.055374648-07:00       1
2025-08-27T16:46:06.055387375-07:00 (1 row)
2025-08-27T16:46:06.055402214-07:00 
2025-08-27T16:46:06.087557782-07:00  setval 
2025-08-27T16:46:06.087607088-07:00 --------
2025-08-27T16:46:06.087617589-07:00       1
2025-08-27T16:46:06.087626381-07:00 (1 row)
2025-08-27T16:46:06.087633100-07:00 
2025-08-27T16:46:06.162511512-07:00  setval 
2025-08-27T16:46:06.162572437-07:00 --------
2025-08-27T16:46:06.162585919-07:00       1
2025-08-27T16:46:06.162594038-07:00 (1 row)
2025-08-27T16:46:06.162600765-07:00 
2025-08-27T16:46:06.203644121-07:00  setval 
2025-08-27T16:46:06.203694844-07:00 --------
2025-08-27T16:46:06.203706622-07:00    1185
2025-08-27T16:46:06.203715226-07:00 (1 row)
2025-08-27T16:46:06.203722012-07:00 
```

## Step 5: Finish the migrations

Once the `vegbankdb-init-pg-restore` completes its data restore (which can take around 4 hours at this time because it is not optimized), we need to update `values.yaml` and set `databaseRestore.enabled` back to `false`, and then restart the pods. This will apply any remaining migrations after `1.6`.

```
# values.yaml

databaseRestore:
  enabled: false
  target: "1.6"
  pvc: "vegbankdb-init-pgdata"
  mountpath: "/tmp/databaseRestore"
  filepath: "vegbank_dataonly_20240814.sql"
```

Restart the pods by executing helm upgrade, and ensure the `values.yaml` changes get included by including the `-f` flag for `values.yaml`

```sh
$ helm upgrade vegbankdb . -f values.yaml
```

Note: This is also how we can apply any migrations/schema updates that we want to test. Update the `/db/migrations` with the correct naming convention and files, and then execute helm upgrade again.


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
