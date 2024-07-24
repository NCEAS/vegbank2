VegBank PostGres Migration Notes

## Begin with getting the very first `vegbank.sql` file

./getvegbanksql.sh

Missing SQL Files that were declared in 'db_model_vegbank':
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
<updateSQLFile>throwAways\alterTaxObsDenormRenameSciNameToFull.sql</updateSQLFile>
<updateSQLFile>throwAways\createTable_dba_stats.sql</updateSQLFile>
```