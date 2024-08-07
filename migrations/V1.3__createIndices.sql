
-- Create indexes for vegbank.  drops them before adding them.
-- The db needs to be vacummed and analyzed before any impact .e.g. "vacuumdb -z -f vegbank" 
-- Those commented with a -- t mean that they are tested and work in our favor

-- plantusage

DROP INDEX  plantusage_plantname_x ;
CREATE INDEX plantusage_plantname_x on plantusage ( plantname ); -- t
DROP INDEX  plantusage_plantname_id_x ;
CREATE INDEX plantusage_plantname_id_x on plantusage ( plantname_id ); -- t
DROP INDEX  plantusage_plantconcept_id_x ;
CREATE INDEX plantusage_plantconcept_id_x on plantusage ( plantconcept_id ); -- t
DROP INDEX  plantusage_classsystem_x ;
CREATE INDEX plantusage_classsystem_x on plantusage ( classsystem ); -- t
DROP INDEX  plantusage_party_id_x ;
CREATE INDEX plantusage_party_id_x ON plantusage (party_id);
DROP INDEX  plantusage_plantstatus_id_x ;
CREATE INDEX plantusage_plantstatus_id_x ON plantusage (plantstatus_id);

-- plantname
DROP INDEX  plantname_plantname_x ;
CREATE INDEX plantname_plantname_x on plantname ( plantname ); -- t
DROP INDEX  plantname_reference_id_x ;
CREATE INDEX plantname_reference_id_x ON plantname (reference_id);

-- plantconcept
DROP INDEX  plantconcept_plantname_id_x ;
CREATE INDEX plantconcept_plantname_id_x on plantconcept ( plantname_id ); -- t
DROP INDEX  plantconcept_reference_id_x ;
CREATE INDEX plantconcept_reference_id_x ON plantconcept (reference_id);

DROP INDEX  plantconcept_dobscount_x ;
CREATE INDEX plantconcept_dobscount_x ON plantconcept (d_obscount);


-- plantstatus
DROP INDEX  plantstatus_plantlevel_x ;
CREATE INDEX plantstatus_plantlevel_x ON plantstatus (plantlevel); -- t
DROP INDEX  plantstatus_plantconcept_id_x ;
CREATE INDEX plantstatus_plantconcept_id_x ON plantstatus (plantconcept_id); -- t
DROP INDEX  plantstatus_reference_id_x ;
CREATE INDEX plantstatus_reference_id_x ON plantstatus (reference_id);
DROP INDEX  plantstatus_plantparent_id_x ;
CREATE INDEX plantstatus_plantparent_id_x ON plantstatus (plantparent_id);
DROP INDEX  plantstatus_party_id_x ;
CREATE INDEX plantstatus_party_id_x ON plantstatus (party_id);

-- userregionalexp 
DROP INDEX  userregionalexp_usercertification_id_x ;
CREATE INDEX userregionalexp_usercertification_id_x ON userregionalexp (usercertification_id);

-- userdatasetitem 
DROP INDEX  userdatasetitem_userdataset_id_x ;
CREATE INDEX userdatasetitem_userdataset_id_x ON userdatasetitem (userdataset_id);

-- userdataset 
DROP INDEX  userdataset_usr_id_x ;
CREATE INDEX userdataset_usr_id_x ON userdataset (usr_id);

-- usernotify 
DROP INDEX  usernotify_usr_id_x ;
CREATE INDEX usernotify_usr_id_x ON usernotify (usr_id);

-- embargo 
DROP INDEX  embargo_plot_id_x ;
CREATE INDEX embargo_plot_id_x ON embargo (plot_id);

-- userpermission 
DROP INDEX  userpermission_embargo_id_x ;
CREATE INDEX userpermission_embargo_id_x ON userpermission (embargo_id);
DROP INDEX  userpermission_usr_id_x ;
CREATE INDEX userpermission_usr_id_x ON userpermission (usr_id);

-- userquery 
DROP INDEX  userquery_usr_id_x ;
CREATE INDEX userquery_usr_id_x ON userquery (usr_id);

-- userpreference 
DROP INDEX  userpreference_usr_id_x ;
CREATE INDEX userpreference_usr_id_x ON userpreference (usr_id);

-- userrecordowner 
DROP INDEX  userrecordowner_usr_id_x ;
CREATE INDEX userrecordowner_usr_id_x ON userrecordowner (usr_id);

-- usr 
DROP INDEX  usr_party_id_x ;
CREATE INDEX usr_party_id_x ON usr (party_id);

-- aux_role 

-- covermethod 
DROP INDEX  covermethod_reference_id_x ;
CREATE INDEX covermethod_reference_id_x ON covermethod (reference_id);

-- stratummethod 
DROP INDEX  stratummethod_reference_id_x ;
CREATE INDEX stratummethod_reference_id_x ON stratummethod (reference_id);

-- usercertification 
DROP INDEX  usercertification_usr_id_x ;
CREATE INDEX usercertification_usr_id_x ON usercertification (usr_id);

-- stratum 
DROP INDEX  stratum_observation_id_x ;
CREATE INDEX stratum_observation_id_x ON stratum (observation_id);
DROP INDEX  stratum_stratumtype_id_x ;
CREATE INDEX stratum_stratumtype_id_x ON stratum (stratumtype_id);
DROP INDEX  stratum_stratummethod_id_x ;
CREATE INDEX stratum_stratummethod_id_x ON stratum (stratummethod_id);

-- stemlocation 
DROP INDEX  stemlocation_stemcount_id_x ;
CREATE INDEX stemlocation_stemcount_id_x ON stemlocation (stemcount_id);


-- observation 
DROP INDEX  observation_previousobs_id_x ;
CREATE INDEX observation_previousobs_id_x ON observation (previousobs_id);
DROP INDEX  observation_previousobs_id_x ;
CREATE INDEX observation_previousobs_id_x ON observation (previousobs_id);
DROP INDEX  observation_previousobs_id_x ;
CREATE INDEX observation_previousobs_id_x ON observation (previousobs_id);
DROP INDEX  observation_plot_id_x ;
CREATE INDEX observation_plot_id_x ON observation (plot_id);
DROP INDEX  observation_project_id_x ;
CREATE INDEX observation_project_id_x ON observation (project_id);
DROP INDEX  observation_covermethod_id_x ;
CREATE INDEX observation_covermethod_id_x ON observation (covermethod_id);
DROP INDEX  observation_stratummethod_id_x ;
CREATE INDEX observation_stratummethod_id_x ON observation (stratummethod_id);
DROP INDEX  observation_soiltaxon_id_x ;
CREATE INDEX observation_soiltaxon_id_x ON observation (soiltaxon_id);

-- taxonobservation 
DROP INDEX  taxonobservation_observation_id_x ;
CREATE INDEX taxonobservation_observation_id_x ON taxonobservation (observation_id);
DROP INDEX  taxonobservation_reference_id_x ;
CREATE INDEX taxonobservation_reference_id_x ON taxonobservation (reference_id);

-- reference 
DROP INDEX  reference_referencejournal_id_x ;
CREATE INDEX reference_referencejournal_id_x ON reference (referencejournal_id);

-- taxoninterpretation 
DROP INDEX  taxoninterpretation_taxonobservation_id_x ;
CREATE INDEX taxoninterpretation_taxonobservation_id_x ON taxoninterpretation (taxonobservation_id);
DROP INDEX  taxoninterpretation_stemlocation_id_x ;
CREATE INDEX taxoninterpretation_stemlocation_id_x ON taxoninterpretation (stemlocation_id);
DROP INDEX  taxoninterpretation_plantconcept_id_x ;
CREATE INDEX taxoninterpretation_plantconcept_id_x ON taxoninterpretation (plantconcept_id);
DROP INDEX  taxoninterpretation_plantname_id_x ;
CREATE INDEX taxoninterpretation_plantname_id_x ON taxoninterpretation (plantname_id);
DROP INDEX  taxoninterpretation_party_id_x ;
CREATE INDEX taxoninterpretation_party_id_x ON taxoninterpretation (party_id);
DROP INDEX  taxoninterpretation_role_id_x ;
CREATE INDEX taxoninterpretation_role_id_x ON taxoninterpretation (role_id);
DROP INDEX  taxoninterpretation_reference_id_x ;
CREATE INDEX taxoninterpretation_reference_id_x ON taxoninterpretation (reference_id);
DROP INDEX  taxoninterpretation_collector_id_x ;
CREATE INDEX taxoninterpretation_collector_id_x ON taxoninterpretation (collector_id);
DROP INDEX  taxoninterpretation_museum_id_x ;
CREATE INDEX taxoninterpretation_museum_id_x ON taxoninterpretation (museum_id);

-- taxonalt 
DROP INDEX  taxonalt_taxoninterpretation_id_x ;
CREATE INDEX taxonalt_taxoninterpretation_id_x ON taxonalt (taxoninterpretation_id);
DROP INDEX  taxonalt_plantconcept_id_x ;
CREATE INDEX taxonalt_plantconcept_id_x ON taxonalt (plantconcept_id);


-- telephone 
DROP INDEX  telephone_party_id_x ;
CREATE INDEX telephone_party_id_x ON telephone (party_id);

-- plot 
DROP INDEX  plot_reference_id_x ;
CREATE INDEX plot_reference_id_x ON plot (reference_id);
DROP INDEX  plot_parent_id_x ;
CREATE INDEX plot_parent_id_x ON plot (parent_id);
DROP INDEX  plot_parent_id_x ;
CREATE INDEX plot_parent_id_x ON plot (parent_id);
DROP INDEX  plot_parent_id_x ;
CREATE INDEX plot_parent_id_x ON plot (parent_id);

-- party 
DROP INDEX  party_currentname_id_x ;
CREATE INDEX party_currentname_id_x ON party (currentname_id);
DROP INDEX  party_currentname_id_x ;
CREATE INDEX party_currentname_id_x ON party (currentname_id);
DROP INDEX  party_currentname_id_x ;
CREATE INDEX party_currentname_id_x ON party (currentname_id);

-- place 
DROP INDEX  place_plot_id_x ;
CREATE INDEX place_plot_id_x ON place (plot_id);
DROP INDEX  place_namedplace_id_x ;
CREATE INDEX place_namedplace_id_x ON place (namedplace_id);

-- namedplace 
DROP INDEX  namedplace_reference_id_x ;
CREATE INDEX namedplace_reference_id_x ON namedplace (reference_id);

-- project 

-- projectcontributor 
DROP INDEX  projectcontributor_project_id_x ;
CREATE INDEX projectcontributor_project_id_x ON projectcontributor (project_id);
DROP INDEX  projectcontributor_party_id_x ;
CREATE INDEX projectcontributor_party_id_x ON projectcontributor (party_id);
DROP INDEX  projectcontributor_role_id_x ;
CREATE INDEX projectcontributor_role_id_x ON projectcontributor (role_id);

-- revision 
DROP INDEX  revision_previousrevision_id_x ;
CREATE INDEX revision_previousrevision_id_x ON revision (previousrevision_id);
DROP INDEX  revision_previousrevision_id_x ;
CREATE INDEX revision_previousrevision_id_x ON revision (previousrevision_id);
DROP INDEX  revision_previousrevision_id_x ;
CREATE INDEX revision_previousrevision_id_x ON revision (previousrevision_id);

-- soilobs 
DROP INDEX  soilobs_observation_id_x ;
CREATE INDEX soilobs_observation_id_x ON soilobs (observation_id);

-- soiltaxon 
DROP INDEX  soiltaxon_soilparent_id_x ;
CREATE INDEX soiltaxon_soilparent_id_x ON soiltaxon (soilparent_id);
DROP INDEX  soiltaxon_soilparent_id_x ;
CREATE INDEX soiltaxon_soilparent_id_x ON soiltaxon (soilparent_id);
DROP INDEX  soiltaxon_soilparent_id_x ;
CREATE INDEX soiltaxon_soilparent_id_x ON soiltaxon (soilparent_id);

-- stemcount 
DROP INDEX  stemcount_taxonimportance_id_x ;
CREATE INDEX stemcount_taxonimportance_id_x ON stemcount (taxonimportance_id);

-- stratumtype 
DROP INDEX  stratumtype_stratummethod_id_x ;
CREATE INDEX stratumtype_stratummethod_id_x ON stratumtype (stratummethod_id);

-- taxonimportance 
DROP INDEX  taxonimportance_taxonobservation_id_x ;
CREATE INDEX taxonimportance_taxonobservation_id_x ON taxonimportance (taxonobservation_id);
DROP INDEX  taxonimportance_stratum_id_x ;
CREATE INDEX taxonimportance_stratum_id_x ON taxonimportance (stratum_id);

-- observationcontributor 
DROP INDEX  observationcontributor_observation_id_x ;
CREATE INDEX observationcontributor_observation_id_x ON observationcontributor (observation_id);
DROP INDEX  observationcontributor_party_id_x ;
CREATE INDEX observationcontributor_party_id_x ON observationcontributor (party_id);
DROP INDEX  observationcontributor_role_id_x ;
CREATE INDEX observationcontributor_role_id_x ON observationcontributor (role_id);

-- observationsynonym 
DROP INDEX  observationsynonym_synonymobservation_id_x ;
CREATE INDEX observationsynonym_synonymobservation_id_x ON observationsynonym (synonymobservation_id);
DROP INDEX  observationsynonym_primaryobservation_id_x ;
CREATE INDEX observationsynonym_primaryobservation_id_x ON observationsynonym (primaryobservation_id);
DROP INDEX  observationsynonym_party_id_x ;
CREATE INDEX observationsynonym_party_id_x ON observationsynonym (party_id);
DROP INDEX  observationsynonym_role_id_x ;
CREATE INDEX observationsynonym_role_id_x ON observationsynonym (role_id);

-- partymember 
DROP INDEX  partymember_parentparty_id_x ;
CREATE INDEX partymember_parentparty_id_x ON partymember (parentparty_id);
DROP INDEX  partymember_childparty_id_x ;
CREATE INDEX partymember_childparty_id_x ON partymember (childparty_id);
DROP INDEX  partymember_role_id_x ;
CREATE INDEX partymember_role_id_x ON partymember (role_id);

-- referenceparty 
DROP INDEX  referenceparty_currentparty_id_x ;
CREATE INDEX referenceparty_currentparty_id_x ON referenceparty (currentparty_id);
DROP INDEX  referenceparty_currentparty_id_x ;
CREATE INDEX referenceparty_currentparty_id_x ON referenceparty (currentparty_id);
DROP INDEX  referenceparty_currentparty_id_x ;
CREATE INDEX referenceparty_currentparty_id_x ON referenceparty (currentparty_id);

-- classcontributor 
DROP INDEX  classcontributor_commclass_id_x ;
CREATE INDEX classcontributor_commclass_id_x ON classcontributor (commclass_id);
DROP INDEX  classcontributor_party_id_x ;
CREATE INDEX classcontributor_party_id_x ON classcontributor (party_id);
DROP INDEX  classcontributor_role_id_x ;
CREATE INDEX classcontributor_role_id_x ON classcontributor (role_id);

-- commclass 
DROP INDEX  commclass_observation_id_x ;
CREATE INDEX commclass_observation_id_x ON commclass (observation_id);
DROP INDEX  commclass_classpublication_id_x ;
CREATE INDEX commclass_classpublication_id_x ON commclass (classpublication_id);

-- commconcept 
DROP INDEX  commconcept_commname_id_x ;
CREATE INDEX commconcept_commname_id_x ON commconcept (commname_id);
DROP INDEX  commconcept_reference_id_x ;
CREATE INDEX commconcept_reference_id_x ON commconcept (reference_id);

DROP INDEX  commconcept_dobscount_x ;
CREATE INDEX commconcept_dobscount_x ON commconcept (d_obscount);


-- comminterpretation 
DROP INDEX  comminterpretation_commclass_id_x ;
CREATE INDEX comminterpretation_commclass_id_x ON comminterpretation (commclass_id);
DROP INDEX  comminterpretation_commconcept_id_x ;
CREATE INDEX comminterpretation_commconcept_id_x ON comminterpretation (commconcept_id);
DROP INDEX  comminterpretation_commauthority_id_x ;
CREATE INDEX comminterpretation_commauthority_id_x ON comminterpretation (commauthority_id);

-- coverindex 
DROP INDEX  coverindex_covermethod_id_x ;
CREATE INDEX coverindex_covermethod_id_x ON coverindex (covermethod_id);

-- definedvalue 
DROP INDEX  definedvalue_userdefined_id_x ;
CREATE INDEX definedvalue_userdefined_id_x ON definedvalue (userdefined_id);

-- userdefined 

-- disturbanceobs 
DROP INDEX  disturbanceobs_observation_id_x ;
CREATE INDEX disturbanceobs_observation_id_x ON disturbanceobs (observation_id);

-- graphic 
DROP INDEX  graphic_observation_id_x ;
CREATE INDEX graphic_observation_id_x ON graphic (observation_id);

-- notelink 

-- note 
DROP INDEX  note_notelink_id_x ;
CREATE INDEX note_notelink_id_x ON note (notelink_id);
DROP INDEX  note_party_id_x ;
CREATE INDEX note_party_id_x ON note (party_id);
DROP INDEX  note_role_id_x ;
CREATE INDEX note_role_id_x ON note (role_id);

-- plantlineage 
DROP INDEX  plantlineage_childplantstatus_id_x ;
CREATE INDEX plantlineage_childplantstatus_id_x ON plantlineage (childplantstatus_id);
DROP INDEX  plantlineage_parentplantstatus_id_x ;
CREATE INDEX plantlineage_parentplantstatus_id_x ON plantlineage (parentplantstatus_id);



-- address 
DROP INDEX  address_party_id_x ;
CREATE INDEX address_party_id_x ON address (party_id);
DROP INDEX  address_organization_id_x ;
CREATE INDEX address_organization_id_x ON address (organization_id);

-- referencejournal 

-- referencealtident 
DROP INDEX  referencealtident_reference_id_x ;
CREATE INDEX referencealtident_reference_id_x ON referencealtident (reference_id);

-- referencecontributor 
DROP INDEX  referencecontributor_reference_id_x ;
CREATE INDEX referencecontributor_reference_id_x ON referencecontributor (reference_id);
DROP INDEX  referencecontributor_referenceparty_id_x ;
CREATE INDEX referencecontributor_referenceparty_id_x ON referencecontributor (referenceparty_id);

-- commcorrelation 
DROP INDEX  commcorrelation_commstatus_id_x ;
CREATE INDEX commcorrelation_commstatus_id_x ON commcorrelation (commstatus_id);
DROP INDEX  commcorrelation_commconcept_id_x ;
CREATE INDEX commcorrelation_commconcept_id_x ON commcorrelation (commconcept_id);

-- commlineage 
DROP INDEX  commlineage_parentcommstatus_id_x ;
CREATE INDEX commlineage_parentcommstatus_id_x ON commlineage (parentcommstatus_id);
DROP INDEX  commlineage_childcommstatus_id_x ;
CREATE INDEX commlineage_childcommstatus_id_x ON commlineage (childcommstatus_id);

-- commname 
DROP INDEX  commname_reference_id_x ;
CREATE INDEX commname_reference_id_x ON commname (reference_id);

-- commusage 
DROP INDEX  commusage_commname_id_x ;
CREATE INDEX commusage_commname_id_x ON commusage (commname_id);
DROP INDEX  commusage_commconcept_id_x ;
CREATE INDEX commusage_commconcept_id_x ON commusage (commconcept_id);
DROP INDEX  commusage_party_id_x ;
CREATE INDEX commusage_party_id_x ON commusage (party_id);
DROP INDEX  commusage_commstatus_id_x ;
CREATE INDEX commusage_commstatus_id_x ON commusage (commstatus_id);
DROP INDEX  commusage_commname_x ;
CREATE INDEX commusage_commname_x on commusage ( commname ); -- t
DROP INDEX  commusage_classsystem_x ;
CREATE INDEX commusage_classsystem_x on commusage ( classsystem ); -- t

-- commstatus 
DROP INDEX  commstatus_commconcept_id_x ;
CREATE INDEX commstatus_commconcept_id_x ON commstatus (commconcept_id);
DROP INDEX  commstatus_reference_id_x ;
CREATE INDEX commstatus_reference_id_x ON commstatus (reference_id);
DROP INDEX  commstatus_commparent_id_x ;
CREATE INDEX commstatus_commparent_id_x ON commstatus (commparent_id);
DROP INDEX  commstatus_party_id_x ;
CREATE INDEX commstatus_party_id_x ON commstatus (party_id);
DROP INDEX  commstatus_commlevel_x ;
CREATE INDEX commstatus_commlevel_x ON commstatus (commlevel); -- t

-- plantcorrelation 
DROP INDEX  plantcorrelation_plantstatus_id_x ;
CREATE INDEX plantcorrelation_plantstatus_id_x ON plantcorrelation (plantstatus_id);
DROP INDEX  plantcorrelation_plantconcept_id_x ;
CREATE INDEX plantcorrelation_plantconcept_id_x ON plantcorrelation (plantconcept_id);

-- keywords
DROP INDEX  keywords_table_id_entity_key ;
CREATE INDEX keywords_table_id_entity_key ON keywords (table_id,entity);

--embargo denorm fields
DROP INDEX  emb_classContributor_idx ;
CREATE INDEX emb_classContributor_idx ON classContributor (emb_classContributor);
DROP INDEX  emb_commClass_idx ;
CREATE INDEX emb_commClass_idx ON commClass (emb_commClass);
DROP INDEX  emb_commInterpretation_idx ;
CREATE INDEX emb_commInterpretation_idx ON commInterpretation (emb_commInterpretation);
DROP INDEX  emb_disturbanceObs_idx ;
CREATE INDEX emb_disturbanceObs_idx ON disturbanceObs (emb_disturbanceObs);
DROP INDEX  emb_observation_idx ;
CREATE INDEX emb_observation_idx ON observation (emb_observation);
DROP INDEX  emb_plot_idx ;
CREATE INDEX emb_plot_idx ON plot (emb_plot);
DROP INDEX  emb_soilObs_idx ;
CREATE INDEX emb_soilObs_idx ON soilObs (emb_soilObs);
DROP INDEX  emb_stemCount_idx ;
CREATE INDEX emb_stemCount_idx ON stemCount (emb_stemCount);
DROP INDEX  emb_stemLocation_idx ;
CREATE INDEX emb_stemLocation_idx ON stemLocation (emb_stemLocation);
DROP INDEX  emb_taxonAlt_idx ;
CREATE INDEX emb_taxonAlt_idx ON taxonAlt (emb_taxonAlt);
DROP INDEX  emb_taxonImportance_idx ;
CREATE INDEX emb_taxonImportance_idx ON taxonImportance (emb_taxonImportance);
DROP INDEX  emb_taxonInterpretation_idx ;
CREATE INDEX emb_taxonInterpretation_idx ON taxonInterpretation (emb_taxonInterpretation);
DROP INDEX  emb_taxonObservation_idx ;
CREATE INDEX emb_taxonObservation_idx ON taxonObservation (emb_taxonObservation);

--taxonobservation ID fields:
DROP INDEX  taxonobservation_int_origPlantConcept_ID_x ;
CREATE INDEX taxonobservation_int_origPlantConcept_ID_x on taxonobservation ( int_origPlantConcept_ID );

DROP INDEX  taxonobservation_int_currPlantConcept_ID_x ;
CREATE INDEX taxonobservation_int_currPlantConcept_ID_x on taxonobservation ( int_currPlantConcept_ID );

--accessionCode indices:
-- non unique (reference accession codes)
drop index userDatasetItem_accessioncode_index;
create  index userDatasetItem_accessioncode_index on userDatasetItem (itemAccessionCode);
drop index userDatasetItem2_accessioncode_index;
create  index userDatasetItem2_accessioncode_index on userDatasetItem (externalAccessionCode);

--unique indexes:

drop index reference_accessioncode_index;
create unique index reference_accessioncode_index on reference (accessionCode);
drop index referenceParty_accessioncode_index;
create unique index referenceParty_accessioncode_index on referenceParty (accessionCode);
drop index referenceJournal_accessioncode_index;
create unique index referenceJournal_accessioncode_index on referenceJournal (accessionCode);
drop index commclass_accessioncode_index;
create unique index commclass_accessioncode_index on commClass (accessionCode);
drop index coverMethod_accessioncode_index;
create unique index coverMethod_accessioncode_index on coverMethod (accessionCode);
drop index namedPlace_accessioncode_index;
create unique index namedPlace_accessioncode_index on namedPlace (accessionCode);
drop index observation_accessioncode_index;
create unique index observation_accessioncode_index on observation (accessionCode);
drop index party_accessioncode_index;
create unique index party_accessioncode_index on party (accessionCode);
drop index plot_accessioncode_index;
create unique index plot_accessioncode_index on plot (accessionCode);
drop index project_accessioncode_index;
create unique index project_accessioncode_index on project (accessionCode);
drop index soilTaxon_accessioncode_index;
create unique index soilTaxon_accessioncode_index on soilTaxon (accessionCode);
drop index stratumMethod_accessioncode_index;
create unique index stratumMethod_accessioncode_index on stratumMethod (accessionCode);
drop index taxonObservation_accessioncode_index;
create unique index taxonObservation_accessioncode_index on taxonObservation (accessionCode);
drop index userDefined_accessioncode_index;
create unique index userDefined_accessioncode_index on userDefined (accessioncode);
drop index userDataset_accessioncode_index;
create unique index userDataset_accessioncode_index on userDataset (accessioncode);

drop index userQuery_accessioncode_index;
create unique index userQuery_accessioncode_index on userQuery (accessioncode);
drop index commConcept_accessioncode_index;
create unique index commConcept_accessioncode_index on commConcept (accessioncode);
drop index plantConcept_accessioncode_index;
create unique index plantConcept_accessioncode_index on plantConcept (accessioncode);
drop index aux_Role_accessioncode_index;
create unique index aux_Role_accessioncode_index on aux_Role (accessioncode);

drop index taxonInterpretation_accessioncode_index;
create unique index taxonInterpretation_accessioncode_index on taxonInterpretation (accessioncode);
drop index observationSynonym_accessioncode_index;
create unique index observationSynonym_accessioncode_index on observationSynonym (accessioncode);
drop index observation_accessioncode_index;
create unique index observation_accessioncode_index on observation (accessioncode);
drop index note_accessioncode_index;
create unique index note_accessioncode_index on note (accessioncode);
drop index graphic_accessioncode_index;
create unique index graphic_accessioncode_index on graphic (accessioncode);
drop index plantStatus_accessioncode_index;
create unique index plantStatus_accessioncode_index on plantStatus (accessioncode);
drop index commStatus_accessioncode_index;
create unique index commStatus_accessioncode_index on commStatus (accessioncode);
