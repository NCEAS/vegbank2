# VegBank PostGres Migration Notes

## 0_vegbank.sql

This is the first migration sql file to create the database tables

Run the following bash script in 'sql-transformations':
```sh
./getvegbanksql.sh
```

Note: there is an issue with the syntax relating to the `dba_preassignacccode` table, so the equivalent 'migrations' file has been modified.

Missing SQL Files that were declared in 'db_model_vegbank' and cannot be found:
- add_versionTable.sql
- create_andPopulate_configTables.sql

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

## The remaining migrations

The other migration sqls were obtained by following the 'build.xml' structure.