# Introduction

This document describes how to build and push a docker image to the github container registry for the `vegbank2` Flask API, as well as how to (re)deploy the `vegbankapi` pod in `kubernetes` to pick up the newly added image.
- Note: This `README.md` is a general summary. To learn in detail, you can visit this link: [Working with a GitHub packages registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## Requirements

- GitHub Account
- Docker CLI/Docker Desktop
- Helm (Optional - only if you want to deploy the newly uploaded image)

> [!TIP]
> You can install `docker`, either as part of [Rancher Desktop](https://rancherdesktop.io), [Docker Desktop](https://www.docker.com/products/docker-desktop/), or on the command line via [HomeBrew](https://brew.sh) etc.

## Steps to Deploy A Docker Image

- [1. Create a New Personal Access Token (PAT)](#step-1-create-a-new-personal-access-token-pat)
- [2. Log into GitHub Container Repository (GHCR)](#step-2-log-into-github-container-repository-ghcr)
- [3. Build & push your image](#step-3-build--push-your-image)
- [4. Redeploy the Kubernetes Pod](#step-4-redeploy-the-kubernetes-pod)

### Step 1. Create a New Personal Access Token (PAT)

(For more-detailed instructions, [see GitHub's documentation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens))

First, navigate to the GitHub website and go to your GitHub Settings / Developer Settings. Click on your profile in the upper-right corner, which will trigger a drop-down menu, and then click `Settings`.

On the left side, scroll all the way down until you see the menu/tab option `<> Developer Settings`.

You will then be brought to a page with 3 options:
- GitHub Apps
- OAuth Apps
- Personal Access Tokens

Click `Personal Access Tokens` which will trigger a dropdown menu, and then select `Tokens (classic)`. Once you select this, you may see the list of tokens you have created in the past (which may or may not be expired) or an empty list. We want to generate a new token - so click the button/tab `Generate new token`, and then `Generate new token (classic) for general use`.

You will be asked to add a `Note`. Enter here a short string to remind yourself what this token will be used for, for example, `vegbank2-dockerpush`.

Then select an `Expiration` date - or leave it as the default (30 days).

Lastly, `Select scopes`. Full unlimited access is not required; instead, limit this token to:

```
- repo:
   - repo:status
   - repo:deployment
   - public_repo
   - repo:invite
   - security_events
- write:packages
   - read:packages
```

Selecting `write:packages` will automatically select the required scopes

After clicking the `Generate token` button, you will see your new personal access token. Copy and save this string somewhere safe:

```shell
# Example personal access token string
ghp_kEePtHiSsTrIxGS4FeAnDaDDn0TxsToR3m3mb3r
```

### Step 2. Log into GitHub Container Repository (GHCR)

After you generate your PAT, log into GHCR. When prompted for a password, use the PAT you generated above:

```shell
$ docker login ghcr.io -u youremail@domain.com
Password: 
Login Succeeded
```

### Step 3: Build & Push Your Image

You are now ready to push your updated image to the Github container registry:

```shell
# Example with 0.0.3-develop image version
TAG=0.0.3-develop
$ docker buildx build --build-arg IMG_VER="$TAG" --platform linux/amd64 -f docker/Dockerfile ./ \
      --push -t ghcr.io/nceas/vegbank:$TAG

# Example output
[+] Building 4.5s (16/16) FINISHED                                                                                                                             docker-container:multi-platform-builder
 => [internal] load build definition from Dockerfile                                                                                                                                              0.0s
 => => transferring dockerfile: 556B                                                                                                                                                              0.0s
 => [internal] load metadata for docker.io/library/python:3.13                                                                                                                                    1.2s
 => [internal] load .dockerignore                                                                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                                                                   0.0s
 => [ 1/10] FROM docker.io/library/python:3.13@sha256:c8b03b4e98b39cfb180a5ea13ae5ee39039a8f75ccf52fe6d5c216eed6e1be1d                                                                            0.0s
 => => resolve docker.io/library/python:3.13@sha256:c8b03b4e98b39cfb180a5ea13ae5ee39039a8f75ccf52fe6d5c216eed6e1be1d                                                                              0.0s
 => [internal] load build context                                                                                                                                                                 0.0s
 => => transferring context: 9.72kB                                                                                                                                                               0.0s
 => CACHED [ 2/10] WORKDIR /python-docker                                                                                                                                                         0.0s
 => CACHED [ 3/10] ADD /vegbank/vegbankapi.py .                                                                                                                                                   0.0s
 => CACHED [ 4/10] ADD /vegbank/utilities.py .                                                                                                                                                    0.0s
 => CACHED [ 5/10] ADD queries ./queries                                                                                                                                                          0.0s
 => CACHED [ 6/10] ADD /vegbank/operators ./operators                                                                                                                                             0.0s
 => CACHED [ 7/10] RUN pip install flask                                                                                                                                                          0.0s
 => CACHED [ 8/10] RUN pip install psycopg                                                                                                                                                        0.0s
 => CACHED [ 9/10] RUN pip install pandas                                                                                                                                                         0.0s
 => CACHED [10/10] RUN pip install pyarrow                                                                                                                                                        0.0s
 => exporting to image                                                                                                                                                                            3.2s
 => => exporting layers                                                                                                                                                                           0.0s
 => => exporting manifest sha256:127f0cae822871ef55ca2da3742485659b8f1c176a47d865d861195fd4e249a4                                                                                                 0.0s
 => => exporting config sha256:4bb12eb09ca1f46b1fb718796a7df6c7d6ed281ed033eed3a3a5650d368493e6                                                                                                   0.0s
 => => exporting attestation manifest sha256:b662b8b186d1be2eb241953233bff79536eb9aee7ab73f832da04885e48d0990                                                                                     0.0s
 => => exporting manifest list sha256:fa62838f857c8f7c8f2e3c764fda851b4f7878d5d0f79f9cd33155f9b0f4c5c1                                                                                            0.0s
 => => pushing layers                                                                                                                                                                             2.0s
 => => pushing manifest for ghcr.io/nceas/vegbank:0.0.3-develop@sha256:fa62838f857c8f7c8f2e3c764fda851b4f7878d5d0f79f9cd33155f9b0f4c5c1                                                           1.2s
 => [auth] nceas/vegbank:pull,push token for ghcr.io                                                                                                                                              0.0s
```

### Step 4: Redeploy the Kubernetes Pod

After the image has been published, a `helm upgrade` is needed in order to pull this new image version. For example, using version `2.0.0-beta02`:

Simply override the existing image version in the helm chart...
```shell
# Either add to your values overrides yaml file, or set on command line, as follows:
helm upgrade --install vegbankapi oci://ghcr.io/nceas/charts/vegbank --set image.tag="2.0.0-beta02"
```

...or permanently add to the helm chart by updating the `appVersion` in `helm/Chart.yaml`:

```shell
# edit Chart.yaml to include this value:
#
appVersion: "2.0.0-beta02"

# then upgrade
#
$ helm upgrade vegbankapi ./helm
```

The pods must restart in order to pick up the change. If the helm upgrade did not cause a restart, trigger one manually:

```shell
$ kubectl rollout restart deployment vegbankapi
```

> [!TIP]
> Available images are [listed here](https://github.com/NCEAS/vegbank2/pkgs/container/vegbank)
