# VegBank PostGres Migration Notes

This install document outlines how to generate the Vegbank schema from scratch to reproduce the migration files found in `/migrations`

## Step 1: 0_vegbank.sql

This is the first migration sql file to create the relations.
Run the following bash script in 'sql-transformations':
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

The other migration sqls (Steps 1 to 8) were obtained by following the 'build.xml' structure in the [Vegbank repo](https://github.com/NCEAS/vegbank/).

## Step 3: Populating the Data Dictionary

To help devs better understand the database's structure, we then need to populate the data dictionary.

Run the following to create the relevant 'populate-datadictionary.sql' sql file.

```sh
./getvegbanksql_datadictionary.sh
```