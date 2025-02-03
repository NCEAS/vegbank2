# Introduction

This document describes how to deploy the helm chart and Database for the PostgreSQL pod component of VegBank.

## Requirements

The first step in this process will change depending on what kind of database dump file you are working with as your starting point. If you have a database dump file on a previous version of Postgres, you will first need to follow the instructions provided in the INSTALL.md document located in this repository, as well as the other README.md document located at /src/database/resources. Those two files will guide you through creating a local Postgres instance on the correct version, then running the necessary Flyway migrations to get the database into the correct state. If you have a dump file from the new system already, you can skip the steps below about creating a dump file and go straight to "Adjusting Memory Limits for Import". 

You will also need the following things set up/installed: 

- A Kubernetes cluster you wish to deploy the chart on
- kubectl installed locally
- Helm installed locally

# Deployment

This section will walk you through deploying VegBank from an empty kubernetes cluster. You will also need access to some version of the database, either the current postgres version, or the old one that was deployed on the previous version of VegBank. 

## Creating the Dump File

Once you've got your local version of the database set up, the next step is to create a new dump file of the current version. As a note, one of the tables from the old databse, dba_xmlcache, throws errors when imported on a new version due to a conversion error. This table will no longer be used after the transition to JSON on the new system anyway, so I excluded it when I created the dump file to avoid this problem. Here is the command I used to create my dump file: 

`pg_dump -T 'dba_xmlcache' vegbank > vegbankdumpfile.sql` 

A note here: If you created your initial local database under your local machine's user in Postgres like I did, you may have to ignore ownership when creating the dump file, otherwise the restore will throw an error looking for a user that doesn't exist. You can do that by adding the following parameter to the above command: 

`--no-owner`

## Adjusting Memory Limits for Import

Before deploying the chart, you'll need to make a temporary change to the values.yaml file to increase the memory request/limit values. The resources block in the values.yaml file currently looks like this: 

```
resources:
      requests:
        memory: 128Mi
      limits:
        memory: 192Mi
```

This is because the pod itself requires little memory to run, but the process to import the data will require more. To do this, we're going to temporarily increase the limits to the following: 

```
resources:
      requests:
        memory: 1Gi
      limits:
        memory: 2Gi
```

Make that change, then save the file. We'll come back to this later once we're done to change this value back. 

## Deploying the Helm Chart

Next step is to deploy the helm chart. This can be done simply by opening a terminal in the root folder of this repo, then running the following command: 

`helm install vegbankdb helm`

This will install the Postgres pod on the cluster you have selected as your current context, and give the pod the name vegbankdb. You can change the name vegbankdb to whatever you like. The pod is currently blank, and now needs to be filled with the dump filled with the dump file you created earlier. 

## Copying the Dump File onto the Pod and Importing it

Before we import the file, we have to copy it onto the pod. To do this, we use the kubectl cp command, but we can't just put the file anywhere or you might run into a permission issue when trying to import the file. The easiest place I have found to copy the file is into the /tmp folder on the pod. This folder will get emptied when you take the pod down as well, which can be good for long term space concerns. The command I used looks like this: 

`kubectl cp [location of your dump file] [full name of your pod]:/tmp`

The copy might take a little bit as the file is a few gigs. Once the copy is completed, you need to open bash on the pod. I used this command: 

`kubectl exec [pod-name] -i -t -- bash -il`

Then once you have the bash open, you'll need to add the postgres folder to the path so you can run postgres commands. The bitnami chart we're using placed the files on my pod at the following location: 

`/opt/bitnami/postgresql/bin`

Once you've added that to the path, you should be able to use psql to view the empty Postgres instance. Once you've logged in to Postgres, run the following SQL command from the INSTALL.md document to create an empty DB and user to populate the database with: 

```
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

```
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
