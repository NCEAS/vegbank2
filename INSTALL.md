# Introduction

This install document describes how to restore the Vegbank database from a data-only dump file. 

# Local Development Installation (Postgres 10.23, MacOS M2)

// TODO: Automate as much of this process as possible with a bash script

Requirements:
- Postgres.app with PostgreSQL 10 – 15 (Universal/Intel)
 - https://postgresapp.com/downloads_legacy.html
- Flyway CLI
 - https://documentation.red-gate.com/fd/command-line-184127404.html

Step 1:

Install the `postgres.app` and launch a Postgres 10.23 server. 

Step 2:

Access the postgres server via `psql`, and create a new vegbank db and roles:

```
CREATE ROLE vegbank WITH LOGIN PASSWORD 'vegbank';
CREATE DATABASE vegbank
WITH
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8';
GRANT ALL PRIVILEGES ON DATABASE vegbank TO vegbank;
```

Step 3:

Take the `flyway.conf` file and move it into your local flyway `conf` installation. Ensure that the contents match the location of the `/migrations` folder found in the directory where this `vegbank2` repo exists. For example:

```
// ex. /Users/doumok/Code/flyway-10.17.0/conf/flyway.conf
flyway.url=jdbc:postgresql://localhost:5432/vegbank2
flyway.user=vegbank
flyway.password=vegbank
flyway.locations=filesystem:/Users/doumok/Code/vegbank2/migrations
```

Step 4:

Run the following command to apply migrations up until `V1.11__populate_datadictionary`

```
flyway -target=1.11 migrate
```

Step 5:

Execute the data-only dump file:

```
psql -U doumok -d vegbank2 -f /Users/doumok/Code/testing/vegbank_dataonly_20240814.sql

// The following command will place the output into a txt file of in the directory of your choice
psql -U doumok -d vegbank2 -f /Users/doumok/Code/testing/vegbank_dataonly_20240814.sql > /your/desired/dir/vegbank2_psql_output.txt 2>&1
```

If you don't have a dump file, you can get one by asking a sys admin for `vegbank` to provide you with one via the following command:

```
postgres@vegbank:~/dumps$ pg_dump -d vegbank --data-only -f vegbank_dataonly_[YYMMDD].sq
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   observation
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   party
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   plot
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   referenceparty
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   revision
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
pg_dump: NOTICE: there are circular foreign-key constraints on this table:
pg_dump:   soiltaxon
pg_dump: You might not be able to restore the dump without using --disable-triggers or temporarily dropping the constraints.
pg_dump: Consider using a full dump instead of a --data-only dump to avoid this problem.
postgres@vegbank:~/dumps$
```

**NOTE 1:** You can see that the output above generated from creating the dump file displays warnings, no problem. The migration files can handle these issues.

**NOTE 2:** If any exceptions occur with `COPY` commands in the data insertion process, the entire table the command is trying to add into the database will not be executed. Exceptions must be resolved in order for the table's data to be loaded (all or nothing).

Step 6:

Finish the migration:

```
flyway migrate
```

An example of the full process on my local terminal for added context:

```sh
doumok@Dou-NCEAS-MBP14 ~ % psql
psql (14.11 (Homebrew), server 10.23)
Type "help" for help.

doumok=# DROP DATABASE IF EXISTS vegbank2;
DROP DATABASE
doumok=# CREATE ROLE vegbank WITH LOGIN PASSWORD 'vegbank';
doumok=# CREATE DATABASE vegbank2
WITH
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8';
CREATE DATABASE
doumok=# GRANT ALL PRIVILEGES ON DATABASE vegbank TO vegbank;
doumok=#
\q
doumok@Dou-NCEAS-MBP14 ~ % flyway -target=1.11 migrate
A more recent version of Flyway is available. Find out more about Flyway 10.17.2 at https://rd.gt/3rXiSlV

Flyway Community Edition 10.17.0 by Redgate

See release notes here: https://rd.gt/416ObMi
Database: jdbc:postgresql://localhost:5432/vegbank2 (PostgreSQL 10.23)
Schema history table "public"."flyway_schema_history" does not exist yet
Successfully validated 13 migrations (execution time 00:00.071s)
Creating Schema History table "public"."flyway_schema_history" ...
Current version of schema "public": << Empty Schema >>
Migrating schema "public" to version "1.0 - vegbank"
Migrating schema "public" to version "1.1 - create aggregrates"
Migrating schema "public" to version "1.2 - create extras"
Migrating schema "public" to version "1.3 - create indices"
DB: index "plantusage_plantname_x" does not exist, skipping
DB: index "plantusage_plantname_id_x" does not exist, skipping
DB: index "plantusage_plantconcept_id_x" does not exist, skipping
DB: index "plantusage_classsystem_x" does not exist, skipping
DB: index "plantusage_party_id_x" does not exist, skipping
DB: index "plantusage_plantstatus_id_x" does not exist, skipping
DB: index "plantname_plantname_x" does not exist, skipping
DB: index "plantname_reference_id_x" does not exist, skipping
DB: index "plantconcept_plantname_id_x" does not exist, skipping
DB: index "plantconcept_reference_id_x" does not exist, skipping
DB: index "plantconcept_dobscount_x" does not exist, skipping
DB: index "plantstatus_plantlevel_x" does not exist, skipping
DB: index "plantstatus_plantconcept_id_x" does not exist, skipping
DB: index "plantstatus_reference_id_x" does not exist, skipping
DB: index "plantstatus_plantparent_id_x" does not exist, skipping
DB: index "plantstatus_party_id_x" does not exist, skipping
DB: index "userregionalexp_usercertification_id_x" does not exist, skipping
DB: index "userdatasetitem_userdataset_id_x" does not exist, skipping
DB: index "userdataset_usr_id_x" does not exist, skipping
DB: index "usernotify_usr_id_x" does not exist, skipping
DB: index "embargo_plot_id_x" does not exist, skipping
DB: index "userpermission_embargo_id_x" does not exist, skipping
DB: index "userpermission_usr_id_x" does not exist, skipping
DB: index "userquery_usr_id_x" does not exist, skipping
DB: index "userpreference_usr_id_x" does not exist, skipping
DB: index "userrecordowner_usr_id_x" does not exist, skipping
DB: index "usr_party_id_x" does not exist, skipping
DB: index "covermethod_reference_id_x" does not exist, skipping
DB: index "stratummethod_reference_id_x" does not exist, skipping
DB: index "usercertification_usr_id_x" does not exist, skipping
DB: index "stratum_observation_id_x" does not exist, skipping
DB: index "stratum_stratumtype_id_x" does not exist, skipping
DB: index "stratum_stratummethod_id_x" does not exist, skipping
DB: index "stemlocation_stemcount_id_x" does not exist, skipping
DB: index "observation_previousobs_id_x" does not exist, skipping
DB: index "observation_plot_id_x" does not exist, skipping
DB: index "observation_project_id_x" does not exist, skipping
DB: index "observation_covermethod_id_x" does not exist, skipping
DB: index "observation_stratummethod_id_x" does not exist, skipping
DB: index "observation_soiltaxon_id_x" does not exist, skipping
DB: index "taxonobservation_observation_id_x" does not exist, skipping
DB: index "taxonobservation_reference_id_x" does not exist, skipping
DB: index "reference_referencejournal_id_x" does not exist, skipping
DB: index "taxoninterpretation_taxonobservation_id_x" does not exist, skipping
DB: index "taxoninterpretation_stemlocation_id_x" does not exist, skipping
DB: index "taxoninterpretation_plantconcept_id_x" does not exist, skipping
DB: index "taxoninterpretation_plantname_id_x" does not exist, skipping
DB: index "taxoninterpretation_party_id_x" does not exist, skipping
DB: index "taxoninterpretation_role_id_x" does not exist, skipping
DB: index "taxoninterpretation_reference_id_x" does not exist, skipping
DB: index "taxoninterpretation_collector_id_x" does not exist, skipping
DB: index "taxoninterpretation_museum_id_x" does not exist, skipping
DB: index "taxonalt_taxoninterpretation_id_x" does not exist, skipping
DB: index "taxonalt_plantconcept_id_x" does not exist, skipping
DB: index "telephone_party_id_x" does not exist, skipping
DB: index "plot_reference_id_x" does not exist, skipping
DB: index "plot_parent_id_x" does not exist, skipping
DB: index "party_currentname_id_x" does not exist, skipping
DB: index "place_plot_id_x" does not exist, skipping
DB: index "place_namedplace_id_x" does not exist, skipping
DB: index "namedplace_reference_id_x" does not exist, skipping
DB: index "projectcontributor_project_id_x" does not exist, skipping
DB: index "projectcontributor_party_id_x" does not exist, skipping
DB: index "projectcontributor_role_id_x" does not exist, skipping
DB: index "revision_previousrevision_id_x" does not exist, skipping
DB: index "soilobs_observation_id_x" does not exist, skipping
DB: index "soiltaxon_soilparent_id_x" does not exist, skipping
DB: index "stemcount_taxonimportance_id_x" does not exist, skipping
DB: index "stratumtype_stratummethod_id_x" does not exist, skipping
DB: index "taxonimportance_taxonobservation_id_x" does not exist, skipping
DB: index "taxonimportance_stratum_id_x" does not exist, skipping
DB: index "observationcontributor_observation_id_x" does not exist, skipping
DB: index "observationcontributor_party_id_x" does not exist, skipping
DB: index "observationcontributor_role_id_x" does not exist, skipping
DB: index "observationsynonym_synonymobservation_id_x" does not exist, skipping
DB: index "observationsynonym_primaryobservation_id_x" does not exist, skipping
DB: index "observationsynonym_party_id_x" does not exist, skipping
DB: index "observationsynonym_role_id_x" does not exist, skipping
DB: index "partymember_parentparty_id_x" does not exist, skipping
DB: index "partymember_childparty_id_x" does not exist, skipping
DB: index "partymember_role_id_x" does not exist, skipping
DB: index "referenceparty_currentparty_id_x" does not exist, skipping
DB: index "classcontributor_commclass_id_x" does not exist, skipping
DB: index "classcontributor_party_id_x" does not exist, skipping
DB: index "classcontributor_role_id_x" does not exist, skipping
DB: index "commclass_observation_id_x" does not exist, skipping
DB: index "commclass_classpublication_id_x" does not exist, skipping
DB: index "commconcept_commname_id_x" does not exist, skipping
DB: index "commconcept_reference_id_x" does not exist, skipping
DB: index "commconcept_dobscount_x" does not exist, skipping
DB: index "comminterpretation_commclass_id_x" does not exist, skipping
DB: index "comminterpretation_commconcept_id_x" does not exist, skipping
DB: index "comminterpretation_commauthority_id_x" does not exist, skipping
DB: index "coverindex_covermethod_id_x" does not exist, skipping
DB: index "definedvalue_userdefined_id_x" does not exist, skipping
DB: index "disturbanceobs_observation_id_x" does not exist, skipping
DB: index "graphic_observation_id_x" does not exist, skipping
DB: index "note_notelink_id_x" does not exist, skipping
DB: index "note_party_id_x" does not exist, skipping
DB: index "note_role_id_x" does not exist, skipping
DB: index "plantlineage_childplantstatus_id_x" does not exist, skipping
DB: index "plantlineage_parentplantstatus_id_x" does not exist, skipping
DB: index "address_party_id_x" does not exist, skipping
DB: index "address_organization_id_x" does not exist, skipping
DB: index "referencealtident_reference_id_x" does not exist, skipping
DB: index "referencecontributor_reference_id_x" does not exist, skipping
DB: index "referencecontributor_referenceparty_id_x" does not exist, skipping
DB: index "commcorrelation_commstatus_id_x" does not exist, skipping
DB: index "commcorrelation_commconcept_id_x" does not exist, skipping
DB: index "commlineage_parentcommstatus_id_x" does not exist, skipping
DB: index "commlineage_childcommstatus_id_x" does not exist, skipping
DB: index "commname_reference_id_x" does not exist, skipping
DB: index "commusage_commname_id_x" does not exist, skipping
DB: index "commusage_commconcept_id_x" does not exist, skipping
DB: index "commusage_party_id_x" does not exist, skipping
DB: index "commusage_commstatus_id_x" does not exist, skipping
DB: index "commusage_commname_x" does not exist, skipping
DB: index "commusage_classsystem_x" does not exist, skipping
DB: index "commstatus_commconcept_id_x" does not exist, skipping
DB: index "commstatus_reference_id_x" does not exist, skipping
DB: index "commstatus_commparent_id_x" does not exist, skipping
DB: index "commstatus_party_id_x" does not exist, skipping
DB: index "commstatus_commlevel_x" does not exist, skipping
DB: index "plantcorrelation_plantstatus_id_x" does not exist, skipping
DB: index "plantcorrelation_plantconcept_id_x" does not exist, skipping
DB: index "keywords_table_id_entity_key" does not exist, skipping
DB: index "emb_classcontributor_idx" does not exist, skipping
DB: index "emb_commclass_idx" does not exist, skipping
DB: index "emb_comminterpretation_idx" does not exist, skipping
DB: index "emb_disturbanceobs_idx" does not exist, skipping
DB: index "emb_observation_idx" does not exist, skipping
DB: index "emb_plot_idx" does not exist, skipping
DB: index "emb_soilobs_idx" does not exist, skipping
DB: index "emb_stemcount_idx" does not exist, skipping
DB: index "emb_stemlocation_idx" does not exist, skipping
DB: index "emb_taxonalt_idx" does not exist, skipping
DB: index "emb_taxonimportance_idx" does not exist, skipping
DB: index "emb_taxoninterpretation_idx" does not exist, skipping
DB: index "emb_taxonobservation_idx" does not exist, skipping
DB: index "taxonobservation_int_origplantconcept_id_x" does not exist, skipping
DB: index "taxonobservation_int_currplantconcept_id_x" does not exist, skipping
DB: index "userdatasetitem_accessioncode_index" does not exist, skipping
DB: index "userdatasetitem2_accessioncode_index" does not exist, skipping
DB: index "reference_accessioncode_index" does not exist, skipping
DB: index "referenceparty_accessioncode_index" does not exist, skipping
DB: index "referencejournal_accessioncode_index" does not exist, skipping
DB: index "commclass_accessioncode_index" does not exist, skipping
DB: index "covermethod_accessioncode_index" does not exist, skipping
DB: index "namedplace_accessioncode_index" does not exist, skipping
DB: index "observation_accessioncode_index" does not exist, skipping
DB: index "party_accessioncode_index" does not exist, skipping
DB: index "plot_accessioncode_index" does not exist, skipping
DB: index "project_accessioncode_index" does not exist, skipping
DB: index "soiltaxon_accessioncode_index" does not exist, skipping
DB: index "stratummethod_accessioncode_index" does not exist, skipping
DB: index "taxonobservation_accessioncode_index" does not exist, skipping
DB: index "userdefined_accessioncode_index" does not exist, skipping
DB: index "userdataset_accessioncode_index" does not exist, skipping
DB: index "userquery_accessioncode_index" does not exist, skipping
DB: index "commconcept_accessioncode_index" does not exist, skipping
DB: index "plantconcept_accessioncode_index" does not exist, skipping
DB: index "aux_role_accessioncode_index" does not exist, skipping
DB: index "taxoninterpretation_accessioncode_index" does not exist, skipping
DB: index "observationsynonym_accessioncode_index" does not exist, skipping
DB: index "note_accessioncode_index" does not exist, skipping
DB: index "graphic_accessioncode_index" does not exist, skipping
DB: index "plantstatus_accessioncode_index" does not exist, skipping
DB: index "commstatus_accessioncode_index" does not exist, skipping
Migrating schema "public" to version "1.4 - drop vegbank views"
DB: view "view_busrule_plotsizeshape" does not exist, skipping
DB: view "view_busrule_duplstratumtype" does not exist, skipping
DB: view "view_busrule_duplcovercode" does not exist, skipping
DB: view "view_emb_embargo_complete" does not exist, skipping
DB: view "view_emb_embargo_currentfullonly" does not exist, skipping
DB: view "view_export_classcontributor" does not exist, skipping
DB: view "view_export_commclass" does not exist, skipping
DB: view "view_export_comminterpretation" does not exist, skipping
DB: view "view_export_disturbanceobs" does not exist, skipping
DB: view "view_export_observation" does not exist, skipping
DB: view "view_export_observationcontributor" does not exist, skipping
DB: view "view_export_plot" does not exist, skipping
DB: view "view_export_plot_pre" does not exist, skipping
DB: view "view_export_soilobs" does not exist, skipping
DB: view "view_export_stemcount" does not exist, skipping
DB: view "view_export_stemlocation" does not exist, skipping
DB: view "view_export_taxonalt" does not exist, skipping
DB: view "view_export_taxonimportance" does not exist, skipping
DB: view "view_export_taxoninterpretation" does not exist, skipping
DB: view "view_export_taxonobservation" does not exist, skipping
DB: view "view_dbafielddesc_notimpl" does not exist, skipping
DB: view "view_plotall_withembargo" does not exist, skipping
DB: view "view_taxonobs_distinctid_curr_counts_plants" does not exist, skipping
DB: view "view_taxonobs_distinctid_curr_counts" does not exist, skipping
DB: view "view_taxonobs_distinctid_curr" does not exist, skipping
DB: view "view_taxonobs_withmaxcover" does not exist, skipping
DB: view "view_csv_taxonimportance" does not exist, skipping
DB: view "view_csv_taxonimportance_pre" does not exist, skipping
DB: view "view_browseparty_all_count_combined" does not exist, skipping
DB: view "view_browseparty_classcontrib_count" does not exist, skipping
DB: view "view_browseparty_obscontrib_count" does not exist, skipping
DB: view "view_browseparty_projectcontrib_count" does not exist, skipping
DB: view "view_browseparty_all_count" does not exist, skipping
DB: view "view_browseparty_all" does not exist, skipping
DB: view "view_browseparty_obscontrib" does not exist, skipping
DB: view "view_browseparty_classcontrib" does not exist, skipping
DB: view "view_browseparty_projectcontrib" does not exist, skipping
DB: view "view_comminterp_more" does not exist, skipping
DB: view "view_taxoninterp_more" does not exist, skipping
DB: view "view_observation_transl" does not exist, skipping
DB: view "view_notemb_classcontributor" does not exist, skipping
DB: view "view_notemb_comminterpretation" does not exist, skipping
DB: view "view_notemb_commclass" does not exist, skipping
DB: view "view_notemb_disturbanceobs" does not exist, skipping
DB: view "view_notemb_soilobs" does not exist, skipping
DB: view "view_notemb_stemcount" does not exist, skipping
DB: view "view_notemb_stemlocation" does not exist, skipping
DB: view "view_notemb_taxonalt" does not exist, skipping
DB: view "view_notemb_taxonimportance" does not exist, skipping
DB: view "view_notemb_taxoninterpretation" does not exist, skipping
DB: view "view_notemb_taxonobservation" does not exist, skipping
DB: view "view_notemb_observation" does not exist, skipping
DB: view "view_notemb_observationcontributor" does not exist, skipping
DB: view "view_notemb_plot" does not exist, skipping
DB: view "view_plantconcept_transl" does not exist, skipping
DB: view "view_commconcept_transl" does not exist, skipping
DB: view "view_reference_transl" does not exist, skipping
DB: view "view_party_transl" does not exist, skipping
DB: view "view_party_public" does not exist, skipping
DB: view "view_keywprojplaces" does not exist, skipping
DB: view "view_kwhelper_projcontrib" does not exist, skipping
DB: view "view_kwhelper_refparty" does not exist, skipping
DB: view "view_kwhelper_refjournal" does not exist, skipping
DB: view "view_all_commnames_code" does not exist, skipping
DB: view "view_all_commnames_sciname" does not exist, skipping
DB: view "view_all_commnames_translated" does not exist, skipping
DB: view "view_all_commnames_common" does not exist, skipping
DB: view "view_std_commnames_code" does not exist, skipping
DB: view "view_std_commnames_sciname" does not exist, skipping
DB: view "view_std_commnames_translated" does not exist, skipping
DB: view "view_std_commnames_common" does not exist, skipping
DB: view "view_all_plantnames_code" does not exist, skipping
DB: view "view_all_plantnames_common" does not exist, skipping
DB: view "view_all_plantnames_sciname" does not exist, skipping
DB: view "view_all_plantnames_scinamenoauth" does not exist, skipping
DB: view "view_std_plantnames_code" does not exist, skipping
DB: view "view_std_plantnames_common" does not exist, skipping
DB: view "view_std_plantnames_sciname" does not exist, skipping
DB: view "view_std_plantnames_scinamenoauth" does not exist, skipping
Migrating schema "public" to version "1.5 - create vegbank views"
DB: view "view_busrule_plotsizeshape" does not exist, skipping
DB: view "view_busrule_duplstratumtype" does not exist, skipping
DB: view "view_busrule_duplcovercode" does not exist, skipping
DB: view "view_emb_embargo_complete" does not exist, skipping
DB: view "view_emb_embargo_currentfullonly" does not exist, skipping
DB: view "view_std_plantnames_code" does not exist, skipping
DB: view "view_std_plantnames_sciname" does not exist, skipping
DB: view "view_std_plantnames_scinamenoauth" does not exist, skipping
DB: view "view_std_plantnames_common" does not exist, skipping
DB: view "view_all_plantnames_code" does not exist, skipping
DB: view "view_all_plantnames_sciname" does not exist, skipping
DB: view "view_all_plantnames_scinamenoauth" does not exist, skipping
DB: view "view_all_plantnames_common" does not exist, skipping
DB: view "view_std_commnames_code" does not exist, skipping
DB: view "view_std_commnames_sciname" does not exist, skipping
DB: view "view_std_commnames_translated" does not exist, skipping
DB: view "view_std_commnames_common" does not exist, skipping
DB: view "view_all_commnames_code" does not exist, skipping
DB: view "view_all_commnames_sciname" does not exist, skipping
DB: view "view_all_commnames_translated" does not exist, skipping
DB: view "view_all_commnames_common" does not exist, skipping
Migrating schema "public" to version "1.6 - vegbank populate configtables"
Migrating schema "public" to version "1.7 - create temp tbls"
Migrating schema "public" to version "1.8 - drop vegbank views"
Migrating schema "public" to version "1.9 - create vegbank views"
DB: view "view_busrule_plotsizeshape" does not exist, skipping
DB: view "view_busrule_duplstratumtype" does not exist, skipping
DB: view "view_busrule_duplcovercode" does not exist, skipping
DB: view "view_emb_embargo_complete" does not exist, skipping
DB: view "view_emb_embargo_currentfullonly" does not exist, skipping
DB: view "view_std_plantnames_code" does not exist, skipping
DB: view "view_std_plantnames_sciname" does not exist, skipping
DB: view "view_std_plantnames_scinamenoauth" does not exist, skipping
DB: view "view_std_plantnames_common" does not exist, skipping
DB: view "view_all_plantnames_code" does not exist, skipping
DB: view "view_all_plantnames_sciname" does not exist, skipping
DB: view "view_all_plantnames_scinamenoauth" does not exist, skipping
DB: view "view_all_plantnames_common" does not exist, skipping
DB: view "view_std_commnames_code" does not exist, skipping
DB: view "view_std_commnames_sciname" does not exist, skipping
DB: view "view_std_commnames_translated" does not exist, skipping
DB: view "view_std_commnames_common" does not exist, skipping
DB: view "view_all_commnames_code" does not exist, skipping
DB: view "view_all_commnames_sciname" does not exist, skipping
DB: view "view_all_commnames_translated" does not exist, skipping
DB: view "view_all_commnames_common" does not exist, skipping
Migrating schema "public" to version "1.10 - create admin user"
Migrating schema "public" to version "1.11 - populate datadictionary"
Successfully applied 12 migrations to schema "public", now at version v1.11 (execution time 00:00.907s)

You are not signed in to Flyway, to sign in please run auth
doumok@Dou-NCEAS-MBP14 ~ % psql -U doumok -d vegbank2 -f /Users/doumok/Code/testing/vegbank_dataonly_20240814.sql > /Users/doumok/Code/testing/vegbank2_psql_output_hydrologicregime_update.txt 2>&1

doumok@Dou-NCEAS-MBP14 ~ % flyway migrate
A more recent version of Flyway is available. Find out more about Flyway 10.17.2 at https://rd.gt/3rXiSlV

Flyway Community Edition 10.17.0 by Redgate

See release notes here: https://rd.gt/416ObMi
Database: jdbc:postgresql://localhost:5432/vegbank2 (PostgreSQL 10.23)
Successfully validated 13 migrations (execution time 00:00.111s)
Current version of schema "public": 1.11
Migrating schema "public" to version "1.12 - add constraints"
Successfully applied 1 migration to schema "public", now at version v1.12 (execution time 00:14.342s)

You are not signed in to Flyway, to sign in please run auth
```