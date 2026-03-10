# Production Deployment to Kubernetes

The production k8s release process for VegBank follows the same steps described in the helm [README file](../README.md), with some additional considerations specific to the production environment. This document therefore focuses on the differences, and does not repeat the detail found in the README.

## Configuration

> [!NOTE]
> For simplicity, our private NCEAS GitHub Enterprise repositories will be referred to as "GHE repos" in this document. The GHE repos are accessible only to NCEAS staff.

> [!CAUTION]
> In the event of catastrophic failure, it may be necessary to redeploy from scratch. It is therefore CRITICAL that:
> 1. The VegBank `CHANGELOG.md` file in the GHE `k8s-cluster-config` repo **MUST** be updated for every deployment
> 2. The latest versions of all config files needed for production deployments **MUST** be stored in the GHE `k8s-cluster-config` repo (including values overrides, manually applied YAML templates, etc.)
> 3. The latest **GPG-encrypted** versions of all credentials files needed for production deployments **MUST** be stored in the GHE `Security` repo
>
> **NO EXCEPTIONS!**

## Checklist for Production Deployment

See detailed information in the [helm README file](../README.md) for each step, unless otherwise noted below.

1. Create Secrets

    Follow the steps in the Helm README to create the necessary secrets for the CNPG cluster, Flask and OpenID Connect (OIDC).
    - The production credentials for CNPG can be found in a GPG-encrypted YAML file in the GHE `Security` repo. Decrypt, then use:

      ```shell
      kubectl create -f vegbank-cnpg-secret.yaml
      ```

   - The production KeyCloak client secret credentials can be found in a GPG-encrypted JSON file in the GHE `Security` repo. Decrypt, then follow the steps in the Helm README
   - The Flask Session-Signing Secret creation is exactly as described in the Helm README. It does NOT need to be stored in the GHE repo; it should be regenerated if needed.

2. Deploy CNPG Cluster

    - Do not use the `helm/admin/values-cnpg.yaml` overrides file described in the README. Instead, use the production overrides file (`values-prod-vegbank-cnpg.yaml`) stored in the GHE `k8s-cluster-config` repo.
    - Inspect the values to make sure they are correct for your deployment. For more details, see documentation in the `dataone-cnpg` [GitHub repo](https://github.com/DataONEorg/dataone-cnpg)
    - Pay particular attention to the following:

      ```yaml
      existingSecret: vegbankdbcreds

      init:
        ## Set to "true" for initial installation of a new cluster
        enabled: true
        method: initdb

      backup:
      enabled: true
      ```

    - when you are ready, deploy the CNPG cluster using the production overrides file:

      ```shell
      helm install vegbankdb oci://ghcr.io/dataoneorg/charts/cnpg -f values-prod-vegbank-cnpg.yaml
      ```

3. (Optional) Restore from Data-Only Postgres v10 Dump File

    This step is required only if bootstrapping from the (data-only) dump file, taken from the original VegBank Postgres version 10 database.

    This dump file (created immediately after the legacy (v1) vegbank.org site was taken down on 3/2/2026) is stored on the production ("pdg") cephfs subvolume, which can be accessed on `datateam` at:
 
    ```shell
    /mnt/ceph/repos/vegbank/vegbank_dataonly_fc_20260302.dump
    ```

    - If you need to restore from the legacy data-only dump file, follow the instructions in the [bootstrap README](../admin/bootstrap/README.md). This should be done directly against the CNPG cluster (via the RW service), and NOT via a pooler layer (see below). Note that the dump file will need to be renamed or symlinked to match the name shown in the bootstrap README.

4. (Optional) Restore from a CNPG Backup Object

    If you need to restore from a CNPG Backup object instead, see the [db-recovery.md file](./db-recovery.md) for instructions.

5. Deploy the PGBouncer Pooler

    This step is NOT described in the Helm README, but the PGBouncer deployment is required for production deployments of VegBank, in order to avoid database connection starvation. For more details, see the [`DataONEorg/k8s-cluster` documentation](https://github.com/DataONEorg/k8s-cluster/blob/main/operators/postgres/postgres.md#using-a-connection-pooler).

    - Use the file `pooler--prod-vegbank-cnpg.yaml` from the GHE `k8s-cluster-config` repo, and first double-check the values to make sure they are correct for your deployment. Pay particular attention to the following:

      ```yaml
      ## This is the "host name" your API deployment will use to access PostgreSQL,
      ## instead of accessing it directly via the CNPG cluster service.
      metadata:
        name: vegbankdb-pooler-rw

      ## This is the name of the CNPG cluster installed above.
      ## Find using:  kubectl get cluster
      spec:
        cluster:
          name: vegbankdb-cnpg
      ```

    - Then deploy directly (without using helm):

      ```shell
      kubectl create -f pooler--prod-vegbank-cnpg.yaml
      ```

6. Deploy the API Application

  - Do not use the `values-overrides-dev.yaml` overrides file described in the README. Instead, use the production overrides file (`values-prod-cluster-vegbank.yaml`) stored in the GHE `k8s-cluster-config` repo.
  - Inspect the values to make sure they are correct for your deployment. For more details, see the ["Parameters" section of the helm README](../README.md#parameters), and the comments in the VegBank [`values.yaml`](../values.yaml) file
  - Check all the overrides, and pay particular attention to the following:

    ```yaml
    database:
      host: vegbankdb-pooler-rw  # the PGBouncer pooler service, NOT the CNPG cluster service

    flyway:
      dbHost: vegbankdb-cnpg-rw  # the CNPG cluster RW service, NOT the pooler service
    ```

  - when you are ready, deploy using the production overrides file:

    ```shell
    helm install vegbankapi -f values-prod-cluster-vegbank.yaml \
            oci://ghcr.io/nceas/charts/vegbank --version <version#>
    ```

    Watch the initContainers and pod startup as described in the helm README

> [!TIP]
> Chart release versions are [available here](https://github.com/NCEAS/vegbank2/pkgs/container/charts%2Fvegbank)
