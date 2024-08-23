   
----------------------------------------------------------------------------
-- ALTER commConcept
----------------------------------------------------------------------------
    
    
ALTER TABLE  commConcept
  ADD CONSTRAINT COMMNAME_ID FOREIGN KEY ( COMMNAME_ID )
  REFERENCES  commName (COMMNAME_ID);
    
ALTER TABLE  commConcept
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER commCorrelation
----------------------------------------------------------------------------
    
    
ALTER TABLE  commCorrelation
  ADD CONSTRAINT COMMSTATUS_ID FOREIGN KEY ( COMMSTATUS_ID )
  REFERENCES  commStatus (COMMSTATUS_ID);
    
ALTER TABLE  commCorrelation
  ADD CONSTRAINT COMMCONCEPT_ID FOREIGN KEY ( COMMCONCEPT_ID )
  REFERENCES  commConcept (COMMCONCEPT_ID);
    
----------------------------------------------------------------------------
-- ALTER commLineage
----------------------------------------------------------------------------
    
    
ALTER TABLE  commLineage
  ADD CONSTRAINT parentCommStatus_ID FOREIGN KEY ( parentCommStatus_ID )
  REFERENCES  commStatus (COMMSTATUS_ID);
    
ALTER TABLE  commLineage
  ADD CONSTRAINT childCommStatus_ID FOREIGN KEY ( childCommStatus_ID )
  REFERENCES  commStatus (COMMSTATUS_ID);
    
----------------------------------------------------------------------------
-- ALTER commName
----------------------------------------------------------------------------
    
    
ALTER TABLE  commName
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER commStatus
----------------------------------------------------------------------------
    
    
ALTER TABLE  commStatus
  ADD CONSTRAINT COMMCONCEPT_ID FOREIGN KEY ( COMMCONCEPT_ID )
  REFERENCES  commConcept (COMMCONCEPT_ID);
    
ALTER TABLE  commStatus
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
ALTER TABLE  commStatus
  ADD CONSTRAINT commParent_ID FOREIGN KEY ( commParent_ID )
  REFERENCES  commConcept (COMMCONCEPT_ID);
    
ALTER TABLE  commStatus
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
----------------------------------------------------------------------------
-- ALTER commUsage
----------------------------------------------------------------------------
    
    
ALTER TABLE  commUsage
  ADD CONSTRAINT COMMNAME_ID FOREIGN KEY ( COMMNAME_ID )
  REFERENCES  commName (COMMNAME_ID);
    
ALTER TABLE  commUsage
  ADD CONSTRAINT COMMCONCEPT_ID FOREIGN KEY ( COMMCONCEPT_ID )
  REFERENCES  commConcept (COMMCONCEPT_ID);
    
ALTER TABLE  commUsage
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  commUsage
  ADD CONSTRAINT COMMSTATUS_ID FOREIGN KEY ( COMMSTATUS_ID )
  REFERENCES  commStatus (COMMSTATUS_ID);
    
----------------------------------------------------------------------------
-- ALTER plantConcept
----------------------------------------------------------------------------
    
    
ALTER TABLE  plantConcept
  ADD CONSTRAINT PLANTNAME_ID FOREIGN KEY ( PLANTNAME_ID )
  REFERENCES  plantName (PLANTNAME_ID);
    
ALTER TABLE  plantConcept
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER plantCorrelation
----------------------------------------------------------------------------
    
    
ALTER TABLE  plantCorrelation
  ADD CONSTRAINT PLANTSTATUS_ID FOREIGN KEY ( PLANTSTATUS_ID )
  REFERENCES  plantStatus (PLANTSTATUS_ID);
    
ALTER TABLE  plantCorrelation
  ADD CONSTRAINT PLANTCONCEPT_ID FOREIGN KEY ( PLANTCONCEPT_ID )
  REFERENCES  plantConcept (PLANTCONCEPT_ID);
    
----------------------------------------------------------------------------
-- ALTER plantLineage
----------------------------------------------------------------------------
    
    
ALTER TABLE  plantLineage
  ADD CONSTRAINT childPlantStatus_ID FOREIGN KEY ( childPlantStatus_ID )
  REFERENCES  plantStatus (PLANTSTATUS_ID);
    
ALTER TABLE  plantLineage
  ADD CONSTRAINT parentPlantStatus_ID FOREIGN KEY ( parentPlantStatus_ID )
  REFERENCES  plantStatus (PLANTSTATUS_ID);
    
----------------------------------------------------------------------------
-- ALTER plantName
----------------------------------------------------------------------------
    
    
ALTER TABLE  plantName
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER plantStatus
----------------------------------------------------------------------------
    
    
ALTER TABLE  plantStatus
  ADD CONSTRAINT PLANTCONCEPT_ID FOREIGN KEY ( PLANTCONCEPT_ID )
  REFERENCES  plantConcept (PLANTCONCEPT_ID);
    
ALTER TABLE  plantStatus
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
ALTER TABLE  plantStatus
  ADD CONSTRAINT plantParent_ID FOREIGN KEY ( plantParent_ID )
  REFERENCES  plantConcept (PLANTCONCEPT_ID);
    
ALTER TABLE  plantStatus
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
----------------------------------------------------------------------------
-- ALTER plantUsage
----------------------------------------------------------------------------
    
    
ALTER TABLE  plantUsage
  ADD CONSTRAINT PLANTNAME_ID FOREIGN KEY ( PLANTNAME_ID )
  REFERENCES  plantName (PLANTNAME_ID);
    
ALTER TABLE  plantUsage
  ADD CONSTRAINT PLANTCONCEPT_ID FOREIGN KEY ( PLANTCONCEPT_ID )
  REFERENCES  plantConcept (PLANTCONCEPT_ID);
    
ALTER TABLE  plantUsage
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  plantUsage
  ADD CONSTRAINT PLANTSTATUS_ID FOREIGN KEY ( PLANTSTATUS_ID )
  REFERENCES  plantStatus (PLANTSTATUS_ID);
    
----------------------------------------------------------------------------
-- ALTER address
----------------------------------------------------------------------------
    
    
ALTER TABLE  address
  ADD CONSTRAINT party_ID FOREIGN KEY ( party_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  address
  ADD CONSTRAINT organization_ID FOREIGN KEY ( organization_ID )
  REFERENCES  party (PARTY_ID);
    
----------------------------------------------------------------------------
-- ALTER aux_Role
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER reference
----------------------------------------------------------------------------
    
    
ALTER TABLE  reference
  ADD CONSTRAINT referenceJournal_ID FOREIGN KEY ( referenceJournal_ID )
  REFERENCES  referenceJournal (referenceJournal_ID);
    
----------------------------------------------------------------------------
-- ALTER referenceAltIdent
----------------------------------------------------------------------------
    
    
ALTER TABLE  referenceAltIdent
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER referenceContributor
----------------------------------------------------------------------------
    
    
ALTER TABLE  referenceContributor
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
ALTER TABLE  referenceContributor
  ADD CONSTRAINT referenceParty_ID FOREIGN KEY ( referenceParty_ID )
  REFERENCES  referenceParty (referenceParty_ID);
    
----------------------------------------------------------------------------
-- ALTER referenceParty
----------------------------------------------------------------------------
    
    
ALTER TABLE  referenceParty
  ADD CONSTRAINT currentParty_ID FOREIGN KEY ( currentParty_ID )
  REFERENCES  referenceParty (referenceParty_ID);
    
----------------------------------------------------------------------------
-- ALTER referenceJournal
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER classContributor
----------------------------------------------------------------------------
    
    
ALTER TABLE  classContributor
  ADD CONSTRAINT COMMCLASS_ID FOREIGN KEY ( COMMCLASS_ID )
  REFERENCES  commClass (COMMCLASS_ID);
    
ALTER TABLE  classContributor
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  classContributor
  ADD CONSTRAINT ROLE_ID FOREIGN KEY ( ROLE_ID )
  REFERENCES  aux_Role (ROLE_ID);
    
----------------------------------------------------------------------------
-- ALTER commClass
----------------------------------------------------------------------------
    
    
ALTER TABLE  commClass
  ADD CONSTRAINT OBSERVATION_ID FOREIGN KEY ( OBSERVATION_ID )
  REFERENCES  observation (OBSERVATION_ID);
    
ALTER TABLE  commClass
  ADD CONSTRAINT classPublication_ID FOREIGN KEY ( classPublication_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER commInterpretation
----------------------------------------------------------------------------
    
    
ALTER TABLE  commInterpretation
  ADD CONSTRAINT COMMCLASS_ID FOREIGN KEY ( COMMCLASS_ID )
  REFERENCES  commClass (COMMCLASS_ID);
    
ALTER TABLE  commInterpretation
  ADD CONSTRAINT COMMCONCEPT_ID FOREIGN KEY ( COMMCONCEPT_ID )
  REFERENCES  commConcept (COMMCONCEPT_ID);
    
ALTER TABLE  commInterpretation
  ADD CONSTRAINT commAuthority_ID FOREIGN KEY ( commAuthority_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER coverIndex
----------------------------------------------------------------------------
    
    
ALTER TABLE  coverIndex
  ADD CONSTRAINT COVERMETHOD_ID FOREIGN KEY ( COVERMETHOD_ID )
  REFERENCES  coverMethod (COVERMETHOD_ID);
    
----------------------------------------------------------------------------
-- ALTER coverMethod
----------------------------------------------------------------------------
    
    
ALTER TABLE  coverMethod
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER definedValue
----------------------------------------------------------------------------
    
    
ALTER TABLE  definedValue
  ADD CONSTRAINT USERDEFINED_ID FOREIGN KEY ( USERDEFINED_ID )
  REFERENCES  userDefined (USERDEFINED_ID);
    
----------------------------------------------------------------------------
-- ALTER disturbanceObs
----------------------------------------------------------------------------
    
    
ALTER TABLE  disturbanceObs
  ADD CONSTRAINT OBSERVATION_ID FOREIGN KEY ( OBSERVATION_ID )
  REFERENCES  observation (OBSERVATION_ID);
    
----------------------------------------------------------------------------
-- ALTER graphic
----------------------------------------------------------------------------
    
    
ALTER TABLE  graphic
  ADD CONSTRAINT OBSERVATION_ID FOREIGN KEY ( OBSERVATION_ID )
  REFERENCES  observation (OBSERVATION_ID);
    
----------------------------------------------------------------------------
-- ALTER namedPlace
----------------------------------------------------------------------------
    
    
ALTER TABLE  namedPlace
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER namedPlaceCorrelation
----------------------------------------------------------------------------
    
    
ALTER TABLE  namedPlaceCorrelation
  ADD CONSTRAINT PARENTPLACE_ID FOREIGN KEY ( PARENTPLACE_ID )
  REFERENCES  namedPlace (NAMEDPLACE_ID);
    
ALTER TABLE  namedPlaceCorrelation
  ADD CONSTRAINT CHILDPLACE_ID FOREIGN KEY ( CHILDPLACE_ID )
  REFERENCES  namedPlace (NAMEDPLACE_ID);
    
----------------------------------------------------------------------------
-- ALTER note
----------------------------------------------------------------------------
    
    
ALTER TABLE  note
  ADD CONSTRAINT NOTELINK_ID FOREIGN KEY ( NOTELINK_ID )
  REFERENCES  noteLink (NOTELINK_ID);
    
ALTER TABLE  note
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  note
  ADD CONSTRAINT ROLE_ID FOREIGN KEY ( ROLE_ID )
  REFERENCES  aux_Role (ROLE_ID);
    
----------------------------------------------------------------------------
-- ALTER noteLink
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER observation
----------------------------------------------------------------------------
    
    
ALTER TABLE  observation
  ADD CONSTRAINT PREVIOUSOBS_ID FOREIGN KEY ( PREVIOUSOBS_ID )
  REFERENCES  observation (OBSERVATION_ID);
    
ALTER TABLE  observation
  ADD CONSTRAINT PLOT_ID FOREIGN KEY ( PLOT_ID )
  REFERENCES  plot (PLOT_ID);
    
ALTER TABLE  observation
  ADD CONSTRAINT PROJECT_ID FOREIGN KEY ( PROJECT_ID )
  REFERENCES  project (PROJECT_ID);
    
ALTER TABLE  observation
  ADD CONSTRAINT COVERMETHOD_ID FOREIGN KEY ( COVERMETHOD_ID )
  REFERENCES  coverMethod (COVERMETHOD_ID);
    
ALTER TABLE  observation
  ADD CONSTRAINT STRATUMMETHOD_ID FOREIGN KEY ( STRATUMMETHOD_ID )
  REFERENCES  stratumMethod (STRATUMMETHOD_ID);
    
ALTER TABLE  observation
  ADD CONSTRAINT SOILTAXON_ID FOREIGN KEY ( SOILTAXON_ID )
  REFERENCES  soilTaxon (SOILTAXON_ID);
    
----------------------------------------------------------------------------
-- ALTER observationContributor
----------------------------------------------------------------------------
    
    
ALTER TABLE  observationContributor
  ADD CONSTRAINT OBSERVATION_ID FOREIGN KEY ( OBSERVATION_ID )
  REFERENCES  observation (OBSERVATION_ID);
    
ALTER TABLE  observationContributor
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  observationContributor
  ADD CONSTRAINT ROLE_ID FOREIGN KEY ( ROLE_ID )
  REFERENCES  aux_Role (ROLE_ID);
    
----------------------------------------------------------------------------
-- ALTER observationSynonym
----------------------------------------------------------------------------
    
    
ALTER TABLE  observationSynonym
  ADD CONSTRAINT synonymObservation_ID FOREIGN KEY ( synonymObservation_ID )
  REFERENCES  observation (OBSERVATION_ID);
    
ALTER TABLE  observationSynonym
  ADD CONSTRAINT primaryObservation_ID FOREIGN KEY ( primaryObservation_ID )
  REFERENCES  observation (OBSERVATION_ID);
    
ALTER TABLE  observationSynonym
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  observationSynonym
  ADD CONSTRAINT ROLE_ID FOREIGN KEY ( ROLE_ID )
  REFERENCES  aux_Role (ROLE_ID);
    
----------------------------------------------------------------------------
-- ALTER party
----------------------------------------------------------------------------
    
    
ALTER TABLE  party
  ADD CONSTRAINT currentName_ID FOREIGN KEY ( currentName_ID )
  REFERENCES  party (PARTY_ID);
    
----------------------------------------------------------------------------
-- ALTER partyMember
----------------------------------------------------------------------------
    
    
ALTER TABLE  partyMember
  ADD CONSTRAINT parentParty_ID FOREIGN KEY ( parentParty_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  partyMember
  ADD CONSTRAINT childParty_ID FOREIGN KEY ( childParty_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  partyMember
  ADD CONSTRAINT role_ID FOREIGN KEY ( role_ID )
  REFERENCES  aux_Role (ROLE_ID);
    
----------------------------------------------------------------------------
-- ALTER place
----------------------------------------------------------------------------
    
    
ALTER TABLE  place
  ADD CONSTRAINT PLOT_ID FOREIGN KEY ( PLOT_ID )
  REFERENCES  plot (PLOT_ID);
    
ALTER TABLE  place
  ADD CONSTRAINT NAMEDPLACE_ID FOREIGN KEY ( NAMEDPLACE_ID )
  REFERENCES  namedPlace (NAMEDPLACE_ID);
    
----------------------------------------------------------------------------
-- ALTER plot
----------------------------------------------------------------------------
    
    
ALTER TABLE  plot
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
ALTER TABLE  plot
  ADD CONSTRAINT PARENT_ID FOREIGN KEY ( PARENT_ID )
  REFERENCES  plot (PLOT_ID);
    
----------------------------------------------------------------------------
-- ALTER project
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER projectContributor
----------------------------------------------------------------------------
    
    
ALTER TABLE  projectContributor
  ADD CONSTRAINT PROJECT_ID FOREIGN KEY ( PROJECT_ID )
  REFERENCES  project (PROJECT_ID);
    
ALTER TABLE  projectContributor
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  projectContributor
  ADD CONSTRAINT ROLE_ID FOREIGN KEY ( ROLE_ID )
  REFERENCES  aux_Role (ROLE_ID);
    
----------------------------------------------------------------------------
-- ALTER revision
----------------------------------------------------------------------------
    
    
ALTER TABLE  revision
  ADD CONSTRAINT previousRevision_ID FOREIGN KEY ( previousRevision_ID )
  REFERENCES  revision (REVISION_ID);
    
----------------------------------------------------------------------------
-- ALTER soilObs
----------------------------------------------------------------------------
    
    
ALTER TABLE  soilObs
  ADD CONSTRAINT OBSERVATION_ID FOREIGN KEY ( OBSERVATION_ID )
  REFERENCES  observation (OBSERVATION_ID);
    
----------------------------------------------------------------------------
-- ALTER soilTaxon
----------------------------------------------------------------------------
    
    
ALTER TABLE  soilTaxon
  ADD CONSTRAINT SOILPARENT_ID FOREIGN KEY ( SOILPARENT_ID )
  REFERENCES  soilTaxon (SOILTAXON_ID);
    
----------------------------------------------------------------------------
-- ALTER stemCount
----------------------------------------------------------------------------
    
    
ALTER TABLE  stemCount
  ADD CONSTRAINT TAXONIMPORTANCE_ID FOREIGN KEY ( TAXONIMPORTANCE_ID )
  REFERENCES  taxonImportance (taxonImportance_ID);
    
----------------------------------------------------------------------------
-- ALTER stemLocation
----------------------------------------------------------------------------
    
    
ALTER TABLE  stemLocation
  ADD CONSTRAINT STEMCOUNT_ID FOREIGN KEY ( STEMCOUNT_ID )
  REFERENCES  stemCount (STEMCOUNT_ID);
    
----------------------------------------------------------------------------
-- ALTER stratum
----------------------------------------------------------------------------
    
    
ALTER TABLE  stratum
  ADD CONSTRAINT OBSERVATION_ID FOREIGN KEY ( OBSERVATION_ID )
  REFERENCES  observation (OBSERVATION_ID);
    
ALTER TABLE  stratum
  ADD CONSTRAINT STRATUMTYPE_ID FOREIGN KEY ( STRATUMTYPE_ID )
  REFERENCES  stratumType (STRATUMTYPE_ID);
    
ALTER TABLE  stratum
  ADD CONSTRAINT STRATUMMETHOD_ID FOREIGN KEY ( STRATUMMETHOD_ID )
  REFERENCES  stratumMethod (STRATUMMETHOD_ID);
    
----------------------------------------------------------------------------
-- ALTER stratumMethod
----------------------------------------------------------------------------
    
    
ALTER TABLE  stratumMethod
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER stratumType
----------------------------------------------------------------------------
    
    
ALTER TABLE  stratumType
  ADD CONSTRAINT STRATUMMETHOD_ID FOREIGN KEY ( STRATUMMETHOD_ID )
  REFERENCES  stratumMethod (STRATUMMETHOD_ID);
    
----------------------------------------------------------------------------
-- ALTER taxonImportance
----------------------------------------------------------------------------
    
    
ALTER TABLE  taxonImportance
  ADD CONSTRAINT taxonObservation_ID FOREIGN KEY ( taxonObservation_ID )
  REFERENCES  taxonObservation (TAXONOBSERVATION_ID);
    
ALTER TABLE  taxonImportance
  ADD CONSTRAINT stratum_ID FOREIGN KEY ( stratum_ID )
  REFERENCES  stratum (STRATUM_ID);
    
----------------------------------------------------------------------------
-- ALTER taxonInterpretation
----------------------------------------------------------------------------
    
    
ALTER TABLE  taxonInterpretation
  ADD CONSTRAINT TAXONOBSERVATION_ID FOREIGN KEY ( TAXONOBSERVATION_ID )
  REFERENCES  taxonObservation (TAXONOBSERVATION_ID);
    
ALTER TABLE  taxonInterpretation
  ADD CONSTRAINT stemLocation_ID FOREIGN KEY ( stemLocation_ID )
  REFERENCES  stemLocation (STEMLOCATION_ID);
    
ALTER TABLE  taxonInterpretation
  ADD CONSTRAINT PLANTCONCEPT_ID FOREIGN KEY ( PLANTCONCEPT_ID )
  REFERENCES  plantConcept (PLANTCONCEPT_ID);
    
ALTER TABLE  taxonInterpretation
  ADD CONSTRAINT PLANTNAME_ID FOREIGN KEY ( PLANTNAME_ID )
  REFERENCES  plantName (PLANTNAME_ID);
    
ALTER TABLE  taxonInterpretation
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  taxonInterpretation
  ADD CONSTRAINT ROLE_ID FOREIGN KEY ( ROLE_ID )
  REFERENCES  aux_Role (ROLE_ID);
    
ALTER TABLE  taxonInterpretation
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
ALTER TABLE  taxonInterpretation
  ADD CONSTRAINT collector_ID FOREIGN KEY ( collector_ID )
  REFERENCES  party (PARTY_ID);
    
ALTER TABLE  taxonInterpretation
  ADD CONSTRAINT museum_ID FOREIGN KEY ( museum_ID )
  REFERENCES  party (PARTY_ID);
    
----------------------------------------------------------------------------
-- ALTER taxonObservation
----------------------------------------------------------------------------
    
    
ALTER TABLE  taxonObservation
  ADD CONSTRAINT OBSERVATION_ID FOREIGN KEY ( OBSERVATION_ID )
  REFERENCES  observation (OBSERVATION_ID);
    
ALTER TABLE  taxonObservation
  ADD CONSTRAINT reference_ID FOREIGN KEY ( reference_ID )
  REFERENCES  reference (reference_ID);
    
----------------------------------------------------------------------------
-- ALTER taxonAlt
----------------------------------------------------------------------------
    
    
ALTER TABLE  taxonAlt
  ADD CONSTRAINT taxonInterpretation_ID FOREIGN KEY ( taxonInterpretation_ID )
  REFERENCES  taxonInterpretation (TAXONINTERPRETATION_ID);
    
ALTER TABLE  taxonAlt
  ADD CONSTRAINT plantConcept_ID FOREIGN KEY ( plantConcept_ID )
  REFERENCES  plantConcept (PLANTCONCEPT_ID);
    
----------------------------------------------------------------------------
-- ALTER telephone
----------------------------------------------------------------------------
    
    
ALTER TABLE  telephone
  ADD CONSTRAINT PARTY_ID FOREIGN KEY ( PARTY_ID )
  REFERENCES  party (PARTY_ID);
    
----------------------------------------------------------------------------
-- ALTER userDefined
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER embargo
----------------------------------------------------------------------------
    
    
ALTER TABLE  embargo
  ADD CONSTRAINT plot_ID FOREIGN KEY ( plot_ID )
  REFERENCES  plot (PLOT_ID);
    
----------------------------------------------------------------------------
-- ALTER usr
----------------------------------------------------------------------------
    
    
ALTER TABLE  usr
  ADD CONSTRAINT party_ID FOREIGN KEY ( party_ID )
  REFERENCES  party (PARTY_ID);
    
----------------------------------------------------------------------------
-- ALTER userCertification
----------------------------------------------------------------------------
    
    
ALTER TABLE  userCertification
  ADD CONSTRAINT usr_ID FOREIGN KEY ( usr_ID )
  REFERENCES  usr (usr_ID);
    
----------------------------------------------------------------------------
-- ALTER userRegionalExp
----------------------------------------------------------------------------
    
    
ALTER TABLE  userRegionalExp
  ADD CONSTRAINT userCertification_ID FOREIGN KEY ( userCertification_ID )
  REFERENCES  userCertification (userCertification_ID);
    
----------------------------------------------------------------------------
-- ALTER userDataset
----------------------------------------------------------------------------
    
    
ALTER TABLE  userDataset
  ADD CONSTRAINT usr_ID FOREIGN KEY ( usr_ID )
  REFERENCES  usr (usr_ID);
    
----------------------------------------------------------------------------
-- ALTER userDatasetItem
----------------------------------------------------------------------------
    
    
ALTER TABLE  userDatasetItem
  ADD CONSTRAINT userDataset_ID FOREIGN KEY ( userDataset_ID )
  REFERENCES  userDataset (userDataset_ID);
    
----------------------------------------------------------------------------
-- ALTER userNotify
----------------------------------------------------------------------------
    
    
ALTER TABLE  userNotify
  ADD CONSTRAINT usr_ID FOREIGN KEY ( usr_ID )
  REFERENCES  usr (usr_ID);
    
----------------------------------------------------------------------------
-- ALTER userPermission
----------------------------------------------------------------------------
    
    
ALTER TABLE  userPermission
  ADD CONSTRAINT embargo_ID FOREIGN KEY ( embargo_ID )
  REFERENCES  embargo (embargo_ID);
    
ALTER TABLE  userPermission
  ADD CONSTRAINT usr_ID FOREIGN KEY ( usr_ID )
  REFERENCES  usr (usr_ID);
    
----------------------------------------------------------------------------
-- ALTER userQuery
----------------------------------------------------------------------------
    
    
ALTER TABLE  userQuery
  ADD CONSTRAINT usr_ID FOREIGN KEY ( usr_ID )
  REFERENCES  usr (usr_ID);
    
----------------------------------------------------------------------------
-- ALTER userPreference
----------------------------------------------------------------------------
    
    
ALTER TABLE  userPreference
  ADD CONSTRAINT usr_ID FOREIGN KEY ( usr_ID )
  REFERENCES  usr (usr_ID);
    
----------------------------------------------------------------------------
-- ALTER userRecordOwner
----------------------------------------------------------------------------
    
    
ALTER TABLE  userRecordOwner
  ADD CONSTRAINT usr_ID FOREIGN KEY ( usr_ID )
  REFERENCES  usr (usr_ID);
    
----------------------------------------------------------------------------
-- ALTER keywords
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER keywords_extra
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_confidentialitystatus
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_cookie
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_cookielabels
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_dbstatstime
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_preassignacccode
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_onerow
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_datamodelversion
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_xmlCache
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER temptbl_std_commnames
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER temptbl_std_plantnames
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_tableDescription
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_fieldDescription
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_fieldList
----------------------------------------------------------------------------
    
    
----------------------------------------------------------------------------
-- ALTER dba_dataCache
----------------------------------------------------------------------------
    
    
     --CREATE ANY NAMED SEQUENCES:
     --
     
      
 CREATE SEQUENCE dba_preassignacccode_dba_requestnumber_seq ;