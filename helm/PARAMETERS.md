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
