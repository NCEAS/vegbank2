# Database Recovery from Backups

The preferred method to recreate the `vegbank` `cnpg` cluster is by recovering from a `Backup` object that was created by the `cnpg ScheduledBackup` job. This is the quickest and simplest path to get the database back up and running in a disaster scenario. If `kubernetes`/`cnpg` backups are not available, it is still possible to initialize a database using solely a backup of the `postgres` data folder. This is documented below, but not recommended unless you have no other choice.

## Contents
- [Recovering from a ScheduledBackup](#recovering-from-a-scheduledbackup)
- [How to Recover a Deleted `ScheduledBackup` from `velero` Backups](#how-to-recover-a-deleted-scheduledbackup-from-velero-backups)
- [Recovery using data folders in a file system (Last Resort)](#recovery-using-data-folders-in-a-file-system-last-resort)

## Recovering from a ScheduledBackup

To deploy a `cnpg` cluster by recovering from a `Backup` object that was created by a `cnpg ScheduledBackup`:

### Step 1: Edit your values overrides file (e.g. `values-cnpg.yaml`)

- Change `init.enabled` in `values.yaml` to `true`
- Change `init.method` to `recovery`
- Ensure `backup.enabled` is set to `true` to ensure continuity of `ScheduledBackups` after recovery
- Provide the name of a specific volume snapshot/backup to recover from, for `init.recoverFromBackup`

> [!TIP]
> To see existing `ScheduledBackup` jobs:
>
> ```sh
> $ kubectl get scheduledbackups
>
> NAME                         AGE   CLUSTER          LAST BACKUP
> vegbankdb-scheduled-backup   57s   vegbankdb-cnpg   57s
> ```
>
> ...and to see specific backups/volumesnapshots:
>
> ```sh
> $ kubectl get scheduledbackups
> NAME                         AGE   CLUSTER          LAST BACKUP
> vegbankdb-scheduled-backup   21h   vegbankdb-cnpg   21h
> ```

### Step 2: Install the `cnpg` `helm` chart:

- ```sh
  $ helm install vegbankdb oci://ghcr.io/dataoneorg/charts/cnpg -f './values-cnpg.yaml' --debug
  ```

> [!TIP]
> You may launch multiple `cnpg` clusters in the same namespace, using different release names.

- Monitor progress:

  ```sh
  $ kubectl get pods --watch
  NAME                                           READY   STATUS    RESTARTS      AGE
  vegbankapi-54b85649c6-2pwcm                    1/1     Running   0             4d19h
  vegbankolddb-cnpg-1                              1/1     Running   2             52d
  vegbankolddb-cnpg-2                              1/1     Running   1 (16d ago)   52d
  vegbankolddb-cnpg-3                              1/1     Running   1 (16d ago)   52d
  vegbankdb-cnpg-1-snapshot-recovery-pqsl9       0/1     Pending   0             2s
  ## This ^ is the pod that is responsible for recovering the database from the backup/snapshot.
  ```

> [!NOTE]
> It takes approximately 10 minutes for the pods to be assigned, after which the recovery process will begin.
>
> Until then, it is common to see `FailedScheduling` messages when you `kubectl describe` the PVCs and pods; e.g.:
>
> ```sh
> $ kubectl describe pod vegbankdb-cnpg-1-snapshot-recovery-pqsl9
> ...
> Events:
>   Type     Reason            Age                    From               Message
>   ----     ------            ----                   ----               -------
>   Warning  FailedScheduling  12m                    default-scheduler  0/6 nodes are available:
>             pod has unbound immediate PersistentVolumeClaims. preemption: 0/6 nodes are available:
>               6 Preemption is not helpful for scheduling..
>   Warning  FailedScheduling  2m46s (x2 over 7m46s)  default-scheduler  0/6 nodes are available:
>             pod has unbound immediate PersistentVolumeClaims. preemption: 0/6 nodes are available:
>               6 Preemption is not helpful for scheduling..
>   Normal   Scheduled         67s                    default-scheduler  Successfully assigned
>             vegbank-dev/vegbankvelero-cnpg-1-snapshot-recovery-pqsl9 to k8s-dev-node-4
>   Normal   Pulled            64s                    kubelet            Container image
>             "ghcr.io/cloudnative-pg/cloudnative-pg:1.27.0" already present on machine
>   Normal   Created           63s                    kubelet            Created container
>                                                                           bootstrap-controller
> [...etc]
> ```

- Finally, confirm that `ScheduledBackups` are being run once again:

  ```sh
  $ kubectl get backup -n dev-vegbank
  ...
  vegbankolddb-scheduled-backup-20251207210000  22h    vegbankdb-cnpg      volumeSnapshot  completed
  vegbankdb-scheduled-backup-20251208192351     2m20s  vegbankvelero-cnpg  volumeSnapshot  completed
  ```

### Step 3: Update Clients to Point at the New Cluster.

1. If you are running a pooler (e.g. `PGBouncer` in production):
   1. update pooler values overrides and redeploy:
      ```yaml

      ## 'pooler--prod-vegbank-cnpg.yaml' in NCEAS GHE 'k8s-cluster0--config' private repo
      ##
      spec:
        cluster:
          name: vegbankdb-cnpg    # point this to the new cluster name
      ```
   2. update api values overrides and redeploy:
      ```yaml
      ## 'values-prod-cluster-vegbank.yaml' in NCEAS GHE 'k8s-cluster0--config' private repo
      ##
      database:
        host: vegbankdb-pooler-rw    # should NOT need to change

      flyway:
        dbHost: vegbankdb-cnpg-rw    # point this to the new cluster name
      ```

2. If you are NOT running a pooler (e.g. dev systems), update api values overrides and redeploy:
    ```yaml
    ## e.g. 'values-overrides-dev.yaml'
    ##
    database:
      host: vegbankdb-cnpg-rw      # point this to the new cluster name

    flyway:
      dbHost: vegbankdb-cnpg-rw    # point this to the new cluster name
    ```

### Step 4: Clean Up the Old Cluster

- ```sh
  $ helm uninstall vegbankolddb
  ```

> [!WARNING]
> When you uninstall the old cluster, CNPG will also delete all the scheduled `Backup` objects! If this will be a problem for you, make sure you have backups of the `backups`! Typically, we have Velero taking regular backups of everything (see below for how to recover), but double-check first!


## How to Recover a Deleted `ScheduledBackup` from `velero` Backups

If you have accidentally deleted and need to recover a specific backup, you can use `velero` to do so. `velero` is what we use to back up `kubernetes` resources, which includes `cnpg` resources like `Backups`.

- To list the available `velero` backups that we can recover from:

  ```sh
  $ velero backup get
  # You will see a list of available backups that you can select from
  ...
  full-backup-20251203030015  PartiallyFailed  1  2  2025-12-02 19:00:15 -0800 PST  87d  default  <none>

  # use:
  #   velero backup describe <velero-backup-name>
  # to see more details, including which resources are included
  ```

- After finding the `velero` backup you wish to restore from, recover the `cnpg` backup/snapshot:

  ```sh
  # velero restore create [give_your_restore_a_name]
  #
  $ velero restore create restore-cnpg-bkup-dou-test \
    --from-backup full-backup-20251203030015 \
    --include-resources=backups.postgresql.cnpg.io \
    --include-namespaces=dev-vegbank-dev
  Restore request "restore-cnpg-bkup-dou-test" submitted successfully.
  ```

- Run `velero restore describe restore-cnpg-bkup-dou-test` or `velero restore logs restore-cnpg-bkup-dou-test` for more details. Check the restore completed:

  ```sh
  $ velero restore get
  NAME                         BACKUP                       STATUS      STARTED                         COMPLETED                       ERRORS   WARNINGS   CREATED                         SELECTOR
  restore-cnpg-bkup-dou-test   full-backup-20251203030015   Completed   2025-12-05 13:19:23 -0800 PST   2025-12-05 13:25:30 -0800 PST   0        0          2025-12-05 13:19:23 -0800 PST   <none>
  ```

- After restoring the missing backup, proceed with the ScheduledBackup recovery process [defined above](#recovering-from-a-scheduledbackup).

## Recovery using data folders in a file system (Last Resort)

If no `ScheduledBackups` are available after a disaster occurs, it is still possible to recover if we have a backup of the physical `postgres` data directory and files on disk.

1. Get a local copy of the data and edit the config

   - Copy the data folder to your local directory and navigate to the `/your/path/to/postgresql/data/pgdata/` directory.
   - Edit the `custom.conf` file to make sure any path settings will still work on your local machine. For example, the `log_directory` setting will likely need to be changed

2. Use `docker` to create a `postgres` instance

    ```sh
    # Note: You must be in the postgresql/data/pgdata/ directory when running this docker command.
    # This will mount the current directory $(pwd) to the path specified (/var/lib/postgresql/data),
    # which is inside the container
    #
    $ docker run -it --rm -e POSTGRES_PASSWORD=postgres -v $(pwd):/var/lib/postgresql/data -p 5432:5432 postgres:17
    ```

3. Check it's working

    ```sh
    $ psql -h localhost -U vegbank

    Password for user vegbank:
    WARNING:  database "vegbank" has a collation version mismatch
    DETAIL:  The database was created using collation version 153.14, but the operating system provides version 153.120.
    HINT:  Rebuild all objects in this database that use the default collation and run ALTER DATABASE vegbank REFRESH COLLATION VERSION, or build PostgreSQL with the right library version.
    psql (14.11 (Homebrew), server 17.5 (Debian 17.5-1.pgdg120+1))
    WARNING: psql major version 14, server major version 17.
            Some psql features might not work.
    Type "help" for help.

    # list all the tables to check if recovery was successful
    $ \dt
    ```

> [!TIP]
> The password can be obtained from the k8s secret (e.g. `vegbankdbcreds`):
> use:
>   `kubectl get secret vegbankdbcreds -o yaml`
> ...then decode with:
>   `echo -n "<passwd-from-above-yaml>" | base64 --decode`

4. Restore the `cnpg` cluster

    From here, we can get a dump file, mount it, and use the existing steps to launch a `cnpg` cluster.

    ```sh
    $ pg_dump -h localhost -U vegbank -d vegbank -Fc -f vegbank_20251105.dump
    ```
