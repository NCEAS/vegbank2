# Introduction

This document describes how to build and push a docker image to the github container registry for the `vegbank2` Flask API, as well as how to (re)deploy the `vegbankapi` pod in `kubernetes` to pick up the newly added image.
- Note: This `README.md` is a general summary. To learn in detail, you can visit this link: [Working with a GitHub packages registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## Requirements

- GitHub Account
- Docker CLI/Docker Desktop
- Helm (Optional - only if you want to deploy the newly uploaded image)

## Steps to Deploy A Docker Image

- [1. Log into Docker](#step-1-log-into-docker)
- [2. Getting your Personal Access Token](#step-2-getting-your-personal-access-token)
- [3. Creating a new personal access token (classic)](#step-3-creating-a-new-personal-access-token-classic)
- [4. Update your Dockerfile](#step-4-update-your-dockerfile)
- [5. Build & push your image](#step-5-build--push-your-image)
- [6. Re-deploy the kubernetes pod](#step-6-re-deploy-the-kubernetes-pod)

### Step 1. Log into Docker

There are different ways to push an image to the `vegbank2` github container registry - in this `README.md`, we will be using Docker / Docker Desktop. I feel that this is the simplest way to get set quickly. You can install `docker` through the command line, or download Docker Desktop [here](https://www.docker.com/products/docker-desktop/).

Afterwards, you can run the following command to log in to docker:

```sh
$ docker login ghcr.io -u youremail@domain.com
# Ex. docker login ghcr.io -u mok@nceas.ucsb.edu
```

Upon entering that command, you will be asked to enter a password. The password it is expecting is a personal access token (classic) that you will have to create. You can follow my instructions below on how to create one - or learn in detail [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens).

### Step 2. Getting your Personal Access Token

First, navigate to the GitHub website and go to your GitHub Settings / Developer Settings. Click on your profile in the upper-right corner, which will trigger a drop-down menu, and then click `Settings`.

On the lefthand side, scroll all the way down until you see the menu/tab option `<> Developer Settings`.

You will then be brought to a page with 3 options:
- GitHub Apps
- OAuth Apps
- Personal Access Tokens

Click `Personal Access Tokens` which will trigger a dropdown menu, and then select `Tokens (classic)`. Once you select this, you may see the list of tokens you have created in the past (which may or may not be expired) or an empty list. We want to generate a new token - so click the button/tab `Generate new token`, and then `Generate new token (classic) for general use`.

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

So first confirm that you are in the correct github branch that you would like to push an image for, and then go to `docker/Dockerfile` and update the image.version label:

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

After you've updated the label metadata, you are now ready to push your updated image to the Github container registry. You can do so like such, and be sure to replace the image.version with your specified one in the image metadata:

```sh
# Example with 0.0.3-develop image version
$ docker buildx build --platform linux/amd64 -f docker/Dockerfile ./ --push -t ghcr.io/nceas/vegbank:0.0.3-develop

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

### Step 6: Re-deploy the kubernetes pod

After the image has been deployed, navigate to your helm's `Chart.yaml` and update the `appVersion` to your new chart name. In the example below, I used `0.0.3-develop'.
- Note: You can find the different images available for you to select from [here](https://github.com/NCEAS/vegbank2/pkgs/container/vegbank)

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

If you notice that the deploymeny has been applied, but the pods did not appear to have been updated, you can also restart the pods like such:

```sh
$ kubectl rollout restart deployment vegbankapi
```