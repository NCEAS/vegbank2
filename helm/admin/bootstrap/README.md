# VegBank Database Bootstrap

This directory contains a one-time bootstrap process to initialize the VegBank database. It uses Kustomize to dynamically load local SQL migration files, runs Flyway migrations up to V1.4, restores a data dump from a CephFS Persistent Volume, and then runs the remaining Flyway migrations.

## Prerequisites
- Ensure the target Postgres cluster (CNPG) is running
- Ensure the `vegbankdbcreds` secret exists, containing postgres username and password
- Ensure the data dump file is present at `knbvm:/mnt/ceph/repos/vegbank/vegbank_pg10_dataonly.dump`

## Create the Persistent Volume (`prod-k8s` admin access required) 

Create the PV `cephfs-vegbankdb-init-pgdata` by applying the existing PV definition:
```shell
kubectl apply -f helm/admin/bootstrap/pv--vegbankdb-bootstrap-cephfs.yaml --context=prod-k8s
```

## Run the Bootstrap Pod

Your working directory should be the root directory of this repo.

Because we are referencing local SQL files from outside the Kustomize directory, you must bypass load restrictions:

```shell
kubectl kustomize helm/admin/bootstrap/ --load-restrictor LoadRestrictionsNone | kubectl apply -f -
```
Wait for the vegbankdb-bootstrap-pod to reach Completed status.

You can check its logs to verify the migrations and restore were successful:
```shell
kubectl logs -f vegbankdb-bootstrap-pod
```

## Clean Up

Once the database is successfully populated, remove the bootstrap resources (Pod, PVC, PV, and ConfigMap) to keep the cluster clean:

```shell
kubectl kustomize helm/admin/bootstrap/ --load-restrictor LoadRestrictionsNone | kubectl delete -f -

kubectl delete -f helm/admin/bootstrap/pv--vegbankdb-bootstrap-cephfs.yaml --context=prod-k8s
```

## Notes
The following values are hardcoded and must be updated manually if they change:

- In `kustomization.yaml`:
  - ../../db/migrations/*           --  Relative location of flyway migration files

- In `vegbankdb-bootstrap-from-legacy.yaml`:
  - vegbankdbcreds               --  Name of secret containing postgres username and password
  - vegbank_pg10_dataonly.dump   --  The name of the data-only dump file from the legacy vegbank db
  - vegbankdb-cnpg-rw            --  Hostname for the CNPG RW service for vegbankdb-cnpg cluster
