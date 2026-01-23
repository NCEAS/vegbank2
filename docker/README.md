# Introduction

This document describes how to build and push a docker image file for the `vegbank2` Flask API, and then (re)deploy the `vegbankapi` pod in kubernetes to pick up the changes. This `README.md` is a general summary of this process. To learn in detail, you can visit this link:
- [Working with a GitHub packages registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## Requirements

- GitHub Account
- Docker Desktop

## Steps to Deploy A Docker Image

- [1. Get Your Personal Access Token from GitHub](#personal-access-token)
- [2. Logging into Docker](#docker-login)
- [3. Update your Dockerfile](#)

### Step 1. Log into Docker

To push a docker image to the `vegbank2` GitHub image registry, you will need to ensure that you have `Docker Desktop` running. If you do not have it installed, you can download it [here](https://www.docker.com/products/docker-desktop/) to get it.

Afterwards, you can log into docker like such:

```sh
$ docker login ghcr.io -u youremail@domain.com
# Ex. docker login ghcr.io -u mok@nceas.ucsb.edu
```

Upon entering that command, you will be asked to enter a password. The password it is expecting is a personal access token (classic) that you will have to create. You can follow my instructions below to create it - or learn in detail [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

### Step 2. Getting your Personal Access Token

First, navigate to the GitHub website and go to your GitHub Settings / Developer Settings. Click on your profile in the upper-right corner which will trigger a drop-down menu, and then click `Settings`.

On the lefthand side, scroll all the way down until you see the menu/tab option `<> Developer Settings`.

You will then be brought to a page with 3 options:
- GitHub Apps
- OAuth Apps
- Personal Access Tokens

Click `Personal Access Tokens` which will drop down a menu, and then select `Tokens (classic)`. Once you select this, you will be able to see the list of tokens you have created in the past which may or may not be expired. We want to generate a new token - so click the button/tab `Generate new token`, and then `Generate new token (classic) for general use`.

### Step 3. Creating a new personal access token (classic)

You will be asked to add a `Note`. Enter here a short string to remind yourself what this token will be used for, for example, `vegbank2-dockerpush`.

Then select an `Expiration` date - or leave it as the default (30 days).

Lastly, you will need to `Select scopes`. We do not want to provide this token with full unlimited access to everything and hurt our future selves, so let's limit this token to:
- repo:
   - repo:status
   - repo:deployment
   - public_repo
   - repo:invite
   - security_events
- write:packages
   - read:packages

You will notice that if you select `write:packages`, it will automatically select the required scopes to support it.

After you click the button `Generate token`, you will then be shown a string for your new personal access token. Copy and save this string somewhere safe:

```sh
# Example personal access token string
ghp_kEePtHiSsTrInGS4FeAnDaDDn0TesToR3m3mb3r
```

After you generate your personal access token, log into docker. Your workflow in the command line may now look like this:

```sh
$ docker login ghcr.io -u youremail@domain.com
Password: 
Login Succeeded
```

### Step 4: Update your Dockerfile

Every image we push should have a unique and immutable version number, and this should be recorded in the (docker) image metadata.

So first confirm that you are in the correct github branch that you would like to push an image for, and then go to `docker/Dockerfile` and update the following label:

```sh
# docker/Dockerfile
FROM python:3.13

LABEL org.opencontainers.image.title="vegbank2 Flask API"
LABEL org.opencontainers.image.source="http://github.com/nceas/vegbank2"
# Update this label
# ex. LABEL org.opencontainers.image.version="0.0.3-develop"
LABEL org.opencontainers.image.version="#.#.#-unique-name"

...

```

### Step 5: Build & push your image

After you've updated the label metadata, you are now ready to push your updated image to the Github container registry. You can do so like such:

```sh
$ docker buildx build --platform linux/amd64 -f docker/Dockerfile ./ --push -t ghcr.io/nceas/vegbank:#.#.#-unique-name

# Example output
[+] Building 62.6s (17/17) FINISHED                                                                                                                                                              docker-container:multi-platform-builder
 => [internal] load build definition from Dockerfile                                                                                                                                                                                0.0s
 => => transferring dockerfile: 443B                                                                                                                                                                                                0.0s
 => [internal] load metadata for docker.io/library/python:3.13                                                                                                                                                                      1.0s
 => [internal] load .dockerignore                                                                                                                                                                                                   0.0s
 => => transferring context: 2B                                                                                                                                                                                                     0.0s
 => [ 1/10] FROM docker.io/library/python:3.13@sha256:c8b03b4e98b39cfb180a5ea13ae5ee39039a8f75ccf52fe6d5c216eed6e1be1d                                                                                                              0.0s
 => => resolve docker.io/library/python:3.13@sha256:c8b03b4e98b39cfb180a5ea13ae5ee39039a8f75ccf52fe6d5c216eed6e1be1d                                                                                                                0.0s
 => [internal] load build context                                                                                                                                                                                                   0.0s
 => => transferring context: 9.72kB                                                                                                                                                                                                 0.0s
 => CACHED [ 2/10] WORKDIR /python-docker                                                                                                                                                                                           0.0s
 => CACHED [ 3/10] ADD /vegbank/vegbankapi.py .                                                                                                                                                                                     0.0s
 => CACHED [ 4/10] ADD /vegbank/utilities.py .                                                                                                                                                                                      0.0s
 => CACHED [ 5/10] ADD queries ./queries                                                                                                                                                                                            0.0s
 => CACHED [ 6/10] ADD /vegbank/operators ./operators                                                                                                                                                                               0.0s
 => CACHED [ 7/10] RUN pip install flask                                                                                                                                                                                            0.0s
 => CACHED [ 8/10] RUN pip install psycopg                                                                                                                                                                                          0.0s
 => CACHED [ 9/10] RUN pip install pandas                                                                                                                                                                                           0.0s
 => CACHED [10/10] RUN pip install pyarrow                                                                                                                                                                                          0.0s
 => exporting to image                                                                                                                                                                                                             61.5s
 => => exporting layers                                                                                                                                                                                                             0.0s
 => => exporting manifest sha256:ebce57de6dcd722657b7085e90812aa5e823df00c340bfdc87d5b85bef55808e                                                                                                                                   0.0s
 => => exporting config sha256:73f0bc60e8a604c034bd5deac33ad02c75c7fb82cc3cb38d8963a2b489579761                                                                                                                                     0.0s
 => => exporting attestation manifest sha256:ad402922db46c5c19fdc9b7aa1d5cda641cad004930976312dcfe80a5790dcc6                                                                                                                       0.0s
 => => exporting manifest list sha256:3df3487c033272e3a3712c51385be21f7fa8a6095702bd9de9df5213df0a6eb5                                                                                                                              0.0s
 => => pushing layers                                                                                                                                                                                                              59.8s
 => => pushing manifest for ghcr.io/nceas/vegbank:0.0.3-dev@sha256:3df3487c033272e3a3712c51385be21f7fa8a6095702bd9de9df5213df0a6eb5                                                                                                 1.7s
 => [auth] nceas/vegbank:pull,push token for ghcr.io                                                                                                                                                                                0.0s
 => [auth] nceas/vegbank:pull,push token for ghcr.io                                                                                                                                                                                0.0s
```

### Step 6: Re-deploy the kubernetes pod

After the image has been deployed, navigate to your helm's `Chart.yaml` and updated the `appVersion` to your new chart name. In the example below, I used `0.0.3-develop'.

```sh
# helm/Chart.yaml

...
appVersion: "0.0.3-develop"
```

Once you've updated your chart version, use `helm` to re-deploy the `vegbankapi` pod.

```sh
$ helm upgrade vegbankapi . -f values.yaml
```

You can check whether your upgrade succeeded by executing the following command:

```sh
$ helm history vegbankapi
```

If you notice that the change has been applied, but the pods did not appear to have been updated, you can also restart the pods like such:

```sh
$ kubectl rollout restart deployment vegbankapi
```