# Introduction

The vegbank DB will be backed up using the `cnpg` `ScheduledBackUp` custom resource. To learn more about this, view our cnpg operator documentation [here](https://github.com/DataONEorg/k8s-cluster/blob/main/operators/postgres/postgres.md#database-backups).

## Applying the 'scheduled-backup.yaml' resource

You can check if there is an existing `ScheduledBackup` by executing the following:

```sh
# Note, you must have admin privileges to check for `ScheduledBackup`s
$ kubectl get scheduledbackup -n vegbank-dev --context=dev-k8s 

NAME                         AGE   CLUSTER          LAST BACKUP
vegbankdb-scheduled-backup   57s   vegbankdb-cnpg   57s
```

If there are no `ScheduledBackup` resources, you can apply the existing yaml document like such:

```sh
# Note, you must have admin privileges to apply the `ScheduledBackup` resource
$ kubectl apply -f '/Users/doumok/Code/vegbank2/helm/backup/scheduled-backup.yaml' -n vegbank-dev --context=dev-k8s

scheduledbackup.postgresql.cnpg.io/vegbankdb-scheduled-backup configured
```

You can check the existing backups by executing the following:

```sh
$ kubectl get backups -n vegbank-dev

NAME                                        AGE   CLUSTER          METHOD           PHASE       ERROR
vegbankdb-scheduled-backup-20251107221536   12s   vegbankdb-cnpg   volumeSnapshot   completed 
```

## Example Disaster Scenario (Cumbersome, but it works)

Scenario - a disaster occurs and we have literally nothing but a physical directory of the `postgres` data that can be found from Nick's latest folder backup.

**Step 1: Copy the data folder to your local directory and navigate to it**

To get the `vegbank` db back up and running, we will first copy that postgres data folder to our local directory and navigate to it.
```sh
doumok@Dou-NCEAS-MBP14.local:~ $ cd /Code/testing/pgrecoverytesting/pgdata
```

Now, we modify the following settings because the setup for `cnpg` does not match what we are trying to achieve with a docker instance. 
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