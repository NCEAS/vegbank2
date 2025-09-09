During the review process, we have been able to create the expected schema using less migration files. You can get more context and find more about that process here:
- https://github.com/NCEAS/vegbank2/issues/74

# VegBank PostGres Migration Notes (How the migration files were generated)

This README document outlines the process taken to generate the Vegbank schema from scratch to reproduce the migration files found in `/migrations`, along with the modifications made to get everything in sync. This document is meant to provide context, not the concrete steps to set-up postgres from scratch and migrate to the latest version.

## Step 1: V1.0__vegbank.sql

This first migration SQL produced - it contains all the tables/relations needed for a data-only insert. It also includes the alter table commands to apply foreign key constraints. These constraints will cause issues with loading data, so those commands have been moved to a new migration file `V1.12__add_constraints.sql`. which is to be applied after the data has been copied after migrating to `V1.11__populate_datadictionary`.

To generate this initial file, run the following bash script in 'sql-transformations':
```sh
./getvegbanksql.sh
```

### Deprecated Code
There is an issue with the syntax relating to the formatting of time, so the equivalent 'migrations' file `0_vegbank.sql` has been modified.

So if you are generating this initial `0_vegbank.sql` file from scratch, you will need to fix the deprecated code.

For example, RE: `dba_preassignacccode` was previously:

```
CREATE TABLE dba_preassignacccode
(
    dba_preassignacccode_id integer 
          NOT NULL PRIMARY KEY default nextval('dba_preassignacccode_dba_preassignacccode_id_seq')
          , 
    dba_requestnumber Integer NOT NULL, 
    databasekey varchar (20) NOT NULL, 
    tableabbrev varchar (10) NOT NULL, 
    confirmcode varchar (70) NOT NULL DEFAULT (replace(replace(replace(replace(now(),' ','T'),'-',''),':',''),'.','d') || 'R' || floor(random()*1000000)), 
    accessioncode varchar (255), 
    codeIsUsed Boolean
  
);  
```
- 

And has been amended to:

```
CREATE TABLE dba_preassignacccode
(
    dba_preassignacccode_id integer 
          NOT NULL PRIMARY KEY default nextval('dba_preassignacccode_dba_preassignacccode_id_seq')
          , 
    dba_requestnumber Integer NOT NULL, 
    databasekey varchar (20) NOT NULL, 
    tableabbrev varchar (10) NOT NULL, 
       confirmcode varchar (70) NOT NULL DEFAULT (
        replace(
            replace(
                replace(
                    replace(to_char(now(), 'YYYY-MM-DD"T"HH24:MI:SS'), ' ', 'T'), '-', ''
                ), ':', ''
            ), '.', 'd'
        ) || 'R' || floor(random() * 1000000)
    ), 
    accessioncode varchar (255), 
    codeIsUsed Boolean
);  
```

### UpdateSQL & Missing Files
Missing SQL Files that were declared in 'db_model_vegbank' and cannot be found:
- add_versionTable.sql
- create_andPopulate_configTables.sql

Note: The `db_model_vegbank.xml` found in this repo has been modified to address the backward slashes to be forward slashes so that they can properly be referenced.
```
<updateSQLFile>throwAways\alterTaxObsDenormRenameSciNameToFull.sql</updateSQLFile>
<updateSQLFile>throwAways\createTable_dba_stats.sql</updateSQLFile>
```

To find all the different updates, you can perform the following:

```sh
% grep "<updateSQLFile>" db_model_vegbank.xml > updateSQLFileList.txt 
% sort db_model_vegbank_updateSQLFileList.txt| uniq > unique_rows.txt

<updateSQLFile>addCoverCodeToTaxImportance.sql</updateSQLFile>
<updateSQLFile>addInterpFldsToObs.sql</updateSQLFile>
<updateSQLFile>addObsSynDenorm.sql</updateSQLFile>
<updateSQLFile>addTaxonObsDenormPlantNames.sql</updateSQLFile>
<updateSQLFile>addTop5SppToObs_denormFlds.sql</updateSQLFile>
<updateSQLFile>add_currentaccepted_toconcept.sql</updateSQLFile>
<updateSQLFile>add_requestAccCodeTblFields.sql</updateSQLFile>
<updateSQLFile>add_versionTable.sql</updateSQLFile>
<updateSQLFile>create_andPopulate_configTables.sql</updateSQLFile>
<updateSQLFile>throwAways/add_datasetItem_denorms.sql</updateSQLFile>
// The backward slashes have been amended in 'db_model_vegbank.xml' to be forward slashes
<updateSQLFile>throwAways\alterTaxObsDenormRenameSciNameToFull.sql</updateSQLFile>
<updateSQLFile>throwAways\createTable_dba_stats.sql</updateSQLFile>
```

### Other Comments

When reviewing Vegbank's 'db_model_vegbank.xml', there appears to be specific update versions to attributes for vegbank changes 1.0.*, which leads me to believe we can safely omit the respective `vegbank-changes-1.0.*.sql` files.

## Step 2: The remaining migrations

The other migration sqls were obtained by following the 'build.xml' structure in the [Vegbank repo](https://github.com/NCEAS/vegbank/). These files have also been named for consistency to follow `flyway` best practices.

Notes:
- There also exists SQL code within these files that cause a flyway migration failure - so these files have been amended accordingly (ex. DROP VIEW -> DROP VIEW IF EXISTS), namely in V1.3, V1.4, V1.5
- I also added an additional migration file (V1.8) to drop views before creating them again to ensure consistency
- In V1.6, all commands were disabled as the config tables were already being populated through the data-only dump file.
- During the testing process, an additional table was also added to V1.0 which was necessary (missing): `temp_ks_commconcept_acccodelist`

## Step 3: Populating the Data Dictionary

To help devs better understand the database's structure, we then need to populate the data dictionary.

Run the following to create the relevant 'populate-datadictionary.sql' sql file.

```sh
./getvegbanksql_datadictionary.sh
```

## Step 4: Applying constraints

In order to load a data-only postgres dump file, we need to remove the foreign key constraints. This is why the constraints SQL was extracted from `V1.0__vegbank.sql` and moved to its own migration file `V1.12__add_constraints.sql`, which is to be applied AFTER the data-only dump file has been loaded.

This also means that when setting up postgres, and applying migrations, the target should first be V1.11, then the data dump, then the V1.12 execution.