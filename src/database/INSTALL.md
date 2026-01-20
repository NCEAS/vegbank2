# Introduction

This install document describes how to restore the original Vegbank database (which uses Postgres 10.23) from a data-only dump file* to either a local Postgres instance or a Docker container.
  * Note: This data-only dump file can be found in the knbvm test server under `/mnt/ceph/repos/vegbank` with the file name `vegbank_dataonly_fc_20250904.dump`
  * Note 2: For historical purposes, a data-only dump file that can be executed with `psql` is also located in the same directory with the file name `vegbank_dataonly_20240814.sql`


## Local Postgres Development (Postgres 10.23, MacOS M2)

**Requirements:**
- Postgres.app with PostgreSQL 10 – 15 (Universal/Intel)
  - https://postgresapp.com/downloads_legacy.html
- Flyway CLI
  - https://documentation.red-gate.com/fd/command-line-184127404.html

### Step 1:

Install the `postgres.app` and launch a Postgres 10.23 server. 

### Step 2:

Access the postgres server via `psql`, and create a new vegbank db and roles:

```
CREATE ROLE vegbank WITH LOGIN PASSWORD 'vegbank';
CREATE DATABASE vegbank
WITH
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8';
GRANT ALL PRIVILEGES ON DATABASE vegbank TO vegbank;
```

### Step 3:

Take the `flyway.conf` file in this repo and move it into your local flyway `conf` installation. Ensure that the contents match the location of the `/migrations` folder found in the directory where this `vegbank2` repo exists. For example:

```sh
$ cat Users/doumok/Code/flyway-10.17.0/conf/flyway.conf

flyway.url=jdbc:postgresql://localhost:5432/vegbank
flyway.user=vegbank
flyway.password=vegbank
# Example: flyway.locations=filesystem:/Users/doumok/Code/vegbank2/helm/db/migrations
flyway.locations=/path/to/your/helm/db/migrations
```

### Step 4:

If you are starting from scratch, there will likely be additional migration files that need to be applied after the restore. To recover the original version of `vegbank`, proceed by running the following command to apply migrations up until `V1.4__create_vegbank_views.sql`:

```
flyway -target=1.4 migrate
```

### Step 5: Execute the dump file

Restore the data by running `pg_restore`.

```sh
# If using the binary data-only dump file
$ pg_restore -U vegbank -d vegbank -j 4 '/Users/doumok/Code/testing/vegbank_dataonly_fc_20250904.dump'

# If using the single-threaded psql command
# The following command will also place the output into a txt file of in the directory of your choice
$ psql -U doumok -d vegbank2 -f /Users/doumok/Code/testing/vegbank_dataonly_20240814.sql > /your/desired/dir/vegbank2_psql_output.txt 2>&1
```

If you don't have a dump file, you can get one by asking a sys admin for `vegbank` to provide you with one via the following command:

```sh
# This dump file produced is in a binary format, which is more efficient than the following which has to be executed through a single psql statment
# pg_dump -d vegbank --data-only -f vegbank_dataonly_[YYMMDD].sql
postgres@vegbank:~/dumps$ pg_dump -d vegbank --data-only -Fc -f vegbank_dataonly_fc_[YYYYMMDD].dump
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   observation
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   party
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   plot
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   referenceparty
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   revision
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   soiltaxon
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
postgres@vegbank:~/dumps$
```

**NOTE 1:** You can see that the output above generated from creating the dump file displays warnings, no problem. The migration files can handle these issues.

**NOTE 2:** If any exceptions occur with `COPY` commands in the data insertion process, the entire table the command is trying to add into the database will not be executed. Exceptions must be resolved in order for the table's data to be loaded (all or nothing).

### Step 6: Apply remaining migrations

If you only need the original database, you can stop here. But if you need to apply schema updates and changes, finish applying the migrations by executing:

```
flyway migrate
```

An example of the full process on my local terminal for added context. Note, this log is still accurate less the migration points (which are now different as of updating this `README` document and the actual migration files which now live in helm)


## Postgres Docker Development (Postgres12, 16, and 17)

This process is also applicable to Postgres12, 16 AND 17 (tested!), starting from 10.23 is not necessary.

**Requirements:**
- Docker
   - https://docs.docker.com/engine/install/
- Flyway CLI
  - https://documentation.red-gate.com/fd/command-line-184127404.html

### Step 1: Install Docker and Launch a Postgres Instance**

After installing Docker, run the following command to launch a postgres container:

```sh
docker run --name vegbank -e POSTGRES_PASSWORD=vegbank -e POSTGRES_DB=vegbank -e POSTGRES_USER=vegbank -e PGDATA=/tmp/postgresql/data -e POSTGRES_HOST_AUTH_METHOD=password -p 5432:5432 -d postgres:16
```
 - You are asking Docker to run a postgres database called `vegbank`, with password `vegbank` and user `vegbank`
 - You are providing a location for where postgres files are to exist within the container
 - This container is now listening on port 5432
 - We are selecting `postgres:16` or Postgres V16, you may also select `postgres:12` if you prefer

### Step 2: Apply SQL files to Postgres via Flyway migrations

Migrate `flyway` to `V1.4__create_vegbank_views.sql`. See the above section (Step 3, `Local Development (Postgres 10.23, MacOS M2)`) to work with `flyway` if you haven't already set it up.

```sh
flyway -target=1.4
```
 - Specifically migrate to migrations version 1.4, any additional migrations/schema updates must be applied after the data restore.

### Step 3: Restore the vegbank data via a data-only dump (backup) file

Load data only dump file. See above section to obtain data-only dump file if you do not have it.

```sh
pg_restore -h localhost -p 5432 -U vegbank -d vegbank -j 4 '/Users/doumok/Code/testing/vegbank_dataonly_fc_20250904.dump'
```

### Step 4: Finish the vegbank database restoration process

Finish the migration by applying the remaining schema updates.

```sh
flyway migrate
```