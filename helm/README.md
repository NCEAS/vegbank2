# Introduction

This document describes how to deploy the helm chart and database for the PostgreSQL pod component of VegBank.

## Requirements

The first step in this process will change depending on what kind of database dump file you are working with as your starting point. If you have a database dump file on a previous version of Postgres, you will first need to follow the instructions provided in the INSTALL.md document located in this repository, as well as the other README.md document located at /src/database/flyway. Those two files will guide you through creating a local Postgres instance on the correct version, then running the necessary Flyway migrations to get the database into the correct state. If you have a dump file from the new system already, you can skip the steps below about creating a dump file and go straight to "Adjusting Memory Limits for Import". 

You will also need the following things set up/installed: 

- A Kubernetes cluster you wish to deploy the chart on (ex. dev-vegbank, dev-vegbank-dev)
- kubectl installed locally
- Helm installed locally

# Deploying to Kubernetes

This section will walk you through deploying VegBank to an empty kubernetes namespace. The required data is already available in a directory that can be accessed by mounting a PV/PVC.
- Note: PV/PVCs cannot be shared amongst namespaces - there can only be one PV for one PVC claim. This is why you will see under `helm/admin` two sets of PV and PVC documents: one is for the namespace `dev-vegbank` and the other is for `dev-vegbank-dev`.

## Step 1: Apply the PV/PVC

You will likely not need to apply the PV/PVC because they are already applied in the `dev-vegbank` and `dev-vegbank-dev` namespace. However, if you have a new namespace (ex. `dev-dou-vegbank`), then you will need to duplicate and apply the existing PV/PVC documents in `helm/admin`.
- The pv.yaml file should be renamed, and you'll have to update `metadata.name`
- The pvc.yaml file should also be renamed, and you'll have to update `metadata.namespace` to be the user of your namespace, and `spec.volumeName` to be the `metadata.name` that you used in the pv.yaml

```sh
# Apply the PV as k8s admin
$ kubectl config use-context `dev-k8s`
$ kubectl apply -f '/Users/doumok/Code/vegbank2/helm/admin/pvc--vegbankdb-init-douvgdb.yaml' 

# Apply the PVC in your namespace
$ kubectl config use-context `dev-dou-vegbank`
$ kubectl apply -f '/Users/doumok/Code/vegbank2/helm/admin/pv--vegbankdb-init-cephfs-douvgdb.yaml' 
```

You can check what PV/PVCs are applied like such:
```sh
$ kubectl get pvc | grep 'vegbank'
```

## Step 2: Helm Install (and Uninstall...)

Next step is to deploy the helm chart. This can be done simply by opening a terminal in the root folder of this repo, then running the following command: 

```sh
# If you're in the root folder
$ helm install vegbankdb helm

# If you're in the helm folder
$ helm install vegbankdb .
```

If you are on a namespace without ingress, be sure to set the flag to prevent ingress errors:

```sh
$ helm install vegbankdb . --set ingress.enabled=false
```

This will install the Postgres pod on the namespace you have selected as your current context (ex. `dev-vegbank`), and give the pod the name vegbankdb. You can change the name vegbankdb to whatever you like. The pod is currently blank, and now needs to be restored with the dump file.

- Tip: If you are clearing out an existing namespace, or need to restart this process - you can do this by uninstalling the helm chart and deleting the existing postgres content.

  ```sh
  $ kubectl exec -it vegbankdb-postgresql-0 -- /bin/sh
  $ rm -rf /bitnami/postgresql/data
  # Exit the shell (ctrl+d)
  $ helm uninstall vegbankdb
  ```

  This will delete all the pods and give you a fresh start. The postgres pod will start up and point to an empty directory, ready for you to restart this process.

At this point, your pod will not be able to start up successfully. This is because the postgres pod with the existing configuration values does not have a corresponding database to access. We will need to exec into the pod and get it set up so that the helm startup process with `flyway` and `postgres` can execute with the correct credentials/faculties in place.

You can check what's happening by looking at the `initContainer` like such:

```sh
$ kubectl get pods
vegbankdb-6966f945c6-xgq4l   0/1     Init:Error   1 (10s ago)   14s
vegbankdb-postgresql-0       1/1     Running      0             14s

# This will show you information about the pod, and if you scroll all the way down, where it's at in the initialization process 
$ kubectl describe pod vegbankdb-6966f945c6-xgq4l
# You can then check the logs of a specific initContainer to see what issues occurred
$ kubectl logs vegbankdb-5b6956f48d-xgq4l -c vegbank-init-flyway
```

## Step 3: Postgres Pod Set-up

First, confirm that you see the postgres pod:

```sh
$ kubectl get pods

vegbankdb-6966f945c6-xgq4l   0/1     Init:Error   1 (10s ago)   14s
vegbankdb-postgresql-0       1/1     Running      0             14s
```

Now let's set up the postgres instance (in our case, a fresh installation of PG16)

```sh

```

## Restoring the data-only dump file

Before we import the file, we have to copy it onto the pod. To do this, we use the kubectl cp command, but we can't just put the file anywhere or you might run into a permission issue when trying to import the file. The easiest place I have found to copy the file is into the /tmp folder on the pod. This folder will get emptied when you take the pod down as well, which can be good for long term space concerns. The command I used looks like this: 

`kubectl cp [location of your dump file] [full name of your pod]:/tmp`

The copy might take a little bit as the file is a few gigs. Once the copy is completed, you need to open bash on the pod. I used this command: 

`kubectl exec [pod-name] -i -t -- bash -il`

Then once you have the bash open, you'll need to add the postgres folder to the path so you can run postgres commands. The bitnami chart we're using placed the files on my pod at the following location: 

`/opt/bitnami/postgresql/bin`

Once you've added that to the path, you should be able to use psql to view the empty Postgres instance. Once you've logged in to Postgres, run the following SQL command from the INSTALL.md document to create an empty DB and user to populate the database with: 

```SQL
CREATE ROLE vegbank WITH LOGIN PASSWORD 'vegbank';
CREATE DATABASE vegbank
WITH
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8';
GRANT ALL PRIVILEGES ON DATABASE vegbank TO vegbank;
```

Then we can run the psql import. You'll need to quit out of the psql terminal for this. Because this dump file process creates a text based file, we'll need to use the psql command rather than pg_restore. Here's what mine looked like: 

`psql --username=vegbank -d vegbank -f [name of your dump file]`

This restore took quite a while for me, especially some of the larger tables. Once it's done, you can check to make sure everything worked right by running some sample queries. If the restore failed, there won't be any data in the database at all. 

## Restoring Memory Settings

Now that you're done, the last step is to uninstall the chart, change back the memory setting we adjusted earlier, and reinstall the chart. Don't worry about losing your newly imported data, the persistence settings will hold onto it for you. You can run helm uninstall vegbankdb, then change the values.yaml file back to the following: 

```YAML
resources:
      requests:
        memory: 128Mi
      limits:
        memory: 192Mi
```

Save that, redeploy the helm chart, and you're all done!

# Connecting to API via kubectl port forwarding

Once you're in the k8s dev-vegbank context, you can find the name of the API pod via the following command: 


` kubectl get pods `

The API pod is the one with the werid alphanumeric name. After that, all you need is this command: 

` kubectl port-forward <API pod name> <desired port on your machine>:80 `

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
