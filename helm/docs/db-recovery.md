# Database Recovery from Backups

Recovering using a `ScheduledBackup` is our preferred method to re-deploy the `vegbank` `cnpg` cluster. This is the quickest and simplest path to get the database back up and running in any disaster scenario or if the database becomes corrupted/unusable. In the event where `kubernetes`/`cnpg` is not available, it is still possible to initialize a database using solely the `postgres` data folder. This is documented below, but not recommended unless you have no other choice.

## Recovering from a ScheduledBackup

If you wish to deploy a `cnpg` cluster via a `ScheduledBackup`, you can do so by:
- Changing the `init.enabled` section in `values.yaml` to `true`
- Changing the `init.method` section to `recovery`
- Providing a specific volume snapshot/backup to recover from for `init.recoverFromBackup`.
- Important Note: Please double-check that `backup.enabled` in `values.yaml` is set to `true` before executing `helm install ...` to ensure that backup volumesnapshots are generating once again via `ScheduledBackup`s.

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
  $ kubectl get scheduledbackup -n vegbank-dev

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
- Note: You may launch multiple `cnpg` clusters using different release names. In the example you see below, you'll notice that there is an existing `vegbankdb-cnpg` cluster - along with a new `vegbankvelero-cnpg` cluster that's initializing. There should not be any conflicts with the existing services because those configurations were installed with release name specific settings. For example, the existing `vegbank` API is set up to communicate with `vegbankdb-cnpg-rw`. If you install a cluster called `vegbankvelero-cnpg` - the respective host would be `vegbankvelero-cnpg-rw`.

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

If you have multiple clusters live, you will need to redeploy the existing `vegbankapi` helm chart with an updated `database` section. Specifically `database.host` needs to be revised. Please see below for an example:

```sh
database:
  name: vegbank # The database name should be the same after recovery
  # Previously, this value would have been 'vegbankdb-cnpg-rw'
  host: vegbankvelero-cnpg-rw # Update this host
  port: 5432 # The port should also remain the same
```

After you have confirmed that the API and related tools are working as you expect, you may uninstall the old, presumably now redundant, cluster.

```sh
$ helm uninstall vegbankdb
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
