-- This is a generated SQL script for postgresql
--
   
----------------------------------------------------------------------------
-- CREATE commConcept
----------------------------------------------------------------------------
CREATE SEQUENCE commConcept_COMMCONCEPT_ID_seq;
CREATE TABLE commConcept (
  COMMCONCEPT_ID integer NOT NULL PRIMARY KEY default nextval('commConcept_COMMCONCEPT_ID_seq'),
  COMMNAME_ID Integer NOT NULL,
  commName text,
  reference_ID Integer,
  commDescription text,
  accessionCode varchar (255),
  d_obscount Integer,
  d_currentaccepted Boolean
);
----------------------------------------------------------------------------
-- CREATE commCorrelation
----------------------------------------------------------------------------
CREATE SEQUENCE commCorrelation_COMMCORRELATION_ID_seq;
CREATE TABLE commCorrelation (
  COMMCORRELATION_ID integer NOT NULL PRIMARY KEY default nextval('commCorrelation_COMMCORRELATION_ID_seq'),
  COMMSTATUS_ID Integer NOT NULL,
  COMMCONCEPT_ID Integer NOT NULL,
  commConvergence varchar (20) NOT NULL,
  correlationStart timestamp with time zone NOT NULL,
  correlationStop timestamp with time zone
);
----------------------------------------------------------------------------
-- CREATE commLineage
----------------------------------------------------------------------------
CREATE SEQUENCE commLineage_COMMLINEAGE_ID_seq;
CREATE TABLE commLineage (
  COMMLINEAGE_ID integer NOT NULL PRIMARY KEY default nextval('commLineage_COMMLINEAGE_ID_seq'),
  parentCommStatus_ID Integer NOT NULL,
  childCommStatus_ID Integer NOT NULL
);
----------------------------------------------------------------------------
-- CREATE commName
----------------------------------------------------------------------------
CREATE SEQUENCE commName_COMMNAME_ID_seq;
CREATE TABLE commName (
  COMMNAME_ID integer NOT NULL PRIMARY KEY default nextval('commName_COMMNAME_ID_seq'),
  commName text NOT NULL,
  reference_ID Integer,
  dateEntered timestamp with time zone DEFAULT now()
);
----------------------------------------------------------------------------
-- CREATE commStatus
----------------------------------------------------------------------------
CREATE SEQUENCE commStatus_COMMSTATUS_ID_seq;
CREATE TABLE commStatus (
  COMMSTATUS_ID integer NOT NULL PRIMARY KEY default nextval('commStatus_COMMSTATUS_ID_seq'),
  COMMCONCEPT_ID Integer NOT NULL,
  reference_ID Integer,
  commConceptStatus varchar (20) NOT NULL,
  commParent_ID Integer,
  commLevel varchar (80),
  startDate timestamp with time zone NOT NULL,
  stopDate timestamp with time zone,
  commPartyComments text,
  PARTY_ID Integer NOT NULL,
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE commUsage
----------------------------------------------------------------------------
CREATE SEQUENCE commUsage_COMMUSAGE_ID_seq;
CREATE TABLE commUsage (
  COMMUSAGE_ID integer NOT NULL PRIMARY KEY default nextval('commUsage_COMMUSAGE_ID_seq'),
  COMMNAME_ID Integer NOT NULL,
  commName text,
  COMMCONCEPT_ID Integer,
  usageStart timestamp with time zone,
  usageStop timestamp with time zone,
  commNameStatus varchar (20),
  classSystem varchar (50),
  PARTY_ID Integer,
  COMMSTATUS_ID Integer
);
----------------------------------------------------------------------------
-- CREATE plantConcept
----------------------------------------------------------------------------
CREATE SEQUENCE plantConcept_PLANTCONCEPT_ID_seq;
CREATE TABLE plantConcept (
  PLANTCONCEPT_ID integer NOT NULL PRIMARY KEY default nextval('plantConcept_PLANTCONCEPT_ID_seq'),
  PLANTNAME_ID Integer NOT NULL,
  reference_ID Integer NOT NULL,
  plantname varchar (200),
  plantCode varchar (23),
  plantDescription text,
  accessionCode varchar (255),
  d_obscount Integer,
  d_currentaccepted Boolean
);
----------------------------------------------------------------------------
-- CREATE plantCorrelation
----------------------------------------------------------------------------
CREATE SEQUENCE plantCorrelation_PLANTCORRELATION_ID_seq;
CREATE TABLE plantCorrelation (
  PLANTCORRELATION_ID integer NOT NULL PRIMARY KEY default nextval('plantCorrelation_PLANTCORRELATION_ID_seq'),
  PLANTSTATUS_ID Integer NOT NULL,
  PLANTCONCEPT_ID Integer NOT NULL,
  plantConvergence varchar (20) NOT NULL,
  correlationStart timestamp with time zone NOT NULL,
  correlationStop timestamp with time zone
);
----------------------------------------------------------------------------
-- CREATE plantLineage
----------------------------------------------------------------------------
CREATE SEQUENCE plantLineage_PLANTLINEAGE_ID_seq;
CREATE TABLE plantLineage (
  PLANTLINEAGE_ID integer NOT NULL PRIMARY KEY default nextval('plantLineage_PLANTLINEAGE_ID_seq'),
  childPlantStatus_ID Integer NOT NULL,
  parentPlantStatus_ID Integer NOT NULL
);
----------------------------------------------------------------------------
-- CREATE plantName
----------------------------------------------------------------------------
CREATE SEQUENCE plantName_PLANTNAME_ID_seq;
CREATE TABLE plantName (
  PLANTNAME_ID integer NOT NULL PRIMARY KEY default nextval('plantName_PLANTNAME_ID_seq'),
  plantName varchar (255) NOT NULL,
  reference_ID Integer,
  dateEntered timestamp with time zone DEFAULT now()
);
----------------------------------------------------------------------------
-- CREATE plantStatus
----------------------------------------------------------------------------
CREATE SEQUENCE plantStatus_PLANTSTATUS_ID_seq;
CREATE TABLE plantStatus (
  PLANTSTATUS_ID integer NOT NULL PRIMARY KEY default nextval('plantStatus_PLANTSTATUS_ID_seq'),
  PLANTCONCEPT_ID Integer NOT NULL,
  reference_ID Integer,
  plantConceptStatus varchar (20) NOT NULL,
  startDate timestamp with time zone NOT NULL,
  stopDate timestamp with time zone,
  plantPartyComments text,
  plantParentName varchar (200),
  plantParentConcept_id Integer,
  plantParent_ID Integer,
  plantLevel varchar (80),
  PARTY_ID Integer NOT NULL,
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE plantUsage
----------------------------------------------------------------------------
CREATE SEQUENCE plantUsage_PLANTUSAGE_ID_seq;
CREATE TABLE plantUsage (
  PLANTUSAGE_ID integer NOT NULL PRIMARY KEY default nextval('plantUsage_PLANTUSAGE_ID_seq'),
  PLANTNAME_ID Integer NOT NULL,
  PLANTCONCEPT_ID Integer,
  usageStart timestamp with time zone,
  usageStop timestamp with time zone,
  plantNameStatus varchar (20),
  plantName varchar (220),
  classSystem varchar (50),
  acceptedSynonym varchar (220),
  PARTY_ID Integer,
  PLANTSTATUS_ID Integer
);
----------------------------------------------------------------------------
-- CREATE address
----------------------------------------------------------------------------
CREATE SEQUENCE address_ADDRESS_ID_seq;
CREATE TABLE address (
  ADDRESS_ID integer NOT NULL PRIMARY KEY default nextval('address_ADDRESS_ID_seq'),
  party_ID Integer NOT NULL,
  organization_ID Integer,
  orgPosition varchar (50),
  email varchar (100),
  deliveryPoint varchar (200),
  city varchar (50),
  administrativeArea varchar (50),
  postalCode varchar (10),
  country varchar (50),
  currentFlag Boolean,
  addressStartDate timestamp with time zone
);
----------------------------------------------------------------------------
-- CREATE aux_Role
----------------------------------------------------------------------------
CREATE SEQUENCE aux_Role_ROLE_ID_seq;
CREATE TABLE aux_Role (
  ROLE_ID integer NOT NULL PRIMARY KEY default nextval('aux_Role_ROLE_ID_seq'),
  roleCode varchar (30) NOT NULL,
  roleDescription varchar (200),
  accessionCode varchar (255),
  roleProject Integer,
  roleObservation Integer,
  roleTaxonInt Integer,
  roleClassInt Integer
);
----------------------------------------------------------------------------
-- CREATE reference
----------------------------------------------------------------------------
CREATE SEQUENCE reference_reference_ID_seq;
CREATE TABLE reference (
  reference_ID integer NOT NULL PRIMARY KEY default nextval('reference_reference_ID_seq'),
  shortName varchar (250),
  fulltext text,
  referenceType varchar (250),
  title varchar (250),
  titleSuperior varchar (250),
  pubDate timestamp with time zone,
  accessDate timestamp with time zone,
  conferenceDate timestamp with time zone,
  referenceJournal_ID Integer,
  volume varchar (250),
  issue varchar (250),
  pageRange varchar (250),
  totalPages Integer,
  publisher varchar (250),
  publicationPlace varchar (250),
  isbn varchar (250),
  edition varchar (250),
  numberOfVolumes Integer,
  chapterNumber Integer,
  reportNumber Integer,
  communicationType varchar (250),
  degree varchar (250),
  url text,
  doi text,
  additionalInfo text,
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE referenceAltIdent
----------------------------------------------------------------------------
CREATE SEQUENCE referenceAltIdent_referenceAltIdent_ID_seq;
CREATE TABLE referenceAltIdent (
  referenceAltIdent_ID integer NOT NULL PRIMARY KEY default nextval('referenceAltIdent_referenceAltIdent_ID_seq'),
  reference_ID Integer NOT NULL,
  system varchar (250),
  identifier varchar (250) NOT NULL
);
----------------------------------------------------------------------------
-- CREATE referenceContributor
----------------------------------------------------------------------------
CREATE SEQUENCE referenceContributor_referenceContributor_ID_seq;
CREATE TABLE referenceContributor (
  referenceContributor_ID integer NOT NULL PRIMARY KEY default nextval(
    'referenceContributor_referenceContributor_ID_seq'
  ),
  reference_ID Integer NOT NULL,
  referenceParty_ID Integer NOT NULL,
  roleType varchar (250),
  position Integer
);
----------------------------------------------------------------------------
-- CREATE referenceParty
----------------------------------------------------------------------------
CREATE SEQUENCE referenceParty_referenceParty_ID_seq;
CREATE TABLE referenceParty (
  referenceParty_ID integer NOT NULL PRIMARY KEY default nextval('referenceParty_referenceParty_ID_seq'),
  type varchar (250),
  positionName varchar (250),
  salutation varchar (250),
  givenName varchar (250),
  surname varchar (250),
  suffix varchar (250),
  organizationName varchar (250),
  currentParty_ID Integer,
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE referenceJournal
----------------------------------------------------------------------------
CREATE SEQUENCE referenceJournal_referenceJournal_ID_seq;
CREATE TABLE referenceJournal (
  referenceJournal_ID integer NOT NULL PRIMARY KEY default nextval('referenceJournal_referenceJournal_ID_seq'),
  journal varchar (250) NOT NULL,
  issn varchar (250),
  abbreviation varchar (250),
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE classContributor
----------------------------------------------------------------------------
CREATE SEQUENCE classContributor_CLASSCONTRIBUTOR_ID_seq;
CREATE TABLE classContributor (
  CLASSCONTRIBUTOR_ID integer NOT NULL PRIMARY KEY default nextval('classContributor_CLASSCONTRIBUTOR_ID_seq'),
  COMMCLASS_ID Integer NOT NULL,
  PARTY_ID Integer NOT NULL,
  ROLE_ID Integer,
  emb_classContributor Integer
);
----------------------------------------------------------------------------
-- CREATE commClass
----------------------------------------------------------------------------
CREATE SEQUENCE commClass_COMMCLASS_ID_seq;
CREATE TABLE commClass (
  COMMCLASS_ID integer NOT NULL PRIMARY KEY default nextval('commClass_COMMCLASS_ID_seq'),
  OBSERVATION_ID Integer NOT NULL,
  classStartDate timestamp with time zone,
  classStopDate timestamp with time zone,
  inspection Boolean,
  tableAnalysis Boolean,
  multivariateAnalysis Boolean,
  expertSystem text,
  classPublication_ID Integer,
  classNotes text,
  commName varchar (200),
  commCode varchar (200),
  commFramework varchar (200),
  commLevel varchar (200),
  accessionCode varchar (255),
  emb_commClass Integer
);
----------------------------------------------------------------------------
-- CREATE commInterpretation
----------------------------------------------------------------------------
CREATE SEQUENCE commInterpretation_COMMINTERPRETATION_ID_seq;
CREATE TABLE commInterpretation (
  COMMINTERPRETATION_ID integer NOT NULL PRIMARY KEY default nextval('commInterpretation_COMMINTERPRETATION_ID_seq'),
  COMMCLASS_ID Integer NOT NULL,
  COMMCONCEPT_ID Integer,
  commcode varchar (34),
  commname varchar (200),
  classFit varchar (50),
  classConfidence varchar (15),
  commAuthority_ID Integer,
  notes text,
  type Boolean,
  nomenclaturalType Boolean,
  emb_commInterpretation Integer
);
----------------------------------------------------------------------------
-- CREATE coverIndex
----------------------------------------------------------------------------
CREATE SEQUENCE coverIndex_COVERINDEX_ID_seq;
CREATE TABLE coverIndex (
  COVERINDEX_ID integer NOT NULL PRIMARY KEY default nextval('coverIndex_COVERINDEX_ID_seq'),
  COVERMETHOD_ID Integer NOT NULL,
  coverCode varchar (10) NOT NULL,
  upperLimit Float,
  lowerLimit Float,
  coverPercent Float NOT NULL,
  indexDescription text
);
----------------------------------------------------------------------------
-- CREATE coverMethod
----------------------------------------------------------------------------
CREATE SEQUENCE coverMethod_COVERMETHOD_ID_seq;
CREATE TABLE coverMethod (
  COVERMETHOD_ID integer NOT NULL PRIMARY KEY default nextval('coverMethod_COVERMETHOD_ID_seq'),
  reference_ID Integer,
  coverType varchar (30) NOT NULL,
  coverEstimationMethod varchar (80),
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE definedValue
----------------------------------------------------------------------------
CREATE SEQUENCE definedValue_DEFINEDVALUE_ID_seq;
CREATE TABLE definedValue (
  DEFINEDVALUE_ID integer NOT NULL PRIMARY KEY default nextval('definedValue_DEFINEDVALUE_ID_seq'),
  USERDEFINED_ID Integer NOT NULL,
  tableRecord_ID Integer NOT NULL,
  definedValue text NOT NULL
);
----------------------------------------------------------------------------
-- CREATE disturbanceObs
----------------------------------------------------------------------------
CREATE SEQUENCE disturbanceObs_disturbanceObs_ID_seq;
CREATE TABLE disturbanceObs (
  disturbanceObs_ID integer NOT NULL PRIMARY KEY default nextval('disturbanceObs_disturbanceObs_ID_seq'),
  OBSERVATION_ID Integer NOT NULL,
  disturbanceType varchar (30) NOT NULL,
  disturbanceIntensity varchar (30),
  disturbanceAge Float,
  disturbanceExtent Float,
  disturbanceComment text,
  emb_disturbanceObs Integer
);
----------------------------------------------------------------------------
-- CREATE graphic
----------------------------------------------------------------------------
CREATE SEQUENCE graphic_GRAPHIC_ID_seq;
CREATE TABLE graphic (
  GRAPHIC_ID integer NOT NULL PRIMARY KEY default nextval('graphic_GRAPHIC_ID_seq'),
  OBSERVATION_ID Integer NOT NULL,
  graphicName varchar (30),
  graphicLocation text,
  graphicDescription text,
  graphicType varchar (20),
  graphicDate timestamp with time zone,
  graphicData oid,
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE namedPlace
----------------------------------------------------------------------------
CREATE SEQUENCE namedPlace_NAMEDPLACE_ID_seq;
CREATE TABLE namedPlace (
  NAMEDPLACE_ID integer NOT NULL PRIMARY KEY default nextval('namedPlace_NAMEDPLACE_ID_seq'),
  placeSystem varchar (50),
  placeName varchar (100) NOT NULL,
  placeDescription text,
  placeCode varchar (15),
  owner varchar (100),
  reference_ID Integer,
  accessionCode varchar (255),
  d_obscount Integer
);
----------------------------------------------------------------------------
-- CREATE namedPlaceCorrelation
----------------------------------------------------------------------------
CREATE SEQUENCE namedPlaceCorrelation_NAMEDPLACECORRELATION_ID_seq;
CREATE TABLE namedPlaceCorrelation (
  NAMEDPLACECORRELATION_ID integer NOT NULL PRIMARY KEY default nextval(
    'namedPlaceCorrelation_NAMEDPLACECORRELATION_ID_seq'
  ),
  PARENTPLACE_ID Integer NOT NULL,
  CHILDPLACE_ID Integer NOT NULL,
  placeConvergence varchar (20) NOT NULL
);
----------------------------------------------------------------------------
-- CREATE note
----------------------------------------------------------------------------
CREATE SEQUENCE note_NOTE_ID_seq;
CREATE TABLE note (
  NOTE_ID integer NOT NULL PRIMARY KEY default nextval('note_NOTE_ID_seq'),
  NOTELINK_ID Integer NOT NULL,
  PARTY_ID Integer NOT NULL,
  ROLE_ID Integer NOT NULL,
  noteDate timestamp with time zone,
  noteType varchar (20) NOT NULL,
  noteText text NOT NULL,
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE noteLink
----------------------------------------------------------------------------
CREATE SEQUENCE noteLink_NOTELINK_ID_seq;
CREATE TABLE noteLink (
  NOTELINK_ID integer NOT NULL PRIMARY KEY default nextval('noteLink_NOTELINK_ID_seq'),
  tableName varchar (50) NOT NULL,
  attributeName varchar (50),
  tableRecord Integer NOT NULL
);
----------------------------------------------------------------------------
-- CREATE observation
----------------------------------------------------------------------------
CREATE SEQUENCE observation_OBSERVATION_ID_seq;
CREATE TABLE observation (
  OBSERVATION_ID integer NOT NULL PRIMARY KEY default nextval('observation_OBSERVATION_ID_seq'),
  PREVIOUSOBS_ID Integer,
  PLOT_ID Integer NOT NULL,
  PROJECT_ID Integer,
  authorObsCode varchar (30),
  obsStartDate timestamp with time zone,
  obsEndDate timestamp with time zone,
  dateAccuracy varchar (30),
  dateEntered timestamp with time zone DEFAULT now(),
  COVERMETHOD_ID Integer,
  coverDispersion varchar (30),
  autoTaxonCover Boolean,
  STRATUMMETHOD_ID Integer,
  methodNarrative text,
  taxonObservationArea Float,
  stemSizeLimit Float,
  stemObservationArea Float,
  stemSampleMethod varchar (30),
  originalData text,
  effortLevel varchar (30),
  plotValidationLevel Integer,
  floristicQuality varchar (30),
  bryophyteQuality varchar (30),
  lichenQuality varchar (30),
  observationNarrative text,
  landscapeNarrative text,
  homogeneity varchar (50),
  phenologicAspect varchar (30),
  representativeness varchar (255),
  standMaturity varchar (50),
  successionalStatus text,
  numberOfTaxa Integer,
  basalArea Float,
  hydrologicRegime varchar (255),
  soilMoistureRegime varchar (30),
  soilDrainage varchar (30),
  waterSalinity varchar (30),
  waterDepth Float,
  shoreDistance Float,
  soilDepth Float,
  organicDepth Float,
  SOILTAXON_ID Integer,
  soilTaxonSrc varchar (200),
  percentBedRock Float,
  percentRockGravel Float,
  percentWood Float,
  percentLitter Float,
  percentBareSoil Float,
  percentWater Float,
  percentOther Float,
  nameOther varchar (30),
  treeHt Float,
  shrubHt Float,
  fieldHt Float,
  nonvascularHt Float,
  submergedHt Float,
  treeCover Float,
  shrubCover Float,
  fieldCover Float,
  nonvascularCover Float,
  floatingCover Float,
  submergedCover Float,
  dominantStratum varchar (40),
  growthform1Type varchar (40),
  growthform2Type varchar (40),
  growthform3Type varchar (40),
  growthform1Cover Float,
  growthform2Cover Float,
  growthform3Cover Float,
  totalCover Float,
  accessionCode varchar (255),
  notesPublic Boolean,
  notesMgt Boolean,
  revisions Boolean,
  emb_observation Integer,
  interp_orig_ci_ID Integer,
  interp_orig_cc_ID Integer,
  interp_orig_sciname text,
  interp_orig_code text,
  interp_orig_party_id Integer,
  interp_orig_partyname text,
  interp_current_ci_ID Integer,
  interp_current_cc_ID Integer,
  interp_current_sciname text,
  interp_current_code text,
  interp_current_party_id Integer,
  interp_current_partyname text,
  interp_bestfit_ci_ID Integer,
  interp_bestfit_cc_ID Integer,
  interp_bestfit_sciname text,
  interp_bestfit_code text,
  interp_bestfit_party_id Integer,
  interp_bestfit_partyname text,
  topTaxon1Name varchar (255),
  topTaxon2Name varchar (255),
  topTaxon3Name varchar (255),
  topTaxon4Name varchar (255),
  topTaxon5Name varchar (255),
  hasObservationSynonym Boolean
);
----------------------------------------------------------------------------
-- CREATE observationContributor
----------------------------------------------------------------------------
CREATE SEQUENCE observationContributor_OBSERVATIONCONTRIBUTOR_ID_seq;
CREATE TABLE observationContributor (
  OBSERVATIONCONTRIBUTOR_ID integer NOT NULL PRIMARY KEY default nextval(
    'observationContributor_OBSERVATIONCONTRIBUTOR_ID_seq'
  ),
  OBSERVATION_ID Integer NOT NULL,
  PARTY_ID Integer NOT NULL,
  ROLE_ID Integer NOT NULL,
  contributionDate timestamp with time zone
);
----------------------------------------------------------------------------
-- CREATE observationSynonym
----------------------------------------------------------------------------
CREATE SEQUENCE observationSynonym_OBSERVATIONSYNONYM_ID_seq;
CREATE TABLE observationSynonym (
  OBSERVATIONSYNONYM_ID integer NOT NULL PRIMARY KEY default nextval('observationSynonym_OBSERVATIONSYNONYM_ID_seq'),
  synonymObservation_ID Integer NOT NULL,
  primaryObservation_ID Integer NOT NULL,
  PARTY_ID Integer NOT NULL,
  ROLE_ID Integer NOT NULL,
  classStartDate timestamp with time zone NOT NULL DEFAULT now(),
  classStopDate timestamp with time zone,
  synonymComment text,
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE party
----------------------------------------------------------------------------
CREATE SEQUENCE party_PARTY_ID_seq;
CREATE TABLE party (
  PARTY_ID integer NOT NULL PRIMARY KEY default nextval('party_PARTY_ID_seq'),
  salutation varchar (20),
  givenName varchar (50),
  middleName varchar (50),
  surName varchar (50),
  organizationName varchar (100),
  currentName_ID Integer,
  contactInstructions text,
  email varchar (120),
  accessionCode varchar (255),
  partyType varchar (40),
  partyPublic Boolean DEFAULT true,
  d_obscount Integer
);
----------------------------------------------------------------------------
-- CREATE partyMember
----------------------------------------------------------------------------
CREATE SEQUENCE partyMember_partyMember_ID_seq;
CREATE TABLE partyMember (
  partyMember_ID integer NOT NULL PRIMARY KEY default nextval('partyMember_partyMember_ID_seq'),
  parentParty_ID Integer NOT NULL,
  childParty_ID Integer NOT NULL,
  role_ID Integer,
  memberStart timestamp with time zone NOT NULL DEFAULT now(),
  memberStop timestamp with time zone
);
----------------------------------------------------------------------------
-- CREATE place
----------------------------------------------------------------------------
CREATE SEQUENCE place_PLOTPLACE_ID_seq;
CREATE TABLE place (
  PLOTPLACE_ID integer NOT NULL PRIMARY KEY default nextval('place_PLOTPLACE_ID_seq'),
  PLOT_ID Integer NOT NULL,
  calculated Boolean,
  NAMEDPLACE_ID Integer NOT NULL
);
----------------------------------------------------------------------------
-- CREATE plot
----------------------------------------------------------------------------
CREATE SEQUENCE plot_PLOT_ID_seq;
CREATE TABLE plot (
  PLOT_ID integer NOT NULL PRIMARY KEY default nextval('plot_PLOT_ID_seq'),
  authorPlotCode varchar (30) NOT NULL,
  reference_ID Integer,
  PARENT_ID Integer,
  realLatitude Float,
  realLongitude Float,
  locationAccuracy Float,
  confidentialityStatus Integer NOT NULL,
  confidentialityReason varchar (200),
  latitude Float,
  longitude Float,
  authorE varchar (20),
  authorN varchar (20),
  authorZone varchar (20),
  authorDatum varchar (20),
  authorLocation varchar (200),
  locationNarrative text,
  plotRationaleNarrative text,
  azimuth Float,
  dsgpoly text,
  shape varchar (50),
  area Float,
  standSize varchar (50),
  placementMethod varchar (50),
  permanence Boolean,
  layoutNarrative text,
  elevation Float,
  elevationAccuracy Float,
  elevationRange Float,
  slopeAspect Float,
  minSlopeAspect Float,
  maxSlopeAspect Float,
  slopeGradient Float,
  minSlopeGradient Float,
  maxSlopeGradient Float,
  topoPosition varchar (90),
  landform varchar (50),
  surficialDeposits varchar (90),
  rockType varchar (90),
  stateProvince varchar (55),
  country varchar (100),
  dateentered timestamp with time zone DEFAULT now(),
  submitter_surname varchar (100),
  submitter_givenname varchar (100),
  submitter_email varchar (100),
  accessionCode varchar (255),
  notesPublic Boolean,
  notesMgt Boolean,
  revisions Boolean,
  emb_plot Integer
);
----------------------------------------------------------------------------
-- CREATE project
----------------------------------------------------------------------------
CREATE SEQUENCE project_PROJECT_ID_seq;
CREATE TABLE project (
  PROJECT_ID integer NOT NULL PRIMARY KEY default nextval('project_PROJECT_ID_seq'),
  projectName varchar (150) NOT NULL,
  projectDescription text,
  startDate timestamp with time zone,
  stopDate timestamp with time zone,
  accessionCode varchar (255),
  d_obscount Integer,
  d_lastplotaddeddate timestamp with time zone
);
----------------------------------------------------------------------------
-- CREATE projectContributor
----------------------------------------------------------------------------
CREATE SEQUENCE projectContributor_PROJECTCONTRIBUTOR_ID_seq;
CREATE TABLE projectContributor (
  PROJECTCONTRIBUTOR_ID integer NOT NULL PRIMARY KEY default nextval('projectContributor_PROJECTCONTRIBUTOR_ID_seq'),
  PROJECT_ID Integer NOT NULL,
  PARTY_ID Integer NOT NULL,
  ROLE_ID Integer,
  surname varchar (50),
  cheatRole varchar (50)
);
----------------------------------------------------------------------------
-- CREATE revision
----------------------------------------------------------------------------
CREATE SEQUENCE revision_REVISION_ID_seq;
CREATE TABLE revision (
  REVISION_ID integer NOT NULL PRIMARY KEY default nextval('revision_REVISION_ID_seq'),
  tableName varchar (50) NOT NULL,
  tableAttribute varchar (50) NOT NULL,
  tableRecord Integer NOT NULL,
  revisionDate timestamp with time zone NOT NULL,
  previousValueText text NOT NULL,
  previousValueType varchar (20) NOT NULL,
  previousRevision_ID Integer
);
----------------------------------------------------------------------------
-- CREATE soilObs
----------------------------------------------------------------------------
CREATE SEQUENCE soilObs_SOILOBS_ID_seq;
CREATE TABLE soilObs (
  SOILOBS_ID integer NOT NULL PRIMARY KEY default nextval('soilObs_SOILOBS_ID_seq'),
  OBSERVATION_ID Integer NOT NULL,
  soilHorizon varchar (15) NOT NULL,
  soilDepthTop Float,
  soilDepthBottom Float,
  soilColor varchar (30),
  soilOrganic Float,
  soilTexture varchar (50),
  soilSand Float,
  soilSilt Float,
  soilClay Float,
  soilCoarse Float,
  soilPH Float,
  exchangeCapacity Float,
  baseSaturation Float,
  soilDescription text,
  emb_soilObs Integer
);
----------------------------------------------------------------------------
-- CREATE soilTaxon
----------------------------------------------------------------------------
CREATE SEQUENCE soilTaxon_SOILTAXON_ID_seq;
CREATE TABLE soilTaxon (
  SOILTAXON_ID integer NOT NULL PRIMARY KEY default nextval('soilTaxon_SOILTAXON_ID_seq'),
  soilCode varchar (15),
  soilName varchar (100),
  soilLevel Integer,
  SOILPARENT_ID Integer,
  soilFramework varchar (33),
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE stemCount
----------------------------------------------------------------------------
CREATE SEQUENCE stemCount_STEMCOUNT_ID_seq;
CREATE TABLE stemCount (
  STEMCOUNT_ID integer NOT NULL PRIMARY KEY default nextval('stemCount_STEMCOUNT_ID_seq'),
  TAXONIMPORTANCE_ID Integer NOT NULL,
  stemDiameter Float,
  stemDiameterAccuracy Float,
  stemHeight Float,
  stemHeightAccuracy Float,
  stemCount Integer NOT NULL,
  stemTaxonArea Float,
  emb_stemCount Integer
);
----------------------------------------------------------------------------
-- CREATE stemLocation
----------------------------------------------------------------------------
CREATE SEQUENCE stemLocation_STEMLOCATION_ID_seq;
CREATE TABLE stemLocation (
  STEMLOCATION_ID integer NOT NULL PRIMARY KEY default nextval('stemLocation_STEMLOCATION_ID_seq'),
  STEMCOUNT_ID Integer NOT NULL,
  stemCode varchar (20),
  stemXPosition Float,
  stemYPosition Float,
  stemHealth varchar (50),
  emb_stemLocation Integer
);
----------------------------------------------------------------------------
-- CREATE stratum
----------------------------------------------------------------------------
CREATE SEQUENCE stratum_STRATUM_ID_seq;
CREATE TABLE stratum (
  STRATUM_ID integer NOT NULL PRIMARY KEY default nextval('stratum_STRATUM_ID_seq'),
  OBSERVATION_ID Integer NOT NULL,
  STRATUMTYPE_ID Integer NOT NULL,
  STRATUMMETHOD_ID Integer,
  stratumName varchar (30),
  stratumHeight Float,
  stratumBase Float,
  stratumCover Float,
  stratumDescription varchar (200)
);
----------------------------------------------------------------------------
-- CREATE stratumMethod
----------------------------------------------------------------------------
CREATE SEQUENCE stratumMethod_STRATUMMETHOD_ID_seq;
CREATE TABLE stratumMethod (
  STRATUMMETHOD_ID integer NOT NULL PRIMARY KEY default nextval('stratumMethod_STRATUMMETHOD_ID_seq'),
  reference_ID Integer,
  stratumMethodName varchar (30) NOT NULL,
  stratumMethodDescription text,
  stratumAssignment varchar (50),
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE stratumType
----------------------------------------------------------------------------
CREATE SEQUENCE stratumType_STRATUMTYPE_ID_seq;
CREATE TABLE stratumType (
  STRATUMTYPE_ID integer NOT NULL PRIMARY KEY default nextval('stratumType_STRATUMTYPE_ID_seq'),
  STRATUMMETHOD_ID Integer NOT NULL,
  stratumIndex varchar (10),
  stratumName varchar (30),
  stratumDescription text
);
----------------------------------------------------------------------------
-- CREATE taxonImportance
----------------------------------------------------------------------------
CREATE SEQUENCE taxonImportance_taxonImportance_ID_seq;
CREATE TABLE taxonImportance (
  taxonImportance_ID integer NOT NULL PRIMARY KEY default nextval('taxonImportance_taxonImportance_ID_seq'),
  taxonObservation_ID Integer NOT NULL,
  stratum_ID Integer,
  cover Float,
  coverCode varchar (10),
  basalArea Float,
  biomass Float,
  inferenceArea Float,
  stratumBase Float,
  stratumHeight Float,
  emb_taxonImportance Integer
);
----------------------------------------------------------------------------
-- CREATE taxonInterpretation
----------------------------------------------------------------------------
CREATE SEQUENCE taxonInterpretation_TAXONINTERPRETATION_ID_seq;
CREATE TABLE taxonInterpretation (
  TAXONINTERPRETATION_ID integer NOT NULL PRIMARY KEY default nextval('taxonInterpretation_TAXONINTERPRETATION_ID_seq'),
  TAXONOBSERVATION_ID Integer NOT NULL,
  stemLocation_ID Integer,
  PLANTCONCEPT_ID Integer NOT NULL,
  interpretationDate timestamp with time zone NOT NULL,
  PLANTNAME_ID Integer,
  PARTY_ID Integer NOT NULL,
  ROLE_ID Integer NOT NULL,
  interpretationType varchar (30),
  reference_ID Integer,
  originalInterpretation Boolean NOT NULL,
  currentInterpretation Boolean NOT NULL,
  taxonFit varchar (50),
  taxonConfidence varchar (50),
  collector_ID Integer,
  collectionNumber varchar (100),
  collectionDate timestamp with time zone,
  museum_ID Integer,
  museumAccessionNumber varchar (100),
  groupType varchar (20),
  notes text,
  notesPublic Boolean,
  notesMgt Boolean,
  revisions Boolean,
  emb_taxonInterpretation Integer,
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE taxonObservation
----------------------------------------------------------------------------
CREATE SEQUENCE taxonObservation_TAXONOBSERVATION_ID_seq;
CREATE TABLE taxonObservation (
  TAXONOBSERVATION_ID integer NOT NULL PRIMARY KEY default nextval('taxonObservation_TAXONOBSERVATION_ID_seq'),
  OBSERVATION_ID Integer NOT NULL,
  authorPlantName varchar (255),
  reference_ID Integer,
  taxonInferenceArea Float,
  accessionCode varchar (255),
  emb_taxonObservation Integer,
  int_origPlantConcept_ID Integer,
  int_origPlantSciFull varchar (255),
  int_origPlantSciNameNoAuth varchar (255),
  int_origPlantCommon varchar (255),
  int_origPlantCode varchar (255),
  int_currPlantConcept_ID Integer,
  int_currPlantSciFull varchar (255),
  int_currPlantSciNameNoAuth varchar (255),
  int_currPlantCommon varchar (255),
  int_currPlantCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE taxonAlt
----------------------------------------------------------------------------
CREATE SEQUENCE taxonAlt_taxonAlt_ID_seq;
CREATE TABLE taxonAlt (
  taxonAlt_ID integer NOT NULL PRIMARY KEY default nextval('taxonAlt_taxonAlt_ID_seq'),
  taxonInterpretation_ID Integer NOT NULL,
  plantConcept_ID Integer NOT NULL,
  taxonAltFit varchar (50),
  taxonAltConfidence varchar (50),
  taxonAltNotes text,
  emb_taxonAlt Integer
);
----------------------------------------------------------------------------
-- CREATE telephone
----------------------------------------------------------------------------
CREATE SEQUENCE telephone_TELEPHONE_ID_seq;
CREATE TABLE telephone (
  TELEPHONE_ID integer NOT NULL PRIMARY KEY default nextval('telephone_TELEPHONE_ID_seq'),
  PARTY_ID Integer NOT NULL,
  phoneNumber varchar (30) NOT NULL,
  phoneType varchar (20) NOT NULL
);
----------------------------------------------------------------------------
-- CREATE userDefined
----------------------------------------------------------------------------
CREATE SEQUENCE userDefined_USERDEFINED_ID_seq;
CREATE TABLE userDefined (
  USERDEFINED_ID integer NOT NULL PRIMARY KEY default nextval('userDefined_USERDEFINED_ID_seq'),
  userDefinedName varchar (50),
  userDefinedMetadata text,
  userDefinedCategory varchar (30),
  userDefinedType varchar (20) NOT NULL,
  tableName varchar (50) NOT NULL,
  accessionCode varchar (255)
);
----------------------------------------------------------------------------
-- CREATE embargo
----------------------------------------------------------------------------
CREATE SEQUENCE embargo_embargo_ID_seq;
CREATE TABLE embargo (
  embargo_ID integer NOT NULL PRIMARY KEY default nextval('embargo_embargo_ID_seq'),
  plot_ID Integer NOT NULL,
  embargoReason text NOT NULL,
  embargoStart timestamp with time zone NOT NULL,
  embargoStop timestamp with time zone NOT NULL,
  defaultStatus Integer NOT NULL
);
----------------------------------------------------------------------------
-- CREATE usr
----------------------------------------------------------------------------
CREATE SEQUENCE usr_usr_ID_seq;
CREATE TABLE usr (
  usr_ID integer NOT NULL PRIMARY KEY default nextval('usr_usr_ID_seq'),
  party_ID Integer NOT NULL,
  password varchar (512),
  permission_type Integer NOT NULL,
  begin_time timestamp with time zone,
  last_connect timestamp with time zone,
  ticket_count Integer,
  email_address varchar (100) NOT NULL,
  preferred_name varchar (100),
  remote_address varchar (100)
);
----------------------------------------------------------------------------
-- CREATE userCertification
----------------------------------------------------------------------------
CREATE SEQUENCE userCertification_userCertification_ID_seq;
CREATE TABLE userCertification (
  userCertification_ID integer NOT NULL PRIMARY KEY default nextval('userCertification_userCertification_ID_seq'),
  usr_ID Integer NOT NULL,
  current_cert_level Integer NOT NULL,
  requested_cert_level Integer NOT NULL,
  highest_degree varchar (50),
  degree_year varchar (50),
  degree_institution varchar (50),
  current_org varchar (50),
  current_pos varchar (200),
  esa_member Boolean,
  prof_exp text,
  relevant_pubs text,
  veg_sampling_exp text,
  veg_analysis_exp text,
  usnvc_exp text,
  vb_exp text,
  vb_intention text,
  tools_exp text,
  esa_sponsor_name_a varchar (120),
  esa_sponsor_email_a varchar (120),
  esa_sponsor_name_b varchar (120),
  esa_sponsor_email_b varchar (120),
  peer_review Boolean,
  addl_stmt text,
  certificationStatus varchar (30),
  certificationStatusComments text,
  exp_region_a text,
  exp_region_b text,
  exp_region_c text,
  exp_region_a_veg text,
  exp_region_b_veg text,
  exp_region_c_veg text,
  exp_region_a_flor text,
  exp_region_b_flor text,
  exp_region_c_flor text,
  exp_region_a_nvc text,
  exp_region_b_nvc text,
  exp_region_c_nvc text
);
----------------------------------------------------------------------------
-- CREATE userRegionalExp
----------------------------------------------------------------------------
CREATE SEQUENCE userRegionalExp_userRegionalExp_ID_seq;
CREATE TABLE userRegionalExp (
  userRegionalExp_ID integer NOT NULL PRIMARY KEY default nextval('userRegionalExp_userRegionalExp_ID_seq'),
  userCertification_ID Integer NOT NULL,
  region varchar (50) NOT NULL,
  vegetation varchar (50),
  floristics varchar (50),
  nvc_ivc varchar (50)
);
----------------------------------------------------------------------------
-- CREATE userDataset
----------------------------------------------------------------------------
CREATE SEQUENCE userDataset_userDataset_ID_seq;
CREATE TABLE userDataset (
  userDataset_ID integer NOT NULL PRIMARY KEY default nextval('userDataset_userDataset_ID_seq'),
  usr_ID Integer,
  datasetStart timestamp with time zone DEFAULT now(),
  datasetStop timestamp with time zone,
  accessionCode varchar (255),
  datasetName varchar (100) NOT NULL,
  datasetDescription text,
  datasetType varchar (50),
  datasetSharing varchar (30),
  datasetPassword varchar (50)
);
----------------------------------------------------------------------------
-- CREATE userDatasetItem
----------------------------------------------------------------------------
CREATE SEQUENCE userDatasetItem_userDatasetItem_ID_seq;
CREATE TABLE userDatasetItem (
  userDatasetItem_ID integer NOT NULL PRIMARY KEY default nextval('userDatasetItem_userDatasetItem_ID_seq'),
  userDataset_ID Integer NOT NULL,
  itemAccessionCode varchar (100) NOT NULL,
  itemDatabase varchar (50) NOT NULL,
  itemTable varchar (50) NOT NULL,
  itemRecord Integer NOT NULL,
  externalAccessionCode varchar (100),
  itemType varchar (50),
  itemStart timestamp with time zone NOT NULL DEFAULT now(),
  itemStop timestamp with time zone,
  notes text
);
----------------------------------------------------------------------------
-- CREATE userNotify
----------------------------------------------------------------------------
CREATE SEQUENCE userNotify_userNotify_ID_seq;
CREATE TABLE userNotify (
  userNotify_ID integer NOT NULL PRIMARY KEY default nextval('userNotify_userNotify_ID_seq'),
  usr_ID Integer NOT NULL,
  notifyName varchar (100),
  notifyDescription text,
  notifyStart timestamp with time zone DEFAULT now(),
  notifyStop timestamp with time zone,
  lastCheckDate timestamp with time zone,
  notifySQL text
);
----------------------------------------------------------------------------
-- CREATE userPermission
----------------------------------------------------------------------------
CREATE SEQUENCE userPermission_userPermission_ID_seq;
CREATE TABLE userPermission (
  userPermission_ID integer NOT NULL PRIMARY KEY default nextval('userPermission_userPermission_ID_seq'),
  embargo_ID Integer NOT NULL,
  usr_ID Integer NOT NULL,
  permissionStart timestamp with time zone NOT NULL DEFAULT now(),
  permissionStop timestamp with time zone,
  permissionStatus Integer NOT NULL,
  permissionNotes text
);
----------------------------------------------------------------------------
-- CREATE userQuery
----------------------------------------------------------------------------
CREATE SEQUENCE userQuery_userQuery_ID_seq;
CREATE TABLE userQuery (
  userQuery_ID integer NOT NULL PRIMARY KEY default nextval('userQuery_userQuery_ID_seq'),
  usr_ID Integer NOT NULL,
  queryStart timestamp with time zone DEFAULT now(),
  queryStop timestamp with time zone,
  accessionCode varchar (255),
  queryName varchar (100),
  queryDescription text,
  querySQL text,
  queryType varchar (50),
  querySharing varchar (30),
  queryPassword varchar (50)
);
----------------------------------------------------------------------------
-- CREATE userPreference
----------------------------------------------------------------------------
CREATE SEQUENCE userPreference_userPreference_ID_seq;
CREATE TABLE userPreference (
  userPreference_ID integer NOT NULL PRIMARY KEY default nextval('userPreference_userPreference_ID_seq'),
  usr_ID Integer NOT NULL,
  preferenceName varchar (100),
  preferenceValue text,
  preferencePriority Float,
  preferenceStart timestamp with time zone DEFAULT now(),
  preferenceStop timestamp with time zone
);
----------------------------------------------------------------------------
-- CREATE userRecordOwner
----------------------------------------------------------------------------
CREATE SEQUENCE userRecordOwner_userRecordOwner_ID_seq;
CREATE TABLE userRecordOwner (
  userRecordOwner_ID integer NOT NULL PRIMARY KEY default nextval('userRecordOwner_userRecordOwner_ID_seq'),
  usr_ID Integer NOT NULL,
  tableName varchar (50) NOT NULL,
  tableRecord Integer NOT NULL,
  recordCreationDate timestamp with time zone NOT NULL,
  ownerStart timestamp with time zone NOT NULL DEFAULT now(),
  ownerStop timestamp with time zone,
  ownerType varchar (30) NOT NULL
);
----------------------------------------------------------------------------
-- CREATE keywords
----------------------------------------------------------------------------
CREATE TABLE keywords (
  entity text NOT NULL,
  keywords text,
  table_id Integer NOT NULL
);
----------------------------------------------------------------------------
-- CREATE keywords_extra
----------------------------------------------------------------------------
CREATE TABLE keywords_extra (
  entity text NOT NULL,
  keywords text,
  table_id Integer NOT NULL
);
----------------------------------------------------------------------------
-- CREATE dba_confidentialitystatus
----------------------------------------------------------------------------
CREATE TABLE dba_confidentialitystatus (
  confidentialitystatus Integer NOT NULL PRIMARY KEY,
  confidentialityshorttext varchar (100),
  confidentialitytext varchar (100)
);
----------------------------------------------------------------------------
-- CREATE dba_cookie
----------------------------------------------------------------------------
CREATE SEQUENCE dba_cookie_cookie_id_seq;
CREATE TABLE dba_cookie (
  cookie_id integer NOT NULL PRIMARY KEY default nextval('dba_cookie_cookie_id_seq'),
  cookiename varchar (75) NOT NULL,
  defaultvalue varchar (75) NOT NULL,
  viewname varchar (25) NOT NULL,
  description text,
  examplepk Integer NOT NULL,
  sortorder Integer,
  startgroup Boolean,
  prefixhtml text,
  suffixhtml text
);
----------------------------------------------------------------------------
-- CREATE dba_cookielabels
----------------------------------------------------------------------------
CREATE SEQUENCE dba_cookielabels_cookielabel_id_seq;
CREATE TABLE dba_cookielabels (
  cookielabel_id integer NOT NULL PRIMARY KEY default nextval('dba_cookielabels_cookielabel_id_seq'),
  vieworcookie varchar (50) NOT NULL,
  description text
);
----------------------------------------------------------------------------
-- CREATE dba_dbstatstime
----------------------------------------------------------------------------
CREATE SEQUENCE dba_dbstatstime_stat_id_seq;
CREATE TABLE dba_dbstatstime (
  stat_id integer NOT NULL PRIMARY KEY default nextval('dba_dbstatstime_stat_id_seq'),
  statdate timestamp with time zone,
  statpkg Integer,
  statname text,
  stattable varchar (100),
  minpk Integer,
  maxpk Integer,
  countrecs Integer
);
----------------------------------------------------------------------------
-- CREATE dba_preassignacccode
----------------------------------------------------------------------------
CREATE SEQUENCE dba_preassignacccode_dba_preassignacccode_id_seq;
CREATE TABLE dba_preassignacccode (
  dba_preassignacccode_id integer NOT NULL PRIMARY KEY default nextval(
    'dba_preassignacccode_dba_preassignacccode_id_seq'
  ),
  dba_requestnumber Integer NOT NULL,
  databasekey varchar (20) NOT NULL,
  tableabbrev varchar (10) NOT NULL,
  confirmcode varchar (70) NOT NULL DEFAULT (
    replace(
      replace(
        replace(
          replace(
            to_char(now(), 'YYYY-MM-DD"T"HH24:MI:SS'),
            ' ',
            'T'
          ),
          '-',
          ''
        ),
        ':',
        ''
      ),
      '.',
      'd'
    ) || 'R' || floor(random() * 1000000)
  ),
  accessioncode varchar (255),
  codeIsUsed Boolean
);
----------------------------------------------------------------------------
-- CREATE dba_onerow
----------------------------------------------------------------------------
CREATE SEQUENCE dba_onerow_dba_onerow_id_seq;
CREATE TABLE dba_onerow (
  dba_onerow_id integer NOT NULL PRIMARY KEY default nextval('dba_onerow_dba_onerow_id_seq')
);
----------------------------------------------------------------------------
-- CREATE dba_datamodelversion
----------------------------------------------------------------------------
CREATE SEQUENCE dba_datamodelversion_dba_datamodelversion_ID_seq;
CREATE TABLE dba_datamodelversion (
  dba_datamodelversion_ID integer NOT NULL PRIMARY KEY default nextval(
    'dba_datamodelversion_dba_datamodelversion_ID_seq'
  ),
  versionText varchar (20) NOT NULL,
  versionImplemented timestamp with time zone DEFAULT now()
);
-- DOU DISABLE:
-- THIS IS ALREADY DECLARED IN THE DUMP FILE
-- INSERT INTO dba_datamodelversion (versionText) values ('1.0.5');
----------------------------------------------------------------------------
-- CREATE dba_xmlCache
----------------------------------------------------------------------------
CREATE TABLE dba_xmlCache (
  accessioncode varchar (255),
  xml bytea
);
----------------------------------------------------------------------------
-- CREATE temptbl_std_commnames
----------------------------------------------------------------------------
CREATE SEQUENCE temptbl_std_commnames_commconcept_id_seq;
CREATE TABLE temptbl_std_commnames (
  commconcept_id integer NOT NULL PRIMARY KEY default nextval('temptbl_std_commnames_commconcept_id_seq'),
  sciname varchar (255),
  translated varchar (255),
  code varchar (255),
  common varchar (255)
);
----------------------------------------------------------------------------
-- CREATE temptbl_std_plantnames
----------------------------------------------------------------------------
CREATE SEQUENCE temptbl_std_plantnames_plantconcept_id_seq;
CREATE TABLE temptbl_std_plantnames (
  plantconcept_id integer NOT NULL PRIMARY KEY default nextval('temptbl_std_plantnames_plantconcept_id_seq'),
  plantname varchar (255),
  sciname varchar (255),
  scinamenoauth varchar (255),
  code varchar (255),
  common varchar (255)
);
----------------------------------------------------------------------------
-- CREATE dba_tableDescription
----------------------------------------------------------------------------
CREATE SEQUENCE dba_tableDescription_dba_tableDescription_ID_seq;
CREATE TABLE dba_tableDescription (
  dba_tableDescription_ID integer NOT NULL PRIMARY KEY default nextval(
    'dba_tableDescription_dba_tableDescription_ID_seq'
  ),
  tableName varchar (75),
  tableLabel varchar (200),
  tableNotes text,
  tableDescription text,
  tableKeywords text
);
----------------------------------------------------------------------------
-- CREATE dba_fieldDescription
----------------------------------------------------------------------------
CREATE SEQUENCE dba_fieldDescription_dba_fieldDescription_ID_seq;
CREATE TABLE dba_fieldDescription (
  dba_fieldDescription_ID integer NOT NULL PRIMARY KEY default nextval(
    'dba_fieldDescription_dba_fieldDescription_ID_seq'
  ),
  tableName varchar (75),
  fieldName varchar (75),
  fieldLabel varchar (200),
  fieldModel varchar (50),
  fieldNulls varchar (10),
  fieldType varchar (30),
  fieldKey varchar (10),
  fieldReferences varchar (200),
  fieldList varchar (50),
  fieldNotes text,
  fieldDefinition text,
  fieldKeywords text
);
----------------------------------------------------------------------------
-- CREATE dba_fieldList
----------------------------------------------------------------------------
CREATE SEQUENCE dba_fieldList_dba_fieldList_ID_seq;
CREATE TABLE dba_fieldList (
  dba_fieldList_ID integer NOT NULL PRIMARY KEY default nextval('dba_fieldList_dba_fieldList_ID_seq'),
  tableName varchar (75),
  fieldName varchar (75),
  listValue varchar (255),
  listValueDescription text,
  listValueSortOrder Float
);
----------------------------------------------------------------------------
-- CREATE dba_dataCache
----------------------------------------------------------------------------
CREATE SEQUENCE dba_dataCache_DBA_DATACACHE_ID_seq;
CREATE TABLE dba_dataCache (
  DBA_DATACACHE_ID integer NOT NULL PRIMARY KEY default nextval('dba_dataCache_DBA_DATACACHE_ID_seq'),
  cache_key varchar (200) NOT NULL,
  cache_label varchar (200),
  cache_order Float,
  data1 varchar (255),
  data2 varchar (255),
  data3 varchar (255),
  data4 varchar (255),
  data5 varchar (255),
  data6 varchar (255),
  data7 varchar (255),
  data8 varchar (255),
  data9 varchar (255),
  data10 varchar (255)
);
-- DOU: Add Missing Tables
CREATE TABLE temp_ks_commconcept_acccodelist (accessioncode character varying(255));
CREATE SEQUENCE dba_preassignacccode_dba_requestnumber_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;