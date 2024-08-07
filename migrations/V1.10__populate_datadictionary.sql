
    --
    -- This is a generated SQL script for postgresql
    --
    
    -- first delete any info out of the tables
    DELETE FROM dba_tableDescription;
    DELETE FROM dba_fieldDescription;
    DELETE FROM dba_fieldList;
   
    
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'commConcept',
        'Community Concept',
        'This table store the concepts (assertions) that are linked to community names through the commUsage table.',
        null,
        ' commConcept  Community Concept  This table store the concepts (assertions) that are linked to community names through the commUsage table.    COMMCONCEPT_ID  ID  COMMNAME_ID  Community Name  commName  Community Name  reference_ID  Reference  commDescription  Community Description  accessionCode  Accession Code  d_obscount  Plot Count  d_currentaccepted  Currently Accepted by Someone '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commConcept',
        'COMMCONCEPT_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the commConcept table.',
     
        ' commConcept  Community Concept  COMMCONCEPT_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the commConcept table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commConcept',
        'COMMNAME_ID',
        'Community Name',
        'logical',
        'no',
        'Integer',
        'FK',
        'commName.COMMNAME_ID',
        'no',
        'na',
        'Foreign key into the commName table providing the name used for the community when it was defined by usage in a publication (which could be this database).',
     
        ' commConcept  Community Concept  COMMNAME_ID  Community Name  logical  required  Integer  FK  commName.COMMNAME_ID  no  na  Foreign key into the commName table providing the name used for the community when it was defined by usage in a publication (which could be this database). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commConcept',
        'commName',
        'Community Name',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The name the community is based on, denorm of commName_ID',
     
        ' commConcept  Community Concept  commName  Community Name  denorm    text  n/a  n/a  no  n/a  The name the community is based on, denorm of commName_ID '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commConcept',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'n/a',
        'Foreign key into the Reference table to identify a reference in which the community was identified by a name.  This could be a regular publication, or a self reference created by completing the commDescription field in reference',
     
        ' commConcept  Community Concept  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  n/a  Foreign key into the Reference table to identify a reference in which the community was identified by a name.  This could be a regular publication, or a self reference created by completing the commDescription field in reference '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commConcept',
        'commDescription',
        'Community Description',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The commDescription is a description of the community concept by the party that contributed the concept.',
     
        ' commConcept  Community Concept  commDescription  Community Description  logical    text  n/a  n/a  no  n/a  The commDescription is a description of the community concept by the party that contributed the concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commConcept',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' commConcept  Community Concept  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commConcept',
        'd_obscount',
        'Plot Count',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Number of observations associated with this entity.',
     
        ' commConcept  Community Concept  d_obscount  Plot Count  denorm    Integer  n/a  n/a  no  n/a  Number of observations associated with this entity. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commConcept',
        'd_currentaccepted',
        'Currently Accepted by Someone',
        'denorm',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Currently accepted by at least one party.',
     
        ' commConcept  Community Concept  d_currentaccepted  Currently Accepted by Someone  denorm    Boolean  n/a  n/a  no  n/a  Currently accepted by at least one party. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'commCorrelation',
        'Community Correlation',
        'This table correlates multiple community concepts as they change through time in the perception of a party',
        null,
        ' commCorrelation  Community Correlation  This table correlates multiple community concepts as they change through time in the perception of a party    COMMCORRELATION_ID  ID  COMMSTATUS_ID  Community Status  COMMCONCEPT_ID  Community Concept  commConvergence  Community Convergence  correlationStart  Correlation Start  correlationStop  Correlation Stop '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commCorrelation',
        'COMMCORRELATION_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the communityCorrelation table.',
     
        ' commCorrelation  Community Correlation  COMMCORRELATION_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the communityCorrelation table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commCorrelation',
        'COMMSTATUS_ID',
        'Community Status',
        'logical',
        'no',
        'Integer',
        'FK',
        'commStatus.COMMSTATUS_ID',
        'no',
        'n/a',
        'This is the foreign key into the CommStatus table "pointing" to a concept no longer viewed as standard by the party.',
     
        ' commCorrelation  Community Correlation  COMMSTATUS_ID  Community Status  logical  required  Integer  FK  commStatus.COMMSTATUS_ID  no  n/a  This is the foreign key into the CommStatus table "pointing" to a concept no longer viewed as standard by the party. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commCorrelation',
        'COMMCONCEPT_ID',
        'Community Concept',
        'logical',
        'no',
        'Integer',
        'FK',
        'commConcept.COMMCONCEPT_ID',
        'no',
        'n/a',
        'This is the foreign key into the communityConcept table "pointing" to a concept recognized by the party as a "standard" concept.',
     
        ' commCorrelation  Community Correlation  COMMCONCEPT_ID  Community Concept  logical  required  Integer  FK  commConcept.COMMCONCEPT_ID  no  n/a  This is the foreign key into the communityConcept table "pointing" to a concept recognized by the party as a "standard" concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commCorrelation',
        'commConvergence',
        'Community Convergence',
        'logical',
        'no',
        'varchar (20)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'This is the descriptive attribute that is used to relate the congruence between two concepts.',
     
        ' commCorrelation  Community Correlation  commConvergence  Community Convergence  logical  required  varchar (20)  n/a  n/a  closed  n/a  This is the descriptive attribute that is used to relate the congruence between two concepts.  equal  The two concepts are exactly the same.  greater than  The reference concept (referenced in table:Status) fully contains the correlated concept (referenced in table:Concept), but also includes additional entities.  less than  The reference concept is fully included in the correlated concept, but the latter concept contains additional entities.  not equal  The two concepts are not exactly the same. This leaves the possibilities that the reference concept is greater than, less than, overlapping, similar, or disjunct relative to the correlated concept.  overlapping  The two concepts contain at least one common entity, and each concept also contains at least one entity that the other does not contain.  Neither concept is fully contained in the other.  similar  The two concepts contain at least one common individual.  disjunct  The two concepts in question contain no common entities.  undetermined  Although some correlation is likely, the party responsible for the this correlation has not made a determination. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commCorrelation',
                              'commConvergence',
                              'equal',
                              'The two concepts are exactly the same.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commCorrelation',
                              'commConvergence',
                              'greater than',
                              'The reference concept (referenced in table:Status) fully contains the correlated concept (referenced in table:Concept), but also includes additional entities.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commCorrelation',
                              'commConvergence',
                              'less than',
                              'The reference concept is fully included in the correlated concept, but the latter concept contains additional entities.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commCorrelation',
                              'commConvergence',
                              'not equal',
                              'The two concepts are not exactly the same. This leaves the possibilities that the reference concept is greater than, less than, overlapping, similar, or disjunct relative to the correlated concept.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commCorrelation',
                              'commConvergence',
                              'overlapping',
                              'The two concepts contain at least one common entity, and each concept also contains at least one entity that the other does not contain.  Neither concept is fully contained in the other.',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commCorrelation',
                              'commConvergence',
                              'similar',
                              'The two concepts contain at least one common individual.',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commCorrelation',
                              'commConvergence',
                              'disjunct',
                              'The two concepts in question contain no common entities.',
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commCorrelation',
                              'commConvergence',
                              'undetermined',
                              'Although some correlation is likely, the party responsible for the this correlation has not made a determination.',
                              '8'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commCorrelation',
        'correlationStart',
        'Correlation Start',
        'logical',
        'no',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the start date for recognition by a party of a correlation between two concepts.',
     
        ' commCorrelation  Community Correlation  correlationStart  Correlation Start  logical  required  Date  n/a  n/a  no  n/a  This is the start date for recognition by a party of a correlation between two concepts. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commCorrelation',
        'correlationStop',
        'Correlation Stop',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the stop date for recognition by a party of a correlation between two concepts.',
     
        ' commCorrelation  Community Correlation  correlationStop  Correlation Stop  logical    Date  n/a  n/a  no  n/a  This is the stop date for recognition by a party of a correlation between two concepts. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'commLineage',
        'Community Lineage',
        'This table stores tracks the lineage of vegetation community concepts.',
        null,
        ' commLineage  Community Lineage  This table stores tracks the lineage of vegetation community concepts.    COMMLINEAGE_ID  ID  parentCommStatus_ID  Parent Community Status  childCommStatus_ID  Child Community Status '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commLineage',
        'COMMLINEAGE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the commLineage table.',
     
        ' commLineage  Community Lineage  COMMLINEAGE_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the commLineage table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commLineage',
        'parentCommStatus_ID',
        'Parent Community Status',
        'logical',
        'no',
        'Integer',
        'FK',
        'commStatus.COMMSTATUS_ID',
        'no',
        'n/a',
        'This is the foreign key into the commStatus table "pointing" to a parent concept.',
     
        ' commLineage  Community Lineage  parentCommStatus_ID  Parent Community Status  logical  required  Integer  FK  commStatus.COMMSTATUS_ID  no  n/a  This is the foreign key into the commStatus table "pointing" to a parent concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commLineage',
        'childCommStatus_ID',
        'Child Community Status',
        'logical',
        'no',
        'Integer',
        'FK',
        'commStatus.COMMSTATUS_ID',
        'no',
        'n/a',
        'This is the foreign key into the commStatus table "pointing" to a child concept.',
     
        ' commLineage  Community Lineage  childCommStatus_ID  Child Community Status  logical  required  Integer  FK  commStatus.COMMSTATUS_ID  no  n/a  This is the foreign key into the commStatus table "pointing" to a child concept. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'commName',
        'Community Name',
        'This table stores vegetation community names',
        null,
        ' commName  Community Name  This table stores vegetation community names    COMMNAME_ID  ID  commName  Community Name  reference_ID  Reference  dateEntered  Date Entered '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commName',
        'COMMNAME_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the commName table.',
     
        ' commName  Community Name  COMMNAME_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the commName table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commName',
        'commName',
        'Community Name',
        'logical',
        'no',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The community name.',
     
        ' commName  Community Name  commName  Community Name  logical  required  text  n/a  n/a  no  n/a  The community name. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commName',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'n/a',
        'Foreign key into reference to identify the source of the name.',
     
        ' commName  Community Name  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  n/a  Foreign key into reference to identify the source of the name. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commName',
        'dateEntered',
        'Date Entered',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Field stores the date that the name was entered into the database.',
     
        ' commName  Community Name  dateEntered  Date Entered  logical    Date  n/a  n/a  no  n/a  Field stores the date that the name was entered into the database. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'commStatus',
        'Community Status',
        'This table store the status of a community concept as perceived by a party at a time.',
        null,
        ' commStatus  Community Status  This table store the status of a community concept as perceived by a party at a time.    COMMSTATUS_ID  ID  COMMCONCEPT_ID  Community Concept  reference_ID  Reference  commConceptStatus  Community Concept Status  commParent_ID  Community Parent  commLevel  Community Level  startDate  Start Date  stopDate  Stop Date  commPartyComments  Community Party Comments  PARTY_ID  Party  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'COMMSTATUS_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the commStatus table.',
     
        ' commStatus  Community Status  COMMSTATUS_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the commStatus table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'COMMCONCEPT_ID',
        'Community Concept',
        'logical',
        'no',
        'Integer',
        'FK',
        'commConcept.COMMCONCEPT_ID',
        'no',
        'n/a',
        'Foreign key to identify the concept to which a party assigns a status',
     
        ' commStatus  Community Status  COMMCONCEPT_ID  Community Concept  logical  required  Integer  FK  commConcept.COMMCONCEPT_ID  no  n/a  Foreign key to identify the concept to which a party assigns a status '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'n/a',
        'Link to a reference where the status was reported',
     
        ' commStatus  Community Status  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  n/a  Link to a reference where the status was reported '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'commConceptStatus',
        'Community Concept Status',
        'logical',
        'no',
        'varchar (20)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Status of the concept by the party (accepted, not accepted, undetermined)',
     
        ' commStatus  Community Status  commConceptStatus  Community Concept Status  logical  required  varchar (20)  n/a  n/a  closed  closed list  Status of the concept by the party (accepted, not accepted, undetermined)  accepted    not accepted    undetermined   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commConceptStatus',
                              'accepted',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commConceptStatus',
                              'not accepted',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commConceptStatus',
                              'undetermined',
                              null,
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'commParent_ID',
        'Community Parent',
        'logical',
        'yes',
        'Integer',
        'FK',
        'commConcept.COMMCONCEPT_ID',
        'no',
        'n/a',
        'The commParent is a recursive key to the concept of the parent level in the classification hierarchy.  For example, if this concept were at the association level, the parentClass would be a concept that is the parent alliance type.',
     
        ' commStatus  Community Status  commParent_ID  Community Parent  logical    Integer  FK  commConcept.COMMCONCEPT_ID  no  n/a  The commParent is a recursive key to the concept of the parent level in the classification hierarchy.  For example, if this concept were at the association level, the parentClass would be a concept that is the parent alliance type. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'commLevel',
        'Community Level',
        'logical',
        'yes',
        'varchar (80)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'The commLevel attribute specifies a level in the taxonomic hierarchy to which  a class belongs.  Field commLevel is an open list with the possible values defined by the classification system employed. If the party responsible for the record in the commStatus table is using the U.S. National Vegetation Classification, the acceptable levels are defined in the Vegetation Classification Standard of the Federal Geographic Data Committee as adopted June 1997. The standard is available at http://biology.usgs.gov/fgdc.veg/standards/vegstd.htm and the allowable entries for each of the physiognomic levels are listed in the appendix (see http://www.fgdc.gov/standards/documents/standards/vegetation/tables19-41.pdf). If the Braun-Blanquet classification system is employed, the acceptable values are defined in the International Code of Phytosociological Nomenclature (Weber, H.E., Moravec, J. Theurillat, J.-P. 2000. Journal of Vegetation Science. 11: 739-769).',
     
        ' commStatus  Community Status  commLevel  Community Level  logical    varchar (80)  n/a  n/a  closed  closed list  The commLevel attribute specifies a level in the taxonomic hierarchy to which  a class belongs.  Field commLevel is an open list with the possible values defined by the classification system employed. If the party responsible for the record in the commStatus table is using the U.S. National Vegetation Classification, the acceptable levels are defined in the Vegetation Classification Standard of the Federal Geographic Data Committee as adopted June 1997. The standard is available at http://biology.usgs.gov/fgdc.veg/standards/vegstd.htm and the allowable entries for each of the physiognomic levels are listed in the appendix (see http://www.fgdc.gov/standards/documents/standards/vegetation/tables19-41.pdf). If the Braun-Blanquet classification system is employed, the acceptable values are defined in the International Code of Phytosociological Nomenclature (Weber, H.E., Moravec, J. Theurillat, J.-P. 2000. Journal of Vegetation Science. 11: 739-769).  alliance  A grouping of associations with a characteristic physiognomy and habitat and which share one or more diagnostic species typically found in the uppermost or dominant stratum of the vegetation. (This definition includes both floristic and physiognomic criteria, in keeping with the integrated physiognomic-floristic hierarchy of the NVC.  It is similar to the FGDC 1997 definition:  a physiognomically uniform group of Associations sharing one or more diagnostic (dominant, differential, indicator, or character) species, which, as a rule, are found in the uppermost stratum of the vegetation.)  association  A recurring plant community with a characteristic range in species composition, specific diagnostic species, and a defined range in habitat conditions and physiognomy or structure.  Physiognomic class  the first physiognomic level in the NVC hierarchy; based on the structure of the vegetation and determined by the relative percentage of cover and the height of the dominant, life forms (Grossman et al. 1998).  formation  a level in the NVC based on physiognomic grouping of vegetation units with broadly defined environmental and additional physiognomic factors in common. (FGDC 1997).  Grossman et al. (1998) clarified this definition as a level in the classification hierarchy below subgroup which represents vegetation types that share a definite physiognomy or structure within broadly defined environmental factors, relative landscape positions, or hydrologic regimes.   Both of these definitions derive from Whittaker 1962: a "community type defined by dominance of a given growth form in the uppermost stratum of the community, or by a combination of dominant growth forms."  Physiognomic group  the level in the classification hierarchy below subclass based on leaf characters and identified and named in conjunction with broadly defined macroclimatic types to provide a structural-geographic orientation (Grossman et al. 1998).  other    phase    Physiognomic subclass    subassociation    subgroup    order   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'Physiognomic class',
                              'the first physiognomic level in the NVC hierarchy; based on the structure of the vegetation and determined by the relative percentage of cover and the height of the dominant, life forms (Grossman et al. 1998).',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'Physiognomic subclass',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'Physiognomic group',
                              'the level in the classification hierarchy below subclass based on leaf characters and identified and named in conjunction with broadly defined macroclimatic types to provide a structural-geographic orientation (Grossman et al. 1998).',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'subgroup',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'formation',
                              'a level in the NVC based on physiognomic grouping of vegetation units with broadly defined environmental and additional physiognomic factors in common. (FGDC 1997).  Grossman et al. (1998) clarified this definition as a level in the classification hierarchy below subgroup which represents vegetation types that share a definite physiognomy or structure within broadly defined environmental factors, relative landscape positions, or hydrologic regimes.   Both of these definitions derive from Whittaker 1962: a "community type defined by dominance of a given growth form in the uppermost stratum of the community, or by a combination of dominant growth forms."',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'alliance',
                              'A grouping of associations with a characteristic physiognomy and habitat and which share one or more diagnostic species typically found in the uppermost or dominant stratum of the vegetation. (This definition includes both floristic and physiognomic criteria, in keeping with the integrated physiognomic-floristic hierarchy of the NVC.  It is similar to the FGDC 1997 definition:  a physiognomically uniform group of Associations sharing one or more diagnostic (dominant, differential, indicator, or character) species, which, as a rule, are found in the uppermost stratum of the vegetation.)',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'association',
                              'A recurring plant community with a characteristic range in species composition, specific diagnostic species, and a defined range in habitat conditions and physiognomy or structure.',
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'subassociation',
                              null,
                              '8'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'phase',
                              null,
                              '9'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'order',
                              null,
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commStatus',
                              'commLevel',
                              'other',
                              null,
                              '11'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'startDate',
        'Start Date',
        'logical',
        'no',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the date for which the status assignment by the party started.',
     
        ' commStatus  Community Status  startDate  Start Date  logical  required  Date  n/a  n/a  no  n/a  This is the date for which the status assignment by the party started. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'stopDate',
        'Stop Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the date for which the status assignment by the party ended.',
     
        ' commStatus  Community Status  stopDate  Stop Date  logical    Date  n/a  n/a  no  n/a  This is the date for which the status assignment by the party ended. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'commPartyComments',
        'Community Party Comments',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Comments by party providing rationale for status assignment',
     
        ' commStatus  Community Status  commPartyComments  Community Party Comments  logical    text  n/a  n/a  no  n/a  Comments by party providing rationale for status assignment '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'PARTY_ID',
        'Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'n/a',
        'Foreign key that identifies the party that made the status assignment',
     
        ' commStatus  Community Status  PARTY_ID  Party  logical  required  Integer  FK  party.PARTY_ID  no  n/a  Foreign key that identifies the party that made the status assignment '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commStatus',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' commStatus  Community Status  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'commUsage',
        'Community Usage',
        'This table links a community name with a concept.',
        null,
        ' commUsage  Community Usage  This table links a community name with a concept.    COMMUSAGE_ID  ID  COMMNAME_ID  Community Name  commName  Community Name  COMMCONCEPT_ID  Community Concept  usageStart  Usage Start  usageStop  Usage Stop  commNameStatus  Community Name Status  classSystem  Class System  PARTY_ID  Party  COMMSTATUS_ID  Comm Status '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commUsage',
        'COMMUSAGE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the communityUsage table.',
     
        ' commUsage  Community Usage  COMMUSAGE_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the communityUsage table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commUsage',
        'COMMNAME_ID',
        'Community Name',
        'logical',
        'no',
        'Integer',
        'FK',
        'commName.COMMNAME_ID',
        'no',
        'n/a',
        'This field is the foreign key into the commName table.',
     
        ' commUsage  Community Usage  COMMNAME_ID  Community Name  logical  required  Integer  FK  commName.COMMNAME_ID  no  n/a  This field is the foreign key into the commName table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commUsage',
        'commName',
        'Community Name',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the community Name that the party uses for this community, of the type indicated in classSystem.',
     
        ' commUsage  Community Usage  commName  Community Name  denorm    text  n/a  n/a  no  n/a  This is the community Name that the party uses for this community, of the type indicated in classSystem. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commUsage',
        'COMMCONCEPT_ID',
        'Community Concept',
        'denorm',
        'yes',
        'Integer',
        'FK',
        'commConcept.COMMCONCEPT_ID',
        'no',
        'n/a',
        'This field is the foreign key into the commConcept table.',
     
        ' commUsage  Community Usage  COMMCONCEPT_ID  Community Concept  denorm    Integer  FK  commConcept.COMMCONCEPT_ID  no  n/a  This field is the foreign key into the commConcept table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commUsage',
        'usageStart',
        'Usage Start',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the date on which the party applied the name to the concept.',
     
        ' commUsage  Community Usage  usageStart  Usage Start  logical    Date  n/a  n/a  no  n/a  This is the date on which the party applied the name to the concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commUsage',
        'usageStop',
        'Usage Stop',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the date on which the party ceased to apply the name to the concept.',
     
        ' commUsage  Community Usage  usageStop  Usage Stop  logical    Date  n/a  n/a  no  n/a  This is the date on which the party ceased to apply the name to the concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commUsage',
        'commNameStatus',
        'Community Name Status',
        'logical',
        'yes',
        'varchar (20)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'This field shows the status of the application of the name to the concept by the party (standard, not standard, undetermined).',
     
        ' commUsage  Community Usage  commNameStatus  Community Name Status  logical    varchar (20)  n/a  n/a  closed  closed list  This field shows the status of the application of the name to the concept by the party (standard, not standard, undetermined).  not standard    standard    undetermined   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commUsage',
                              'commNameStatus',
                              'standard',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commUsage',
                              'commNameStatus',
                              'not standard',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commUsage',
                              'commNameStatus',
                              'undetermined',
                              null,
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commUsage',
        'classSystem',
        'Class System',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'open',
        'Like FGDC of Forest Cover Class.',
        'This is the name of the classification system wherein the name is applied (e.g., Scientific, Spanish common).',
     
        ' commUsage  Community Usage  classSystem  Class System  logical    varchar (50)  n/a  n/a  open  Like FGDC of Forest Cover Class.  This is the name of the classification system wherein the name is applied (e.g., Scientific, Spanish common).  Code  Ecological Society of American Vegetation Classification Panel. 2003. Guidelines ver. 2  Common  Ecological Society of American Vegetation Classification Panel. 2003. Guidelines ver. 2  Other    Scientific  Ecological Society of American Vegetation Classification Panel. 2003. Guidelines ver. 2  Translated  Ecological Society of American Vegetation Classification Panel. 2003. Guidelines ver. 2 '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commUsage',
                              'classSystem',
                              'Scientific',
                              'Ecological Society of American Vegetation Classification Panel. 2003. Guidelines ver. 2',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commUsage',
                              'classSystem',
                              'Translated',
                              'Ecological Society of American Vegetation Classification Panel. 2003. Guidelines ver. 2',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commUsage',
                              'classSystem',
                              'Code',
                              'Ecological Society of American Vegetation Classification Panel. 2003. Guidelines ver. 2',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commUsage',
                              'classSystem',
                              'Common',
                              'Ecological Society of American Vegetation Classification Panel. 2003. Guidelines ver. 2',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commUsage',
                              'classSystem',
                              'Other',
                              null,
                              '6'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commUsage',
        'PARTY_ID',
        'Party',
        'denorm',
        'yes',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'n/a',
        'Foreign key that identifies the party that used the class concept with the name.',
     
        ' commUsage  Community Usage  PARTY_ID  Party  denorm    Integer  FK  party.PARTY_ID  no  n/a  Foreign key that identifies the party that used the class concept with the name. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commUsage',
        'COMMSTATUS_ID',
        'Comm Status',
        'logical',
        'yes',
        'Integer',
        'FK',
        'commStatus.COMMSTATUS_ID',
        'no',
        'n/a',
        'Comm Status which applies to this commUsage.',
     
        ' commUsage  Community Usage  COMMSTATUS_ID  Comm Status  logical    Integer  FK  commStatus.COMMSTATUS_ID  no  n/a  Comm Status which applies to this commUsage. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'plantConcept',
        'Plant Concept',
        'This table store the concepts that are linked to plant names through the plantUsage table.',
        null,
        ' plantConcept  Plant Concept  This table store the concepts that are linked to plant names through the plantUsage table.    PLANTCONCEPT_ID  ID  PLANTNAME_ID  Plant Name  reference_ID  Reference  plantname  Plant Name  plantCode  Plant Code  plantDescription  Plant Description  accessionCode  Accession Code  d_obscount  Plot Count  d_currentaccepted  Currently Accepted by Someone '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantConcept',
        'PLANTCONCEPT_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the commConcept table.',
     
        ' plantConcept  Plant Concept  PLANTCONCEPT_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the commConcept table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantConcept',
        'PLANTNAME_ID',
        'Plant Name',
        'logical',
        'no',
        'Integer',
        'FK',
        'plantName.PLANTNAME_ID',
        'no',
        'n/a',
        'This is a foreign key into the plant name list, the entry in which when combined with a reference constitutes a concept.',
     
        ' plantConcept  Plant Concept  PLANTNAME_ID  Plant Name  logical  required  Integer  FK  plantName.PLANTNAME_ID  no  n/a  This is a foreign key into the plant name list, the entry in which when combined with a reference constitutes a concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantConcept',
        'reference_ID',
        'Reference',
        'logical',
        'no',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'n/a',
        'This is a foreign key to the reference in which the name was used, thereby defining a concept.',
     
        ' plantConcept  Plant Concept  reference_ID  Reference  logical  required  Integer  FK  reference.reference_ID  no  n/a  This is a foreign key to the reference in which the name was used, thereby defining a concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantConcept',
        'plantname',
        'Plant Name',
        'denorm',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the name of the plant upon which the concept is based.',
     
        ' plantConcept  Plant Concept  plantname  Plant Name  denorm    varchar (200)  n/a  n/a  no  n/a  This is the name of the plant upon which the concept is based. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantConcept',
        'plantCode',
        'Plant Code',
        'implementation',
        'yes',
        'varchar (23)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' plantConcept  Plant Concept  plantCode  Plant Code  implementation    varchar (23)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantConcept',
        'plantDescription',
        'Plant Description',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The plantDescription is a description of the plantConcept by the party contributing the plantConcept.',
     
        ' plantConcept  Plant Concept  plantDescription  Plant Description  logical    text  n/a  n/a  no  n/a  The plantDescription is a description of the plantConcept by the party contributing the plantConcept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantConcept',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' plantConcept  Plant Concept  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantConcept',
        'd_obscount',
        'Plot Count',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Number of observations associated with this entity.',
     
        ' plantConcept  Plant Concept  d_obscount  Plot Count  denorm    Integer  n/a  n/a  no  n/a  Number of observations associated with this entity. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantConcept',
        'd_currentaccepted',
        'Currently Accepted by Someone',
        'denorm',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Currently accepted by at least one party.',
     
        ' plantConcept  Plant Concept  d_currentaccepted  Currently Accepted by Someone  denorm    Boolean  n/a  n/a  no  n/a  Currently accepted by at least one party. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'plantCorrelation',
        'Plant Correlation',
        'This table correlates multiple plant concepts as they change through time.',
        null,
        ' plantCorrelation  Plant Correlation  This table correlates multiple plant concepts as they change through time.    PLANTCORRELATION_ID  ID  PLANTSTATUS_ID  Plant Status  PLANTCONCEPT_ID  Plant Concept  plantConvergence  Plant Convergence  correlationStart  Correlation Start  correlationStop  Correlation Stop '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantCorrelation',
        'PLANTCORRELATION_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the plantCorrelation table.',
     
        ' plantCorrelation  Plant Correlation  PLANTCORRELATION_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the plantCorrelation table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantCorrelation',
        'PLANTSTATUS_ID',
        'Plant Status',
        'logical',
        'no',
        'Integer',
        'FK',
        'plantStatus.PLANTSTATUS_ID',
        'no',
        'n/a',
        'This is the foreign key into the plantStatus table "pointing" to a concept no longer viewed as standard by the party.',
     
        ' plantCorrelation  Plant Correlation  PLANTSTATUS_ID  Plant Status  logical  required  Integer  FK  plantStatus.PLANTSTATUS_ID  no  n/a  This is the foreign key into the plantStatus table "pointing" to a concept no longer viewed as standard by the party. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantCorrelation',
        'PLANTCONCEPT_ID',
        'Plant Concept',
        'logical',
        'no',
        'Integer',
        'FK',
        'plantConcept.PLANTCONCEPT_ID',
        'no',
        'n/a',
        'This is the foreign key into the plantConcept table "pointing" to a concept recognized by the party as a "standard" concept.',
     
        ' plantCorrelation  Plant Correlation  PLANTCONCEPT_ID  Plant Concept  logical  required  Integer  FK  plantConcept.PLANTCONCEPT_ID  no  n/a  This is the foreign key into the plantConcept table "pointing" to a concept recognized by the party as a "standard" concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantCorrelation',
        'plantConvergence',
        'Plant Convergence',
        'logical',
        'no',
        'varchar (20)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'This is the descriptive attribute that is used to relate the congruence between two concepts.  The concept that is represented in the party perspective, via the Status_ID field is [this field, i.e. <,>,=] the concept represented in Concept_ID field.  As normally used, (no Longer Valid Concept) [convergence] (Valid Concept).  For example, if a concept is split, the convergence would be ''greater than'' (The old concept is ''greater than'' the new concept).',
     
        ' plantCorrelation  Plant Correlation  plantConvergence  Plant Convergence  logical  required  varchar (20)  n/a  n/a  closed  closed list  This is the descriptive attribute that is used to relate the congruence between two concepts.  The concept that is represented in the party perspective, via the Status_ID field is [this field, i.e. <,>,=] the concept represented in Concept_ID field.  As normally used, (no Longer Valid Concept) [convergence] (Valid Concept).  For example, if a concept is split, the convergence would be ''greater than'' (The old concept is ''greater than'' the new concept).  equal  The two concepts are exactly the same.  greater than  The reference concept (referenced in table:Status) fully contains the correlated concept (referenced in table:Concept), but also includes additional entities.  less than  The reference concept is fully included in the correlated concept, but the latter concept contains additional entities.  not equal  The two concepts, are not exactly the same. This leaves the possibilities that the reference concept is greater than, less than, overlapping, similar, or disjunct relative to the correlated concept.  overlapping  The two concepts contain at least one common individual, and each concept also contains at least one individual that the other does not contain. Neither concept is fully contained in the other.  similar  The two concepts contain at least one common individual.  disjunct  The two concepts in question contain no common individuals.  undetermined  Although some correlation is likely, the party responsible for the this correlation has not made a determination. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantCorrelation',
                              'plantConvergence',
                              'equal',
                              'The two concepts are exactly the same.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantCorrelation',
                              'plantConvergence',
                              'greater than',
                              'The reference concept (referenced in table:Status) fully contains the correlated concept (referenced in table:Concept), but also includes additional entities.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantCorrelation',
                              'plantConvergence',
                              'less than',
                              'The reference concept is fully included in the correlated concept, but the latter concept contains additional entities.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantCorrelation',
                              'plantConvergence',
                              'not equal',
                              'The two concepts, are not exactly the same. This leaves the possibilities that the reference concept is greater than, less than, overlapping, similar, or disjunct relative to the correlated concept.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantCorrelation',
                              'plantConvergence',
                              'overlapping',
                              'The two concepts contain at least one common individual, and each concept also contains at least one individual that the other does not contain. Neither concept is fully contained in the other.',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantCorrelation',
                              'plantConvergence',
                              'similar',
                              'The two concepts contain at least one common individual.',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantCorrelation',
                              'plantConvergence',
                              'disjunct',
                              'The two concepts in question contain no common individuals.',
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantCorrelation',
                              'plantConvergence',
                              'undetermined',
                              'Although some correlation is likely, the party responsible for the this correlation has not made a determination.',
                              '8'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantCorrelation',
        'correlationStart',
        'Correlation Start',
        'logical',
        'no',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the start date for recognition by a party of a correlation between two concepts.',
     
        ' plantCorrelation  Plant Correlation  correlationStart  Correlation Start  logical  required  Date  n/a  n/a  no  n/a  This is the start date for recognition by a party of a correlation between two concepts. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantCorrelation',
        'correlationStop',
        'Correlation Stop',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the stop date for recognition by a party of a correlation between two concepts.',
     
        ' plantCorrelation  Plant Correlation  correlationStop  Correlation Stop  logical    Date  n/a  n/a  no  n/a  This is the stop date for recognition by a party of a correlation between two concepts. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'plantLineage',
        'Plant Lineage',
        'This table stores tracks the lineage of plant taxon concepts.',
        null,
        ' plantLineage  Plant Lineage  This table stores tracks the lineage of plant taxon concepts.    PLANTLINEAGE_ID  ID  childPlantStatus_ID  Child Plant Status  parentPlantStatus_ID  Parent Plant Status '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantLineage',
        'PLANTLINEAGE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the plantLineage table.',
     
        ' plantLineage  Plant Lineage  PLANTLINEAGE_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the plantLineage table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantLineage',
        'childPlantStatus_ID',
        'Child Plant Status',
        'logical',
        'no',
        'Integer',
        'FK',
        'plantStatus.PLANTSTATUS_ID',
        'no',
        'n/a',
        'This is the foreign key into the plantStatus table "pointing" to a child concept.',
     
        ' plantLineage  Plant Lineage  childPlantStatus_ID  Child Plant Status  logical  required  Integer  FK  plantStatus.PLANTSTATUS_ID  no  n/a  This is the foreign key into the plantStatus table "pointing" to a child concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantLineage',
        'parentPlantStatus_ID',
        'Parent Plant Status',
        'logical',
        'no',
        'Integer',
        'FK',
        'plantStatus.PLANTSTATUS_ID',
        'no',
        'n/a',
        'This is the foreign key into the plantStatus table "pointing" to a parent concept.',
     
        ' plantLineage  Plant Lineage  parentPlantStatus_ID  Parent Plant Status  logical  required  Integer  FK  plantStatus.PLANTSTATUS_ID  no  n/a  This is the foreign key into the plantStatus table "pointing" to a parent concept. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'plantName',
        'Plant Name',
        'This table stores plant names',
        null,
        ' plantName  Plant Name  This table stores plant names    PLANTNAME_ID  ID  plantName  Plant Name  reference_ID  Reference  dateEntered  Date Entered '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantName',
        'PLANTNAME_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the plantName table.',
     
        ' plantName  Plant Name  PLANTNAME_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the plantName table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantName',
        'plantName',
        'Plant Name',
        'logical',
        'no',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The plant name.',
     
        ' plantName  Plant Name  plantName  Plant Name  logical  required  varchar (255)  n/a  n/a  no  n/a  The plant name. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantName',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'n/a',
        'Foreign key into the reference table to identify the original source of the name (usually the type description).',
     
        ' plantName  Plant Name  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  n/a  Foreign key into the reference table to identify the original source of the name (usually the type description). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantName',
        'dateEntered',
        'Date Entered',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Field stores the date that the name was entered into the database.',
     
        ' plantName  Plant Name  dateEntered  Date Entered  logical    Date  n/a  n/a  no  n/a  Field stores the date that the name was entered into the database. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'plantStatus',
        'Plant Status',
        'This table store the status of a community concept as perceived by a party at a time.',
        null,
        ' plantStatus  Plant Status  This table store the status of a community concept as perceived by a party at a time.    PLANTSTATUS_ID  ID  PLANTCONCEPT_ID  Plant Concept  reference_ID  Reference  plantConceptStatus  Plant Concept Status  startDate  Start Date  stopDate  Stop Date  plantPartyComments  Plant Party Comments  plantParentName  Plant Parent Name  plantParentConcept_id  Plant Parent Concept_id  plantParent_ID  Plant Parent  plantLevel  Plant Level  PARTY_ID  Party  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'PLANTSTATUS_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the plantStatus table.',
     
        ' plantStatus  Plant Status  PLANTSTATUS_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the plantStatus table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'PLANTCONCEPT_ID',
        'Plant Concept',
        'logical',
        'no',
        'Integer',
        'FK',
        'plantConcept.PLANTCONCEPT_ID',
        'no',
        'n/a',
        'Foreign key to identify the concept to which a party assigns a status',
     
        ' plantStatus  Plant Status  PLANTCONCEPT_ID  Plant Concept  logical  required  Integer  FK  plantConcept.PLANTCONCEPT_ID  no  n/a  Foreign key to identify the concept to which a party assigns a status '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'n/a',
        'Link to a reference where the status was reported',
     
        ' plantStatus  Plant Status  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  n/a  Link to a reference where the status was reported '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'plantConceptStatus',
        'Plant Concept Status',
        'logical',
        'no',
        'varchar (20)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Status of the concept by the party (accepted, not accepted, undetermined)',
     
        ' plantStatus  Plant Status  plantConceptStatus  Plant Concept Status  logical  required  varchar (20)  n/a  n/a  closed  closed list  Status of the concept by the party (accepted, not accepted, undetermined)  accepted    not accepted    undetermined   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantConceptStatus',
                              'accepted',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantConceptStatus',
                              'not accepted',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantConceptStatus',
                              'undetermined',
                              null,
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'startDate',
        'Start Date',
        'logical',
        'no',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the date for which the status assignment by the party started.',
     
        ' plantStatus  Plant Status  startDate  Start Date  logical  required  Date  n/a  n/a  no  n/a  This is the date for which the status assignment by the party started. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'stopDate',
        'Stop Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the date for which the status assignment by the party ended.',
     
        ' plantStatus  Plant Status  stopDate  Stop Date  logical    Date  n/a  n/a  no  n/a  This is the date for which the status assignment by the party ended. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'plantPartyComments',
        'Plant Party Comments',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Comments by party providing rationale for status assignment',
     
        ' plantStatus  Plant Status  plantPartyComments  Plant Party Comments  logical    text  n/a  n/a  no  n/a  Comments by party providing rationale for status assignment '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'plantParentName',
        'Plant Parent Name',
        'implementation',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' plantStatus  Plant Status  plantParentName  Plant Parent Name  implementation    varchar (200)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'plantParentConcept_id',
        'Plant Parent Concept_id',
        'implementation',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' plantStatus  Plant Status  plantParentConcept_id  Plant Parent Concept_id  implementation    Integer  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'plantParent_ID',
        'Plant Parent',
        'logical',
        'yes',
        'Integer',
        'FK',
        'plantConcept.PLANTCONCEPT_ID',
        'no',
        'n/a',
        'The plantParent is a recursive key to the concept of the parent level in the classification hierarchy.  For example if this plantConcept were at the genus level the plantParent would be the plantConcept that is the family level (or subfamily level).',
     
        ' plantStatus  Plant Status  plantParent_ID  Plant Parent  logical    Integer  FK  plantConcept.PLANTCONCEPT_ID  no  n/a  The plantParent is a recursive key to the concept of the parent level in the classification hierarchy.  For example if this plantConcept were at the genus level the plantParent would be the plantConcept that is the family level (or subfamily level). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'plantLevel',
        'Plant Level',
        'logical',
        'yes',
        'varchar (80)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'The classLevel attribute specifies a level in the taxonomic hierarchy that a class belongs.',
     
        ' plantStatus  Plant Status  plantLevel  Plant Level  logical    varchar (80)  n/a  n/a  closed  n/a  The classLevel attribute specifies a level in the taxonomic hierarchy that a class belongs.  Class    Cultivar/Forma    Division    Family    Genus    Kingdom    Order    Section    Species    Species Aggregate    Subclass    Subfamily    Subgenus    Subkingdom    Suborder    Subspecies    Subtribe    Superdivision    Tribe    Variety   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Kingdom',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Subkingdom',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Superdivision',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Division',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Class',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Subclass',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Order',
                              null,
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Suborder',
                              null,
                              '8'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Family',
                              null,
                              '9'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Subfamily',
                              null,
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Tribe',
                              null,
                              '11'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Subtribe',
                              null,
                              '12'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Genus',
                              null,
                              '13'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Subgenus',
                              null,
                              '14'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Section',
                              null,
                              '15'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Species Aggregate',
                              null,
                              '16'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Species',
                              null,
                              '17'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Subspecies',
                              null,
                              '18'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Variety',
                              null,
                              '19'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantStatus',
                              'plantLevel',
                              'Cultivar/Forma',
                              null,
                              '20'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'PARTY_ID',
        'Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'n/a',
        'Foreign key that identifies the party that made the status assignment',
     
        ' plantStatus  Plant Status  PARTY_ID  Party  logical  required  Integer  FK  party.PARTY_ID  no  n/a  Foreign key that identifies the party that made the status assignment '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantStatus',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' plantStatus  Plant Status  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'plantUsage',
        'Plant Usage',
        'This table links a plant name with a concept.',
        null,
        ' plantUsage  Plant Usage  This table links a plant name with a concept.    PLANTUSAGE_ID  ID  PLANTNAME_ID  Plant Name  PLANTCONCEPT_ID  Plant Concept  usageStart  Usage Start  usageStop  Usage Stop  plantNameStatus  Plant Name Status  plantName  Plant Name  classSystem  Class System  acceptedSynonym  Accepted Synonym  PARTY_ID  Party  PLANTSTATUS_ID  Plant Status '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'PLANTUSAGE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database assigned value to each unique record in the plantUsage table.',
     
        ' plantUsage  Plant Usage  PLANTUSAGE_ID  ID  logical    serial  PK  n/a  no  n/a  Database assigned value to each unique record in the plantUsage table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'PLANTNAME_ID',
        'Plant Name',
        'logical',
        'no',
        'Integer',
        'FK',
        'plantName.PLANTNAME_ID',
        'no',
        'n/a',
        'This field is the foreign key into the plantName table.',
     
        ' plantUsage  Plant Usage  PLANTNAME_ID  Plant Name  logical  required  Integer  FK  plantName.PLANTNAME_ID  no  n/a  This field is the foreign key into the plantName table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'PLANTCONCEPT_ID',
        'Plant Concept',
        'denorm',
        'yes',
        'Integer',
        'FK',
        'plantConcept.PLANTCONCEPT_ID',
        'no',
        'n/a',
        'This field is the foreign key into the plantConcept table.',
     
        ' plantUsage  Plant Usage  PLANTCONCEPT_ID  Plant Concept  denorm    Integer  FK  plantConcept.PLANTCONCEPT_ID  no  n/a  This field is the foreign key into the plantConcept table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'usageStart',
        'Usage Start',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the date on which the party applied the name to the concept.',
     
        ' plantUsage  Plant Usage  usageStart  Usage Start  logical    Date  n/a  n/a  no  n/a  This is the date on which the party applied the name to the concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'usageStop',
        'Usage Stop',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the date on which the party ceased to apply the name to the concept.',
     
        ' plantUsage  Plant Usage  usageStop  Usage Stop  logical    Date  n/a  n/a  no  n/a  This is the date on which the party ceased to apply the name to the concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'plantNameStatus',
        'Plant Name Status',
        'logical',
        'yes',
        'varchar (20)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'This field shows the status of the application of the name to the concept by the party (standard, not standard, undetermined).',
     
        ' plantUsage  Plant Usage  plantNameStatus  Plant Name Status  logical    varchar (20)  n/a  n/a  closed  n/a  This field shows the status of the application of the name to the concept by the party (standard, not standard, undetermined).  not standard    standard    undetermined   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantUsage',
                              'plantNameStatus',
                              'standard',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantUsage',
                              'plantNameStatus',
                              'not standard',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantUsage',
                              'plantNameStatus',
                              'undetermined',
                              null,
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'plantName',
        'Plant Name',
        'denorm',
        'yes',
        'varchar (220)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the plant name that the party uses for this plant concept, in the name system indicated in classSystem.',
     
        ' plantUsage  Plant Usage  plantName  Plant Name  denorm    varchar (220)  n/a  n/a  no  n/a  This is the plant name that the party uses for this plant concept, in the name system indicated in classSystem. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'classSystem',
        'Class System',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'open',
        'closed list',
        'This is the name of the classification system wherein the name is applied (e.g., EnglishCommon or Scientific).',
     
        ' plantUsage  Plant Usage  classSystem  Class System  logical    varchar (50)  n/a  n/a  open  closed list  This is the name of the classification system wherein the name is applied (e.g., EnglishCommon or Scientific).  Code    English Common    Other    Scientific    Scientific without authors    Spanish Common    French Common   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantUsage',
                              'classSystem',
                              'Scientific',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantUsage',
                              'classSystem',
                              'Scientific without authors',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantUsage',
                              'classSystem',
                              'Code',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantUsage',
                              'classSystem',
                              'English Common',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantUsage',
                              'classSystem',
                              'Spanish Common',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantUsage',
                              'classSystem',
                              'Other',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plantUsage',
                              'classSystem',
                              'French Common',
                              null,
                              '7'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'acceptedSynonym',
        'Accepted Synonym',
        'implementation',
        'yes',
        'varchar (220)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' plantUsage  Plant Usage  acceptedSynonym  Accepted Synonym  implementation    varchar (220)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'PARTY_ID',
        'Party',
        'denorm',
        'yes',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'n/a',
        'Foreign key that identifies  the party that uses the concept with the name.',
     
        ' plantUsage  Plant Usage  PARTY_ID  Party  denorm    Integer  FK  party.PARTY_ID  no  n/a  Foreign key that identifies  the party that uses the concept with the name. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plantUsage',
        'PLANTSTATUS_ID',
        'Plant Status',
        'logical',
        'yes',
        'Integer',
        'FK',
        'plantStatus.PLANTSTATUS_ID',
        'no',
        'n/a',
        'Plant Status which applies to this plantUsage.',
     
        ' plantUsage  Plant Usage  PLANTSTATUS_ID  Plant Status  logical    Integer  FK  plantStatus.PLANTSTATUS_ID  no  n/a  Plant Status which applies to this plantUsage. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'address',
        'Address',
        'This table contains the postal address, email address and/or organizational affiliation for a parties at the time of a plot event.',
        null,
        ' address  Address  This table contains the postal address, email address and/or organizational affiliation for a parties at the time of a plot event.    ADDRESS_ID  ID  party_ID  Party  organization_ID  Organization  orgPosition  Organization Position  email  Email  deliveryPoint  Delivery Point  city  City  administrativeArea  Administrative Area  postalCode  Postal Code  country  Country  currentFlag  Address is Current?  addressStartDate  Address Start Date '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'ADDRESS_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the address table.',
        'Database generated identifier assigned to each unique party address (note that a single party may have multiple addresses but that only one may be ''current'').',
     
        ' address  Address  ADDRESS_ID  ID  logical    serial  PK  n/a  no  Primary key for the address table.  Database generated identifier assigned to each unique party address (note that a single party may have multiple addresses but that only one may be ''current''). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'party_ID',
        'Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'Foreign key into the party table.',
        'Link to the party to which this address applies',
     
        ' address  Address  party_ID  Party  logical  required  Integer  FK  party.PARTY_ID  no  Foreign key into the party table.  Link to the party to which this address applies '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'organization_ID',
        'Organization',
        'logical',
        'yes',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'Foreign key into the party table',
        'Link to an organization with which a party is affiliated',
     
        ' address  Address  organization_ID  Organization  logical    Integer  FK  party.PARTY_ID  no  Foreign key into the party table  Link to an organization with which a party is affiliated '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'orgPosition',
        'Organization Position',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Position of party within organization.',
     
        ' address  Address  orgPosition  Organization Position  logical    varchar (50)  n/a  n/a  no  n/a  Position of party within organization. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'email',
        'Email',
        'logical',
        'yes',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'email address',
     
        ' address  Address  email  Email  logical    varchar (100)  n/a  n/a  no  n/a  email address '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'deliveryPoint',
        'Delivery Point',
        'logical',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Address line for the location (Street name, box number, suite).',
     
        ' address  Address  deliveryPoint  Delivery Point  logical    varchar (200)  n/a  n/a  no  n/a  Address line for the location (Street name, box number, suite). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'city',
        'City',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'City of the location.',
     
        ' address  Address  city  City  logical    varchar (50)  n/a  n/a  no  n/a  City of the location. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'administrativeArea',
        'Administrative Area',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'State, province of the location.',
     
        ' address  Address  administrativeArea  Administrative Area  logical    varchar (50)  n/a  n/a  no  n/a  State, province of the location. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'postalCode',
        'Postal Code',
        'logical',
        'yes',
        'varchar (10)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Zip code or other postal code.',
     
        ' address  Address  postalCode  Postal Code  logical    varchar (10)  n/a  n/a  no  n/a  Zip code or other postal code. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'country',
        'Country',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Country of the physical address.',
     
        ' address  Address  country  Country  logical    varchar (50)  n/a  n/a  no  n/a  Country of the physical address. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'currentFlag',
        'Address is Current?',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This flag signifies whether the address is the current address of the party.',
     
        ' address  Address  currentFlag  Address is Current?  logical    Boolean  n/a  n/a  no  n/a  This flag signifies whether the address is the current address of the party. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'address',
        'addressStartDate',
        'Address Start Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The first database date on which the address/organization information applied (have a discrete date on which address is known to applied - not necessarily the first date on which the address applied).',
     
        ' address  Address  addressStartDate  Address Start Date  logical    Date  n/a  n/a  no  n/a  The first database date on which the address/organization information applied (have a discrete date on which address is known to applied - not necessarily the first date on which the address applied). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'aux_Role',
        'Role',
        'This table stores valid role codes for use in contributor tables',
        null,
        ' aux_Role  Role  This table stores valid role codes for use in contributor tables    ROLE_ID  ID  roleCode  Role Code  roleDescription  Role Description  accessionCode  Accession Code  roleProject  Role Allowed for Project Contributor  roleObservation  Role Allowed for Observation Contributor  roleTaxonInt  Role Allowed for Taxon Interpretation  roleClassInt  Role Allowed for Community Interpretation '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'aux_Role',
        'ROLE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the aux_Role table.',
        'Database assigned value for a unique role code',
     
        ' aux_Role  Role  ROLE_ID  ID  logical    serial  PK  n/a  no  Primary key for the aux_Role table.  Database assigned value for a unique role code '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'aux_Role',
        'roleCode',
        'Role Code',
        'logical',
        'no',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'constraining list of role codes for *Contributor tables',
     
        ' aux_Role  Role  roleCode  Role Code  logical  required  varchar (30)  n/a  n/a  no  n/a  constraining list of role codes for *Contributor tables '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'aux_Role',
        'roleDescription',
        'Role Description',
        'logical',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Description of the role',
     
        ' aux_Role  Role  roleDescription  Role Description  logical    varchar (200)  n/a  n/a  no  n/a  Description of the role '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'aux_Role',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' aux_Role  Role  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'aux_Role',
        'roleProject',
        'Role Allowed for Project Contributor',
        'implementation',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        '1=required, 2=allowed',
     
        ' aux_Role  Role  roleProject  Role Allowed for Project Contributor  implementation    Integer  n/a  n/a  no  n/a  1=required, 2=allowed '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'aux_Role',
        'roleObservation',
        'Role Allowed for Observation Contributor',
        'implementation',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        '1=required, 2=allowed',
     
        ' aux_Role  Role  roleObservation  Role Allowed for Observation Contributor  implementation    Integer  n/a  n/a  no  n/a  1=required, 2=allowed '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'aux_Role',
        'roleTaxonInt',
        'Role Allowed for Taxon Interpretation',
        'implementation',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        '1=required, 2=allowed',
     
        ' aux_Role  Role  roleTaxonInt  Role Allowed for Taxon Interpretation  implementation    Integer  n/a  n/a  no  n/a  1=required, 2=allowed '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'aux_Role',
        'roleClassInt',
        'Role Allowed for Community Interpretation',
        'implementation',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        '1=required, 2=allowed',
     
        ' aux_Role  Role  roleClassInt  Role Allowed for Community Interpretation  implementation    Integer  n/a  n/a  no  n/a  1=required, 2=allowed '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'reference',
        'Reference',
        'This table stores information about references cited within the database',
        null,
        ' reference  Reference  This table stores information about references cited within the database    reference_ID  ID  shortName  Short Name  fulltext  Full Text  referenceType  Reference Type  title  Title  titleSuperior  Title Superior  pubDate  Publication Date  accessDate  Access Date  conferenceDate  Conference Date  referenceJournal_ID  Reference Journal  volume  Volume  issue  Issue  pageRange  Page Range  totalPages  Total Pages  publisher  Publisher  publicationPlace  Publication Place  isbn  ISBN  edition  Edition  numberOfVolumes  Number Of Volumes  chapterNumber  Chapter Number  reportNumber  Report Number  communicationType  Communication Type  degree  Degree  url  URL  doi  DOI  additionalInfo  Additional Information  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'reference_ID',
        'ID',
        'logical',
        'no',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Primary key for the reference table.',
     
        ' reference  Reference  reference_ID  ID  logical  required  serial  PK  n/a  no  n/a  Primary key for the reference table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'shortName',
        'Short Name',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The ''shortName'' field provides a concise or abbreviated name that describes the resource that is being documented.',
     
        ' reference  Reference  shortName  Short Name  logical    varchar (250)  n/a  n/a  no  n/a  The ''shortName'' field provides a concise or abbreviated name that describes the resource that is being documented. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'fulltext',
        'Full Text',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Full Text of the reference citation.',
     
        ' reference  Reference  fulltext  Full Text  logical    text  n/a  n/a  no  n/a  Full Text of the reference citation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'referenceType',
        'Reference Type',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'Describes the type of reference this generic type is being used to represent.  Examples: book, journal article, web page.',
     
        ' reference  Reference  referenceType  Reference Type  logical    varchar (250)  n/a  n/a  closed  n/a  Describes the type of reference this generic type is being used to represent.  Examples: book, journal article, web page.  Article    Book    Chapter    EditedBook    Manuscript    Report    Thesis    ConferenceProceedings    PersonalCommunication    Presentation    Website    Generic   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'Article',
                              null,
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'Book',
                              null,
                              '20'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'Chapter',
                              null,
                              '30'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'EditedBook',
                              null,
                              '40'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'Manuscript',
                              null,
                              '50'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'Report',
                              null,
                              '60'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'Thesis',
                              null,
                              '70'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'ConferenceProceedings',
                              null,
                              '80'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'PersonalCommunication',
                              null,
                              '90'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'Presentation',
                              null,
                              '100'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'Website',
                              null,
                              '110'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'reference',
                              'referenceType',
                              'Generic',
                              null,
                              '120'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'title',
        'Title',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The formal title given to the work by its author or publisher.  The ''title'' field provides a description of the resource that is being documented that is long enough to differentiate it from other similar resources.',
     
        ' reference  Reference  title  Title  logical    varchar (250)  n/a  n/a  no  n/a  The formal title given to the work by its author or publisher.  The ''title'' field provides a description of the resource that is being documented that is long enough to differentiate it from other similar resources. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'titleSuperior',
        'Title Superior',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'A second, higher order title where appropriate, which in the case of a reference to a chapter is the Book title, and in the case of a Conference Presentation is the Name of the Conference.',
     
        ' reference  Reference  titleSuperior  Title Superior  logical    varchar (250)  n/a  n/a  no  n/a  A second, higher order title where appropriate, which in the case of a reference to a chapter is the Book title, and in the case of a Conference Presentation is the Name of the Conference. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'pubDate',
        'Publication Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The ''pubDate'' field represents the date that the resource was published. The format should be represented as: CCYY, which represents a 4 digit year, or as CCYY-MM-DD, which denotes the full year, month, and day. Note that month and day are optional components. Formats must conform to ISO 8601. For example: 1999-10-26',
     
        ' reference  Reference  pubDate  Publication Date  logical    Date  n/a  n/a  no  n/a  The ''pubDate'' field represents the date that the resource was published. The format should be represented as: CCYY, which represents a 4 digit year, or as CCYY-MM-DD, which denotes the full year, month, and day. Note that month and day are optional components. Formats must conform to ISO 8601. For example: 1999-10-26 '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'accessDate',
        'Access Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The date the resource being referenced was accessed.  This is useful if the resource is could be changed after formal publication, such as web sites or databases.',
     
        ' reference  Reference  accessDate  Access Date  logical    Date  n/a  n/a  no  n/a  The date the resource being referenced was accessed.  This is useful if the resource is could be changed after formal publication, such as web sites or databases. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'conferenceDate',
        'Conference Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The date the conference was held.',
     
        ' reference  Reference  conferenceDate  Conference Date  logical    Date  n/a  n/a  no  n/a  The date the conference was held. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'referenceJournal_ID',
        'Reference Journal',
        'logical',
        'yes',
        'Integer',
        'FK',
        'referenceJournal.referenceJournal_ID',
        'no',
        'n/a',
        'Foreign key into the journal table to identify the journal of this reference.',
     
        ' reference  Reference  referenceJournal_ID  Reference Journal  logical    Integer  FK  referenceJournal.referenceJournal_ID  no  n/a  Foreign key into the journal table to identify the journal of this reference. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'volume',
        'Volume',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The volume field is used to describe the volume of the journal in which the article appears.',
     
        ' reference  Reference  volume  Volume  logical    varchar (250)  n/a  n/a  no  n/a  The volume field is used to describe the volume of the journal in which the article appears. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'issue',
        'Issue',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The issue field is used to describe the issue of the journal in which the article appears.',
     
        ' reference  Reference  issue  Issue  logical    varchar (250)  n/a  n/a  no  n/a  The issue field is used to describe the issue of the journal in which the article appears. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'pageRange',
        'Page Range',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The page range field is used for the beginning and ending pages of the journal article that is being documented.',
     
        ' reference  Reference  pageRange  Page Range  logical    varchar (250)  n/a  n/a  no  n/a  The page range field is used for the beginning and ending pages of the journal article that is being documented. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'totalPages',
        'Total Pages',
        'logical',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The total pages field is used to describe the total number of pages in the book that is being described.',
     
        ' reference  Reference  totalPages  Total Pages  logical    Integer  n/a  n/a  no  n/a  The total pages field is used to describe the total number of pages in the book that is being described. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'publisher',
        'Publisher',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The organization that physically put together the report and publishes it.',
     
        ' reference  Reference  publisher  Publisher  logical    varchar (250)  n/a  n/a  no  n/a  The organization that physically put together the report and publishes it. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'publicationPlace',
        'Publication Place',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The location at which the work was published. This is usually the name of the city in which the publishing house produced the work.',
     
        ' reference  Reference  publicationPlace  Publication Place  logical    varchar (250)  n/a  n/a  no  n/a  The location at which the work was published. This is usually the name of the city in which the publishing house produced the work. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'isbn',
        'ISBN',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The ISBN, or International Standard Book Number that has been assigned to this literature resource.',
     
        ' reference  Reference  isbn  ISBN  logical    varchar (250)  n/a  n/a  no  n/a  The ISBN, or International Standard Book Number that has been assigned to this literature resource. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'edition',
        'Edition',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The edition field is to document the edition of the generic reference type that is being described.',
     
        ' reference  Reference  edition  Edition  logical    varchar (250)  n/a  n/a  no  n/a  The edition field is to document the edition of the generic reference type that is being described. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'numberOfVolumes',
        'Number Of Volumes',
        'logical',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Number of volumes in a collection',
     
        ' reference  Reference  numberOfVolumes  Number Of Volumes  logical    Integer  n/a  n/a  no  n/a  Number of volumes in a collection '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'chapterNumber',
        'Chapter Number',
        'logical',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The chapter number of the chapter of a book that is being described.',
     
        ' reference  Reference  chapterNumber  Chapter Number  logical    Integer  n/a  n/a  no  n/a  The chapter number of the chapter of a book that is being described. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'reportNumber',
        'Report Number',
        'logical',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The report number field is used to describe the unique identification number that has been issued by the report institution for the report being described.',
     
        ' reference  Reference  reportNumber  Report Number  logical    Integer  n/a  n/a  no  n/a  The report number field is used to describe the unique identification number that has been issued by the report institution for the report being described. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'communicationType',
        'Communication Type',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The type of personal communication. Could be an email, letter, memo, transcript of conversation either hardcopy or online.',
     
        ' reference  Reference  communicationType  Communication Type  logical    varchar (250)  n/a  n/a  no  n/a  The type of personal communication. Could be an email, letter, memo, transcript of conversation either hardcopy or online. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'degree',
        'Degree',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The degree field is used to describe the name or degree level for which the thesis was completed.',
     
        ' reference  Reference  degree  Degree  logical    varchar (250)  n/a  n/a  no  n/a  The degree field is used to describe the name or degree level for which the thesis was completed. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'url',
        'URL',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'A URL (Uniform Resource Locator) from which this resource can be downloaded or additional information can be obtained.',
     
        ' reference  Reference  url  URL  logical    text  n/a  n/a  no  n/a  A URL (Uniform Resource Locator) from which this resource can be downloaded or additional information can be obtained. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'doi',
        'DOI',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'A Digital Object Identifier - a digital identifier for any object of intellectual property. A DOI provides a means of persistently identifying a piece of intellectual property on a digital network and associating it with related current data.  (www.doi.org)',
     
        ' reference  Reference  doi  DOI  logical    text  n/a  n/a  no  n/a  A Digital Object Identifier - a digital identifier for any object of intellectual property. A DOI provides a means of persistently identifying a piece of intellectual property on a digital network and associating it with related current data.  (www.doi.org) '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'additionalInfo',
        'Additional Information',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This field provides any information that is not characterized by the other resource metadata fields. Example: Copyright 2001, Robert Warner',
     
        ' reference  Reference  additionalInfo  Additional Information  logical    text  n/a  n/a  no  n/a  This field provides any information that is not characterized by the other resource metadata fields. Example: Copyright 2001, Robert Warner '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'reference',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' reference  Reference  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'referenceAltIdent',
        'Reference Alternate Identifier',
        'This table stores information about identifiers that can be used to indicate a particular reference.',
        null,
        ' referenceAltIdent  Reference Alternate Identifier  This table stores information about identifiers that can be used to indicate a particular reference.    referenceAltIdent_ID  ID  reference_ID  Reference  system  System  identifier  Identifier '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceAltIdent',
        'referenceAltIdent_ID',
        'ID',
        'logical',
        'no',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Primary key for the referenceAltIdent table.',
     
        ' referenceAltIdent  Reference Alternate Identifier  referenceAltIdent_ID  ID  logical  required  serial  PK  n/a  no  n/a  Primary key for the referenceAltIdent table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceAltIdent',
        'reference_ID',
        'Reference',
        'logical',
        'no',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'n/a',
        'Foreign key into the reference table to indicate which reference is referenced by this alternate identifier.',
     
        ' referenceAltIdent  Reference Alternate Identifier  reference_ID  Reference  logical  required  Integer  FK  reference.reference_ID  no  n/a  Foreign key into the reference table to indicate which reference is referenced by this alternate identifier. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceAltIdent',
        'system',
        'System',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The data management system within which an identifier is in scope and therefore unique. This is typically a URL (Uniform Resource Locator) that indicates a data management system. All identifiers that share a system must be unique. In other words, if the same identifier is used in two locations with identical systems, then by definition the objects at which they point are in fact the same object. Example(s): http://metacat.somewhere.org/svc/mc/',
     
        ' referenceAltIdent  Reference Alternate Identifier  system  System  logical    varchar (250)  n/a  n/a  no  n/a  The data management system within which an identifier is in scope and therefore unique. This is typically a URL (Uniform Resource Locator) that indicates a data management system. All identifiers that share a system must be unique. In other words, if the same identifier is used in two locations with identical systems, then by definition the objects at which they point are in fact the same object. Example(s): http://metacat.somewhere.org/svc/mc/ '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceAltIdent',
        'identifier',
        'Identifier',
        'logical',
        'no',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'An additional, secondary identifier for this entity. The primary identifier belongs in the reference table, but additional identifiers that are used to label this entity, possibly from different data management systems, can be listed here. Example: VCR3465',
     
        ' referenceAltIdent  Reference Alternate Identifier  identifier  Identifier  logical  required  varchar (250)  n/a  n/a  no  n/a  An additional, secondary identifier for this entity. The primary identifier belongs in the reference table, but additional identifiers that are used to label this entity, possibly from different data management systems, can be listed here. Example: VCR3465 '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'referenceContributor',
        'Reference Contributor',
        'This table links reference parties with references and shows how a contribution was made by the party.',
        null,
        ' referenceContributor  Reference Contributor  This table links reference parties with references and shows how a contribution was made by the party.    referenceContributor_ID  ID  reference_ID  Reference  referenceParty_ID  Reference Party  roleType  Role Type  position  Position '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceContributor',
        'referenceContributor_ID',
        'ID',
        'logical',
        'no',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Primary key for the referenceContributor table.',
     
        ' referenceContributor  Reference Contributor  referenceContributor_ID  ID  logical  required  serial  PK  n/a  no  n/a  Primary key for the referenceContributor table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceContributor',
        'reference_ID',
        'Reference',
        'logical',
        'no',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'n/a',
        'Foreign key into the reference table to indicate which reference is referenced by this alternate identifier.',
     
        ' referenceContributor  Reference Contributor  reference_ID  Reference  logical  required  Integer  FK  reference.reference_ID  no  n/a  Foreign key into the reference table to indicate which reference is referenced by this alternate identifier. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceContributor',
        'referenceParty_ID',
        'Reference Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'referenceParty.referenceParty_ID',
        'no',
        'n/a',
        'Foreign key into the referenceParty table to indicate which person contributed.',
     
        ' referenceContributor  Reference Contributor  referenceParty_ID  Reference Party  logical  required  Integer  FK  referenceParty.referenceParty_ID  no  n/a  Foreign key into the referenceParty table to indicate which person contributed. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceContributor',
        'roleType',
        'Role Type',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'Use this field to describe the role the party played with respect to the resource. Some potential roles include technician, reviewer, principal investigator, and many others.',
     
        ' referenceContributor  Reference Contributor  roleType  Role Type  logical    varchar (250)  n/a  n/a  closed  n/a  Use this field to describe the role the party played with respect to the resource. Some potential roles include technician, reviewer, principal investigator, and many others.  Author    Editor    Originator    Performer    Recipient    CustodianSteward   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'referenceContributor',
                              'roleType',
                              'Author',
                              null,
                              null
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'referenceContributor',
                              'roleType',
                              'CustodianSteward',
                              null,
                              null
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'referenceContributor',
                              'roleType',
                              'Editor',
                              null,
                              null
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'referenceContributor',
                              'roleType',
                              'Originator',
                              null,
                              null
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'referenceContributor',
                              'roleType',
                              'Performer',
                              null,
                              null
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'referenceContributor',
                              'roleType',
                              'Recipient',
                              null,
                              null
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceContributor',
        'position',
        'Position',
        'logical',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Numerical order in which this contributor''s name should be in the order of contributors, if applicable.  Examples: 1 [for the first author], 2, [for the second author], etc.',
     
        ' referenceContributor  Reference Contributor  position  Position  logical    Integer  n/a  n/a  no  n/a  Numerical order in which this contributor''s name should be in the order of contributors, if applicable.  Examples: 1 [for the first author], 2, [for the second author], etc. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'referenceParty',
        'Reference Party',
        'This table stores information about parties that contributed to a reference.',
        null,
        ' referenceParty  Reference Party  This table stores information about parties that contributed to a reference.    referenceParty_ID  ID  type  Reference Party Type  positionName  Position Name  salutation  Salutation  givenName  Given Name  surname  Surname  suffix  Suffix  organizationName  Organization Name  currentParty_ID  Current Name  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceParty',
        'referenceParty_ID',
        'ID',
        'logical',
        'no',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Primary key for the referenceParty table.',
     
        ' referenceParty  Reference Party  referenceParty_ID  ID  logical  required  serial  PK  n/a  no  n/a  Primary key for the referenceParty table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceParty',
        'type',
        'Reference Party Type',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Type of Party this record refers to: usually person or institution.  Type determines rules for which fields must be completed.',
     
        ' referenceParty  Reference Party  type  Reference Party Type  logical    varchar (250)  n/a  n/a  no  n/a  Type of Party this record refers to: usually person or institution.  Type determines rules for which fields must be completed. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceParty',
        'positionName',
        'Position Name',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This field is intended to be used instead of a particular person or full organization name. If the associated person that holds the role changes frequently, then Position Name would be used for consistency. Note that this field, used in conjunction with ''organizationName'' and ''individualName'' make up a single logical originator. Because of this, an originator with only the individualName of ''Joe Smith'' is NOT the same as an originator with the name of ''Joe Smith'' and the organizationName of ''NSF''. Also, the positionName should not be used in conjunction with individualName unless only that individual at that position would be considered an originator for the data package. If a positionName is used in conjunction with an organizationName, then that implies that any person who currently occupies said positionName at organizationName is the originator of the data package. Example(s): Niwot Ridge Data Manager',
     
        ' referenceParty  Reference Party  positionName  Position Name  logical    varchar (250)  n/a  n/a  no  n/a  This field is intended to be used instead of a particular person or full organization name. If the associated person that holds the role changes frequently, then Position Name would be used for consistency. Note that this field, used in conjunction with ''organizationName'' and ''individualName'' make up a single logical originator. Because of this, an originator with only the individualName of ''Joe Smith'' is NOT the same as an originator with the name of ''Joe Smith'' and the organizationName of ''NSF''. Also, the positionName should not be used in conjunction with individualName unless only that individual at that position would be considered an originator for the data package. If a positionName is used in conjunction with an organizationName, then that implies that any person who currently occupies said positionName at organizationName is the originator of the data package. Example(s): Niwot Ridge Data Manager '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceParty',
        'salutation',
        'Salutation',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The salutation field is used in addressing an individual with a particular title, such as Dr., Ms., Mrs., Mr., etc.',
     
        ' referenceParty  Reference Party  salutation  Salutation  logical    varchar (250)  n/a  n/a  no  n/a  The salutation field is used in addressing an individual with a particular title, such as Dr., Ms., Mrs., Mr., etc. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceParty',
        'givenName',
        'Given Name',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'All names except surname',
        'The given name field is used for the all names, except the surname, of the individual associated with the resource.  Possible usages include: first name and middle name, first name and middle initials, first name, etc.  Example(s): Jo, Jo R., Jo R.W., John Robert Peter',
     
        ' referenceParty  Reference Party  givenName  Given Name  logical    varchar (250)  n/a  n/a  no  All names except surname  The given name field is used for the all names, except the surname, of the individual associated with the resource.  Possible usages include: first name and middle name, first name and middle initials, first name, etc.  Example(s): Jo, Jo R., Jo R.W., John Robert Peter '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceParty',
        'surname',
        'Surname',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The surname field is used for the last name of the individual associated with the resource.',
     
        ' referenceParty  Reference Party  surname  Surname  logical    varchar (250)  n/a  n/a  no  n/a  The surname field is used for the last name of the individual associated with the resource. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceParty',
        'suffix',
        'Suffix',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'A suffix or suffix abbreviation that follows a name.  Examples: Jr., Senior, III, etc.',
     
        ' referenceParty  Reference Party  suffix  Suffix  logical    varchar (250)  n/a  n/a  no  n/a  A suffix or suffix abbreviation that follows a name.  Examples: Jr., Senior, III, etc. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceParty',
        'organizationName',
        'Organization Name',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The responsible party field contains the full name of the organization that is associated with the resource. This field is intended to describe which institution or overall organization is associated with the resource being described. Note that this field, used in conjunction with ''individualName'' and ''positionName'' make up a single logical originator. Because of this, an originator with only the individualName of ''Joe Smith'' is NOT the same as an originator with the name of ''Joe Smith'' and the organizationName of ''NSF''. Also, the positionName should not be used in conjunction with individualName unless only that individual at that position would be considered an originator for the data package. If a positionName is used in conjunction with an organizationName, then that implies that any person who currently occupies said positionName at organizationName is the originator of the data package. Example(s): National Center for Ecological Analysis and Synthesis',
     
        ' referenceParty  Reference Party  organizationName  Organization Name  logical    varchar (250)  n/a  n/a  no  n/a  The responsible party field contains the full name of the organization that is associated with the resource. This field is intended to describe which institution or overall organization is associated with the resource being described. Note that this field, used in conjunction with ''individualName'' and ''positionName'' make up a single logical originator. Because of this, an originator with only the individualName of ''Joe Smith'' is NOT the same as an originator with the name of ''Joe Smith'' and the organizationName of ''NSF''. Also, the positionName should not be used in conjunction with individualName unless only that individual at that position would be considered an originator for the data package. If a positionName is used in conjunction with an organizationName, then that implies that any person who currently occupies said positionName at organizationName is the originator of the data package. Example(s): National Center for Ecological Analysis and Synthesis '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceParty',
        'currentParty_ID',
        'Current Name',
        'logical',
        'yes',
        'Integer',
        'FK',
        'referenceParty.referenceParty_ID',
        'no',
        'recursive FK',
        'Recursive Foreign key into the referenceParty table to indicate the current name of the party.',
     
        ' referenceParty  Reference Party  currentParty_ID  Current Name  logical    Integer  FK  referenceParty.referenceParty_ID  no  recursive FK  Recursive Foreign key into the referenceParty table to indicate the current name of the party. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceParty',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' referenceParty  Reference Party  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'referenceJournal',
        'Reference Journal',
        'This table stores information about journals used as part of a reference.',
        null,
        ' referenceJournal  Reference Journal  This table stores information about journals used as part of a reference.    referenceJournal_ID  ID  journal  Journal  issn  ISSN  abbreviation  Abbreviation  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceJournal',
        'referenceJournal_ID',
        'ID',
        'logical',
        'no',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Primary key for the referenceJournal table.',
     
        ' referenceJournal  Reference Journal  referenceJournal_ID  ID  logical  required  serial  PK  n/a  no  n/a  Primary key for the referenceJournal table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceJournal',
        'journal',
        'Journal',
        'logical',
        'no',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The name of the journal, magazine, newspaper, zine, etc... in which the article was published. Example(s): Ecology, New York Times, Harper''s, Canadian Journal of Botany/Revue Canadienne de Botanique ,The Journal of the American Medical Association',
     
        ' referenceJournal  Reference Journal  journal  Journal  logical  required  varchar (250)  n/a  n/a  no  n/a  The name of the journal, magazine, newspaper, zine, etc... in which the article was published. Example(s): Ecology, New York Times, Harper''s, Canadian Journal of Botany/Revue Canadienne de Botanique ,The Journal of the American Medical Association '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceJournal',
        'issn',
        'ISSN',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The ISSN, or International Standard Serial Number that has been assigned to this literature resource. Example(s): ISSN 1234-5679',
     
        ' referenceJournal  Reference Journal  issn  ISSN  logical    varchar (250)  n/a  n/a  no  n/a  The ISSN, or International Standard Serial Number that has been assigned to this literature resource. Example(s): ISSN 1234-5679 '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceJournal',
        'abbreviation',
        'Abbreviation',
        'logical',
        'yes',
        'varchar (250)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Standard abbreviation or shorter name of the journal.  Example(s): Can. J. Bot./Rev. Can. Bot., JAMA',
     
        ' referenceJournal  Reference Journal  abbreviation  Abbreviation  logical    varchar (250)  n/a  n/a  no  n/a  Standard abbreviation or shorter name of the journal.  Example(s): Can. J. Bot./Rev. Can. Bot., JAMA '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'referenceJournal',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' referenceJournal  Reference Journal  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'classContributor',
        'Classification Contributor',
        'This table stores information about who participated in a classification event',
        'This table serves as an intersection entity used to link a party with a specific plot classification event.',
        ' classContributor  Classification Contributor  This table stores information about who participated in a classification event  This table serves as an intersection entity used to link a party with a specific plot classification event.  CLASSCONTRIBUTOR_ID  ID  COMMCLASS_ID  Community Classification  PARTY_ID  Party  ROLE_ID  Role  emb_classContributor  this row embargoed. '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'classContributor',
        'CLASSCONTRIBUTOR_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the classContributor table.',
        'Database generated identifier assigned to each unique contribution to the classification of a plot observation.',
     
        ' classContributor  Classification Contributor  CLASSCONTRIBUTOR_ID  ID  logical    serial  PK  n/a  no  Primary key for the classContributor table.  Database generated identifier assigned to each unique contribution to the classification of a plot observation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'classContributor',
        'COMMCLASS_ID',
        'Community Classification',
        'logical',
        'no',
        'Integer',
        'FK',
        'commClass.COMMCLASS_ID',
        'no',
        'Foreign key into the commClass table.',
        'Observation classification event to which the contributor is associated.',
     
        ' classContributor  Classification Contributor  COMMCLASS_ID  Community Classification  logical  required  Integer  FK  commClass.COMMCLASS_ID  no  Foreign key into the commClass table.  Observation classification event to which the contributor is associated. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'classContributor',
        'PARTY_ID',
        'Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'Foreign key into the party table.',
        'Link to the party that contributed to the classification event.',
     
        ' classContributor  Classification Contributor  PARTY_ID  Party  logical  required  Integer  FK  party.PARTY_ID  no  Foreign key into the party table.  Link to the party that contributed to the classification event. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'classContributor',
        'ROLE_ID',
        'Role',
        'logical',
        'yes',
        'Integer',
        'FK',
        'aux_Role.ROLE_ID',
        'no',
        'Foreign key into the aux_Role table',
        'Foreign key that identifies the role that the party had in the classification event (e.g., classifier, consultant, research advisor).',
     
        ' classContributor  Classification Contributor  ROLE_ID  Role  logical    Integer  FK  aux_Role.ROLE_ID  no  Foreign key into the aux_Role table  Foreign key that identifies the role that the party had in the classification event (e.g., classifier, consultant, research advisor). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'classContributor',
        'emb_classContributor',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' classContributor  Classification Contributor  emb_classContributor  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'commClass',
        'Community Classification',
        'This table stores general information about classification events where one or more community concepts were applied to a specific Observation by one or more parties.',
        null,
        ' commClass  Community Classification  This table stores general information about classification events where one or more community concepts were applied to a specific Observation by one or more parties.    COMMCLASS_ID  ID  OBSERVATION_ID  Observation  classStartDate  Classification Start Date  classStopDate  Classification Stop Date  inspection  Inspection  tableAnalysis  Table Analysis  multivariateAnalysis  Multivariate Analysis  expertSystem  Expert System  classPublication_ID  Classification Publication  classNotes  Classification Notes  commName  Community Name  commCode  Community Code  commFramework  Community Framework  commLevel  Community Level  accessionCode  Accession Code  emb_commClass  this row embargoed. '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'COMMCLASS_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary Key for the commClass table.',
        'Database generated identifier assigned to each unique observation classification event.',
     
        ' commClass  Community Classification  COMMCLASS_ID  ID  logical    serial  PK  n/a  no  Primary Key for the commClass table.  Database generated identifier assigned to each unique observation classification event. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'OBSERVATION_ID',
        'Observation',
        'logical',
        'no',
        'Integer',
        'FK',
        'observation.OBSERVATION_ID',
        'no',
        'Foreign key into the observation table',
        'Link to the observation table identifying which observation is being classified.',
     
        ' commClass  Community Classification  OBSERVATION_ID  Observation  logical  required  Integer  FK  observation.OBSERVATION_ID  no  Foreign key into the observation table  Link to the observation table identifying which observation is being classified. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'classStartDate',
        'Classification Start Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Start date for the application of a vegetation class to a plot observation by one or more parties.',
     
        ' commClass  Community Classification  classStartDate  Classification Start Date  logical    Date  n/a  n/a  no  n/a  Start date for the application of a vegetation class to a plot observation by one or more parties. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'classStopDate',
        'Classification Stop Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Stop date for the application of a vegetation class to a plot observation by one or more parties.',
     
        ' commClass  Community Classification  classStopDate  Classification Stop Date  logical    Date  n/a  n/a  no  n/a  Stop date for the application of a vegetation class to a plot observation by one or more parties. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'inspection',
        'Inspection',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Classification informed by simple inspection of data.',
     
        ' commClass  Community Classification  inspection  Inspection  logical    Boolean  n/a  n/a  no  n/a  Classification informed by simple inspection of data. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'tableAnalysis',
        'Table Analysis',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Classification informed by inspection of floristic composition tables.',
     
        ' commClass  Community Classification  tableAnalysis  Table Analysis  logical    Boolean  n/a  n/a  no  n/a  Classification informed by inspection of floristic composition tables. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'multivariateAnalysis',
        'Multivariate Analysis',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Classification informed by use of multivariate numerical tools.',
     
        ' commClass  Community Classification  multivariateAnalysis  Multivariate Analysis  logical    Boolean  n/a  n/a  no  n/a  Classification informed by use of multivariate numerical tools. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'expertSystem',
        'Expert System',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Description of any  automated expert system used in classification.',
     
        ' commClass  Community Classification  expertSystem  Expert System  logical    text  n/a  n/a  no  n/a  Description of any  automated expert system used in classification. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'classPublication_ID',
        'Classification Publication',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'Foreign key into the reference table',
        'Link to a publication wherein the observation was classified.',
     
        ' commClass  Community Classification  classPublication_ID  Classification Publication  logical    Integer  FK  reference.reference_ID  no  Foreign key into the reference table  Link to a publication wherein the observation was classified. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'classNotes',
        'Classification Notes',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Notes about the classification event by the parties participating in the event. This might include the purpose or rationale for the classification.',
     
        ' commClass  Community Classification  classNotes  Classification Notes  logical    text  n/a  n/a  no  n/a  Notes about the classification event by the parties participating in the event. This might include the purpose or rationale for the classification. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'commName',
        'Community Name',
        'implementation',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' commClass  Community Classification  commName  Community Name  implementation    varchar (200)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'commCode',
        'Community Code',
        'implementation',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' commClass  Community Classification  commCode  Community Code  implementation    varchar (200)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'commFramework',
        'Community Framework',
        'implementation',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' commClass  Community Classification  commFramework  Community Framework  implementation    varchar (200)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'commLevel',
        'Community Level',
        'implementation',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' commClass  Community Classification  commLevel  Community Level  implementation    varchar (200)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' commClass  Community Classification  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commClass',
        'emb_commClass',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' commClass  Community Classification  emb_commClass  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'commInterpretation',
        'Community Interpretation',
        'This table tracks the assignment of specific community concepts to plot observations',
        null,
        ' commInterpretation  Community Interpretation  This table tracks the assignment of specific community concepts to plot observations    COMMINTERPRETATION_ID  ID  COMMCLASS_ID  Community Classification  COMMCONCEPT_ID  Community Concept  commcode  Community Code  commname  Community Name  classFit  Class Fit  classConfidence  Class Confidence  commAuthority_ID  Community Authority Reference  notes  Notes  type  Typal  nomenclaturalType  Nomenclatural Type  emb_commInterpretation  this row embargoed. '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'COMMINTERPRETATION_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary Key for the communityInterpretation table.',
        'Database generated identifier assigned to each unique assignment of a community concept to a plot observation.',
     
        ' commInterpretation  Community Interpretation  COMMINTERPRETATION_ID  ID  logical    serial  PK  n/a  no  Primary Key for the communityInterpretation table.  Database generated identifier assigned to each unique assignment of a community concept to a plot observation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'COMMCLASS_ID',
        'Community Classification',
        'logical',
        'no',
        'Integer',
        'FK',
        'commClass.COMMCLASS_ID',
        'no',
        'Foreign key into the commClassification table.',
        'Link to the commClassification table identifying the specific classification event.',
     
        ' commInterpretation  Community Interpretation  COMMCLASS_ID  Community Classification  logical  required  Integer  FK  commClass.COMMCLASS_ID  no  Foreign key into the commClassification table.  Link to the commClassification table identifying the specific classification event. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'COMMCONCEPT_ID',
        'Community Concept',
        'logical',
        'yes',
        'Integer',
        'FK',
        'commConcept.COMMCONCEPT_ID',
        'no',
        'Foreign key into the commConcept table.',
        'Link to the communityConcept table identifying the specific community concept being applied.',
     
        ' commInterpretation  Community Interpretation  COMMCONCEPT_ID  Community Concept  logical    Integer  FK  commConcept.COMMCONCEPT_ID  no  Foreign key into the commConcept table.  Link to the communityConcept table identifying the specific community concept being applied. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'commcode',
        'Community Code',
        'implementation',
        'yes',
        'varchar (34)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' commInterpretation  Community Interpretation  commcode  Community Code  implementation    varchar (34)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'commname',
        'Community Name',
        'denorm',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the community indicated in commConcept_ID.',
     
        ' commInterpretation  Community Interpretation  commname  Community Name  denorm    varchar (200)  n/a  n/a  no  n/a  Name of the community indicated in commConcept_ID. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'classFit',
        'Class Fit',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Indicates the degree of fit with the community concept being assigned. Values derive from Gopal, S., and Woodcock, C. (1994), Theory and methods for accuracy assessment of thematic maps using fuzzy sets. Photogrammetric Engineering and Remote Sensing 60(2):181-188.',
     
        ' commInterpretation  Community Interpretation  classFit  Class Fit  logical    varchar (50)  n/a  n/a  closed  closed list  Indicates the degree of fit with the community concept being assigned. Values derive from Gopal, S., and Woodcock, C. (1994), Theory and methods for accuracy assessment of thematic maps using fuzzy sets. Photogrammetric Engineering and Remote Sensing 60(2):181-188.  Absolutely correct  (Fits well)  No doubt about the match. Perfect fit.  Absolutely wrong  (Absolutely doesn''t fit)  This answer is absolutely unacceptable. Unambiguously incorrect.  Good answer  (Fits reasonably well)  Good match with the concept.  Unambiguously correct.  Reasonable or acceptable answer  (Possibly fits)  Maybe not the best possible answer but it is acceptable; this answer does not pose a problem to the user. Correct.  Understandable but wrong  (Doesn''t fit but is close)  Not a good answer. There is something about the plot that makes the answer understandable, but there is clearly a better answer. This answer would pose a problem for users.  Incorrect. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commInterpretation',
                              'classFit',
                              'Absolutely wrong',
                              '(Absolutely doesn''t fit)  This answer is absolutely unacceptable. Unambiguously incorrect.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commInterpretation',
                              'classFit',
                              'Understandable but wrong',
                              '(Doesn''t fit but is close)  Not a good answer. There is something about the plot that makes the answer understandable, but there is clearly a better answer. This answer would pose a problem for users.  Incorrect.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commInterpretation',
                              'classFit',
                              'Reasonable or acceptable answer',
                              '(Possibly fits)  Maybe not the best possible answer but it is acceptable; this answer does not pose a problem to the user. Correct.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commInterpretation',
                              'classFit',
                              'Good answer',
                              '(Fits reasonably well)  Good match with the concept.  Unambiguously correct.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commInterpretation',
                              'classFit',
                              'Absolutely correct',
                              '(Fits well)  No doubt about the match. Perfect fit.',
                              '5'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'classConfidence',
        'Class Confidence',
        'logical',
        'yes',
        'varchar (15)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Indicates the degree of confidence of the interpreter(s) in the interpretation made. This can reflect the level of familiarity with the classification or the sufficiency of information about the plot (e.g., High, Moderate, Low).',
     
        ' commInterpretation  Community Interpretation  classConfidence  Class Confidence  logical    varchar (15)  n/a  n/a  closed  closed list  Indicates the degree of confidence of the interpreter(s) in the interpretation made. This can reflect the level of familiarity with the classification or the sufficiency of information about the plot (e.g., High, Moderate, Low).  High  The party making the community interpretation has a high confidence in the accuracy of this interpretation. A party can have high confidence that a plot has a fit of "absolutely wrong" for a particular community.  Low  The party making the community interpretation has a low confidence in the accuracy of this interpretation.  Medium  The party making the community interpretation has a medium amount of confidence in the accuracy of this interpretation. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commInterpretation',
                              'classConfidence',
                              'High',
                              'The party making the community interpretation has a high confidence in the accuracy of this interpretation. A party can have high confidence that a plot has a fit of "absolutely wrong" for a particular community.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commInterpretation',
                              'classConfidence',
                              'Medium',
                              'The party making the community interpretation has a medium amount of confidence in the accuracy of this interpretation.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'commInterpretation',
                              'classConfidence',
                              'Low',
                              'The party making the community interpretation has a low confidence in the accuracy of this interpretation.',
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'commAuthority_ID',
        'Community Authority Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'Foreign key into the reference table',
        'Link to the reference from which information on the community concept was obtained during the classification event. (A case could be made for this being moved to reference.)',
     
        ' commInterpretation  Community Interpretation  commAuthority_ID  Community Authority Reference  logical    Integer  FK  reference.reference_ID  no  Foreign key into the reference table  Link to the reference from which information on the community concept was obtained during the classification event. (A case could be made for this being moved to reference.) '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'notes',
        'Notes',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Notes pertaining to the classification analysis and decision.',
     
        ' commInterpretation  Community Interpretation  notes  Notes  logical    text  n/a  n/a  no  n/a  Notes pertaining to the classification analysis and decision. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'type',
        'Typal',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This assignment is the type description for the community concept, as indicated in the publication referenced in  commClass.classPublication_ID  (NOT the commAuthority_ID of this commInterpretation table).',
     
        ' commInterpretation  Community Interpretation  type  Typal  logical    Boolean  n/a  n/a  no  n/a  This assignment is the type description for the community concept, as indicated in the publication referenced in  commClass.classPublication_ID  (NOT the commAuthority_ID of this commInterpretation table). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'nomenclaturalType',
        'Nomenclatural Type',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Typal plot for the Braun-Blanquet community name.',
     
        ' commInterpretation  Community Interpretation  nomenclaturalType  Nomenclatural Type  logical    Boolean  n/a  n/a  no  n/a  Typal plot for the Braun-Blanquet community name. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'commInterpretation',
        'emb_commInterpretation',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' commInterpretation  Community Interpretation  emb_commInterpretation  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'coverIndex',
        'Cover Index',
        'This table stores the definitions of each coverclass unit associated with each coverclass method.',
        null,
        ' coverIndex  Cover Index  This table stores the definitions of each coverclass unit associated with each coverclass method.    COVERINDEX_ID  ID  COVERMETHOD_ID  Cover Method  coverCode  Cover Code  upperLimit  Upper Limit  lowerLimit  Lower Limit  coverPercent  Cover Percent  indexDescription  Index Description '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverIndex',
        'COVERINDEX_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the coverIndex table',
        'Database generated identifier assigned to each unique coverclass associated index value.',
     
        ' coverIndex  Cover Index  COVERINDEX_ID  ID  logical    serial  PK  n/a  no  Primary key for the coverIndex table  Database generated identifier assigned to each unique coverclass associated index value. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverIndex',
        'COVERMETHOD_ID',
        'Cover Method',
        'logical',
        'no',
        'Integer',
        'FK',
        'coverMethod.COVERMETHOD_ID',
        'no',
        'Foreign key into the coverMethod table.',
        'Links to a specific cover scale.',
     
        ' coverIndex  Cover Index  COVERMETHOD_ID  Cover Method  logical  required  Integer  FK  coverMethod.COVERMETHOD_ID  no  Foreign key into the coverMethod table.  Links to a specific cover scale. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverIndex',
        'coverCode',
        'Cover Code',
        'logical',
        'no',
        'varchar (10)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The name or label used in the coverclass scale for this specific coverclass.',
     
        ' coverIndex  Cover Index  coverCode  Cover Code  logical  required  varchar (10)  n/a  n/a  no  n/a  The name or label used in the coverclass scale for this specific coverclass. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverIndex',
        'upperLimit',
        'Upper Limit',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Upper limit, in percent, associated with the specific coverCode.',
     
        ' coverIndex  Cover Index  upperLimit  Upper Limit  logical    Float  n/a  n/a  no  n/a  Upper limit, in percent, associated with the specific coverCode. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverIndex',
        'lowerLimit',
        'Lower Limit',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the lower limit, in percent, associated with a specific coverCode. Where a cover scale has a non-quantitative lower or upper value, as in the "+" of the Braun-Blanquet scale, it is necessary to provide an approximation with "0" being the lower limit of the bottom most class.',
     
        ' coverIndex  Cover Index  lowerLimit  Lower Limit  logical    Float  n/a  n/a  no  n/a  This is the lower limit, in percent, associated with a specific coverCode. Where a cover scale has a non-quantitative lower or upper value, as in the "+" of the Braun-Blanquet scale, it is necessary to provide an approximation with "0" being the lower limit of the bottom most class. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverIndex',
        'coverPercent',
        'Cover Percent',
        'logical',
        'no',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'A middle value (usually mean or geometric mean) between the upperLimit and lowerLimt stored by the database for each taxon observation and used for all coverclass conversions and interpretations.  This is assigned by the author of the cover class schema.',
     
        ' coverIndex  Cover Index  coverPercent  Cover Percent  logical  required  Float  n/a  n/a  no  n/a  A middle value (usually mean or geometric mean) between the upperLimit and lowerLimt stored by the database for each taxon observation and used for all coverclass conversions and interpretations.  This is assigned by the author of the cover class schema. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverIndex',
        'indexDescription',
        'Index Description',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Description of the specific coverclass. This is particularly helpful in the case that there is no numeric value that can be applied.',
     
        ' coverIndex  Cover Index  indexDescription  Index Description  logical    text  n/a  n/a  no  n/a  Description of the specific coverclass. This is particularly helpful in the case that there is no numeric value that can be applied. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'coverMethod',
        'Cover Method',
        'This table associates a cover scale recognized by the plot data collectors with a set of coverclasses specified in the coverIndex table. This table, together with the coverIndex table, defines a coverclass method.',
        null,
        ' coverMethod  Cover Method  This table associates a cover scale recognized by the plot data collectors with a set of coverclasses specified in the coverIndex table. This table, together with the coverIndex table, defines a coverclass method.    COVERMETHOD_ID  ID  reference_ID  Reference  coverType  Cover Type  coverEstimationMethod  Cover Estimation Method  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverMethod',
        'COVERMETHOD_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the coverMethod table.',
        'Database generated identifier assigned to each unique coverclass methodology.',
     
        ' coverMethod  Cover Method  COVERMETHOD_ID  ID  logical    serial  PK  n/a  no  Primary key for the coverMethod table.  Database generated identifier assigned to each unique coverclass methodology. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverMethod',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'Foreign key into the reference table.',
        'Foreign Key into the reference table, linking the defining reference to a cover method.',
     
        ' coverMethod  Cover Method  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  Foreign key into the reference table.  Foreign Key into the reference table, linking the defining reference to a cover method. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverMethod',
        'coverType',
        'Cover Type',
        'logical',
        'no',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the coverclass method (e.g., Braun-Blanquet, Barkman, Domin, Daubenmire, Carolina Vegetation Survey, etc.).',
     
        ' coverMethod  Cover Method  coverType  Cover Type  logical  required  varchar (30)  n/a  n/a  no  n/a  Name of the coverclass method (e.g., Braun-Blanquet, Barkman, Domin, Daubenmire, Carolina Vegetation Survey, etc.). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverMethod',
        'coverEstimationMethod',
        'Cover Estimation Method',
        'logical',
        'yes',
        'varchar (80)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'The way that cover is estimated on the observation.',
     
        ' coverMethod  Cover Method  coverEstimationMethod  Cover Estimation Method  logical    varchar (80)  n/a  n/a  closed  n/a  The way that cover is estimated on the observation.  canopy cover  Cover estimated as the percentage of ground covered by a vertical outermost perimeter of the natural spread of foliage of plants. (SRM 1989)  foliar cover  Cover estimated as the percentage of ground covered by the vertical portion of plants. Small openings in the canopy and intraspecific overlap are excluded (SRM 1989). Foliar cover is the vertical projection of shoots; i.e., stems and leaves. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'coverMethod',
                              'coverEstimationMethod',
                              'canopy cover',
                              'Cover estimated as the percentage of ground covered by a vertical outermost perimeter of the natural spread of foliage of plants. (SRM 1989)',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'coverMethod',
                              'coverEstimationMethod',
                              'foliar cover',
                              'Cover estimated as the percentage of ground covered by the vertical portion of plants. Small openings in the canopy and intraspecific overlap are excluded (SRM 1989). Foliar cover is the vertical projection of shoots; i.e., stems and leaves.',
                              '2'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'coverMethod',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' coverMethod  Cover Method  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'definedValue',
        'Defined Value',
        'This table stores the values of user-defined variables.',
        'This table stores values associated with specific user-defined variables identified in the userDefined table.',
        ' definedValue  Defined Value  This table stores the values of user-defined variables.  This table stores values associated with specific user-defined variables identified in the userDefined table.  DEFINEDVALUE_ID  ID  USERDEFINED_ID  User Defined  tableRecord_ID  Table Record  definedValue  Defined Value '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'definedValue',
        'DEFINEDVALUE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the definedValue table',
        'Database generated identifier assigned to each unique defined value.',
     
        ' definedValue  Defined Value  DEFINEDVALUE_ID  ID  logical    serial  PK  n/a  no  Primary key for the definedValue table  Database generated identifier assigned to each unique defined value. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'definedValue',
        'USERDEFINED_ID',
        'User Defined',
        'logical',
        'no',
        'Integer',
        'FK',
        'userDefined.USERDEFINED_ID',
        'no',
        'n/a',
        'Link to a specific user-defined variable defined in the userDefined table.',
     
        ' definedValue  Defined Value  USERDEFINED_ID  User Defined  logical  required  Integer  FK  userDefined.USERDEFINED_ID  no  n/a  Link to a specific user-defined variable defined in the userDefined table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'definedValue',
        'tableRecord_ID',
        'Table Record',
        'logical',
        'no',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'Pseudokey for the table with which this value should be associated',
        'The numeric value of the record number (primary key) that this user-defined value would have if it were in the table identified by USERDEFINED_ID.',
     
        ' definedValue  Defined Value  tableRecord_ID  Table Record  logical  required  Integer  n/a  n/a  no  Pseudokey for the table with which this value should be associated  The numeric value of the record number (primary key) that this user-defined value would have if it were in the table identified by USERDEFINED_ID. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'definedValue',
        'definedValue',
        'Defined Value',
        'logical',
        'no',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The value of the user-defined variable.',
     
        ' definedValue  Defined Value  definedValue  Defined Value  logical  required  text  n/a  n/a  no  n/a  The value of the user-defined variable. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'disturbanceObs',
        'Disturbance Observation',
        'This table stores plot observation information pertaining to observer estimation of the disturbance history of the plot.',
        'disturbanceObs is  a child of observation; a plot might experience many types of disturbance unique to different observation events.',
        ' disturbanceObs  Disturbance Observation  This table stores plot observation information pertaining to observer estimation of the disturbance history of the plot.  disturbanceObs is  a child of observation; a plot might experience many types of disturbance unique to different observation events.  disturbanceObs_ID  ID  OBSERVATION_ID  Observation  disturbanceType  Disturbance Type  disturbanceIntensity  Disturbance Intensity  disturbanceAge  Disturbance Age  disturbanceExtent  Disturbance Extent  disturbanceComment  Disturbance Comment  emb_disturbanceObs  this row embargoed. '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'disturbanceObs',
        'disturbanceObs_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for disturbanceObs',
        'Database generated identifier assigned to each unique disturbance observation..',
     
        ' disturbanceObs  Disturbance Observation  disturbanceObs_ID  ID  logical    serial  PK  n/a  no  Primary key for disturbanceObs  Database generated identifier assigned to each unique disturbance observation.. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'disturbanceObs',
        'OBSERVATION_ID',
        'Observation',
        'logical',
        'no',
        'Integer',
        'FK',
        'observation.OBSERVATION_ID',
        'no',
        'Foreign key that points to the parent observation for this disturbance record',
        'Link to the observation event with which this report of a disturbance event is associated.',
     
        ' disturbanceObs  Disturbance Observation  OBSERVATION_ID  Observation  logical  required  Integer  FK  observation.OBSERVATION_ID  no  Foreign key that points to the parent observation for this disturbance record  Link to the observation event with which this report of a disturbance event is associated. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'disturbanceObs',
        'disturbanceType',
        'Disturbance Type',
        'logical',
        'no',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'The type of disturbance being reported',
     
        ' disturbanceObs  Disturbance Observation  disturbanceType  Disturbance Type  logical  required  varchar (30)  n/a  n/a  closed  closed list  The type of disturbance being reported  Animal, general    Grazing, domestic stock    Grazing, native ungulates    Herbivory, invertebrate    Herbivory, vertebrates    Human, general    Cultivation    Fire suppression    Herbicide or chemical    Mowing    Roads and vehicular traffic    Timber harvest, general    Timber harvest, clearcut    Timber harvest, selective    Trampling and trails    Natural, general    Avalanche and snow    Cryoturbation    Erosion    Floods    Hydrologic alteration    Ice    Mass movements (landslides)    Plant disease    Salt spray    Tides    Wind, chronic    Wind event    Fire, general    Fire, canopy    Fire, ground    Other disturbances    unknown   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Animal, general',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Grazing, domestic stock',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Grazing, native ungulates',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Herbivory, invertebrate',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Herbivory, vertebrates',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Human, general',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Cultivation',
                              null,
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Fire suppression',
                              null,
                              '8'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Herbicide or chemical',
                              null,
                              '9'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Mowing',
                              null,
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Roads and vehicular traffic',
                              null,
                              '11'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Timber harvest, general',
                              null,
                              '12'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Timber harvest, clearcut',
                              null,
                              '13'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Timber harvest, selective',
                              null,
                              '14'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Trampling and trails',
                              null,
                              '15'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Natural, general',
                              null,
                              '16'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Avalanche and snow',
                              null,
                              '17'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Cryoturbation',
                              null,
                              '18'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Erosion',
                              null,
                              '19'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Floods',
                              null,
                              '23'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Hydrologic alteration',
                              null,
                              '24'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Ice',
                              null,
                              '25'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Mass movements (landslides)',
                              null,
                              '26'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Plant disease',
                              null,
                              '27'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Salt spray',
                              null,
                              '28'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Tides',
                              null,
                              '29'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Wind, chronic',
                              null,
                              '30'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Wind event',
                              null,
                              '31'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Fire, general',
                              null,
                              '35'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Fire, canopy',
                              null,
                              '36'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Fire, ground',
                              null,
                              '37'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'Other disturbances',
                              null,
                              '40'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceType',
                              'unknown',
                              null,
                              '50'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'disturbanceObs',
        'disturbanceIntensity',
        'Disturbance Intensity',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Intensity or degree of the disturbance.',
     
        ' disturbanceObs  Disturbance Observation  disturbanceIntensity  Disturbance Intensity  logical    varchar (30)  n/a  n/a  closed  closed list  Intensity or degree of the disturbance.  High    None  No disturbance of this type was observed on the plot.  This may be a useful observation where certain types of disturbance are expected, but no signs of such disturbance were found.  Low    Medium   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceIntensity',
                              'High',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceIntensity',
                              'Medium',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceIntensity',
                              'Low',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'disturbanceObs',
                              'disturbanceIntensity',
                              'None',
                              'No disturbance of this type was observed on the plot.  This may be a useful observation where certain types of disturbance are expected, but no signs of such disturbance were found.',
                              '4'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'disturbanceObs',
        'disturbanceAge',
        'Disturbance Age',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Estimated time in years since the disturbance event.',
     
        ' disturbanceObs  Disturbance Observation  disturbanceAge  Disturbance Age  logical    Float  n/a  n/a  no  n/a  Estimated time in years since the disturbance event. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'disturbanceObs',
        'disturbanceExtent',
        'Disturbance Extent',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent of the plot that experienced the event.',
     
        ' disturbanceObs  Disturbance Observation  disturbanceExtent  Disturbance Extent  logical    Float  n/a  n/a  no  n/a  Percent of the plot that experienced the event. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'disturbanceObs',
        'disturbanceComment',
        'Disturbance Comment',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Text description of details of the disturbance and its impact on the vegetation.',
     
        ' disturbanceObs  Disturbance Observation  disturbanceComment  Disturbance Comment  logical    text  n/a  n/a  no  n/a  Text description of details of the disturbance and its impact on the vegetation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'disturbanceObs',
        'emb_disturbanceObs',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' disturbanceObs  Disturbance Observation  emb_disturbanceObs  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'graphic',
        'Graphic',
        'This table stores information about graphical files related to vegetation plot observations',
        'Graphical files can include, among other formats: gif, jpeg, and tif file formats.  Because many graphical files, especially remote sensing digital photographs, may be too large to be stored within the database, a graphicLocation may be given as an alternative. Current Business rules cap graphic size at 5M per plot. Graphics of modest size should be included rather than referenced by external address.',
        ' graphic  Graphic  This table stores information about graphical files related to vegetation plot observations  Graphical files can include, among other formats: gif, jpeg, and tif file formats.  Because many graphical files, especially remote sensing digital photographs, may be too large to be stored within the database, a graphicLocation may be given as an alternative. Current Business rules cap graphic size at 5M per plot. Graphics of modest size should be included rather than referenced by external address.  GRAPHIC_ID  ID  OBSERVATION_ID  Observation  graphicName  Graphic Name  graphicLocation  Graphic Location  graphicDescription  Graphic Description  graphicType  Graphic Type  graphicDate  Graphic Date  graphicData  Graphic Data  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'graphic',
        'GRAPHIC_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key the graphic table',
        'Database generated identifier assigned to each unique graphic idem.',
     
        ' graphic  Graphic  GRAPHIC_ID  ID  logical    serial  PK  n/a  no  Primary key the graphic table  Database generated identifier assigned to each unique graphic idem. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'graphic',
        'OBSERVATION_ID',
        'Observation',
        'logical',
        'no',
        'Integer',
        'FK',
        'observation.OBSERVATION_ID',
        'no',
        'Foreign key into the observation table.',
        'Link from a graphic file to a specific plot observation.',
     
        ' graphic  Graphic  OBSERVATION_ID  Observation  logical  required  Integer  FK  observation.OBSERVATION_ID  no  Foreign key into the observation table.  Link from a graphic file to a specific plot observation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'graphic',
        'graphicName',
        'Graphic Name',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the graphic file.',
     
        ' graphic  Graphic  graphicName  Graphic Name  logical    varchar (30)  n/a  n/a  no  n/a  Name of the graphic file. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'graphic',
        'graphicLocation',
        'Graphic Location',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Where the graphic is located, if not in the database',
     
        ' graphic  Graphic  graphicLocation  Graphic Location  logical    text  n/a  n/a  no  n/a  Where the graphic is located, if not in the database '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'graphic',
        'graphicDescription',
        'Graphic Description',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Description of the graphical file and associated metadata such as contributor, author, sensor, etc.',
     
        ' graphic  Graphic  graphicDescription  Graphic Description  logical    text  n/a  n/a  no  n/a  Description of the graphical file and associated metadata such as contributor, author, sensor, etc. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'graphic',
        'graphicType',
        'Graphic Type',
        'logical',
        'yes',
        'varchar (20)',
        'n/a',
        'n/a',
        'no',
        'may become a closed list',
        'The type of the graphical file format (e.g. gif, tif, ,jpeg).',
     
        ' graphic  Graphic  graphicType  Graphic Type  logical    varchar (20)  n/a  n/a  no  may become a closed list  The type of the graphical file format (e.g. gif, tif, ,jpeg). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'graphic',
        'graphicDate',
        'Graphic Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Date that the graphic was produced.',
     
        ' graphic  Graphic  graphicDate  Graphic Date  logical    Date  n/a  n/a  no  n/a  Date that the graphic was produced. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'graphic',
        'graphicData',
        'Graphic Data',
        'logical',
        'yes',
        'oid',
        'n/a',
        'n/a',
        'no',
        'may be constrained by a maximum size',
        'The graphical file data. - Max = 5 M total per plot',
     
        ' graphic  Graphic  graphicData  Graphic Data  logical    oid  n/a  n/a  no  may be constrained by a maximum size  The graphical file data. - Max = 5 M total per plot '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'graphic',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' graphic  Graphic  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'namedPlace',
        'Named Place',
        'This tables stores information about the various ''named places'' that a plot may have been located within. Such places could include geographic regions, study sites, ownership units, managed units, any placename in the USGS glossary (http://www-nmd.usgs.gov/www/gnis/), or equivalent glossary.',
        null,
        ' namedPlace  Named Place  This tables stores information about the various ''named places'' that a plot may have been located within. Such places could include geographic regions, study sites, ownership units, managed units, any placename in the USGS glossary (http://www-nmd.usgs.gov/www/gnis/), or equivalent glossary.    NAMEDPLACE_ID  ID  placeSystem  Place System  placeName  Place Name  placeDescription  Place Description  placeCode  Place Code  owner  Owner  reference_ID  Reference  accessionCode  Accession Code  d_obscount  Plot Count '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlace',
        'NAMEDPLACE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary for the namedPlace table',
        'Database generated identifier assigned to each unique named place.',
     
        ' namedPlace  Named Place  NAMEDPLACE_ID  ID  logical    serial  PK  n/a  no  Primary for the namedPlace table  Database generated identifier assigned to each unique named place. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlace',
        'placeSystem',
        'Place System',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Name of the system of names.  These can be treated as points as with place names, or as a coverage or set of polygons (e.g., geographic area names, HUC codes, Ecoregions, Quadrangles).',
     
        ' namedPlace  Named Place  placeSystem  Place System  logical    varchar (50)  n/a  n/a  closed  closed list  Name of the system of names.  These can be treated as points as with place names, or as a coverage or set of polygons (e.g., geographic area names, HUC codes, Ecoregions, Quadrangles).  area|country|territory  area, country, or territory  continent    county  county, canton, or parish  Geographic Name  User named places  HUC Code    TNC Conservation Region    quadrangle    region|state|province  region or state or province  EPA-Omernik Ecoregion    USFS-Bailey Ecoregion    Ecoregion  A non-standard or generic ecoregion that is not specifically mentioned in this list. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'region|state|province',
                              'region or state or province',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'county',
                              'county, canton, or parish',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'area|country|territory',
                              'area, country, or territory',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'continent',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'quadrangle',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'HUC Code',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'TNC Conservation Region',
                              null,
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'EPA-Omernik Ecoregion',
                              null,
                              '8'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'USFS-Bailey Ecoregion',
                              null,
                              '9'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'Ecoregion',
                              'A non-standard or generic ecoregion that is not specifically mentioned in this list.',
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlace',
                              'placeSystem',
                              'Geographic Name',
                              'User named places',
                              '11'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlace',
        'placeName',
        'Place Name',
        'logical',
        'no',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The name of a place in or at which a plot is located. The system "Geographic Name" is an open list defined within this table. The other systems are generally closed lists constrained by aux_tables. These include at least USGSQuad, Continent, Country, State, County, HUC, and Ecoregion.',
     
        ' namedPlace  Named Place  placeName  Place Name  logical  required  varchar (100)  n/a  n/a  no  n/a  The name of a place in or at which a plot is located. The system "Geographic Name" is an open list defined within this table. The other systems are generally closed lists constrained by aux_tables. These include at least USGSQuad, Continent, Country, State, County, HUC, and Ecoregion. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlace',
        'placeDescription',
        'Place Description',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the description of a named place.',
     
        ' namedPlace  Named Place  placeDescription  Place Description  logical    text  n/a  n/a  no  n/a  This is the description of a named place. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlace',
        'placeCode',
        'Place Code',
        'logical',
        'yes',
        'varchar (15)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Optional code for location identification',
     
        ' namedPlace  Named Place  placeCode  Place Code  logical    varchar (15)  n/a  n/a  no  n/a  Optional code for location identification '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlace',
        'owner',
        'Owner',
        'logical',
        'yes',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Although somewhat redundant with the owner information contained in observationContributor with roleCode of owner, this allows the program to provide ownership information automatically.  The ownership field supercedes this field in priority.',
     
        ' namedPlace  Named Place  owner  Owner  logical    varchar (100)  n/a  n/a  no  n/a  Although somewhat redundant with the owner information contained in observationContributor with roleCode of owner, this allows the program to provide ownership information automatically.  The ownership field supercedes this field in priority. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlace',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'Foreign key into the reference table',
        'Link to a reference that contains further information on the named place.',
     
        ' namedPlace  Named Place  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  Foreign key into the reference table  Link to a reference that contains further information on the named place. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlace',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' namedPlace  Named Place  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlace',
        'd_obscount',
        'Plot Count',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Number of observations associated with this entity.',
     
        ' namedPlace  Named Place  d_obscount  Plot Count  denorm    Integer  n/a  n/a  no  n/a  Number of observations associated with this entity. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'namedPlaceCorrelation',
        'Named Place Correlation',
        'Stores information about how different named places related to one another.',
        null,
        ' namedPlaceCorrelation  Named Place Correlation  Stores information about how different named places related to one another.    NAMEDPLACECORRELATION_ID    PARENTPLACE_ID  Parent Place  CHILDPLACE_ID  Child Place  placeConvergence  Place Convergence '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlaceCorrelation',
        'NAMEDPLACECORRELATION_ID',
        null,
        'logical',
        'no',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Primary Key.',
     
        ' namedPlaceCorrelation  Named Place Correlation  NAMEDPLACECORRELATION_ID    logical  required  serial  PK  n/a  no  n/a  Primary Key. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlaceCorrelation',
        'PARENTPLACE_ID',
        'Parent Place',
        'logical',
        'no',
        'Integer',
        'FK',
        'namedPlace.NAMEDPLACE_ID',
        'no',
        'Foreign key into the namedPlace table',
        'Link to a parent geographical region.',
     
        ' namedPlaceCorrelation  Named Place Correlation  PARENTPLACE_ID  Parent Place  logical  required  Integer  FK  namedPlace.NAMEDPLACE_ID  no  Foreign key into the namedPlace table  Link to a parent geographical region. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlaceCorrelation',
        'CHILDPLACE_ID',
        'Child Place',
        'logical',
        'no',
        'Integer',
        'FK',
        'namedPlace.NAMEDPLACE_ID',
        'no',
        'Foreign key into the namedPlace table',
        'Link to a child geographical region.',
     
        ' namedPlaceCorrelation  Named Place Correlation  CHILDPLACE_ID  Child Place  logical  required  Integer  FK  namedPlace.NAMEDPLACE_ID  no  Foreign key into the namedPlace table  Link to a child geographical region. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'namedPlaceCorrelation',
        'placeConvergence',
        'Place Convergence',
        'logical',
        'no',
        'varchar (20)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'This is the descriptive attribute that is used to relate the congruence between two places, Parent [convergence value] child (generally greater than).',
     
        ' namedPlaceCorrelation  Named Place Correlation  placeConvergence  Place Convergence  logical  required  varchar (20)  n/a  n/a  closed  n/a  This is the descriptive attribute that is used to relate the congruence between two places, Parent [convergence value] child (generally greater than).  equal  The two places are exactly the same.  greater than  The parent place fully contains the child place, and also includes additional space.  less than  The parent place is fully included in the child place, but the child place contains additional space.  not equal  The two places are not exactly the same. This leaves the possibilities that the parent place is greater than, less than, overlapping, similar, or disjunct relative to the child place.  overlapping  The two places contain at least some common area, and each place also contains at least some area that the other does not contain.  Neither place is fully contained in the other.  similar  The two places contain at least some common area.  disjunct  The two places in question contain no common area.  undetermined  Although some correlation is likely, the correlation has not been determined. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlaceCorrelation',
                              'placeConvergence',
                              'equal',
                              'The two places are exactly the same.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlaceCorrelation',
                              'placeConvergence',
                              'greater than',
                              'The parent place fully contains the child place, and also includes additional space.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlaceCorrelation',
                              'placeConvergence',
                              'less than',
                              'The parent place is fully included in the child place, but the child place contains additional space.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlaceCorrelation',
                              'placeConvergence',
                              'not equal',
                              'The two places are not exactly the same. This leaves the possibilities that the parent place is greater than, less than, overlapping, similar, or disjunct relative to the child place.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlaceCorrelation',
                              'placeConvergence',
                              'overlapping',
                              'The two places contain at least some common area, and each place also contains at least some area that the other does not contain.  Neither place is fully contained in the other.',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlaceCorrelation',
                              'placeConvergence',
                              'similar',
                              'The two places contain at least some common area.',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlaceCorrelation',
                              'placeConvergence',
                              'disjunct',
                              'The two places in question contain no common area.',
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'namedPlaceCorrelation',
                              'placeConvergence',
                              'undetermined',
                              'Although some correlation is likely, the correlation has not been determined.',
                              '8'
                       );
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'note',
        'Note',
        'This table is where notations associated with table records are stored',
        'All notes associated with plots and plot observations are stored in this table.  These notes can be linked to any table, record and attribute via the noteLink table.',
        ' note  Note  This table is where notations associated with table records are stored  All notes associated with plots and plot observations are stored in this table.  These notes can be linked to any table, record and attribute via the noteLink table.  NOTE_ID  ID  NOTELINK_ID  Note Link  PARTY_ID  Party  ROLE_ID  Role  noteDate  Note Date  noteType  Note Type  noteText  Note Text  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'note',
        'NOTE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the note table',
        'Database generated identifier assigned to each unique note.',
     
        ' note  Note  NOTE_ID  ID  logical    serial  PK  n/a  no  Primary key for the note table  Database generated identifier assigned to each unique note. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'note',
        'NOTELINK_ID',
        'Note Link',
        'logical',
        'no',
        'Integer',
        'FK',
        'noteLink.NOTELINK_ID',
        'no',
        'Foreign key into the notelink table',
        'Link to the noteLink table via which a note is associated with a table, record and attribute.',
     
        ' note  Note  NOTELINK_ID  Note Link  logical  required  Integer  FK  noteLink.NOTELINK_ID  no  Foreign key into the notelink table  Link to the noteLink table via which a note is associated with a table, record and attribute. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'note',
        'PARTY_ID',
        'Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'Foreign key into the party table',
        'Link to the party table to identify the party that contributed the note.',
     
        ' note  Note  PARTY_ID  Party  logical  required  Integer  FK  party.PARTY_ID  no  Foreign key into the party table  Link to the party table to identify the party that contributed the note. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'note',
        'ROLE_ID',
        'Role',
        'logical',
        'no',
        'Integer',
        'FK',
        'aux_Role.ROLE_ID',
        'no',
        'Foreign key into the aux_role table',
        'What role was the party playing when the note was applied?',
     
        ' note  Note  ROLE_ID  Role  logical  required  Integer  FK  aux_Role.ROLE_ID  no  Foreign key into the aux_role table  What role was the party playing when the note was applied? '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'note',
        'noteDate',
        'Note Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The date on which the note was stored in the database.',
     
        ' note  Note  noteDate  Note Date  logical    Date  n/a  n/a  no  n/a  The date on which the note was stored in the database. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'note',
        'noteType',
        'Note Type',
        'logical',
        'no',
        'varchar (20)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'The type of note: Database Management, Observation Author, Database User and Internal. "Database Management" notes are those added by the management team and may be queried and viewed by the public. "Database Use" notes are those entered by the users of the database and are publicly viewable. "Internal" notes are for management to use internally and will not be broadcast.',
     
        ' note  Note  noteType  Note Type  logical  required  varchar (20)  n/a  n/a  closed  closed list  The type of note: Database Management, Observation Author, Database User and Internal. "Database Management" notes are those added by the management team and may be queried and viewed by the public. "Database Use" notes are those entered by the users of the database and are publicly viewable. "Internal" notes are for management to use internally and will not be broadcast.  Clarification    Correction    Internal    Warning   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'note',
                              'noteType',
                              'Clarification',
                              null,
                              '0'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'note',
                              'noteType',
                              'Correction',
                              null,
                              '0'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'note',
                              'noteType',
                              'Internal',
                              null,
                              '0'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'note',
                              'noteType',
                              'Warning',
                              null,
                              '0'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'note',
        'noteText',
        'Note Text',
        'logical',
        'no',
        'text',
        'n/a',
        'n/a',
        'no',
        'actual note text',
        'The text of the note.',
     
        ' note  Note  noteText  Note Text  logical  required  text  n/a  n/a  no  actual note text  The text of the note. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'note',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' note  Note  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'noteLink',
        'Note Link',
        'This table links a note made by a database user or manager to a specific table, record and attribute in the database.',
        'This table was developed with the goal of keeping all the notes associated with the plots in a single table rather than distributed in many tables across  the database.',
        ' noteLink  Note Link  This table links a note made by a database user or manager to a specific table, record and attribute in the database.  This table was developed with the goal of keeping all the notes associated with the plots in a single table rather than distributed in many tables across  the database.  NOTELINK_ID  ID  tableName  Table Name  attributeName  Attribute Name  tableRecord  Table Record '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'noteLink',
        'NOTELINK_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the noteLink table',
        'Database generated identifier assigned to each unique noteLink.',
     
        ' noteLink  Note Link  NOTELINK_ID  ID  logical    serial  PK  n/a  no  Primary key for the noteLink table  Database generated identifier assigned to each unique noteLink. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'noteLink',
        'tableName',
        'Table Name',
        'logical',
        'no',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the table that the note is associated with.',
     
        ' noteLink  Note Link  tableName  Table Name  logical  required  varchar (50)  n/a  n/a  no  n/a  Name of the table that the note is associated with. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'noteLink',
        'attributeName',
        'Attribute Name',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the attribute in the table (stored in tableName) that the note is associated with.',
     
        ' noteLink  Note Link  attributeName  Attribute Name  logical    varchar (50)  n/a  n/a  no  n/a  Name of the attribute in the table (stored in tableName) that the note is associated with. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'noteLink',
        'tableRecord',
        'Table Record',
        'logical',
        'no',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The record number (row) containing the value with which the note is associated (which translates to the primary key value for the table wherein the record is stored).',
     
        ' noteLink  Note Link  tableRecord  Table Record  logical  required  Integer  n/a  n/a  no  n/a  The record number (row) containing the value with which the note is associated (which translates to the primary key value for the table wherein the record is stored). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'observation',
        'Observation',
        'This table stores plot observation results that might vary between official observation events.',
        'Observation is a child of plot in recognition of the fact that a plot may be re-sampled and that some of the environmental conditions may change between resampling events.   ',
        ' observation  Observation  This table stores plot observation results that might vary between official observation events.  Observation is a child of plot in recognition of the fact that a plot may be re-sampled and that some of the environmental conditions may change between resampling events.     OBSERVATION_ID  OBSERVATION ID  PREVIOUSOBS_ID  Previous Observation  PLOT_ID  Plot  PROJECT_ID  Project  authorObsCode  Author Observation Code  obsStartDate  Observation Start Date  obsEndDate  Observation End Date  dateAccuracy  Date Accuracy  dateEntered  Date Entered into VegBank  COVERMETHOD_ID  Cover Method  coverDispersion  Cover Dispersion  autoTaxonCover  Overall Taxon Cover Values are Automatically Calculated?  STRATUMMETHOD_ID  Stratum Method  methodNarrative  Method Narrative  taxonObservationArea  Taxon Observation Area  stemSizeLimit  Stem Size Limit  stemObservationArea  Stem Observation Area  stemSampleMethod  Stem Sample Method  originalData  Original Data Location  effortLevel  Effort Level  plotValidationLevel  Plot Validation Level  floristicQuality  Floristic Quality  bryophyteQuality  Bryophyte Quality  lichenQuality  Lichen Quality  observationNarrative  Observation Narrative  landscapeNarrative  Landscape Narrative  homogeneity  Homogeneity  phenologicAspect  Phenologic Aspect  representativeness  Representativeness  standMaturity  Stand Maturity  successionalStatus  Successional Status  numberOfTaxa  Number of Taxa  basalArea  Basal Area  hydrologicRegime  Hydrologic Regime  soilMoistureRegime  Soil Moisture Regime  soilDrainage  Soil Drainage  waterSalinity  Water Salinity  waterDepth  Water Depth  shoreDistance  Shore Distance  soilDepth  Soil Depth  organicDepth  Organic Depth  SOILTAXON_ID  Soil Taxon  soilTaxonSrc  Soil Taxon Source  percentBedRock  Percent Bedrock  percentRockGravel  Percent Rock / Gravel  percentWood  Percent Wood  percentLitter  Percent Litter  percentBareSoil  Percent Bare Soil  percentWater  Percent Water  percentOther  Percent Other  nameOther  Name Other  treeHt  Tree Height  shrubHt  Shrub Height  fieldHt  Field Height  nonvascularHt  Nonvascular Height  submergedHt  Submerged Height  treeCover  Tree Cover  shrubCover  Shrub Cover  fieldCover  Field Cover  nonvascularCover  Nonvascular Cover  floatingCover  Floating Cover  submergedCover  Submerged Cover  dominantStratum  Dominant Stratum  growthform1Type  Growthform1 Type  growthform2Type  Growthform2 Type  growthform3Type  Growthform3 Type  growthform1Cover  Growthform1 Cover  growthform2Cover  Growthform2 Cover  growthform3Cover  Growthform3 Cover  totalCover  Total Cover  accessionCode  Observation Accession Code  notesPublic  Notes Public  notesMgt  Notes Mgt  revisions  Revisions  emb_observation  this row embargoed.  interp_orig_ci_ID  Original commInterpret ID  interp_orig_cc_ID  CommConcept_ID  interp_orig_sciname  Scientific Name of Community.  interp_orig_code  CEGL-type code of Community.  interp_orig_party_id  Party_ID of classifier.  interp_orig_partyname  Classifier.  interp_current_ci_ID  Most Recent Classification commInterp ID  interp_current_cc_ID  CommConcept_ID  interp_current_sciname  Scientific Name of Community.  interp_current_code  CEGL-type code of Community.  interp_current_party_id  Party_ID of classifier.  interp_current_partyname  Classifier.  interp_bestfit_ci_ID  Best Fit commInterp ID  interp_bestfit_cc_ID  CommConcept_ID  interp_bestfit_sciname  Scientific Name of Community.  interp_bestfit_code  CEGL-type code of Community.  interp_bestfit_party_id  Party_ID of classifier.  interp_bestfit_partyname  Classifier.  topTaxon1Name  Top Taxon #1  topTaxon2Name  Top Taxon #2  topTaxon3Name  Top Taxon #3  topTaxon4Name  Top Taxon #4  topTaxon5Name  Top Taxon #5  hasObservationSynonym  Has Synonym Observation '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'OBSERVATION_ID',
        'OBSERVATION ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the observation table',
        'Database generated identifier assigned to each unique plot observation.',
     
        ' observation  Observation  OBSERVATION_ID  OBSERVATION ID  logical    serial  PK  n/a  no  Primary key for the observation table  Database generated identifier assigned to each unique plot observation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'PREVIOUSOBS_ID',
        'Previous Observation',
        'logical',
        'yes',
        'Integer',
        'FK',
        'observation.OBSERVATION_ID',
        'no',
        'Recursive foreign key',
        'Link to data from the previous observation of this plot.',
     
        ' observation  Observation  PREVIOUSOBS_ID  Previous Observation  logical    Integer  FK  observation.OBSERVATION_ID  no  Recursive foreign key  Link to data from the previous observation of this plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'PLOT_ID',
        'Plot',
        'logical',
        'no',
        'Integer',
        'FK',
        'plot.PLOT_ID',
        'no',
        'Foreign key into the plot table.',
        'Link to data and metadata that do not change between observations and which are stored in the plot table.',
     
        ' observation  Observation  PLOT_ID  Plot  logical  required  Integer  FK  plot.PLOT_ID  no  Foreign key into the plot table.  Link to data and metadata that do not change between observations and which are stored in the plot table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'PROJECT_ID',
        'Project',
        'logical',
        'yes',
        'Integer',
        'FK',
        'project.PROJECT_ID',
        'no',
        'Foreign key into the project table.',
        'Link between an observation and the project within which the observation was made',
     
        ' observation  Observation  PROJECT_ID  Project  logical    Integer  FK  project.PROJECT_ID  no  Foreign key into the project table.  Link between an observation and the project within which the observation was made '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'authorObsCode',
        'Author Observation Code',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the code or name that the author uses to identify this plot observation event. Where a plot has only one observation, this will often equal plot.authorPlotCode.',
     
        ' observation  Observation  authorObsCode  Author Observation Code  logical    varchar (30)  n/a  n/a  no  n/a  This is the code or name that the author uses to identify this plot observation event. Where a plot has only one observation, this will often equal plot.authorPlotCode. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'obsStartDate',
        'Observation Start Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'default = current year',
        'The date of the observation, or the first day if the observation spanned more than one day.',
     
        ' observation  Observation  obsStartDate  Observation Start Date  logical    Date  n/a  n/a  no  default = current year  The date of the observation, or the first day if the observation spanned more than one day. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'obsEndDate',
        'Observation End Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'If the observation event spanned more than a single day, this is the last day on which observations were made.',
     
        ' observation  Observation  obsEndDate  Observation End Date  logical    Date  n/a  n/a  no  n/a  If the observation event spanned more than a single day, this is the last day on which observations were made. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'dateAccuracy',
        'Date Accuracy',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Estimated accuracy of the observation date.',
     
        ' observation  Observation  dateAccuracy  Date Accuracy  logical    varchar (30)  n/a  n/a  closed  closed list  Estimated accuracy of the observation date.  Exact  The exact date of the observation - within one day.  One week    One month  Within one month of the observation.  Three months    One year    Three years    Ten years    Greater than ten years   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dateAccuracy',
                              'Exact',
                              'The exact date of the observation - within one day.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dateAccuracy',
                              'One week',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dateAccuracy',
                              'One month',
                              'Within one month of the observation.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dateAccuracy',
                              'Three months',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dateAccuracy',
                              'One year',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dateAccuracy',
                              'Three years',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dateAccuracy',
                              'Ten years',
                              null,
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dateAccuracy',
                              'Greater than ten years',
                              null,
                              '8'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'dateEntered',
        'Date Entered into VegBank',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Date that the observation was added to VegBank',
     
        ' observation  Observation  dateEntered  Date Entered into VegBank  logical    Date  n/a  n/a  no  n/a  Date that the observation was added to VegBank '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'COVERMETHOD_ID',
        'Cover Method',
        'logical',
        'yes',
        'Integer',
        'FK',
        'coverMethod.COVERMETHOD_ID',
        'no',
        'Foreign key into the coverMethod table.',
        'Link to the scale used to estimate taxon cover. The database stores estimated cover to the nearest percent, but the conversion details are recovered by reference to the specific scale employed.',
     
        ' observation  Observation  COVERMETHOD_ID  Cover Method  logical    Integer  FK  coverMethod.COVERMETHOD_ID  no  Foreign key into the coverMethod table.  Link to the scale used to estimate taxon cover. The database stores estimated cover to the nearest percent, but the conversion details are recovered by reference to the specific scale employed. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'coverDispersion',
        'Cover Dispersion',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list; default = Entire',
        'Were cover values for the total taxon list collected from one contiguous area or dispersed subplots?',
     
        ' observation  Observation  coverDispersion  Cover Dispersion  logical    varchar (30)  n/a  n/a  closed  closed list; default = Entire  Were cover values for the total taxon list collected from one contiguous area or dispersed subplots?  Entire  Cover based on observation of an entire plot consisting of a single contiguous area of land.  subplot-random  Cover based on observation of multiple randomly dispersed subplots within the overall plot.  subplot-regular  Cover based on observation of multiple subplots arranged in a regular pattern within the overall plot.  subplot-haphazard  Cover based on observation of multiple subplots haphazardly arranged within the overall plot.  subplot-contiguous  Cover based on observation of a single contiguous area of land of less spatial extent than the entire plot.  line-intercept  Cover based on length of line touching each species present.  point-intercept  Cover based on number of points for each species present. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'coverDispersion',
                              'Entire',
                              'Cover based on observation of an entire plot consisting of a single contiguous area of land.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'coverDispersion',
                              'subplot-contiguous',
                              'Cover based on observation of a single contiguous area of land of less spatial extent than the entire plot.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'coverDispersion',
                              'subplot-regular',
                              'Cover based on observation of multiple subplots arranged in a regular pattern within the overall plot.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'coverDispersion',
                              'subplot-random',
                              'Cover based on observation of multiple randomly dispersed subplots within the overall plot.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'coverDispersion',
                              'subplot-haphazard',
                              'Cover based on observation of multiple subplots haphazardly arranged within the overall plot.',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'coverDispersion',
                              'line-intercept',
                              'Cover based on length of line touching each species present.',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'coverDispersion',
                              'point-intercept',
                              'Cover based on number of points for each species present.',
                              '7'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'autoTaxonCover',
        'Overall Taxon Cover Values are Automatically Calculated?',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'default = FALSE',
        'TRUE indicates that taxonObservation.taxonCover was automatically calculated from the values of all stratumObservation.taxonStratumCover',
     
        ' observation  Observation  autoTaxonCover  Overall Taxon Cover Values are Automatically Calculated?  logical    Boolean  n/a  n/a  no  default = FALSE  TRUE indicates that taxonObservation.taxonCover was automatically calculated from the values of all stratumObservation.taxonStratumCover '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'STRATUMMETHOD_ID',
        'Stratum Method',
        'logical',
        'yes',
        'Integer',
        'FK',
        'stratumMethod.STRATUMMETHOD_ID',
        'no',
        'Foreign key into the stratumMethod table',
        'Link to the definitions of strata used in recording taxon-specific values of cover.',
     
        ' observation  Observation  STRATUMMETHOD_ID  Stratum Method  logical    Integer  FK  stratumMethod.STRATUMMETHOD_ID  no  Foreign key into the stratumMethod table  Link to the definitions of strata used in recording taxon-specific values of cover. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'methodNarrative',
        'Method Narrative',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Additional metadata helpful for understanding how the data were collected during the observation event.',
     
        ' observation  Observation  methodNarrative  Method Narrative  logical    text  n/a  n/a  no  n/a  Additional metadata helpful for understanding how the data were collected during the observation event. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'taxonObservationArea',
        'Taxon Observation Area',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'default = plot.area',
        'the total surface area (in m^2) used for cover estimates and for which a complete species list is provided.  If subplots were used, this would be the total area of the subplots without interstitial space.  RESERVED VALUE: -1 is used to indicate the complete list of species had no known boundaries.',
     
        ' observation  Observation  taxonObservationArea  Taxon Observation Area  logical    Float  n/a  n/a  no  default = plot.area  the total surface area (in m^2) used for cover estimates and for which a complete species list is provided.  If subplots were used, this would be the total area of the subplots without interstitial space.  RESERVED VALUE: -1 is used to indicate the complete list of species had no known boundaries. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'stemSizeLimit',
        'Stem Size Limit',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Lower diameter limit in centimeters for inclusion of a tree in the stem count (stemCount).',
     
        ' observation  Observation  stemSizeLimit  Stem Size Limit  logical    Float  n/a  n/a  no  n/a  Lower diameter limit in centimeters for inclusion of a tree in the stem count (stemCount). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'stemObservationArea',
        'Stem Observation Area',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'default = plot.area',
        'the total surface area (in m^2) observed for recording woody stem data.  RESERVED VALUE: -1 means no known area.',
     
        ' observation  Observation  stemObservationArea  Stem Observation Area  logical    Float  n/a  n/a  no  default = plot.area  the total surface area (in m^2) observed for recording woody stem data.  RESERVED VALUE: -1 means no known area. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'stemSampleMethod',
        'Stem Sample Method',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list; default = full census',
        'The method used to obtain basal area or tree stem data (e.g., full census, point quarter, random pairs, Bitterlich, other).',
     
        ' observation  Observation  stemSampleMethod  Stem Sample Method  logical    varchar (30)  n/a  n/a  closed  closed list; default = full census  The method used to obtain basal area or tree stem data (e.g., full census, point quarter, random pairs, Bitterlich, other).  Bitterlich    Full census    Other    Point quarter    Random pairs    Subsample census   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'stemSampleMethod',
                              'Full census',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'stemSampleMethod',
                              'Point quarter',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'stemSampleMethod',
                              'Random pairs',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'stemSampleMethod',
                              'Bitterlich',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'stemSampleMethod',
                              'Other',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'stemSampleMethod',
                              'Subsample census',
                              null,
                              '6'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'originalData',
        'Original Data Location',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Location where the hard data reside and any access instructions.',
     
        ' observation  Observation  originalData  Original Data Location  logical    text  n/a  n/a  no  n/a  Location where the hard data reside and any access instructions. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'effortLevel',
        'Effort Level',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'This is the effort spent making the observations as estimated by the party that submitted the data (e.g., Very thorough, Average, Hurried description).',
     
        ' observation  Observation  effortLevel  Effort Level  logical    varchar (30)  n/a  n/a  closed  closed list  This is the effort spent making the observations as estimated by the party that submitted the data (e.g., Very thorough, Average, Hurried description).  Accurate    Hurried or incomplete    Very thorough   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'effortLevel',
                              'Very thorough',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'effortLevel',
                              'Accurate',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'effortLevel',
                              'Hurried or incomplete',
                              null,
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'plotValidationLevel',
        'Plot Validation Level',
        'logical',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Quality of plot as determined by an automated filter system, including values such as (1) sufficient for determining type occurrence, (2) sufficient for inclusion in a classification  revision, and (3) fully compliant with recommendations.',
     
        ' observation  Observation  plotValidationLevel  Plot Validation Level  logical    Integer  n/a  n/a  closed  closed list  Quality of plot as determined by an automated filter system, including values such as (1) sufficient for determining type occurrence, (2) sufficient for inclusion in a classification  revision, and (3) fully compliant with recommendations.  -1  observation has not yet been fully rectified by user and is not complete.  1  sufficient for determining type occurrence  2  sufficient for inclusion in a classification revision  3  sufficient for classification and meets best practices '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'plotValidationLevel',
                              '-1',
                              'observation has not yet been fully rectified by user and is not complete.',
                              '-1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'plotValidationLevel',
                              '1',
                              'sufficient for determining type occurrence',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'plotValidationLevel',
                              '2',
                              'sufficient for inclusion in a classification revision',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'plotValidationLevel',
                              '3',
                              'sufficient for classification and meets best practices',
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'floristicQuality',
        'Floristic Quality',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Subjective assessment of floristic quality by the party that submitted the plot (e.g., Highest, High, High but incomplete, Moderate, Moderate and incomplete, Low).',
     
        ' observation  Observation  floristicQuality  Floristic Quality  logical    varchar (30)  n/a  n/a  closed  closed list  Subjective assessment of floristic quality by the party that submitted the plot (e.g., Highest, High, High but incomplete, Moderate, Moderate and incomplete, Low).  High  between 85% and 95% of all taxa were identified to species level; search was thorough.  High but incomplete  at least 85% of all taxa were identified to species level; search was not so thorough.  Highest  at least 95% of all taxa were identified to species level; search was thorough.  Low  less than 70% of all taxa were identified to species level.  Moderate  between 70% and 85% of all taxa were identified to species level; search was thorough.  Moderate but incomplete  between 70% and 85% of all taxa were identified to species level; search was not so thorough. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'floristicQuality',
                              'Highest',
                              'at least 95% of all taxa were identified to species level; search was thorough.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'floristicQuality',
                              'High',
                              'between 85% and 95% of all taxa were identified to species level; search was thorough.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'floristicQuality',
                              'High but incomplete',
                              'at least 85% of all taxa were identified to species level; search was not so thorough.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'floristicQuality',
                              'Moderate',
                              'between 70% and 85% of all taxa were identified to species level; search was thorough.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'floristicQuality',
                              'Moderate but incomplete',
                              'between 70% and 85% of all taxa were identified to species level; search was not so thorough.',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'floristicQuality',
                              'Low',
                              'less than 70% of all taxa were identified to species level.',
                              '6'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'bryophyteQuality',
        'Bryophyte Quality',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Subjective assessment of the taxonomic quality of the bryophyte data by the party that submitted the plot (e.g., Highest, High, High but incomplete, Moderate, Moderate and incomplete, Low, Very incomplete, absent).',
     
        ' observation  Observation  bryophyteQuality  Bryophyte Quality  logical    varchar (30)  n/a  n/a  closed  closed list  Subjective assessment of the taxonomic quality of the bryophyte data by the party that submitted the plot (e.g., Highest, High, High but incomplete, Moderate, Moderate and incomplete, Low, Very incomplete, absent).  High    High but incomplete    Highest    Low    Moderate    Moderate but incomplete    Not examined    Very incomplete   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'bryophyteQuality',
                              'Highest',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'bryophyteQuality',
                              'High',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'bryophyteQuality',
                              'High but incomplete',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'bryophyteQuality',
                              'Moderate',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'bryophyteQuality',
                              'Moderate but incomplete',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'bryophyteQuality',
                              'Low',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'bryophyteQuality',
                              'Very incomplete',
                              null,
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'bryophyteQuality',
                              'Not examined',
                              null,
                              '8'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'lichenQuality',
        'Lichen Quality',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Subjective assessment of the taxonomic quality of the lichen data by the party that submitted the plot (e.g., Highest, High, High but incomplete, Moderate, Moderate and incomplete, Low, Very incomplete, absent).',
     
        ' observation  Observation  lichenQuality  Lichen Quality  logical    varchar (30)  n/a  n/a  closed  closed list  Subjective assessment of the taxonomic quality of the lichen data by the party that submitted the plot (e.g., Highest, High, High but incomplete, Moderate, Moderate and incomplete, Low, Very incomplete, absent).  High    High but incomplete    Highest    Low    Moderate    Moderate but incomplete    Not examined    Very incomplete   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'lichenQuality',
                              'Highest',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'lichenQuality',
                              'High',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'lichenQuality',
                              'High but incomplete',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'lichenQuality',
                              'Moderate',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'lichenQuality',
                              'Moderate but incomplete',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'lichenQuality',
                              'Low',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'lichenQuality',
                              'Very incomplete',
                              null,
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'lichenQuality',
                              'Not examined',
                              null,
                              '8'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'observationNarrative',
        'Observation Narrative',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Additional unstructured observations useful for understanding the ecological attributes and significance of the plot observations.',
     
        ' observation  Observation  observationNarrative  Observation Narrative  logical    text  n/a  n/a  no  n/a  Additional unstructured observations useful for understanding the ecological attributes and significance of the plot observations. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'landscapeNarrative',
        'Landscape Narrative',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Unstructured observations on the landscape context of the observed plot.',
     
        ' observation  Observation  landscapeNarrative  Landscape Narrative  logical    text  n/a  n/a  no  n/a  Unstructured observations on the landscape context of the observed plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'homogeneity',
        'Homogeneity',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'How homogeneous was the community (e.g., homogeneous, compositional trend across plot, conspicuous inclusions, irregular mosaic or pattern).',
     
        ' observation  Observation  homogeneity  Homogeneity  logical    varchar (50)  n/a  n/a  closed  closed list  How homogeneous was the community (e.g., homogeneous, compositional trend across plot, conspicuous inclusions, irregular mosaic or pattern).  compositional trend across plot    conspicuous inclusions    homogeneous    irregular or pattern mosaic   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'homogeneity',
                              'homogeneous',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'homogeneity',
                              'compositional trend across plot',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'homogeneity',
                              'conspicuous inclusions',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'homogeneity',
                              'irregular or pattern mosaic',
                              null,
                              '4'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'phenologicAspect',
        'Phenologic Aspect',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Season expression of the community (e.g., typical growing season, vernal, aestival, wet, autumnal, winter, dry, irregular ephemerals present).',
     
        ' observation  Observation  phenologicAspect  Phenologic Aspect  logical    varchar (30)  n/a  n/a  closed  closed list  Season expression of the community (e.g., typical growing season, vernal, aestival, wet, autumnal, winter, dry, irregular ephemerals present).  aestival    autumnal    dry season    early wet season    irregular ephemeral phase    late wet season    typical growing season    vernal    wet season    winter   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'phenologicAspect',
                              'typical growing season',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'phenologicAspect',
                              'vernal',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'phenologicAspect',
                              'early wet season',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'phenologicAspect',
                              'aestival',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'phenologicAspect',
                              'wet season',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'phenologicAspect',
                              'autumnal',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'phenologicAspect',
                              'late wet season',
                              null,
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'phenologicAspect',
                              'winter',
                              null,
                              '8'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'phenologicAspect',
                              'dry season',
                              null,
                              '9'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'phenologicAspect',
                              'irregular ephemeral phase',
                              null,
                              '10'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'representativeness',
        'Representativeness',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'How representative was the plot of the stand?',
     
        ' observation  Observation  representativeness  Representativeness  logical    varchar (255)  n/a  n/a  no  n/a  How representative was the plot of the stand? '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'standMaturity',
        'Stand Maturity',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'How mature is the stand.  Could be young, mature but even-aged, old-growth, etc.',
     
        ' observation  Observation  standMaturity  Stand Maturity  logical    varchar (50)  n/a  n/a  closed  closed list  How mature is the stand.  Could be young, mature but even-aged, old-growth, etc.  Even-age, aggrading    Mature, even-age    Oldgrowth, all-age    Transition, breakup    Young, regenerative    Uneven-age  Ages of individuals are uneven so that this community does not fit neatly into the succession model. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'standMaturity',
                              'Young, regenerative',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'standMaturity',
                              'Even-age, aggrading',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'standMaturity',
                              'Mature, even-age',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'standMaturity',
                              'Transition, breakup',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'standMaturity',
                              'Oldgrowth, all-age',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'standMaturity',
                              'Uneven-age',
                              'Ages of individuals are uneven so that this community does not fit neatly into the succession model.',
                              '6'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'successionalStatus',
        'Successional Status',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Description of the assumed successional status of the plot. This description is of necessity highly subjective.',
     
        ' observation  Observation  successionalStatus  Successional Status  logical    text  n/a  n/a  no  n/a  Description of the assumed successional status of the plot. This description is of necessity highly subjective. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'numberOfTaxa',
        'Number of Taxa',
        'logical',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'default could be count of taxonObservations',
        'The number of taxa found on the plot, within the taxonObservationArea. Any species known to be found only outside of the taxonObservationArea would not be included in this number.  Use 0 for this field to indicate that no taxa were found within the plot bounds.',
     
        ' observation  Observation  numberOfTaxa  Number of Taxa  logical    Integer  n/a  n/a  no  default could be count of taxonObservations  The number of taxa found on the plot, within the taxonObservationArea. Any species known to be found only outside of the taxonObservationArea would not be included in this number.  Use 0 for this field to indicate that no taxa were found within the plot bounds. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'basalArea',
        'Basal Area',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total basal area of woody stems (in m²/ha).  0 should be used to indicate that plots have no stems.',
     
        ' observation  Observation  basalArea  Basal Area  logical    Float  n/a  n/a  no  n/a  Total basal area of woody stems (in m²/ha).  0 should be used to indicate that plots have no stems. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'hydrologicRegime',
        'Hydrologic Regime',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'What is the hydrologic regime, which is a reflection of frequency and duration of flooding?  List is taken from Cowardin et al. 1979, 1985.',
     
        ' observation  Observation  hydrologicRegime  Hydrologic Regime  logical    varchar (30)  n/a  n/a  closed  closed list  What is the hydrologic regime, which is a reflection of frequency and duration of flooding?  List is taken from Cowardin et al. 1979, 1985.  Intermittently flooded  Substrate is usually exposed, but surface water can be present for variable periods without detectable seasonal periodicity. Inundation is not predictable to a given season and is dependent upon highly localized rain storms. This modifier was developed for use in the arid West for water regimes of Playa lakes, intermittent streams, and dry washes but can be used in other parts of the U.S. where appropriate. This modifier can be applied to both wetland and non-wetland situations. Equivalent to Cowardin''s Intermittently Flooded modifier.  Permanently flooded  Water covers the land surface at all times of the year in all years. Equivalent to Cowardin''s "permanently flooded".  Permanently flooded - tidal  Salt water covers the land surface at all times of the year in all years. This modifier applies only to permanently flooded area irregularly flooded by fresh tidal water. Equivalent to Cowardin''s "permanently flooded/tidal".  Saturated  Surface water is seldom present, but substrate is saturated to surface for extended periods during the growing season. Equivalent to Cowardin''s Saturated modifier.  Seasonally flooded  Surface water is present for extended periods during the growing season, but is absent by the end of the growing season in most years. The water table after flooding ceases is very variable, extending from saturated to a water table well below the ground surface. Includes Cowardin''s Seasonal, Seasonal-Saturated, and Seasonal-Well Drained modifiers.  Seasonally saturated    Semipermanently flooded  Surface water persists throughout the growing season in most years. Land surface is normally saturated when water level drops below soil surface. Includes Cowardin''s Intermittently Exposed and Semipermanently Flooded modifiers.  Temporarily flooded  Surface water present for brief periods during growing season, but water table usually lies well below soil surface. Often characterizes flood-plain wetlands. Equivalent to Cowardin''s Temporary modifier.  Tidally flooded  Flooded by the alternate rise and fall of the surface of oceans, seas, and the bays, rivers, etc. connected to them, caused by the attraction of the moon and sun.  Unknown    Upland  Not a wetland.  Very rarely flooded.  Irregularly flooded  Tidal water floods land surface less often than daily; the area must be flooded by tides at least once yearly as a result of extreme high spring tide plus wind plus flow.  Irregularly exposed  Land surface is exposed by tides less often than daily; the area from mean low tide to extreme low spring tide.  Wind-tidally flooded  Flooded by the alternate rise and fall of the surface of oceans, seas, and the bays, rivers, etc. connected to them, caused by the back-up of water caused by unfavorable winds. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Semipermanently flooded',
                              'Surface water persists throughout the growing season in most years. Land surface is normally saturated when water level drops below soil surface. Includes Cowardin''s Intermittently Exposed and Semipermanently Flooded modifiers.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Seasonally flooded',
                              'Surface water is present for extended periods during the growing season, but is absent by the end of the growing season in most years. The water table after flooding ceases is very variable, extending from saturated to a water table well below the ground surface. Includes Cowardin''s Seasonal, Seasonal-Saturated, and Seasonal-Well Drained modifiers.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Saturated',
                              'Surface water is seldom present, but substrate is saturated to surface for extended periods during the growing season. Equivalent to Cowardin''s Saturated modifier.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Seasonally saturated',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Temporarily flooded',
                              'Surface water present for brief periods during growing season, but water table usually lies well below soil surface. Often characterizes flood-plain wetlands. Equivalent to Cowardin''s Temporary modifier.',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Intermittently flooded',
                              'Substrate is usually exposed, but surface water can be present for variable periods without detectable seasonal periodicity. Inundation is not predictable to a given season and is dependent upon highly localized rain storms. This modifier was developed for use in the arid West for water regimes of Playa lakes, intermittent streams, and dry washes but can be used in other parts of the U.S. where appropriate. This modifier can be applied to both wetland and non-wetland situations. Equivalent to Cowardin''s Intermittently Flooded modifier.',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Permanently flooded',
                              'Water covers the land surface at all times of the year in all years. Equivalent to Cowardin''s "permanently flooded".',
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Permanently flooded - tidal',
                              'Salt water covers the land surface at all times of the year in all years. This modifier applies only to permanently flooded area irregularly flooded by fresh tidal water. Equivalent to Cowardin''s "permanently flooded/tidal".',
                              '8'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Tidally flooded',
                              'Flooded by the alternate rise and fall of the surface of oceans, seas, and the bays, rivers, etc. connected to them, caused by the attraction of the moon and sun.',
                              '9'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Wind-tidally flooded',
                              'Flooded by the alternate rise and fall of the surface of oceans, seas, and the bays, rivers, etc. connected to them, caused by the back-up of water caused by unfavorable winds.',
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Irregularly flooded',
                              'Tidal water floods land surface less often than daily; the area must be flooded by tides at least once yearly as a result of extreme high spring tide plus wind plus flow.',
                              '11'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Irregularly exposed',
                              'Land surface is exposed by tides less often than daily; the area from mean low tide to extreme low spring tide.',
                              '12'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Upland',
                              'Not a wetland.  Very rarely flooded.',
                              '13'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'hydrologicRegime',
                              'Unknown',
                              null,
                              '14'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'soilMoistureRegime',
        'Soil Moisture Regime',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'How moist was the soil at the sampling event?',
     
        ' observation  Observation  soilMoistureRegime  Soil Moisture Regime  logical    varchar (30)  n/a  n/a  closed  closed list  How moist was the soil at the sampling event?  Hydric    Hygric    Mesic    Subhydric    Subhygric    Submesic    Subxeric    Very xeric    Xeric   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilMoistureRegime',
                              'Very xeric',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilMoistureRegime',
                              'Xeric',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilMoistureRegime',
                              'Subxeric',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilMoistureRegime',
                              'Submesic',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilMoistureRegime',
                              'Mesic',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilMoistureRegime',
                              'Subhygric',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilMoistureRegime',
                              'Hygric',
                              null,
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilMoistureRegime',
                              'Subhydric',
                              null,
                              '8'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilMoistureRegime',
                              'Hydric',
                              null,
                              '9'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'soilDrainage',
        'Soil Drainage',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Identifies the natural drainage conditions of the soil and refers to the frequency and duration of wet periods. The soil drainage classes are defined in terms of (1) actual moisture content (in excess of field moisture capacity) and (2) the extent of the period during which excess water is present in the plant-root zone. Soil drainage class categories conform to the FGDC Soil Geographic Data Standards, September 1997. (http://www.fgdc.gov/standards/documents/standards/soils/soil997.PDF.) Definitions are derived from Grossman et al. (1998) and Sims et al. (1997). ',
     
        ' observation  Observation  soilDrainage  Soil Drainage  logical    varchar (30)  n/a  n/a  closed  closed list  Identifies the natural drainage conditions of the soil and refers to the frequency and duration of wet periods. The soil drainage classes are defined in terms of (1) actual moisture content (in excess of field moisture capacity) and (2) the extent of the period during which excess water is present in the plant-root zone. Soil drainage class categories conform to the FGDC Soil Geographic Data Standards, September 1997. (http://www.fgdc.gov/standards/documents/standards/soils/soil997.PDF.) Definitions are derived from Grossman et al. (1998) and Sims et al. (1997).   excessively drained  Soils are free from any evidence of gleying throughout the profile.  These soils are commonly very coarse textured (e.g., >35% volume of particles > 2 mm in size) or soils on very steep slopes.  Sometimes described as "very rapidly drained."  somewhat excessively drained  The soil moisture content seldom exceeds field capacity in any horizon except immediately after water addition. Soils are free from any evidence of gleying throughout the profile.  Rapidly drained soils are commonly coarse textured or soils on steep slopes. Sometimes described as "rapidly drained."  well drained  The soil moisture content does not normally exceed field capacity in any horizon (except possibly the C) for a significant part of the year.  Soils are usually free from mottling in the upper 3 feet (1 m), but may be mottled below this depth. B horizons, if present, are reddish, brownish, or yellowish.  moderately well drained  The soil moisture in excess of field capacity remains for a small but significant period of the year.  Soils are commonly mottled (chroma < 2) in the lower B and C horizons or below a depth of 2 feet (0.6 m).  The Ae horizon, if present, may be faintly mottled in fine-textured soils and in medium-textured soils that have a slowly permeable layer below the solum.  In grassland soils the B and C horizons may be only faintly mottled and the A horizon may be relatively thick and dark.  somewhat poorly drained  The soil moisture in excess of field capacity remains in subsurface horizons for moderately long periods during the year. Soils are commonly mottled in the B and C horizons; the Ae horizon, if present, may be mottled.  The matrix generally has a lower chroma than in the well-drained soil on similar parent material. Sometimes described as "imperfectly drained."  poorly drained  The soil moisture in excess of field capacity remains in all horizons for a large part of the year.  The soils are usually very strongly gleyed (low chroma colors, such as gray, bluish, or gray-green). Except in high-chroma parent materials the B, if present, and upper C horizons usually have matrix colors of low chroma.  Faint mottling may occur throughout.  very poorly drained  Free water remains at or within 12 inches of the surface most of the year.  The soils are usually very strongly gleyed. Subsurface horizons usually are of low chroma and yellowish to bluish hues. Mottling may be present but at the depth in the profile.  Very poorly drained soils usually have a mucky or peaty surface horizon. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilDrainage',
                              'excessively drained',
                              'Soils are free from any evidence of gleying throughout the profile.  These soils are commonly very coarse textured (e.g., >35% volume of particles > 2 mm in size) or soils on very steep slopes.  Sometimes described as "very rapidly drained."',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilDrainage',
                              'somewhat excessively drained',
                              'The soil moisture content seldom exceeds field capacity in any horizon except immediately after water addition. Soils are free from any evidence of gleying throughout the profile.  Rapidly drained soils are commonly coarse textured or soils on steep slopes. Sometimes described as "rapidly drained."',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilDrainage',
                              'well drained',
                              'The soil moisture content does not normally exceed field capacity in any horizon (except possibly the C) for a significant part of the year.  Soils are usually free from mottling in the upper 3 feet (1 m), but may be mottled below this depth. B horizons, if present, are reddish, brownish, or yellowish.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilDrainage',
                              'moderately well drained',
                              'The soil moisture in excess of field capacity remains for a small but significant period of the year.  Soils are commonly mottled (chroma < 2) in the lower B and C horizons or below a depth of 2 feet (0.6 m).  The Ae horizon, if present, may be faintly mottled in fine-textured soils and in medium-textured soils that have a slowly permeable layer below the solum.  In grassland soils the B and C horizons may be only faintly mottled and the A horizon may be relatively thick and dark.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilDrainage',
                              'somewhat poorly drained',
                              'The soil moisture in excess of field capacity remains in subsurface horizons for moderately long periods during the year. Soils are commonly mottled in the B and C horizons; the Ae horizon, if present, may be mottled.  The matrix generally has a lower chroma than in the well-drained soil on similar parent material. Sometimes described as "imperfectly drained."',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilDrainage',
                              'poorly drained',
                              'The soil moisture in excess of field capacity remains in all horizons for a large part of the year.  The soils are usually very strongly gleyed (low chroma colors, such as gray, bluish, or gray-green). Except in high-chroma parent materials the B, if present, and upper C horizons usually have matrix colors of low chroma.  Faint mottling may occur throughout.',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilDrainage',
                              'very poorly drained',
                              'Free water remains at or within 12 inches of the surface most of the year.  The soils are usually very strongly gleyed. Subsurface horizons usually are of low chroma and yellowish to bluish hues. Mottling may be present but at the depth in the profile.  Very poorly drained soils usually have a mucky or peaty surface horizon.',
                              '7'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'waterSalinity',
        'Water Salinity',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'How saline is the water, if a flooded community?',
     
        ' observation  Observation  waterSalinity  Water Salinity  logical    varchar (30)  n/a  n/a  closed  closed list  How saline is the water, if a flooded community?  Brackish  0.5 to 30 ppt  Freshwater  less than 0.5 ppt  Saltwater  greater than 30 ppt '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'waterSalinity',
                              'Saltwater',
                              'greater than 30 ppt',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'waterSalinity',
                              'Brackish',
                              '0.5 to 30 ppt',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'waterSalinity',
                              'Freshwater',
                              'less than 0.5 ppt',
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'waterDepth',
        'Water Depth',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'For aquatic or marine vegetation, what was the water depth in m.',
     
        ' observation  Observation  waterDepth  Water Depth  logical    Float  n/a  n/a  no  n/a  For aquatic or marine vegetation, what was the water depth in m. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'shoreDistance',
        'Shore Distance',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'For aquatic or marine vegetation, what was the closest distance to shore in m.',
     
        ' observation  Observation  shoreDistance  Shore Distance  logical    Float  n/a  n/a  no  n/a  For aquatic or marine vegetation, what was the closest distance to shore in m. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'soilDepth',
        'Soil Depth',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Median depth to bedrock or permafrost in m (usually from averaging multiple probe readings).',
     
        ' observation  Observation  soilDepth  Soil Depth  logical    Float  n/a  n/a  no  n/a  Median depth to bedrock or permafrost in m (usually from averaging multiple probe readings). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'organicDepth',
        'Organic Depth',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Depth of the surficial organic layer, where present, in centimeters.',
     
        ' observation  Observation  organicDepth  Organic Depth  logical    Float  n/a  n/a  no  n/a  Depth of the surficial organic layer, where present, in centimeters. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'SOILTAXON_ID',
        'Soil Taxon',
        'logical',
        'yes',
        'Integer',
        'FK',
        'soilTaxon.SOILTAXON_ID',
        'no',
        'hierarchy',
        'Foreign key into table of soil taxa within the USDA classification hierarchy, including Order, Suborder, Greatgroup, Subgroup, Family and Series.',
     
        ' observation  Observation  SOILTAXON_ID  Soil Taxon  logical    Integer  FK  soilTaxon.SOILTAXON_ID  no  hierarchy  Foreign key into table of soil taxa within the USDA classification hierarchy, including Order, Suborder, Greatgroup, Subgroup, Family and Series. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'soilTaxonSrc',
        'Soil Taxon Source',
        'logical',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'How was the soil taxon determined (e.g., field observation, map,  other sources)?',
     
        ' observation  Observation  soilTaxonSrc  Soil Taxon Source  logical    varchar (200)  n/a  n/a  closed  closed list  How was the soil taxon determined (e.g., field observation, map,  other sources)?  Field observation    Other soil map    USDA county soil survey   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilTaxonSrc',
                              'Field observation',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilTaxonSrc',
                              'USDA county soil survey',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'soilTaxonSrc',
                              'Other soil map',
                              null,
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'percentBedRock',
        'Percent Bedrock',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent of surface that is exposed bedrock.',
     
        ' observation  Observation  percentBedRock  Percent Bedrock  logical    Float  n/a  n/a  no  n/a  Percent of surface that is exposed bedrock. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'percentRockGravel',
        'Percent Rock / Gravel',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent of surface that is exposed rock and gravel.',
     
        ' observation  Observation  percentRockGravel  Percent Rock / Gravel  logical    Float  n/a  n/a  no  n/a  Percent of surface that is exposed rock and gravel. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'percentWood',
        'Percent Wood',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent of surface that is wood.',
     
        ' observation  Observation  percentWood  Percent Wood  logical    Float  n/a  n/a  no  n/a  Percent of surface that is wood. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'percentLitter',
        'Percent Litter',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent of surface that is litter.',
     
        ' observation  Observation  percentLitter  Percent Litter  logical    Float  n/a  n/a  no  n/a  Percent of surface that is litter. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'percentBareSoil',
        'Percent Bare Soil',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent of surface that is bare soil.',
     
        ' observation  Observation  percentBareSoil  Percent Bare Soil  logical    Float  n/a  n/a  no  n/a  Percent of surface that is bare soil. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'percentWater',
        'Percent Water',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent of surface that is water.',
     
        ' observation  Observation  percentWater  Percent Water  logical    Float  n/a  n/a  no  n/a  Percent of surface that is water. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'percentOther',
        'Percent Other',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent of surface that belong to an additional itemized category',
     
        ' observation  Observation  percentOther  Percent Other  logical    Float  n/a  n/a  no  n/a  Percent of surface that belong to an additional itemized category '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'nameOther',
        'Name Other',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of additional itemized ground cover category (e.g., beer cans).',
     
        ' observation  Observation  nameOther  Name Other  logical    varchar (30)  n/a  n/a  no  n/a  Name of additional itemized ground cover category (e.g., beer cans). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'treeHt',
        'Tree Height',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Height of the tree layer in m.',
     
        ' observation  Observation  treeHt  Tree Height  logical    Float  n/a  n/a  no  n/a  Height of the tree layer in m. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'shrubHt',
        'Shrub Height',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Height of the shrub layer in m.',
     
        ' observation  Observation  shrubHt  Shrub Height  logical    Float  n/a  n/a  no  n/a  Height of the shrub layer in m. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'fieldHt',
        'Field Height',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Height of the field layer in m.',
     
        ' observation  Observation  fieldHt  Field Height  logical    Float  n/a  n/a  no  n/a  Height of the field layer in m. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'nonvascularHt',
        'Nonvascular Height',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Height of the nonvascular layer in m.',
     
        ' observation  Observation  nonvascularHt  Nonvascular Height  logical    Float  n/a  n/a  no  n/a  Height of the nonvascular layer in m. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'submergedHt',
        'Submerged Height',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Height of the submerged layer in m.',
     
        ' observation  Observation  submergedHt  Submerged Height  logical    Float  n/a  n/a  no  n/a  Height of the submerged layer in m. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'treeCover',
        'Tree Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total cover of the tree layer in percent.  Includes tall trees (single-stemmed woody plants, generally more than 5 m in height or greater at maturity under optimal growing conditions). Very tall shrubs with tree-like form may also be included here, as may other life forms, such as lianas and epiphytes.',
     
        ' observation  Observation  treeCover  Tree Cover  logical    Float  n/a  n/a  no  n/a  Total cover of the tree layer in percent.  Includes tall trees (single-stemmed woody plants, generally more than 5 m in height or greater at maturity under optimal growing conditions). Very tall shrubs with tree-like form may also be included here, as may other life forms, such as lianas and epiphytes. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'shrubCover',
        'Shrub Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total cover of the shrub layer in percent.  Includes shrubs (multiple-stemmed woody plants, generally less than 5 m in height at maturity under optimal growing conditions) and shorter trees (saplings).  As with the tree stratum, other life forms present in this stratum may also be included (however, herbaceous life forms should be excluded, as their stems often die back annually and do not have as consistent a height as woody life forms). Where dwarf-shrubs (i.e. shrubs shorter than 0.5 m) form a distinct stratum (either as part of a series of strata, as in a forest, or as the top stratum of more open vegetation, such as tundra or xeric shrublands), they should be treated as a low version of the shrub stratum (or short shrub substratum).  In many vegetation types, dwarf-shrubs may simply occur as one life form component of the herb stratum.',
     
        ' observation  Observation  shrubCover  Shrub Cover  logical    Float  n/a  n/a  no  n/a  Total cover of the shrub layer in percent.  Includes shrubs (multiple-stemmed woody plants, generally less than 5 m in height at maturity under optimal growing conditions) and shorter trees (saplings).  As with the tree stratum, other life forms present in this stratum may also be included (however, herbaceous life forms should be excluded, as their stems often die back annually and do not have as consistent a height as woody life forms). Where dwarf-shrubs (i.e. shrubs shorter than 0.5 m) form a distinct stratum (either as part of a series of strata, as in a forest, or as the top stratum of more open vegetation, such as tundra or xeric shrublands), they should be treated as a low version of the shrub stratum (or short shrub substratum).  In many vegetation types, dwarf-shrubs may simply occur as one life form component of the herb stratum. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'fieldCover',
        'Field Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total cover of the field layer in percent.  Also referred to as Herb stratum.  Includes herbs (plants without woody stems and often dying back annually), often in association with low creeping semi-shrubs, dwarf-shrubs, vines, and non-woody brambles (such as raspberries), as well as tree or shrub seedlings.',
     
        ' observation  Observation  fieldCover  Field Cover  logical    Float  n/a  n/a  no  n/a  Total cover of the field layer in percent.  Also referred to as Herb stratum.  Includes herbs (plants without woody stems and often dying back annually), often in association with low creeping semi-shrubs, dwarf-shrubs, vines, and non-woody brambles (such as raspberries), as well as tree or shrub seedlings. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'nonvascularCover',
        'Nonvascular Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total cover of the nonvascular layer in percent.  Also referred to as moss, bryoid, or ground stratum.  Defined entirely by mosses, lichens, liverworts, and alga.  Ground-creeping vines, prostrate shrubs and herbs should be treated in the herb stratum.  Where herbs are entirely absent, it is still possible to recognize this stratum if other very low woody or semi-woody life forms are present.',
     
        ' observation  Observation  nonvascularCover  Nonvascular Cover  logical    Float  n/a  n/a  no  n/a  Total cover of the nonvascular layer in percent.  Also referred to as moss, bryoid, or ground stratum.  Defined entirely by mosses, lichens, liverworts, and alga.  Ground-creeping vines, prostrate shrubs and herbs should be treated in the herb stratum.  Where herbs are entirely absent, it is still possible to recognize this stratum if other very low woody or semi-woody life forms are present. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'floatingCover',
        'Floating Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total cover of the floating layer in percent.  Includes rooted or drifting plants that float on the water surface (e.g., duckweed, water-lily).',
     
        ' observation  Observation  floatingCover  Floating Cover  logical    Float  n/a  n/a  no  n/a  Total cover of the floating layer in percent.  Includes rooted or drifting plants that float on the water surface (e.g., duckweed, water-lily). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'submergedCover',
        'Submerged Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total cover of the submerged layer in percent.  Includes rooted or drifting plants that by-and-large remain submerged in the water column or on the aquatic bottom (e.g., pondweed).  The focus is on the overall strata arrangement of these aquatic plants.  Note that emergent plants life forms in a wetland should be placed in above water strata (e.g., cattail or sedges would be placed in the herb stratum, whereas the duckweed would be in the floating aquatic stratum).',
     
        ' observation  Observation  submergedCover  Submerged Cover  logical    Float  n/a  n/a  no  n/a  Total cover of the submerged layer in percent.  Includes rooted or drifting plants that by-and-large remain submerged in the water column or on the aquatic bottom (e.g., pondweed).  The focus is on the overall strata arrangement of these aquatic plants.  Note that emergent plants life forms in a wetland should be placed in above water strata (e.g., cattail or sedges would be placed in the herb stratum, whereas the duckweed would be in the floating aquatic stratum). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'dominantStratum',
        'Dominant Stratum',
        'logical',
        'yes',
        'varchar (40)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Which of the six standard strata is dominant?',
     
        ' observation  Observation  dominantStratum  Dominant Stratum  logical    varchar (40)  n/a  n/a  closed  closed list  Which of the six standard strata is dominant?  Floating    Herb    Nonvascular    Shrub    Submerged    Tree   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dominantStratum',
                              'Tree',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dominantStratum',
                              'Shrub',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dominantStratum',
                              'Herb',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dominantStratum',
                              'Nonvascular',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dominantStratum',
                              'Floating',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'dominantStratum',
                              'Submerged',
                              null,
                              '6'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'growthform1Type',
        'Growthform1 Type',
        'logical',
        'yes',
        'varchar (40)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'The predominant growth form?',
     
        ' observation  Observation  growthform1Type  Growthform1 Type  logical    varchar (40)  n/a  n/a  closed  closed list  The predominant growth form?  Trees  larger woody plants, mostly well above 5 m tall  Needle-leaved tree  mainly conifers - pine, spruce, larch, redwood, etc.  Broad-leaved deciduous tree  leaves shed in the temperate zone winter, or in the tropical dry season  Broad-leaved evergreen tree  many tropical and subtropical trees, mostly with medium-sized leaves  Thorn tree  armed with spines, in many cases with compound, deciduous leaves, often reduced in size  Evergreen sclerophyllous tree  with smaller, tough, evergreen leaves  Succulent tree  primarily cacti and succulent euphorbs  Palm tree  rosette trees, unbranched with a crown of large leaves  Tree fern  rosette trees, unbranched with a crown of large leaves  Bamboo  arborescent grasses with woody-like stems  Other tree  other type of tree not on the list  Shrubs  smaller woody plants, mostly below 5 m tall  Needle-leaved shrub  mainly conifers - juniper, yew, etc.  Broad-leaved deciduous shrub  leaves shed in the temperate zone winter, or in the tropical dry season  Broad-leaved evergreen shrub  many tropical and temperate shrubs, mostly with medium to small-sized leaves  Thorn shrub  armed with spines, in many cases with compound, deciduous leaves, often reduced in size  Evergreen sclerophyllous shrub  with smaller, tough, evergreen leaves  Palm shrub  rosette shrubs, unbranched with a short crown of leaves  Dwarf-shrub  low shrubs spreading near the ground surface, less than 50 cm high  Semi-shrub  suffrutescent, i.e., with the upper parts of the stems and branches dying back in unfavorable seasons  Succulent shrub  cacti, certain euphorbias, etc.  Other shrub  other type of shrub not on the list  Herbs  plants without perennial aboveground woody stems  Forb  herbs other than ferns and graminoids  Graminoid  grasses, sedges, and other grass like plants  Fern and fern allies  pteridophytes -ferns, clubmosses, horsetails, etc  Succulent forb    Aquatic herb  floating and submergent  Other herbaceous  other type of herbaceous species not on the list  Moss    Liverwort/hornwort    Lichen    Alga    Epiphyte  plants growing wholly above the ground surface on other plants  Vine/liana  woody climbers or vines  Other/unknown  other type of species not on the list  Not assessed   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Trees',
                              'larger woody plants, mostly well above 5 m tall',
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Needle-leaved tree',
                              'mainly conifers - pine, spruce, larch, redwood, etc.',
                              '20'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Broad-leaved deciduous tree',
                              'leaves shed in the temperate zone winter, or in the tropical dry season',
                              '30'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Broad-leaved evergreen tree',
                              'many tropical and subtropical trees, mostly with medium-sized leaves',
                              '40'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Thorn tree',
                              'armed with spines, in many cases with compound, deciduous leaves, often reduced in size',
                              '50'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Evergreen sclerophyllous tree',
                              'with smaller, tough, evergreen leaves',
                              '60'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Succulent tree',
                              'primarily cacti and succulent euphorbs',
                              '70'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Palm tree',
                              'rosette trees, unbranched with a crown of large leaves',
                              '80'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Tree fern',
                              'rosette trees, unbranched with a crown of large leaves',
                              '90'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Bamboo',
                              'arborescent grasses with woody-like stems',
                              '100'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Other tree',
                              'other type of tree not on the list',
                              '110'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Shrubs',
                              'smaller woody plants, mostly below 5 m tall',
                              '120'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Needle-leaved shrub',
                              'mainly conifers - juniper, yew, etc.',
                              '130'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Broad-leaved deciduous shrub',
                              'leaves shed in the temperate zone winter, or in the tropical dry season',
                              '140'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Broad-leaved evergreen shrub',
                              'many tropical and temperate shrubs, mostly with medium to small-sized leaves',
                              '150'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Thorn shrub',
                              'armed with spines, in many cases with compound, deciduous leaves, often reduced in size',
                              '160'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Evergreen sclerophyllous shrub',
                              'with smaller, tough, evergreen leaves',
                              '170'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Palm shrub',
                              'rosette shrubs, unbranched with a short crown of leaves',
                              '180'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Dwarf-shrub',
                              'low shrubs spreading near the ground surface, less than 50 cm high',
                              '190'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Semi-shrub',
                              'suffrutescent, i.e., with the upper parts of the stems and branches dying back in unfavorable seasons',
                              '200'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Succulent shrub',
                              'cacti, certain euphorbias, etc.',
                              '210'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Other shrub',
                              'other type of shrub not on the list',
                              '220'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Herbs',
                              'plants without perennial aboveground woody stems',
                              '230'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Forb',
                              'herbs other than ferns and graminoids',
                              '240'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Graminoid',
                              'grasses, sedges, and other grass like plants',
                              '250'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Fern and fern allies',
                              'pteridophytes -ferns, clubmosses, horsetails, etc',
                              '260'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Succulent forb',
                              null,
                              '270'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Aquatic herb',
                              'floating and submergent',
                              '280'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Other herbaceous',
                              'other type of herbaceous species not on the list',
                              '290'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Moss',
                              null,
                              '300'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Liverwort/hornwort',
                              null,
                              '310'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Lichen',
                              null,
                              '320'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Alga',
                              null,
                              '330'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Epiphyte',
                              'plants growing wholly above the ground surface on other plants',
                              '340'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Vine/liana',
                              'woody climbers or vines',
                              '350'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Other/unknown',
                              'other type of species not on the list',
                              '360'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform1Type',
                              'Not assessed',
                              null,
                              '370'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'growthform2Type',
        'Growthform2 Type',
        'logical',
        'yes',
        'varchar (40)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'The second-most predominant growthform?',
     
        ' observation  Observation  growthform2Type  Growthform2 Type  logical    varchar (40)  n/a  n/a  closed  closed list  The second-most predominant growthform?  Trees  larger woody plants, mostly well above 5 m tall  Needle-leaved tree  mainly conifers - pine, spruce, larch, redwood, etc.  Broad-leaved deciduous tree  leaves shed in the temperate zone winter, or in the tropical dry season  Broad-leaved evergreen tree  many tropical and subtropical trees, mostly with medium-sized leaves  Thorn tree  armed with spines, in many cases with compound, deciduous leaves, often reduced in size  Evergreen sclerophyllous tree  with smaller, tough, evergreen leaves  Succulent tree  primarily cacti and succulent euphorbs  Palm tree  rosette trees, unbranched with a crown of large leaves  Tree fern  rosette trees, unbranched with a crown of large leaves  Bamboo  arborescent grasses with woody-like stems  Other tree  other type of tree not on the list  Shrubs  smaller woody plants, mostly below 5 m tall  Needle-leaved shrub  mainly conifers - juniper, yew, etc.  Broad-leaved deciduous shrub  leaves shed in the temperate zone winter, or in the tropical dry season  Broad-leaved evergreen shrub  many tropical and temperate shrubs, mostly with medium to small-sized leaves  Thorn shrub  armed with spines, in many cases with compound, deciduous leaves, often reduced in size  Evergreen sclerophyllous shrub  with smaller, tough, evergreen leaves  Palm shrub  rosette shrubs, unbranched with a short crown of leaves  Dwarf-shrub  low shrubs spreading near the ground surface, less than 50 cm high  Semi-shrub  suffrutescent, i.e., with the upper parts of the stems and branches dying back in unfavorable seasons  Succulent shrub  cacti, certain euphorbias, etc.  Other shrub  other type of shrub not on the list  Herbs  plants without perennial aboveground woody stems  Forb  herbs other than ferns and graminoids  Graminoid  grasses, sedges, and other grass like plants  Fern and fern allies  pteridophytes -ferns, clubmosses, horsetails, etc  Succulent forb    Aquatic herb  floating and submergent  Other herbaceous  other type of herbaceous species not on the list  Moss    Liverwort/hornwort    Lichen    Alga    Epiphyte  plants growing wholly above the ground surface on other plants  Vine/liana  woody climbers or vines  Other/unknown  other type of species not on the list  Not assessed   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Trees',
                              'larger woody plants, mostly well above 5 m tall',
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Needle-leaved tree',
                              'mainly conifers - pine, spruce, larch, redwood, etc.',
                              '20'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Broad-leaved deciduous tree',
                              'leaves shed in the temperate zone winter, or in the tropical dry season',
                              '30'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Broad-leaved evergreen tree',
                              'many tropical and subtropical trees, mostly with medium-sized leaves',
                              '40'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Thorn tree',
                              'armed with spines, in many cases with compound, deciduous leaves, often reduced in size',
                              '50'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Evergreen sclerophyllous tree',
                              'with smaller, tough, evergreen leaves',
                              '60'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Succulent tree',
                              'primarily cacti and succulent euphorbs',
                              '70'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Palm tree',
                              'rosette trees, unbranched with a crown of large leaves',
                              '80'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Tree fern',
                              'rosette trees, unbranched with a crown of large leaves',
                              '90'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Bamboo',
                              'arborescent grasses with woody-like stems',
                              '100'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Other tree',
                              'other type of tree not on the list',
                              '110'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Shrubs',
                              'smaller woody plants, mostly below 5 m tall',
                              '120'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Needle-leaved shrub',
                              'mainly conifers - juniper, yew, etc.',
                              '130'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Broad-leaved deciduous shrub',
                              'leaves shed in the temperate zone winter, or in the tropical dry season',
                              '140'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Broad-leaved evergreen shrub',
                              'many tropical and temperate shrubs, mostly with medium to small-sized leaves',
                              '150'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Thorn shrub',
                              'armed with spines, in many cases with compound, deciduous leaves, often reduced in size',
                              '160'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Evergreen sclerophyllous shrub',
                              'with smaller, tough, evergreen leaves',
                              '170'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Palm shrub',
                              'rosette shrubs, unbranched with a short crown of leaves',
                              '180'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Dwarf-shrub',
                              'low shrubs spreading near the ground surface, less than 50 cm high',
                              '190'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Semi-shrub',
                              'suffrutescent, i.e., with the upper parts of the stems and branches dying back in unfavorable seasons',
                              '200'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Succulent shrub',
                              'cacti, certain euphorbias, etc.',
                              '210'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Other shrub',
                              'other type of shrub not on the list',
                              '220'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Herbs',
                              'plants without perennial aboveground woody stems',
                              '230'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Forb',
                              'herbs other than ferns and graminoids',
                              '240'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Graminoid',
                              'grasses, sedges, and other grass like plants',
                              '250'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Fern and fern allies',
                              'pteridophytes -ferns, clubmosses, horsetails, etc',
                              '260'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Succulent forb',
                              null,
                              '270'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Aquatic herb',
                              'floating and submergent',
                              '280'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Other herbaceous',
                              'other type of herbaceous species not on the list',
                              '290'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Moss',
                              null,
                              '300'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Liverwort/hornwort',
                              null,
                              '310'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Lichen',
                              null,
                              '320'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Alga',
                              null,
                              '330'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Epiphyte',
                              'plants growing wholly above the ground surface on other plants',
                              '340'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Vine/liana',
                              'woody climbers or vines',
                              '350'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Other/unknown',
                              'other type of species not on the list',
                              '360'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform2Type',
                              'Not assessed',
                              null,
                              '370'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'growthform3Type',
        'Growthform3 Type',
        'logical',
        'yes',
        'varchar (40)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'The third-most predominant growthform',
     
        ' observation  Observation  growthform3Type  Growthform3 Type  logical    varchar (40)  n/a  n/a  closed  closed list  The third-most predominant growthform  Trees  larger woody plants, mostly well above 5 m tall  Needle-leaved tree  mainly conifers - pine, spruce, larch, redwood, etc.  Broad-leaved deciduous tree  leaves shed in the temperate zone winter, or in the tropical dry season  Broad-leaved evergreen tree  many tropical and subtropical trees, mostly with medium-sized leaves  Thorn tree  armed with spines, in many cases with compound, deciduous leaves, often reduced in size  Evergreen sclerophyllous tree  with smaller, tough, evergreen leaves  Succulent tree  primarily cacti and succulent euphorbs  Palm tree  rosette trees, unbranched with a crown of large leaves  Tree fern  rosette trees, unbranched with a crown of large leaves  Bamboo  arborescent grasses with woody-like stems  Other tree  other type of tree not on the list  Shrubs  smaller woody plants, mostly below 5 m tall  Needle-leaved shrub  mainly conifers - juniper, yew, etc.  Broad-leaved deciduous shrub  leaves shed in the temperate zone winter, or in the tropical dry season  Broad-leaved evergreen shrub  many tropical and temperate shrubs, mostly with medium to small-sized leaves  Thorn shrub  armed with spines, in many cases with compound, deciduous leaves, often reduced in size  Evergreen sclerophyllous shrub  with smaller, tough, evergreen leaves  Palm shrub  rosette shrubs, unbranched with a short crown of leaves  Dwarf-shrub  low shrubs spreading near the ground surface, less than 50 cm high  Semi-shrub  suffrutescent, i.e., with the upper parts of the stems and branches dying back in unfavorable seasons  Succulent shrub  cacti, certain euphorbias, etc.  Other shrub  other type of shrub not on the list  Herbs  plants without perennial aboveground woody stems  Forb  herbs other than ferns and graminoids  Graminoid  grasses, sedges, and other grass like plants  Fern and fern allies  pteridophytes -ferns, clubmosses, horsetails, etc  Succulent forb    Aquatic herb  floating and submergent  Other herbaceous  other type of herbaceous species not on the list  Moss    Liverwort/hornwort    Lichen    Alga    Epiphyte  plants growing wholly above the ground surface on other plants  Vine/liana  woody climbers or vines  Other/unknown  other type of species not on the list  Not assessed   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Trees',
                              'larger woody plants, mostly well above 5 m tall',
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Needle-leaved tree',
                              'mainly conifers - pine, spruce, larch, redwood, etc.',
                              '20'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Broad-leaved deciduous tree',
                              'leaves shed in the temperate zone winter, or in the tropical dry season',
                              '30'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Broad-leaved evergreen tree',
                              'many tropical and subtropical trees, mostly with medium-sized leaves',
                              '40'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Thorn tree',
                              'armed with spines, in many cases with compound, deciduous leaves, often reduced in size',
                              '50'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Evergreen sclerophyllous tree',
                              'with smaller, tough, evergreen leaves',
                              '60'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Succulent tree',
                              'primarily cacti and succulent euphorbs',
                              '70'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Palm tree',
                              'rosette trees, unbranched with a crown of large leaves',
                              '80'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Tree fern',
                              'rosette trees, unbranched with a crown of large leaves',
                              '90'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Bamboo',
                              'arborescent grasses with woody-like stems',
                              '100'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Other tree',
                              'other type of tree not on the list',
                              '110'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Shrubs',
                              'smaller woody plants, mostly below 5 m tall',
                              '120'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Needle-leaved shrub',
                              'mainly conifers - juniper, yew, etc.',
                              '130'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Broad-leaved deciduous shrub',
                              'leaves shed in the temperate zone winter, or in the tropical dry season',
                              '140'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Broad-leaved evergreen shrub',
                              'many tropical and temperate shrubs, mostly with medium to small-sized leaves',
                              '150'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Thorn shrub',
                              'armed with spines, in many cases with compound, deciduous leaves, often reduced in size',
                              '160'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Evergreen sclerophyllous shrub',
                              'with smaller, tough, evergreen leaves',
                              '170'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Palm shrub',
                              'rosette shrubs, unbranched with a short crown of leaves',
                              '180'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Dwarf-shrub',
                              'low shrubs spreading near the ground surface, less than 50 cm high',
                              '190'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Semi-shrub',
                              'suffrutescent, i.e., with the upper parts of the stems and branches dying back in unfavorable seasons',
                              '200'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Succulent shrub',
                              'cacti, certain euphorbias, etc.',
                              '210'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Other shrub',
                              'other type of shrub not on the list',
                              '220'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Herbs',
                              'plants without perennial aboveground woody stems',
                              '230'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Forb',
                              'herbs other than ferns and graminoids',
                              '240'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Graminoid',
                              'grasses, sedges, and other grass like plants',
                              '250'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Fern and fern allies',
                              'pteridophytes -ferns, clubmosses, horsetails, etc',
                              '260'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Succulent forb',
                              null,
                              '270'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Aquatic herb',
                              'floating and submergent',
                              '280'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Other herbaceous',
                              'other type of herbaceous species not on the list',
                              '290'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Moss',
                              null,
                              '300'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Liverwort/hornwort',
                              null,
                              '310'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Lichen',
                              null,
                              '320'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Alga',
                              null,
                              '330'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Epiphyte',
                              'plants growing wholly above the ground surface on other plants',
                              '340'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Vine/liana',
                              'woody climbers or vines',
                              '350'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Other/unknown',
                              'other type of species not on the list',
                              '360'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'observation',
                              'growthform3Type',
                              'Not assessed',
                              null,
                              '370'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'growthform1Cover',
        'Growthform1 Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total cover of the predominant growthform?',
     
        ' observation  Observation  growthform1Cover  Growthform1 Cover  logical    Float  n/a  n/a  no  n/a  Total cover of the predominant growthform? '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'growthform2Cover',
        'Growthform2 Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total cover of the second-most predominant growthform?',
     
        ' observation  Observation  growthform2Cover  Growthform2 Cover  logical    Float  n/a  n/a  no  n/a  Total cover of the second-most predominant growthform? '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'growthform3Cover',
        'Growthform3 Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total cover of the third-most predominant growthform?',
     
        ' observation  Observation  growthform3Cover  Growthform3 Cover  logical    Float  n/a  n/a  no  n/a  Total cover of the third-most predominant growthform? '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'totalCover',
        'Total Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The total cover, in percent, of all vegetation on the plot.',
     
        ' observation  Observation  totalCover  Total Cover  logical    Float  n/a  n/a  no  n/a  The total cover, in percent, of all vegetation on the plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'accessionCode',
        'Observation Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' observation  Observation  accessionCode  Observation Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'notesPublic',
        'Notes Public',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'TRUE indicates that public notes pertaining to this plot exist in "vegPlot.note"',
     
        ' observation  Observation  notesPublic  Notes Public  logical    Boolean  n/a  n/a  no  n/a  TRUE indicates that public notes pertaining to this plot exist in "vegPlot.note" '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'notesMgt',
        'Notes Mgt',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'TRUE indicates that nonpublic management notes pertaining to this plot exist in "vegPlot.note"',
     
        ' observation  Observation  notesMgt  Notes Mgt  logical    Boolean  n/a  n/a  no  n/a  TRUE indicates that nonpublic management notes pertaining to this plot exist in "vegPlot.note" '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'revisions',
        'Revisions',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'TRUE indicates that revisions exist in vegPlot.Revision',
     
        ' observation  Observation  revisions  Revisions  logical    Boolean  n/a  n/a  no  n/a  TRUE indicates that revisions exist in vegPlot.Revision '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'emb_observation',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' observation  Observation  emb_observation  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_orig_ci_ID',
        'Original commInterpret ID',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The first community interpretation ID where the plot was assigned to a community.',
     
        ' observation  Observation  interp_orig_ci_ID  Original commInterpret ID  denorm    Integer  n/a  n/a  no  n/a  The first community interpretation ID where the plot was assigned to a community. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_orig_cc_ID',
        'CommConcept_ID',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'the Comm Concept_ID for this Interpretation.',
     
        ' observation  Observation  interp_orig_cc_ID  CommConcept_ID  denorm    Integer  n/a  n/a  no  n/a  the Comm Concept_ID for this Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_orig_sciname',
        'Scientific Name of Community.',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Scientific Name for this Comm Concept',
     
        ' observation  Observation  interp_orig_sciname  Scientific Name of Community.  denorm    text  n/a  n/a  no  n/a  The Scientific Name for this Comm Concept '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_orig_code',
        'CEGL-type code of Community.',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The CEGL type code for this Comm Concept.',
     
        ' observation  Observation  interp_orig_code  CEGL-type code of Community.  denorm    text  n/a  n/a  no  n/a  The CEGL type code for this Comm Concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_orig_party_id',
        'Party_ID of classifier.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Party_ID of the classifier.',
     
        ' observation  Observation  interp_orig_party_id  Party_ID of classifier.  denorm    Integer  n/a  n/a  no  n/a  The Party_ID of the classifier. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_orig_partyname',
        'Classifier.',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Name of the classifier.',
     
        ' observation  Observation  interp_orig_partyname  Classifier.  denorm    text  n/a  n/a  no  n/a  The Name of the classifier. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_current_ci_ID',
        'Most Recent Classification commInterp ID',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The most recent community interpretation of the plot.',
     
        ' observation  Observation  interp_current_ci_ID  Most Recent Classification commInterp ID  denorm    Integer  n/a  n/a  no  n/a  The most recent community interpretation of the plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_current_cc_ID',
        'CommConcept_ID',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'the Comm Concept_ID for this Interpretation.',
     
        ' observation  Observation  interp_current_cc_ID  CommConcept_ID  denorm    Integer  n/a  n/a  no  n/a  the Comm Concept_ID for this Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_current_sciname',
        'Scientific Name of Community.',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Scientific Name for this Comm Concept',
     
        ' observation  Observation  interp_current_sciname  Scientific Name of Community.  denorm    text  n/a  n/a  no  n/a  The Scientific Name for this Comm Concept '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_current_code',
        'CEGL-type code of Community.',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The CEGL type code for this Comm Concept.',
     
        ' observation  Observation  interp_current_code  CEGL-type code of Community.  denorm    text  n/a  n/a  no  n/a  The CEGL type code for this Comm Concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_current_party_id',
        'Party_ID of classifier.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Party_ID of the classifier.',
     
        ' observation  Observation  interp_current_party_id  Party_ID of classifier.  denorm    Integer  n/a  n/a  no  n/a  The Party_ID of the classifier. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_current_partyname',
        'Classifier.',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Name of the classifier.',
     
        ' observation  Observation  interp_current_partyname  Classifier.  denorm    text  n/a  n/a  no  n/a  The Name of the classifier. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_bestfit_ci_ID',
        'Best Fit commInterp ID',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The best fit, confidence pattern community interpretation ID.',
     
        ' observation  Observation  interp_bestfit_ci_ID  Best Fit commInterp ID  denorm    Integer  n/a  n/a  no  n/a  The best fit, confidence pattern community interpretation ID. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_bestfit_cc_ID',
        'CommConcept_ID',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'the Comm Concept_ID for this Interpretation.',
     
        ' observation  Observation  interp_bestfit_cc_ID  CommConcept_ID  denorm    Integer  n/a  n/a  no  n/a  the Comm Concept_ID for this Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_bestfit_sciname',
        'Scientific Name of Community.',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Scientific Name for this Comm Concept',
     
        ' observation  Observation  interp_bestfit_sciname  Scientific Name of Community.  denorm    text  n/a  n/a  no  n/a  The Scientific Name for this Comm Concept '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_bestfit_code',
        'CEGL-type code of Community.',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The CEGL type code for this Comm Concept.',
     
        ' observation  Observation  interp_bestfit_code  CEGL-type code of Community.  denorm    text  n/a  n/a  no  n/a  The CEGL type code for this Comm Concept. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_bestfit_party_id',
        'Party_ID of classifier.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Party_ID of the classifier.',
     
        ' observation  Observation  interp_bestfit_party_id  Party_ID of classifier.  denorm    Integer  n/a  n/a  no  n/a  The Party_ID of the classifier. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'interp_bestfit_partyname',
        'Classifier.',
        'denorm',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Name of the classifier.',
     
        ' observation  Observation  interp_bestfit_partyname  Classifier.  denorm    text  n/a  n/a  no  n/a  The Name of the classifier. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'topTaxon1Name',
        'Top Taxon #1',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the highest cover taxon on the plot, ignoring strata.',
     
        ' observation  Observation  topTaxon1Name  Top Taxon #1  denorm    varchar (255)  n/a  n/a  no  n/a  Name of the highest cover taxon on the plot, ignoring strata. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'topTaxon2Name',
        'Top Taxon #2',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the 2nd highest cover taxon on the plot, ignoring strata.',
     
        ' observation  Observation  topTaxon2Name  Top Taxon #2  denorm    varchar (255)  n/a  n/a  no  n/a  Name of the 2nd highest cover taxon on the plot, ignoring strata. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'topTaxon3Name',
        'Top Taxon #3',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the 3rd highest cover taxon on the plot, ignoring strata.',
     
        ' observation  Observation  topTaxon3Name  Top Taxon #3  denorm    varchar (255)  n/a  n/a  no  n/a  Name of the 3rd highest cover taxon on the plot, ignoring strata. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'topTaxon4Name',
        'Top Taxon #4',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the 4th highest cover taxon on the plot, ignoring strata.',
     
        ' observation  Observation  topTaxon4Name  Top Taxon #4  denorm    varchar (255)  n/a  n/a  no  n/a  Name of the 4th highest cover taxon on the plot, ignoring strata. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'topTaxon5Name',
        'Top Taxon #5',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the 5th highest cover taxon on the plot, ignoring strata.',
     
        ' observation  Observation  topTaxon5Name  Top Taxon #5  denorm    varchar (255)  n/a  n/a  no  n/a  Name of the 5th highest cover taxon on the plot, ignoring strata. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observation',
        'hasObservationSynonym',
        'Has Synonym Observation',
        'denorm',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Denormalized field to show if there is an observation synonym in the observationSynonym table for this observation.',
     
        ' observation  Observation  hasObservationSynonym  Has Synonym Observation  denorm    Boolean  n/a  n/a  no  n/a  Denormalized field to show if there is an observation synonym in the observationSynonym table for this observation. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'observationContributor',
        'Observation Contributor',
        'This table stores information about which parties contributed to specific plot observation events.',
        'This table serves as an intersection that links a party with a specific plot observation event.  Note that there is no plotContributor table because all contributions take place at a particular observation, such as the first observation.',
        ' observationContributor  Observation Contributor  This table stores information about which parties contributed to specific plot observation events.  This table serves as an intersection that links a party with a specific plot observation event.  Note that there is no plotContributor table because all contributions take place at a particular observation, such as the first observation.  OBSERVATIONCONTRIBUTOR_ID  ID  OBSERVATION_ID  Observation  PARTY_ID  Party  ROLE_ID  Role  contributionDate  Contribution Date '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationContributor',
        'OBSERVATIONCONTRIBUTOR_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database generated identifier assigned to each unique contribution to an observation event.',
     
        ' observationContributor  Observation Contributor  OBSERVATIONCONTRIBUTOR_ID  ID  logical    serial  PK  n/a  no  n/a  Database generated identifier assigned to each unique contribution to an observation event. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationContributor',
        'OBSERVATION_ID',
        'Observation',
        'logical',
        'no',
        'Integer',
        'FK',
        'observation.OBSERVATION_ID',
        'no',
        'This is the foreign key into the Observation table.',
        'Foreign key pointing to a given plot observation event to which the contribution was made.',
     
        ' observationContributor  Observation Contributor  OBSERVATION_ID  Observation  logical  required  Integer  FK  observation.OBSERVATION_ID  no  This is the foreign key into the Observation table.  Foreign key pointing to a given plot observation event to which the contribution was made. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationContributor',
        'PARTY_ID',
        'Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'This is the foreign key into the party table.',
        'Foreign key pointing to the specific party that made the contribution.',
     
        ' observationContributor  Observation Contributor  PARTY_ID  Party  logical  required  Integer  FK  party.PARTY_ID  no  This is the foreign key into the party table.  Foreign key pointing to the specific party that made the contribution. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationContributor',
        'ROLE_ID',
        'Role',
        'logical',
        'no',
        'Integer',
        'FK',
        'aux_Role.ROLE_ID',
        'no',
        'This is the foreign key into the aux_Role table',
        'Foreign key that identifies the role that the party had in the plot observation (e.g.,  PI, contact, research advisor, field assistant, taxonomist, owner, guide, etc.).',
     
        ' observationContributor  Observation Contributor  ROLE_ID  Role  logical  required  Integer  FK  aux_Role.ROLE_ID  no  This is the foreign key into the aux_Role table  Foreign key that identifies the role that the party had in the plot observation (e.g.,  PI, contact, research advisor, field assistant, taxonomist, owner, guide, etc.). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationContributor',
        'contributionDate',
        'Contribution Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The date of the specific contribution, which will generally be within the time span of the plot observation event defined by the obsStartDate and obsStopDate',
     
        ' observationContributor  Observation Contributor  contributionDate  Contribution Date  logical    Date  n/a  n/a  no  n/a  The date of the specific contribution, which will generally be within the time span of the plot observation event defined by the obsStartDate and obsStopDate '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'observationSynonym',
        'Observation Synonym',
        'This table stores opinions as to whether one observation record is a synonym of another owing to double entry into the database.',
        null,
        ' observationSynonym  Observation Synonym  This table stores opinions as to whether one observation record is a synonym of another owing to double entry into the database.    OBSERVATIONSYNONYM_ID  ID  synonymObservation_ID  Synonym Observation  primaryObservation_ID  Primary Observation  PARTY_ID  Party  ROLE_ID  Role  classStartDate  Start Date  classStopDate  Stop Date  synonymComment  Synonym Comment  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationSynonym',
        'OBSERVATIONSYNONYM_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary Key for the observationSynonym table.',
        'Database generated identifier assigned to each unique interpretation of an observation as a synonym.',
     
        ' observationSynonym  Observation Synonym  OBSERVATIONSYNONYM_ID  ID  logical    serial  PK  n/a  no  Primary Key for the observationSynonym table.  Database generated identifier assigned to each unique interpretation of an observation as a synonym. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationSynonym',
        'synonymObservation_ID',
        'Synonym Observation',
        'logical',
        'no',
        'Integer',
        'FK',
        'observation.OBSERVATION_ID',
        'no',
        'Foreign key into the observation table',
        'Link to the observation table identifying which observation is being reduced to synonymy.',
     
        ' observationSynonym  Observation Synonym  synonymObservation_ID  Synonym Observation  logical  required  Integer  FK  observation.OBSERVATION_ID  no  Foreign key into the observation table  Link to the observation table identifying which observation is being reduced to synonymy. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationSynonym',
        'primaryObservation_ID',
        'Primary Observation',
        'logical',
        'no',
        'Integer',
        'FK',
        'observation.OBSERVATION_ID',
        'no',
        'Foreign key into the observation table',
        'Link to the observation table identifying which observation is the preferred synonym for the observation being reduced to synonym.',
     
        ' observationSynonym  Observation Synonym  primaryObservation_ID  Primary Observation  logical  required  Integer  FK  observation.OBSERVATION_ID  no  Foreign key into the observation table  Link to the observation table identifying which observation is the preferred synonym for the observation being reduced to synonym. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationSynonym',
        'PARTY_ID',
        'Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'This is the foreign key into the party table.',
        'Foreign key pointing to the specific party that made the reduction to synonym.',
     
        ' observationSynonym  Observation Synonym  PARTY_ID  Party  logical  required  Integer  FK  party.PARTY_ID  no  This is the foreign key into the party table.  Foreign key pointing to the specific party that made the reduction to synonym. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationSynonym',
        'ROLE_ID',
        'Role',
        'logical',
        'no',
        'Integer',
        'FK',
        'aux_Role.ROLE_ID',
        'no',
        'This is the foreign key into the aux_Role table',
        'Foreign key that identifies the role that the party had in the plot synonomization (e.g., plot author, data manager, publication author, researcher, generic user, etc.).',
     
        ' observationSynonym  Observation Synonym  ROLE_ID  Role  logical  required  Integer  FK  aux_Role.ROLE_ID  no  This is the foreign key into the aux_Role table  Foreign key that identifies the role that the party had in the plot synonomization (e.g., plot author, data manager, publication author, researcher, generic user, etc.). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationSynonym',
        'classStartDate',
        'Start Date',
        'logical',
        'no',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Start date for the synonymization event.',
     
        ' observationSynonym  Observation Synonym  classStartDate  Start Date  logical  required  Date  n/a  n/a  no  n/a  Start date for the synonymization event. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationSynonym',
        'classStopDate',
        'Stop Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Stop date for the synonymization event.',
     
        ' observationSynonym  Observation Synonym  classStopDate  Stop Date  logical    Date  n/a  n/a  no  n/a  Stop date for the synonymization event. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationSynonym',
        'synonymComment',
        'Synonym Comment',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Notes about the reason for the synonymization.',
     
        ' observationSynonym  Observation Synonym  synonymComment  Synonym Comment  logical    text  n/a  n/a  no  n/a  Notes about the reason for the synonymization. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'observationSynonym',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' observationSynonym  Observation Synonym  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'party',
        'Party',
        'Party contributing to collection or interpretation of a plot;  may be either an individual or an organization.',
        null,
        ' party  Party  Party contributing to collection or interpretation of a plot;  may be either an individual or an organization.    PARTY_ID  ID  salutation  Salutation  givenName  Given Name  middleName  Middle Name  surName  Surname  organizationName  Organization Name  currentName_ID  Current Name  contactInstructions  Contact Instructions  email  Email  accessionCode  Accession Code  partyType  Party Type  partyPublic  Party is public?  d_obscount  Plot Count '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'PARTY_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the party table.',
        'Database generated identifier assigned to each unique party.',
     
        ' party  Party  PARTY_ID  ID  logical    serial  PK  n/a  no  Primary key for the party table.  Database generated identifier assigned to each unique party. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'salutation',
        'Salutation',
        'logical',
        'yes',
        'varchar (20)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Salutation preceding one''s given name.',
     
        ' party  Party  salutation  Salutation  logical    varchar (20)  n/a  n/a  no  n/a  Salutation preceding one''s given name. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'givenName',
        'Given Name',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'One''s first name.',
     
        ' party  Party  givenName  Given Name  logical    varchar (50)  n/a  n/a  no  n/a  One''s first name. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'middleName',
        'Middle Name',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'One''s middle name or initial, if any.',
     
        ' party  Party  middleName  Middle Name  logical    varchar (50)  n/a  n/a  no  n/a  One''s middle name or initial, if any. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'surName',
        'Surname',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name shared in common to identify the members of a family, as distinguished from each member''s given name.',
     
        ' party  Party  surName  Surname  logical    varchar (50)  n/a  n/a  no  n/a  Name shared in common to identify the members of a family, as distinguished from each member''s given name. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'organizationName',
        'Organization Name',
        'logical',
        'yes',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of an organization.',
     
        ' party  Party  organizationName  Organization Name  logical    varchar (100)  n/a  n/a  no  n/a  Name of an organization. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'currentName_ID',
        'Current Name',
        'logical',
        'yes',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'n/a',
        'Recursive foreign key to current name of this party.',
     
        ' party  Party  currentName_ID  Current Name  logical    Integer  FK  party.PARTY_ID  no  n/a  Recursive foreign key to current name of this party. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'contactInstructions',
        'Contact Instructions',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Instructions for contacting a party.',
     
        ' party  Party  contactInstructions  Contact Instructions  logical    text  n/a  n/a  no  n/a  Instructions for contacting a party. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'email',
        'Email',
        'implementation',
        'yes',
        'varchar (120)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' party  Party  email  Email  implementation    varchar (120)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' party  Party  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'partyType',
        'Party Type',
        'logical',
        'yes',
        'varchar (40)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'The type of party this is.',
     
        ' party  Party  partyType  Party Type  logical    varchar (40)  n/a  n/a  closed  n/a  The type of party this is.  user  a private user of vegbank- party info not to be exported or displayed  person  a person  team  a group of persons, but not a whole organization  organization  an entire organization  consortium  a group of organizations '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'party',
                              'partyType',
                              'user',
                              'a private user of vegbank- party info not to be exported or displayed',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'party',
                              'partyType',
                              'person',
                              'a person',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'party',
                              'partyType',
                              'team',
                              'a group of persons, but not a whole organization',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'party',
                              'partyType',
                              'organization',
                              'an entire organization',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'party',
                              'partyType',
                              'consortium',
                              'a group of organizations',
                              '5'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'partyPublic',
        'Party is public?',
        'denorm',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This party may be displayed on the website.  Not used for parties that are not contributing anywhere and have only signed up as users.',
     
        ' party  Party  partyPublic  Party is public?  denorm    Boolean  n/a  n/a  no  n/a  This party may be displayed on the website.  Not used for parties that are not contributing anywhere and have only signed up as users. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'party',
        'd_obscount',
        'Plot Count',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Number of observations associated with this entity.',
     
        ' party  Party  d_obscount  Plot Count  denorm    Integer  n/a  n/a  no  n/a  Number of observations associated with this entity. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'partyMember',
        'Party Member',
        'Allows parties to contain other parties within them, so that the children parties can have permissions of the parent parties.',
        'not implemented',
        ' partyMember  Party Member  Allows parties to contain other parties within them, so that the children parties can have permissions of the parent parties.  not implemented  partyMember_ID  Party Member ID  parentParty_ID  Main Party  childParty_ID  Sub-Party  role_ID  Role  memberStart  Member Start  memberStop  Member Stop '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'partyMember',
        'partyMember_ID',
        'Party Member ID',
        'logical',
        'no',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database generated number to uniquely identify this record of this table.',
     
        ' partyMember  Party Member  partyMember_ID  Party Member ID  logical  required  serial  PK  n/a  no  n/a  Database generated number to uniquely identify this record of this table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'partyMember',
        'parentParty_ID',
        'Main Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'n/a',
        'Link to the parent party to whom the child party here belongs.',
     
        ' partyMember  Party Member  parentParty_ID  Main Party  logical  required  Integer  FK  party.PARTY_ID  no  n/a  Link to the parent party to whom the child party here belongs. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'partyMember',
        'childParty_ID',
        'Sub-Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'n/a',
        'Link to the child party who belongs to the parent listed in parentParty_ID.',
     
        ' partyMember  Party Member  childParty_ID  Sub-Party  logical  required  Integer  FK  party.PARTY_ID  no  n/a  Link to the child party who belongs to the parent listed in parentParty_ID. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'partyMember',
        'role_ID',
        'Role',
        'logical',
        'yes',
        'Integer',
        'FK',
        'aux_Role.ROLE_ID',
        'no',
        'n/a',
        'Link to the role which defines the child''s role in the parent party.',
     
        ' partyMember  Party Member  role_ID  Role  logical    Integer  FK  aux_Role.ROLE_ID  no  n/a  Link to the role which defines the child''s role in the parent party. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'partyMember',
        'memberStart',
        'Member Start',
        'logical',
        'no',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Start date for the child''s membership in the parent party.',
     
        ' partyMember  Party Member  memberStart  Member Start  logical  required  Date  n/a  n/a  no  n/a  Start date for the child''s membership in the parent party. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'partyMember',
        'memberStop',
        'Member Stop',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Stop date for the child''s membership in the parent party.',
     
        ' partyMember  Party Member  memberStop  Member Stop  logical    Date  n/a  n/a  no  n/a  Stop date for the child''s membership in the parent party. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'place',
        'Place',
        'This table is the intersection between the plot table and the namedPlace table and is used for querying for plots located in a named place or named region in which a plot or group of plots is located.',
        null,
        ' place  Place  This table is the intersection between the plot table and the namedPlace table and is used for querying for plots located in a named place or named region in which a plot or group of plots is located.    PLOTPLACE_ID  ID  PLOT_ID  Plot  calculated  Calculated?  NAMEDPLACE_ID  Place Name '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'place',
        'PLOTPLACE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the place table',
        'Database generated identifier assigned to each unique plot occurrence at a place.',
     
        ' place  Place  PLOTPLACE_ID  ID  logical    serial  PK  n/a  no  Primary key for the place table  Database generated identifier assigned to each unique plot occurrence at a place. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'place',
        'PLOT_ID',
        'Plot',
        'logical',
        'no',
        'Integer',
        'FK',
        'plot.PLOT_ID',
        'no',
        'Foreign key into the plot table.',
        'Link to a specific plot.',
     
        ' place  Place  PLOT_ID  Plot  logical  required  Integer  FK  plot.PLOT_ID  no  Foreign key into the plot table.  Link to a specific plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'place',
        'calculated',
        'Calculated?',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'TRUE If occurrence is calculated based on geo-coordinates, FALSE if assigned by the author (If, both methods used, the author assigned value takes priority).',
     
        ' place  Place  calculated  Calculated?  logical    Boolean  n/a  n/a  no  n/a  TRUE If occurrence is calculated based on geo-coordinates, FALSE if assigned by the author (If, both methods used, the author assigned value takes priority). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'place',
        'NAMEDPLACE_ID',
        'Place Name',
        'logical',
        'no',
        'Integer',
        'FK',
        'namedPlace.NAMEDPLACE_ID',
        'no',
        'Foreign key into the namedPlace table',
        'Link to a specific named place or region',
     
        ' place  Place  NAMEDPLACE_ID  Place Name  logical  required  Integer  FK  namedPlace.NAMEDPLACE_ID  no  Foreign key into the namedPlace table  Link to a specific named place or region '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'plot',
        'Plot',
        'This table stores general, constant information about the a given plot',
        'plot contains Plot location, dimension, and similarly constant site data, plus metadata that need be stored only once.   Transient observational information (procured during the first or subsequent observation events) are stored separately in observation or its children.',
        ' plot  Plot  This table stores general, constant information about the a given plot  plot contains Plot location, dimension, and similarly constant site data, plus metadata that need be stored only once.   Transient observational information (procured during the first or subsequent observation events) are stored separately in observation or its children.  PLOT_ID  ID  authorPlotCode  Author Plot Code  reference_ID  Reference  PARENT_ID  Parent  realLatitude  Real Latitude  realLongitude  Real Longitude  locationAccuracy  Location Accuracy  confidentialityStatus  Confidentiality Status  confidentialityReason  Confidentiality Reason  latitude  Latitude  longitude  Longitude  authorE  Author E  authorN  Author N  authorZone  Author Zone  authorDatum  Author Datum  authorLocation  Author Location  locationNarrative  Location Narrative  plotRationaleNarrative  Plot Rationale Narrative  azimuth  Azimuth  dsgpoly  DSG Polygon  shape  Shape  area  Area  standSize  Stand Size  placementMethod  Placement Method  permanence  Permanence  layoutNarrative  Layout Narrative  elevation  Elevation  elevationAccuracy  Elevation Accuracy  elevationRange  Elevation Range  slopeAspect  Slope Aspect  minSlopeAspect  Min Slope Aspect  maxSlopeAspect  Max Slope Aspect  slopeGradient  Slope Gradient  minSlopeGradient  Min Slope Gradient  maxSlopeGradient  Max Slope Gradient  topoPosition  Topographic Position  landform  Landform  surficialDeposits  Surficial Deposits  rockType  Rock Type  stateProvince  State or Province  country  Country  dateentered  Date Entered  submitter_surname  Submitter_surname  submitter_givenname  Submitter_givenname  submitter_email  Submitter_email  accessionCode  Accession Code  notesPublic  Notes Public  notesMgt  Notes Mgt  revisions  Revisions  emb_plot  this row embargoed. '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'PLOT_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for plot',
        'Database generated identifier assigned to each unique plot.',
     
        ' plot  Plot  PLOT_ID  ID  logical    serial  PK  n/a  no  Primary key for plot  Database generated identifier assigned to each unique plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'authorPlotCode',
        'Author Plot Code',
        'logical',
        'no',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Author''s Plot number/code, or the original plot number if taken from literature.',
     
        ' plot  Plot  authorPlotCode  Author Plot Code  logical  required  varchar (30)  n/a  n/a  no  n/a  Author''s Plot number/code, or the original plot number if taken from literature. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'Foreign key into the reference table',
        'Link to the source reference from which this plot record was taken',
     
        ' plot  Plot  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  Foreign key into the reference table  Link to the source reference from which this plot record was taken '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'PARENT_ID',
        'Parent',
        'logical',
        'yes',
        'Integer',
        'FK',
        'plot.PLOT_ID',
        'no',
        'Recursive foreign key',
        'Link to the parent plot when plot is nested within another plot.',
     
        ' plot  Plot  PARENT_ID  Parent  logical    Integer  FK  plot.PLOT_ID  no  Recursive foreign key  Link to the parent plot when plot is nested within another plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'realLatitude',
        'Real Latitude',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Latitude of the plot origin in degrees and decimals, datum =WGS84',
     
        ' plot  Plot  realLatitude  Real Latitude  logical    Float  n/a  n/a  no  n/a  Latitude of the plot origin in degrees and decimals, datum =WGS84 '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'realLongitude',
        'Real Longitude',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Longitude of the plot origin in degrees and decimals, datum = WGS84',
     
        ' plot  Plot  realLongitude  Real Longitude  logical    Float  n/a  n/a  no  n/a  Longitude of the plot origin in degrees and decimals, datum = WGS84 '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'locationAccuracy',
        'Location Accuracy',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Estimated accuracy of the location of the plot. Plot origin has a 95% or greater probability of being within this many meters of the reported location.',
     
        ' plot  Plot  locationAccuracy  Location Accuracy  logical    Float  n/a  n/a  no  n/a  Estimated accuracy of the location of the plot. Plot origin has a 95% or greater probability of being within this many meters of the reported location. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'confidentialityStatus',
        'Confidentiality Status',
        'logical',
        'no',
        'Integer',
        'n/a',
        'n/a',
        'closed',
        'closed list, default=0',
        'Are the data to be considered confidential? 0=no, 1= 1km radius, 2=10km radius, 3=100km radius, 4=location embargo, 5=public embargo on all plot data, 6=full embargo on all plot data. This applies also to region.',
     
        ' plot  Plot  confidentialityStatus  Confidentiality Status  logical  required  Integer  n/a  n/a  closed  closed list, default=0  Are the data to be considered confidential? 0=no, 1= 1km radius, 2=10km radius, 3=100km radius, 4=location embargo, 5=public embargo on all plot data, 6=full embargo on all plot data. This applies also to region.  0  Public  1  1 km radius (nearest 0.01 degree)  2  10 km radius (nearest 0.1 degree)  3  100 km radius (nearest degree)  4  Location embargo  5  Public embargo on data  6  Full embargo on data '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'confidentialityStatus',
                              '0',
                              'Public',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'confidentialityStatus',
                              '1',
                              '1 km radius (nearest 0.01 degree)',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'confidentialityStatus',
                              '2',
                              '10 km radius (nearest 0.1 degree)',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'confidentialityStatus',
                              '3',
                              '100 km radius (nearest degree)',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'confidentialityStatus',
                              '4',
                              'Location embargo',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'confidentialityStatus',
                              '5',
                              'Public embargo on data',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'confidentialityStatus',
                              '6',
                              'Full embargo on data',
                              '7'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'confidentialityReason',
        'Confidentiality Reason',
        'logical',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The reason for confidentiality.  This field should not be open to public view.  Reasons might include specific rare species, ownership, prepublication embargo, or many other reason',
     
        ' plot  Plot  confidentialityReason  Confidentiality Reason  logical    varchar (200)  n/a  n/a  no  n/a  The reason for confidentiality.  This field should not be open to public view.  Reasons might include specific rare species, ownership, prepublication embargo, or many other reason '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'latitude',
        'Latitude',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Latitude of the plot origin in degrees and decimals, datum =WGS84, fuzzing applied',
     
        ' plot  Plot  latitude  Latitude  logical    Float  n/a  n/a  no  n/a  Latitude of the plot origin in degrees and decimals, datum =WGS84, fuzzing applied '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'longitude',
        'Longitude',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Longitude of the plot origin in degrees and decimals, datum = WGS84, fuzzing applied',
     
        ' plot  Plot  longitude  Longitude  logical    Float  n/a  n/a  no  n/a  Longitude of the plot origin in degrees and decimals, datum = WGS84, fuzzing applied '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'authorE',
        'Author E',
        'logical',
        'yes',
        'varchar (20)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Original E-W coordinate as recorded by the author',
     
        ' plot  Plot  authorE  Author E  logical    varchar (20)  n/a  n/a  no  n/a  Original E-W coordinate as recorded by the author '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'authorN',
        'Author N',
        'logical',
        'yes',
        'varchar (20)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Original N-S coordinate as recorded by the author',
     
        ' plot  Plot  authorN  Author N  logical    varchar (20)  n/a  n/a  no  n/a  Original N-S coordinate as recorded by the author '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'authorZone',
        'Author Zone',
        'logical',
        'yes',
        'varchar (20)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Original UTM zone reported by the author',
     
        ' plot  Plot  authorZone  Author Zone  logical    varchar (20)  n/a  n/a  no  n/a  Original UTM zone reported by the author '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'authorDatum',
        'Author Datum',
        'logical',
        'yes',
        'varchar (20)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Original datum reported by the author',
     
        ' plot  Plot  authorDatum  Author Datum  logical    varchar (20)  n/a  n/a  no  n/a  Original datum reported by the author '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'authorLocation',
        'Author Location',
        'logical',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Original location as described by author (e.g. Town-Range-Section)',
     
        ' plot  Plot  authorLocation  Author Location  logical    varchar (200)  n/a  n/a  no  n/a  Original location as described by author (e.g. Town-Range-Section) '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'locationNarrative',
        'Location Narrative',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Text description that provides information useful for plot relocation.',
     
        ' plot  Plot  locationNarrative  Location Narrative  logical    text  n/a  n/a  no  n/a  Text description that provides information useful for plot relocation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'plotRationaleNarrative',
        'Plot Rationale Narrative',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Text description about why the plot was placed where it was.',
     
        ' plot  Plot  plotRationaleNarrative  Plot Rationale Narrative  logical    text  n/a  n/a  no  n/a  Text description about why the plot was placed where it was. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'azimuth',
        'Azimuth',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This element stores the azimuth of the x-axis used to describe the relative coordinate system for plot shape (dsgpoly) and other spatial information about the plot. Typically the azimuth is parallel to the long axis of the plot (in the case of a rectangle).',
     
        ' plot  Plot  azimuth  Azimuth  logical    Float  n/a  n/a  no  n/a  This element stores the azimuth of the x-axis used to describe the relative coordinate system for plot shape (dsgpoly) and other spatial information about the plot. Typically the azimuth is parallel to the long axis of the plot (in the case of a rectangle). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'dsgpoly',
        'DSG Polygon',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This field is a text string containing the points circumscribing a plot area.  These points are anticipated to have been collected using tapes, GPS, or calculated from the plot shape and area. Points are X-Y coordinates in m relative to plot origin.',
     
        ' plot  Plot  dsgpoly  DSG Polygon  logical    text  n/a  n/a  no  n/a  This field is a text string containing the points circumscribing a plot area.  These points are anticipated to have been collected using tapes, GPS, or calculated from the plot shape and area. Points are X-Y coordinates in m relative to plot origin. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'shape',
        'Shape',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'open',
        'open list',
        'Shape of the plot area.',
     
        ' plot  Plot  shape  Shape  logical    varchar (50)  n/a  n/a  open  open list  Shape of the plot area.  Circle    Diffuse    Plotless    Rectangular    Square    Transect/Strip    Other   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'shape',
                              'Rectangular',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'shape',
                              'Square',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'shape',
                              'Circle',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'shape',
                              'Transect/Strip',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'shape',
                              'Plotless',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'shape',
                              'Diffuse',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'shape',
                              'Other',
                              null,
                              '7'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'area',
        'Area',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total area of the plot in m2.  If many subplots, this area includes the subplots and the interstitial space.  RESERVED VALUE: -1 is used to indicate that the plot had no boundaries.',
     
        ' plot  Plot  area  Area  logical    Float  n/a  n/a  no  n/a  Total area of the plot in m2.  If many subplots, this area includes the subplots and the interstitial space.  RESERVED VALUE: -1 is used to indicate that the plot had no boundaries. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'standSize',
        'Stand Size',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'The extent of this community occurrence in relation to the plot size: very extensive (>1000x plot), extensive (>100x plot), large (10-100x plot), small (3-10x plot), very small (1-3x plot).',
     
        ' plot  Plot  standSize  Stand Size  logical    varchar (50)  n/a  n/a  closed  closed list  The extent of this community occurrence in relation to the plot size: very extensive (>1000x plot), extensive (>100x plot), large (10-100x plot), small (3-10x plot), very small (1-3x plot).  Extensive  greater than 100x plot size  Large  10-100x plot size  Small  3-10x plot size  Very Extensive  greater than 1000x plot size  Very small  1-3x plot size  Inclusion  less than 1x plot size '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'standSize',
                              'Very Extensive',
                              'greater than 1000x plot size',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'standSize',
                              'Extensive',
                              'greater than 100x plot size',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'standSize',
                              'Large',
                              '10-100x plot size',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'standSize',
                              'Small',
                              '3-10x plot size',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'standSize',
                              'Very small',
                              '1-3x plot size',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'standSize',
                              'Inclusion',
                              'less than 1x plot size',
                              '6'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'placementMethod',
        'Placement Method',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Brief description of strategy for determining plot placement within the stand.',
     
        ' plot  Plot  placementMethod  Placement Method  logical    varchar (50)  n/a  n/a  closed  closed list  Brief description of strategy for determining plot placement within the stand.  Capture specific feature    Random    Regular    Representative    Stratified random    Transect component   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'placementMethod',
                              'Regular',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'placementMethod',
                              'Random',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'placementMethod',
                              'Stratified random',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'placementMethod',
                              'Transect component',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'placementMethod',
                              'Representative',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'placementMethod',
                              'Capture specific feature',
                              null,
                              '6'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'permanence',
        'Permanence',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Is the plot monumented so as to assure permanence?  If so, this should be described in the layoutNarrative',
     
        ' plot  Plot  permanence  Permanence  logical    Boolean  n/a  n/a  no  n/a  Is the plot monumented so as to assure permanence?  If so, this should be described in the layoutNarrative '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'layoutNarrative',
        'Layout Narrative',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Text description of and the rationale for the layout of the plot.',
     
        ' plot  Plot  layoutNarrative  Layout Narrative  logical    text  n/a  n/a  no  n/a  Text description of and the rationale for the layout of the plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'elevation',
        'Elevation',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The elevation of the plot origin in meters above sea level.',
     
        ' plot  Plot  elevation  Elevation  logical    Float  n/a  n/a  no  n/a  The elevation of the plot origin in meters above sea level. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'elevationAccuracy',
        'Elevation Accuracy',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The accuracy of the elevation in meters.',
     
        ' plot  Plot  elevationAccuracy  Elevation Accuracy  logical    Float  n/a  n/a  no  n/a  The accuracy of the elevation in meters. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'elevationRange',
        'Elevation Range',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Meters of difference in elevations of the high and low points in the plot.',
     
        ' plot  Plot  elevationRange  Elevation Range  logical    Float  n/a  n/a  no  n/a  Meters of difference in elevations of the high and low points in the plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'slopeAspect',
        'Slope Aspect',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'optional list that converts',
        'Representative azimuth of slope gradient (0-360 degrees); if too flat to determine = -1; if too irregular to determine = -2.',
     
        ' plot  Plot  slopeAspect  Slope Aspect  logical    Float  n/a  n/a  no  optional list that converts  Representative azimuth of slope gradient (0-360 degrees); if too flat to determine = -1; if too irregular to determine = -2. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'minSlopeAspect',
        'Min Slope Aspect',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'optional list that converts',
        'Minimum azimuth of slope gradient (0-360 degrees), counterclockwise from representative azimuth.',
     
        ' plot  Plot  minSlopeAspect  Min Slope Aspect  logical    Float  n/a  n/a  no  optional list that converts  Minimum azimuth of slope gradient (0-360 degrees), counterclockwise from representative azimuth. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'maxSlopeAspect',
        'Max Slope Aspect',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'optional list that converts',
        'Maximum azimuth of slope gradient (0-360 degrees), clockwise from representative azimuth',
     
        ' plot  Plot  maxSlopeAspect  Max Slope Aspect  logical    Float  n/a  n/a  no  optional list that converts  Maximum azimuth of slope gradient (0-360 degrees), clockwise from representative azimuth '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'slopeGradient',
        'Slope Gradient',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'optional list that converts',
        'Representative inclination of slope in degrees; if too irregular to determine, = -1.',
     
        ' plot  Plot  slopeGradient  Slope Gradient  logical    Float  n/a  n/a  no  optional list that converts  Representative inclination of slope in degrees; if too irregular to determine, = -1. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'minSlopeGradient',
        'Min Slope Gradient',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'optional list that converts',
        'Minimum inclination of slope in degrees.',
     
        ' plot  Plot  minSlopeGradient  Min Slope Gradient  logical    Float  n/a  n/a  no  optional list that converts  Minimum inclination of slope in degrees. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'maxSlopeGradient',
        'Max Slope Gradient',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'optional list that converts',
        'Maximum inclination of slope in degrees.',
     
        ' plot  Plot  maxSlopeGradient  Max Slope Gradient  logical    Float  n/a  n/a  no  optional list that converts  Maximum inclination of slope in degrees. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'topoPosition',
        'Topographic Position',
        'logical',
        'yes',
        'varchar (90)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'Position of the plot on land surface (e.g., Summit, shoulder, upper slope, middle slope, lower slope, toeslope, no slope, channel bed, dune swale, pond).',
     
        ' plot  Plot  topoPosition  Topographic Position  logical    varchar (90)  n/a  n/a  closed  n/a  Position of the plot on land surface (e.g., Summit, shoulder, upper slope, middle slope, lower slope, toeslope, no slope, channel bed, dune swale, pond).  Interfluve  (crest, summit, ridge): linear top of ridge, hill, or mountain; the elevated area between two fluves (drainageways) that sheds water to the drainageways.  High slope  (shoulder slope, upper slope, convex creep slope): geomorphic component that forms the uppermost inclined surface at the top of a slope.  Comprises the transition zone from backslope to summit. Surface is dominantly convex in profile and erosional in origin.  High level  (mesa, high flat): level top of plateau  Midslope  (transportational midslope, middle slope): intermediate slope position  Backslope  (dipslope): subset of midslopes which are steep, linear, and may include cliff segments (fall faces).  Step in slope  (ledge, terracette): nearly level shelf interrupting a steep slope, rock wall, or cliff face.  Lowslope  (lower slope, foot slope, colluvial footslope): inner gently inclined surface at the base of a slope. Surface profile is generally concave and a transition between midslope or backslope, and toe slope.  Toeslope  (alluvial toeslope): outermost gently inclined surface at base of a slope. In profile, commonly gentle and linear and characterized by alluvial deposition.  Low level  (terrace, low flat): valley floor or shoreline representing the former position of an alluvial plain, lake, or shore.  Channel wall  (bank): sloping side of a channel.  Channel bed  (narrow valley bottom, gully arroyo): bed of single or braided watercourse commonly barren of vegetation and formed of modern alluvium.  Basin floor  (depression): nearly level to gently sloping, bottom surface of a basin. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'Interfluve',
                              '(crest, summit, ridge): linear top of ridge, hill, or mountain; the elevated area between two fluves (drainageways) that sheds water to the drainageways.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'High slope',
                              '(shoulder slope, upper slope, convex creep slope): geomorphic component that forms the uppermost inclined surface at the top of a slope.  Comprises the transition zone from backslope to summit. Surface is dominantly convex in profile and erosional in origin.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'High level',
                              '(mesa, high flat): level top of plateau',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'Midslope',
                              '(transportational midslope, middle slope): intermediate slope position',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'Backslope',
                              '(dipslope): subset of midslopes which are steep, linear, and may include cliff segments (fall faces).',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'Step in slope',
                              '(ledge, terracette): nearly level shelf interrupting a steep slope, rock wall, or cliff face.',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'Lowslope',
                              '(lower slope, foot slope, colluvial footslope): inner gently inclined surface at the base of a slope. Surface profile is generally concave and a transition between midslope or backslope, and toe slope.',
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'Toeslope',
                              '(alluvial toeslope): outermost gently inclined surface at base of a slope. In profile, commonly gentle and linear and characterized by alluvial deposition.',
                              '8'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'Low level',
                              '(terrace, low flat): valley floor or shoreline representing the former position of an alluvial plain, lake, or shore.',
                              '9'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'Channel wall',
                              '(bank): sloping side of a channel.',
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'Channel bed',
                              '(narrow valley bottom, gully arroyo): bed of single or braided watercourse commonly barren of vegetation and formed of modern alluvium.',
                              '11'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'topoPosition',
                              'Basin floor',
                              '(depression): nearly level to gently sloping, bottom surface of a basin.',
                              '12'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'landform',
        'Landform',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'open',
        'n/a',
        'A recognizable physical feature on the surface of the earth, often including consideration of the natural cause of its formation.',
     
        ' plot  Plot  landform  Landform  logical    varchar (50)  n/a  n/a  open  n/a  A recognizable physical feature on the surface of the earth, often including consideration of the natural cause of its formation.  active slope  (metastable slope) A mountain or hill slope that is responding to valley incision, and has detritus accumulated behind obstructions, indicating contemporary transport of slope alluvium. Slope gradients commonly exceed 45 percent.  alluvial cone  The material washed down mountain and hill slopes by ephemeral streams and deposited at the mouth of gorges in the form of a moderately steep, conical mass descending equally in all directions from the point of issue.  alluvial fan  A body of alluvium, with or without debris flow deposits, whose surface forms a segment of a cone that radiates downslope from the point where the stream emerges from a narrow valley onto a less sloping surface. Common longitudinal profiles are gently sloping and nearly linear.  Source uplands range in relief and aerial extent from mountains and plateaus to gullied terrains on hill and piedmont slopes.  alluvial flat  A nearly level, graded, alluvial surface.  alluvial plain  A flood plain or a low-gradient delta. It may be modern or relict.  alluvial terrace    arroyo  (wash) The flat-floored channel or an ephemeral stream, commonly with very steep to vertical banks cut in alluvium.  backshore terrace    backswamp  (valley flat) Extensive marshy, depressed areas of flood plains between the natural levee borders of channel belts and valley sides or terraces.  backwater    badlands    bajada    bald    bank    bar  An elongated landform generated by waves and currents and usually running parallel to the shore, composed predominantly of unconsolidated sand, gravel, cobbles, or stones with water on two sides.  barrier beach    barrier flat    barrier island(s)    barrier reef    basin  A depressed area with no or limited surface outlet. Examples are closed depressions in a glacial till plain, lake basin, river basin, or fault-bordered intermontane structure such as the Bighorn Basin of Wyoming.  basin floor    bay    bayou    beach  The unconsolidated material that covers a gently sloping zone, typically with a concave profile, extending landward from the low-water line to the place where there is a definite change in material or physiographic form (such as a cliff) or to the line of permanent vegetation; the relatively thick and temporary accumulation of loose water-borne material (usually well-sorted sand and pebbles, accompanied by mud, cobbles, boulders, and smoothed rock and shell fragment) that is in active transit along, or deposited on the shore zone between the limits of low water and high water.  beach ridge    bench    blowout    bluff  (a) A high bank or bold headland, with a broad, precipitous, sometimes rounded cliff face overlooking a plain or body of water, especially on the outside of a stream meander; (b) any cliff with a steep, broad face.  bottomlands    braided channel or stream  (flood-plain landforms) A channel or stream with multiple channels that interweave as a result of repeated bifurcation and convergence of flow around interchannel bars, resembling in plan the strands of a complex braid. Braiding is generally confined to broad, shallow streams of low sinuosity, high bedload, non-cohesive bank material, and step gradient. At a given bank-full discharge, braided streams have steeper slopes and shallower, broader, and less stable channel cross sections than meandering streams.  butte    caldera    canyon  A long, deep, narrow, very steep-sided valley with high and precipitous walls in an area of high local relief.  carolina bay    channel    chenier    chenier plain    cirque  Semicircular, concave, bowl-like area with steep face primarily resulting from erosive activity of a mountain glacier.  cirque floor    cirque headwall    cliff  Any high, very steep to perpendicular or overhanging face of rock or earth; a precipice.  coast    coastal plain    col    collapse sinkhole    colluvial shoulder    colluvial slope    cove    crest  (summit) The commonly linear top of a ridge, hill or mountain.  cuesta    debris slide    delta  A body of alluvium, nearly flat and fan-shaped, deposited at or near the mouth of a river or stream where it enters a body of relatively quiet water, usually a sea or lake.  delta plain    depositional levee    depositional stream terrace    depression    desert pavement    dike    doline    dome  A roughly symmetrical upfold, with bed dipping in all directions, more or less equally, from a point. A smoothly rounded landform or rock mass such as a rock-capped mountain summit, roughly resembling the dome of a building.  drainage    drainage channel (undifferentiated)    draw    drumlin  A low, smooth, elongated oval hill, mound, or ridge of compact glacial till that may or may not have a core of bedrock or stratified glacial drift. The longer axis is parallel to the general direction of glacier flow.  Drumlins are products of streamline (laminar) flow of glaciers, which molded the subglacial floor through a combination of erosion and deposition.  dune (undifferentiated)  A mound, ridge, or hill of loose, windblown granular material (generally sand), either bare or covered with vegetation.  dune field    earth flow    earth hummock    eroded bench    eroding stream channel system    erosional stream terrace    escarpment  (scarp) A relatively continuous and steep slope or cliff breaking the general continuity of more gently sloping land surfaces and produced by erosion or faulting. The term is more often applied to cliffs produced by differential erosion.  esker  A long, narrow sinuous, steep-sided ridge composed of irregularly stratified sand and gravel that was deposited by a subsurface stream flowing between ice walls, or in an ice tunnel of a retreating glacier, and was left behind when the ice melted.  estuary    exogenous dome    fan piedmont    fault scarp    fault terrace    fissure    fissure vent    flat  A general term for a level or nearly level surface or small area of land marked by little or no relief, eg. mud flat or valley flat.  flood plain  (bottomland) The nearly level alluvial plain that borders a stream and is subject to inundation under flood-stage conditions unless protected artificially.  It is usually a constructional landform built of sediment deposited during overflow and lateral migration of the stream.  fluvial    foothills    foredune    frost creep slope    frost mound    frost scar    gap    glaciated uplands    glacier    gorge  (a) A narrow, deep valley with nearly vertical rocky walls, enclosed by mountains, smaller than a canyon, and more steep-sided than a ravine; especially a restricted, steep-walled part of a canyon. (b) A narrow defile or passage between hills or mountains.  graben    ground moraine    gulch    hanging valley    headland    highland    hills  (foothills) A natural elevation of the land surface, rising as much as 300 m above the surrounding lowlands, usually of restricted summit area (relative to a tableland) and having a well-defined outline; hill slopes generally exceed 15%.  The distinction between a hill and a mountain is often dependent on local usage.  hillslope bedrock outcrop    hogback    hoodoo    hummock  A rounded or conical mound of knoll, hillock, or other small elevation.  Also, a slight rise of ground above a level surface.  inlet    inselberg    interdune flat    interfluve    island    kame  A moundlike hill of ice-contact glacial drift, composed chiefly of stratified sand and gravel.  kame moraine    kame terrace    karst    karst tower    karst window    kegel karst    kettle  A steep-sided bowl-shaped depression without surface drainage. It is in glacial drift deposits and believed to have formed by the melting of a large, detached block of stagnant ice buried in the glacial drift.  kettled outwash plain    knob  (a) A rounded eminence, as a knoll, hillock, or small hill or mountain; especially a prominent or isolated hill with steep sides, commonly found in the southern United States. (b) A peak or other projection from the top of a hill or mountain. Also a boulder or group of boulders or an area of resistant rocks protruding from the side of a hill or mountain.  knoll    lagoon    lake    lake bed    lake plain    lake terrace    lateral moraine    lateral scarp (undifferentiated)    lava flow (undifferentiated)    ledge    levee  (floodwall, earth dike) An artificial or natural embankment built along the margin of a watercourse or an arm of the sea, to protect land from inundation or to confine streamflow to its channel.  loess deposit (undifferentiated)    longshore bar    lowland    marine terrace (undifferentiated)    meander belt    meander scar    mesa    mid slope    mima mound    monadnock    moraine (undifferentiated)  A drift topography characterized by chaotic mounds and pits, generally randomly oriented, developed in superglacial drift by collapse and flow as the underlying stagnant ice melted. Slopes may be steep and unstable and there will be used and unused stream coursed and lake depressions interspersed with the morainic ridges. Consequently, there will be rapid or abrupt changes between materials of differing lithology.  mound    mountain valley    mountain(s)  (hill) A natural elevation of the land surface, rising more than 300 m above surrounding lowlands, usually of restricted summit area (relative to a plateau), and generally having steep sides (greater than 25 percent slope) with or without considerable bare-rock surface. A mountain can occur as a single, isolated mass or in a group forming a chain or range. Mountains are primarily formed by deep-seated earth movements and/or volcanic action and secondarily by differential erosion.  mountain-valley fan    mud flat    noseslope    outwash fan    outwash plain  (glacial outwash, kettles) An extensive lowland area of coarse textured, glaciofluvial material. An outwash plain is commonly smooth; where pitted, due to melt-out of incorporated ice masses, it is generally low in relief.  outwash terrace    oxbow  (meander belt, oxbow lake) A closely looping stream meander having an extreme curvature such that only a neck of land is left between the two parts of the stream. A term used in New England for the land enclosed, or partly enclosed, within an oxbow.  patterned ground (undifferentiated)    peat dome    periglacial boulderfield    piedmont    pimple mounds    pingo  A large frost mound; especially a relatively large conical mound of soil-covered ice (commonly 30 to 50 m high and up to 400 m in diameter) raised in part by hydrostatic pressure within and below the permafrost of Arctic regions, and of more than 1 year’s duration.  pinnacle    plain  (lowland, plateau) An extensive lowland area that ranges from level to gently sloping or undulating. A plain has few or no prominent hills or valleys, and usually occurs at low elevation with reference to surrounding areas (local relief generally less than 100m, although some, such as the Great Plains of the United States, are as much as 1000 to 1800 m above sea level.) Where dissected, remnants of a plain can form the local uplands.  plateau  (mesa, plain) An extensive upland mass with a relatively flat summit area that is considerably elevated (more than 100m) above adjacent lowlands, and is separated from them on one or more sides by escarpments. A comparatively large part of a plateau surface is near summit level.  playa    polygon (high-centered)    polygon (low-centered)    pothole    raised beach    raised estuary    raised mudflat    raised tidal flat    ravine  (gulch, draw) A small stream channel; narrow, steep-sided, and commonly V-shaped in cross section; and larger than a gully.  relict coastline    ridge  A long, narrow elevation of the land surface, usually sharp rested with steep sides and forming an extended upland between valleys. The term is used in areas of both hill and mountain relief.  ridge and valley    ridgetop bedrock outcrop    rift valley    rim    riverbed    rock fall avalanche    saddle  A low point on a ridge or crestline, generally a divide (pass, col) between the heads of streams flowing in opposite directions.  sag pond    sandhills    scarp    scarp slope    scour    scoured basin    sea cliff    seep    shoal    shoreline    shoulder  (hill slope) The geomorphic component that form the uppermost inclined surface at the top of a hillslope. It comprises the transition zone from backslope to summit of an upland. The surface is dominantly convex in profile and erosional in origin.  sinkhole (undifferentiated)  (doline) A closed depression formed either by solution of the surficial bedrock (e.g. limestone, gypsum, salt) or by collapse of underlying caves. Complexes of sinkholes in carbonate-rock terraces are the main components of karst topography.  slide    slope    slough    slump and topple prone slope    slump pond    soil creep slope    solution sinkhole    spit  (a) A small point or low tongue or narrow embankment of land, commonly consisting of sand or gravel deposited by longshore drifting and having one end attached to the mainland and the other terminating in open water, usually the sea; a fingerlike extension of the beach. (b) A relatively long, narrow shoal or reef extending from the shore into a body of water.  splay  A small alluvial fan or other outspread deposit formed where an overloaded stream breaks through a levee and deposits its material (often coarse-grained) on the flood plain.  stone circle    stone stripe    stream terrace (undifferentiated)    streambed    subjacent karst collapse sinkhole    subsidence sinkhole    swale  (a) A slight depression, sometimes swampy, in the midst of generally level land. (b) A shallow depression in an undulating ground moraine due to uneven glacial deposition. (c) A long, narrow, generally shallow, trough-like depression between two beach ridges, and aligned roughly parallel to the coastline.  talus    tarn    terrace  A step-like surface, bordering a valley floor or shoreline, that represent the former position of an alluvial plain, or lake or sea shore. The term is usually applied to both the relatively flat summit surface (platform, tread), cut or built by stream or wave action, and the steeper descending slope (scarp, riser), graded to a lower base level of erosion.  tidal flat    tidal gut    till plain    toe slope    toe zone (undifferentiated)    transverse dune    trench    trough    valley  (basin) An elongate, relatively large, externally drained depression of the earth''s surface that is primarily developed by stream erosion.  valley floor    wave-built terrace    wave-cut platform   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'active slope',
                              '(metastable slope) A mountain or hill slope that is responding to valley incision, and has detritus accumulated behind obstructions, indicating contemporary transport of slope alluvium. Slope gradients commonly exceed 45 percent.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'alluvial cone',
                              'The material washed down mountain and hill slopes by ephemeral streams and deposited at the mouth of gorges in the form of a moderately steep, conical mass descending equally in all directions from the point of issue.',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'alluvial fan',
                              'A body of alluvium, with or without debris flow deposits, whose surface forms a segment of a cone that radiates downslope from the point where the stream emerges from a narrow valley onto a less sloping surface. Common longitudinal profiles are gently sloping and nearly linear.  Source uplands range in relief and aerial extent from mountains and plateaus to gullied terrains on hill and piedmont slopes.',
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'alluvial flat',
                              'A nearly level, graded, alluvial surface.',
                              '15'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'alluvial plain',
                              'A flood plain or a low-gradient delta. It may be modern or relict.',
                              '17'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'alluvial terrace',
                              null,
                              '20'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'arroyo',
                              '(wash) The flat-floored channel or an ephemeral stream, commonly with very steep to vertical banks cut in alluvium.',
                              '22'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'backshore terrace',
                              null,
                              '25'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'backswamp',
                              '(valley flat) Extensive marshy, depressed areas of flood plains between the natural levee borders of channel belts and valley sides or terraces.',
                              '27'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'backwater',
                              null,
                              '30'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'badlands',
                              null,
                              '35'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'bajada',
                              null,
                              '40'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'bald',
                              null,
                              '45'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'bank',
                              null,
                              '50'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'bar',
                              'An elongated landform generated by waves and currents and usually running parallel to the shore, composed predominantly of unconsolidated sand, gravel, cobbles, or stones with water on two sides.',
                              '55'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'barrier beach',
                              null,
                              '60'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'barrier flat',
                              null,
                              '65'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'barrier island(s)',
                              null,
                              '70'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'barrier reef',
                              null,
                              '75'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'basin',
                              'A depressed area with no or limited surface outlet. Examples are closed depressions in a glacial till plain, lake basin, river basin, or fault-bordered intermontane structure such as the Bighorn Basin of Wyoming.',
                              '80'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'basin floor',
                              null,
                              '85'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'bay',
                              null,
                              '90'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'bayou',
                              null,
                              '95'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'beach',
                              'The unconsolidated material that covers a gently sloping zone, typically with a concave profile, extending landward from the low-water line to the place where there is a definite change in material or physiographic form (such as a cliff) or to the line of permanent vegetation; the relatively thick and temporary accumulation of loose water-borne material (usually well-sorted sand and pebbles, accompanied by mud, cobbles, boulders, and smoothed rock and shell fragment) that is in active transit along, or deposited on the shore zone between the limits of low water and high water.',
                              '100'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'beach ridge',
                              null,
                              '105'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'bench',
                              null,
                              '110'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'blowout',
                              null,
                              '115'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'bluff',
                              '(a) A high bank or bold headland, with a broad, precipitous, sometimes rounded cliff face overlooking a plain or body of water, especially on the outside of a stream meander; (b) any cliff with a steep, broad face.',
                              '117'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'bottomlands',
                              null,
                              '120'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'braided channel or stream',
                              '(flood-plain landforms) A channel or stream with multiple channels that interweave as a result of repeated bifurcation and convergence of flow around interchannel bars, resembling in plan the strands of a complex braid. Braiding is generally confined to broad, shallow streams of low sinuosity, high bedload, non-cohesive bank material, and step gradient. At a given bank-full discharge, braided streams have steeper slopes and shallower, broader, and less stable channel cross sections than meandering streams.',
                              '122'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'butte',
                              null,
                              '125'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'caldera',
                              null,
                              '130'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'canyon',
                              'A long, deep, narrow, very steep-sided valley with high and precipitous walls in an area of high local relief.',
                              '135'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'carolina bay',
                              null,
                              '140'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'channel',
                              null,
                              '145'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'chenier',
                              null,
                              '150'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'chenier plain',
                              null,
                              '155'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'cirque',
                              'Semicircular, concave, bowl-like area with steep face primarily resulting from erosive activity of a mountain glacier.',
                              '160'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'cirque floor',
                              null,
                              '165'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'cirque headwall',
                              null,
                              '170'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'cliff',
                              'Any high, very steep to perpendicular or overhanging face of rock or earth; a precipice.',
                              '175'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'coast',
                              null,
                              '180'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'coastal plain',
                              null,
                              '185'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'col',
                              null,
                              '190'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'collapse sinkhole',
                              null,
                              '195'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'colluvial shoulder',
                              null,
                              '200'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'colluvial slope',
                              null,
                              '205'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'cove',
                              null,
                              '210'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'crest',
                              '(summit) The commonly linear top of a ridge, hill or mountain.',
                              '212'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'cuesta',
                              null,
                              '215'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'debris slide',
                              null,
                              '220'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'delta',
                              'A body of alluvium, nearly flat and fan-shaped, deposited at or near the mouth of a river or stream where it enters a body of relatively quiet water, usually a sea or lake.',
                              '225'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'delta plain',
                              null,
                              '230'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'depositional levee',
                              null,
                              '235'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'depositional stream terrace',
                              null,
                              '240'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'depression',
                              null,
                              '245'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'desert pavement',
                              null,
                              '250'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'dike',
                              null,
                              '255'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'doline',
                              null,
                              '260'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'dome',
                              'A roughly symmetrical upfold, with bed dipping in all directions, more or less equally, from a point. A smoothly rounded landform or rock mass such as a rock-capped mountain summit, roughly resembling the dome of a building.',
                              '265'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'drainage',
                              null,
                              '270'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'drainage channel (undifferentiated)',
                              null,
                              '275'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'draw',
                              null,
                              '280'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'drumlin',
                              'A low, smooth, elongated oval hill, mound, or ridge of compact glacial till that may or may not have a core of bedrock or stratified glacial drift. The longer axis is parallel to the general direction of glacier flow.  Drumlins are products of streamline (laminar) flow of glaciers, which molded the subglacial floor through a combination of erosion and deposition.',
                              '285'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'dune (undifferentiated)',
                              'A mound, ridge, or hill of loose, windblown granular material (generally sand), either bare or covered with vegetation.',
                              '290'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'dune field',
                              null,
                              '295'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'earth flow',
                              null,
                              '300'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'earth hummock',
                              null,
                              '305'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'eroded bench',
                              null,
                              '310'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'eroding stream channel system',
                              null,
                              '315'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'erosional stream terrace',
                              null,
                              '320'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'escarpment',
                              '(scarp) A relatively continuous and steep slope or cliff breaking the general continuity of more gently sloping land surfaces and produced by erosion or faulting. The term is more often applied to cliffs produced by differential erosion.',
                              '325'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'esker',
                              'A long, narrow sinuous, steep-sided ridge composed of irregularly stratified sand and gravel that was deposited by a subsurface stream flowing between ice walls, or in an ice tunnel of a retreating glacier, and was left behind when the ice melted.',
                              '330'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'estuary',
                              null,
                              '335'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'exogenous dome',
                              null,
                              '340'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'fan piedmont',
                              null,
                              '345'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'fault scarp',
                              null,
                              '350'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'fault terrace',
                              null,
                              '355'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'fissure',
                              null,
                              '360'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'fissure vent',
                              null,
                              '365'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'flat',
                              'A general term for a level or nearly level surface or small area of land marked by little or no relief, eg. mud flat or valley flat.',
                              '367'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'flood plain',
                              '(bottomland) The nearly level alluvial plain that borders a stream and is subject to inundation under flood-stage conditions unless protected artificially.  It is usually a constructional landform built of sediment deposited during overflow and lateral migration of the stream.',
                              '370'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'fluvial',
                              null,
                              '375'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'foothills',
                              null,
                              '380'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'foredune',
                              null,
                              '385'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'frost creep slope',
                              null,
                              '390'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'frost mound',
                              null,
                              '395'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'frost scar',
                              null,
                              '400'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'gap',
                              null,
                              '405'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'glaciated uplands',
                              null,
                              '410'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'glacier',
                              null,
                              '415'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'gorge',
                              '(a) A narrow, deep valley with nearly vertical rocky walls, enclosed by mountains, smaller than a canyon, and more steep-sided than a ravine; especially a restricted, steep-walled part of a canyon. (b) A narrow defile or passage between hills or mountains.',
                              '420'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'graben',
                              null,
                              '425'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'ground moraine',
                              null,
                              '430'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'gulch',
                              null,
                              '435'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'hanging valley',
                              null,
                              '440'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'headland',
                              null,
                              '445'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'highland',
                              null,
                              '450'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'hills',
                              '(foothills) A natural elevation of the land surface, rising as much as 300 m above the surrounding lowlands, usually of restricted summit area (relative to a tableland) and having a well-defined outline; hill slopes generally exceed 15%.  The distinction between a hill and a mountain is often dependent on local usage.',
                              '455'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'hillslope bedrock outcrop',
                              null,
                              '460'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'hogback',
                              null,
                              '465'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'hoodoo',
                              null,
                              '470'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'hummock',
                              'A rounded or conical mound of knoll, hillock, or other small elevation.  Also, a slight rise of ground above a level surface.',
                              '475'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'inlet',
                              null,
                              '480'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'inselberg',
                              null,
                              '485'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'interdune flat',
                              null,
                              '490'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'interfluve',
                              null,
                              '495'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'island',
                              null,
                              '500'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'kame',
                              'A moundlike hill of ice-contact glacial drift, composed chiefly of stratified sand and gravel.',
                              '505'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'kame moraine',
                              null,
                              '510'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'kame terrace',
                              null,
                              '515'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'karst',
                              null,
                              '520'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'karst tower',
                              null,
                              '525'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'karst window',
                              null,
                              '530'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'kegel karst',
                              null,
                              '535'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'kettle',
                              'A steep-sided bowl-shaped depression without surface drainage. It is in glacial drift deposits and believed to have formed by the melting of a large, detached block of stagnant ice buried in the glacial drift.',
                              '540'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'kettled outwash plain',
                              null,
                              '545'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'knob',
                              '(a) A rounded eminence, as a knoll, hillock, or small hill or mountain; especially a prominent or isolated hill with steep sides, commonly found in the southern United States. (b) A peak or other projection from the top of a hill or mountain. Also a boulder or group of boulders or an area of resistant rocks protruding from the side of a hill or mountain.',
                              '550'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'knoll',
                              null,
                              '555'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'lagoon',
                              null,
                              '560'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'lake',
                              null,
                              '565'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'lake bed',
                              null,
                              '570'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'lake plain',
                              null,
                              '575'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'lake terrace',
                              null,
                              '580'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'lateral moraine',
                              null,
                              '585'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'lateral scarp (undifferentiated)',
                              null,
                              '590'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'lava flow (undifferentiated)',
                              null,
                              '595'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'ledge',
                              null,
                              '600'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'levee',
                              '(floodwall, earth dike) An artificial or natural embankment built along the margin of a watercourse or an arm of the sea, to protect land from inundation or to confine streamflow to its channel.',
                              '605'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'loess deposit (undifferentiated)',
                              null,
                              '610'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'longshore bar',
                              null,
                              '615'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'lowland',
                              null,
                              '620'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'marine terrace (undifferentiated)',
                              null,
                              '625'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'meander belt',
                              null,
                              '630'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'meander scar',
                              null,
                              '635'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'mesa',
                              null,
                              '640'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'mid slope',
                              null,
                              '645'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'mima mound',
                              null,
                              '650'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'monadnock',
                              null,
                              '655'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'moraine (undifferentiated)',
                              'A drift topography characterized by chaotic mounds and pits, generally randomly oriented, developed in superglacial drift by collapse and flow as the underlying stagnant ice melted. Slopes may be steep and unstable and there will be used and unused stream coursed and lake depressions interspersed with the morainic ridges. Consequently, there will be rapid or abrupt changes between materials of differing lithology.',
                              '660'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'mound',
                              null,
                              '665'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'mountain valley',
                              null,
                              '670'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'mountain(s)',
                              '(hill) A natural elevation of the land surface, rising more than 300 m above surrounding lowlands, usually of restricted summit area (relative to a plateau), and generally having steep sides (greater than 25 percent slope) with or without considerable bare-rock surface. A mountain can occur as a single, isolated mass or in a group forming a chain or range. Mountains are primarily formed by deep-seated earth movements and/or volcanic action and secondarily by differential erosion.',
                              '675'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'mountain-valley fan',
                              null,
                              '680'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'mud flat',
                              null,
                              '685'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'noseslope',
                              null,
                              '690'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'outwash fan',
                              null,
                              '695'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'outwash plain',
                              '(glacial outwash, kettles) An extensive lowland area of coarse textured, glaciofluvial material. An outwash plain is commonly smooth; where pitted, due to melt-out of incorporated ice masses, it is generally low in relief.',
                              '700'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'outwash terrace',
                              null,
                              '705'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'oxbow',
                              '(meander belt, oxbow lake) A closely looping stream meander having an extreme curvature such that only a neck of land is left between the two parts of the stream. A term used in New England for the land enclosed, or partly enclosed, within an oxbow.',
                              '710'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'patterned ground (undifferentiated)',
                              null,
                              '715'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'peat dome',
                              null,
                              '720'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'periglacial boulderfield',
                              null,
                              '725'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'piedmont',
                              null,
                              '730'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'pimple mounds',
                              null,
                              '735'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'pingo',
                              'A large frost mound; especially a relatively large conical mound of soil-covered ice (commonly 30 to 50 m high and up to 400 m in diameter) raised in part by hydrostatic pressure within and below the permafrost of Arctic regions, and of more than 1 year’s duration.',
                              '740'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'pinnacle',
                              null,
                              '745'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'plain',
                              '(lowland, plateau) An extensive lowland area that ranges from level to gently sloping or undulating. A plain has few or no prominent hills or valleys, and usually occurs at low elevation with reference to surrounding areas (local relief generally less than 100m, although some, such as the Great Plains of the United States, are as much as 1000 to 1800 m above sea level.) Where dissected, remnants of a plain can form the local uplands.',
                              '750'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'plateau',
                              '(mesa, plain) An extensive upland mass with a relatively flat summit area that is considerably elevated (more than 100m) above adjacent lowlands, and is separated from them on one or more sides by escarpments. A comparatively large part of a plateau surface is near summit level.',
                              '755'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'playa',
                              null,
                              '760'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'polygon (high-centered)',
                              null,
                              '765'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'polygon (low-centered)',
                              null,
                              '770'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'pothole',
                              null,
                              '775'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'raised beach',
                              null,
                              '780'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'raised estuary',
                              null,
                              '785'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'raised mudflat',
                              null,
                              '790'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'raised tidal flat',
                              null,
                              '795'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'ravine',
                              '(gulch, draw) A small stream channel; narrow, steep-sided, and commonly V-shaped in cross section; and larger than a gully.',
                              '800'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'relict coastline',
                              null,
                              '805'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'ridge',
                              'A long, narrow elevation of the land surface, usually sharp rested with steep sides and forming an extended upland between valleys. The term is used in areas of both hill and mountain relief.',
                              '810'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'ridge and valley',
                              null,
                              '815'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'ridgetop bedrock outcrop',
                              null,
                              '820'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'rift valley',
                              null,
                              '825'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'rim',
                              null,
                              '830'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'riverbed',
                              null,
                              '835'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'rock fall avalanche',
                              null,
                              '840'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'saddle',
                              'A low point on a ridge or crestline, generally a divide (pass, col) between the heads of streams flowing in opposite directions.',
                              '845'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'sag pond',
                              null,
                              '850'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'sandhills',
                              null,
                              '855'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'scarp',
                              null,
                              '860'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'scarp slope',
                              null,
                              '865'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'scour',
                              null,
                              '870'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'scoured basin',
                              null,
                              '875'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'sea cliff',
                              null,
                              '880'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'seep',
                              null,
                              '885'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'shoal',
                              null,
                              '890'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'shoreline',
                              null,
                              '895'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'shoulder',
                              '(hill slope) The geomorphic component that form the uppermost inclined surface at the top of a hillslope. It comprises the transition zone from backslope to summit of an upland. The surface is dominantly convex in profile and erosional in origin.',
                              '897'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'sinkhole (undifferentiated)',
                              '(doline) A closed depression formed either by solution of the surficial bedrock (e.g. limestone, gypsum, salt) or by collapse of underlying caves. Complexes of sinkholes in carbonate-rock terraces are the main components of karst topography.',
                              '900'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'slide',
                              null,
                              '905'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'slope',
                              null,
                              '910'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'slough',
                              null,
                              '915'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'slump and topple prone slope',
                              null,
                              '920'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'slump pond',
                              null,
                              '925'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'soil creep slope',
                              null,
                              '930'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'solution sinkhole',
                              null,
                              '935'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'spit',
                              '(a) A small point or low tongue or narrow embankment of land, commonly consisting of sand or gravel deposited by longshore drifting and having one end attached to the mainland and the other terminating in open water, usually the sea; a fingerlike extension of the beach. (b) A relatively long, narrow shoal or reef extending from the shore into a body of water.',
                              '940'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'splay',
                              'A small alluvial fan or other outspread deposit formed where an overloaded stream breaks through a levee and deposits its material (often coarse-grained) on the flood plain.',
                              '945'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'stone circle',
                              null,
                              '950'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'stone stripe',
                              null,
                              '955'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'stream terrace (undifferentiated)',
                              null,
                              '960'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'streambed',
                              null,
                              '965'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'subjacent karst collapse sinkhole',
                              null,
                              '970'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'subsidence sinkhole',
                              null,
                              '975'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'swale',
                              '(a) A slight depression, sometimes swampy, in the midst of generally level land. (b) A shallow depression in an undulating ground moraine due to uneven glacial deposition. (c) A long, narrow, generally shallow, trough-like depression between two beach ridges, and aligned roughly parallel to the coastline.',
                              '980'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'talus',
                              null,
                              '985'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'tarn',
                              null,
                              '990'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'terrace',
                              'A step-like surface, bordering a valley floor or shoreline, that represent the former position of an alluvial plain, or lake or sea shore. The term is usually applied to both the relatively flat summit surface (platform, tread), cut or built by stream or wave action, and the steeper descending slope (scarp, riser), graded to a lower base level of erosion.',
                              '992'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'tidal flat',
                              null,
                              '995'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'tidal gut',
                              null,
                              '1000'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'till plain',
                              null,
                              '1005'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'toe slope',
                              null,
                              '1010'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'toe zone (undifferentiated)',
                              null,
                              '1015'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'transverse dune',
                              null,
                              '1020'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'trench',
                              null,
                              '1025'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'trough',
                              null,
                              '1030'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'valley',
                              '(basin) An elongate, relatively large, externally drained depression of the earth''s surface that is primarily developed by stream erosion.',
                              '1035'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'valley floor',
                              null,
                              '1040'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'wave-built terrace',
                              null,
                              '1045'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'landform',
                              'wave-cut platform',
                              null,
                              '1050'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'surficialDeposits',
        'Surficial Deposits',
        'logical',
        'yes',
        'varchar (90)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'Surficial deposits represent the parent material that are the geologic or organic precursors to the soil.  They may either have been deposited by geologic (wind, ice, gravity or water) or biologic (organic) activity, or formed in place more-or-less directly from rocks and minerals below.',
     
        ' plot  Plot  surficialDeposits  Surficial Deposits  logical    varchar (90)  n/a  n/a  closed  n/a  Surficial deposits represent the parent material that are the geologic or organic precursors to the soil.  They may either have been deposited by geologic (wind, ice, gravity or water) or biologic (organic) activity, or formed in place more-or-less directly from rocks and minerals below.  Aeolian Deposits: Aeolian sand flats and cover sands    Aeolian Deposits: Dunes    Aeolian Deposits: Loess deposits    Aeolian Deposits: Volcanic Ash    Alluvial Deposits: Alluvial Fan    Alluvial Deposits: Deltas    Alluvial Deposits: Floodplain    Chemical Deposits: Evaporites and Precipitates    Glacial Deposits: Bedrock and till    Glacial Deposits: Deltaic deposits    Glacial Deposits: Glaciofluvial    Glacial Deposits: Glaciolacustrine    Glacial Deposits: Glaciomarine    Glacial Deposits: Moraine    Glacial Deposits: Till    Glacial Deposits: Undifferentiated glacial deposit    Lacustrine Deposits: Coarse sediments    Lacustrine Deposits: Fine-grained sediments    Lacustrine Deposits: Unconsolidated Sediments    Marine Deposits: Coarse sediments    Marine Deposits: Fine-grained sediments    Marine Deposits: Unconsolidated Sediments    Organic Deposits: Muck    Organic Deposits: Peat    Other    Residual Material: Bedrock    Residual Material: Deeply Weathered Rock    Residual Material: Disintegrated Rock    Slope and Modified Deposits: Colluvial    Slope and Modified Deposits: Solifluction, landslide    Slope and Modified Deposits: Talus and scree slopes    Variable   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Aeolian Deposits: Aeolian sand flats and cover sands',
                              null,
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Aeolian Deposits: Dunes',
                              null,
                              '20'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Aeolian Deposits: Loess deposits',
                              null,
                              '30'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Aeolian Deposits: Volcanic Ash',
                              null,
                              '40'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Alluvial Deposits: Alluvial Fan',
                              null,
                              '50'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Alluvial Deposits: Deltas',
                              null,
                              '60'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Alluvial Deposits: Floodplain',
                              null,
                              '70'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Chemical Deposits: Evaporites and Precipitates',
                              null,
                              '80'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Glacial Deposits: Bedrock and till',
                              null,
                              '90'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Glacial Deposits: Deltaic deposits',
                              null,
                              '100'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Glacial Deposits: Glaciofluvial',
                              null,
                              '110'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Glacial Deposits: Glaciolacustrine',
                              null,
                              '120'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Glacial Deposits: Glaciomarine',
                              null,
                              '130'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Glacial Deposits: Moraine',
                              null,
                              '140'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Glacial Deposits: Till',
                              null,
                              '150'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Glacial Deposits: Undifferentiated glacial deposit',
                              null,
                              '160'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Lacustrine Deposits: Coarse sediments',
                              null,
                              '170'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Lacustrine Deposits: Fine-grained sediments',
                              null,
                              '180'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Lacustrine Deposits: Unconsolidated Sediments',
                              null,
                              '190'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Marine Deposits: Coarse sediments',
                              null,
                              '200'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Marine Deposits: Fine-grained sediments',
                              null,
                              '210'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Marine Deposits: Unconsolidated Sediments',
                              null,
                              '220'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Organic Deposits: Muck',
                              null,
                              '230'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Organic Deposits: Peat',
                              null,
                              '240'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Residual Material: Bedrock',
                              null,
                              '260'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Residual Material: Deeply Weathered Rock',
                              null,
                              '270'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Residual Material: Disintegrated Rock',
                              null,
                              '280'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Slope and Modified Deposits: Colluvial',
                              null,
                              '290'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Slope and Modified Deposits: Solifluction, landslide',
                              null,
                              '300'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Slope and Modified Deposits: Talus and scree slopes',
                              null,
                              '310'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Variable',
                              null,
                              '320'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'surficialDeposits',
                              'Other',
                              null,
                              '330'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'rockType',
        'Rock Type',
        'logical',
        'yes',
        'varchar (90)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'RockType values conform to the lithic types in the FGDC Soil Geographic Data Standards, September 1997. http://www.fgdc.gov/standards/documents/standards/soils/soil997.PDF (pages 56-59).',
     
        ' plot  Plot  rockType  Rock Type  logical    varchar (90)  n/a  n/a  closed  n/a  RockType values conform to the lithic types in the FGDC Soil Geographic Data Standards, September 1997. http://www.fgdc.gov/standards/documents/standards/soils/soil997.PDF (pages 56-59).  aa    acidic-ash    andesite    andesitic-ash    arkose    basalt    basaltic-ash    basic-ash    chalk    charcoal    chert    cinders    coal    conglomerate, calcareous    conglomerate, noncalcareous    conglomerate, unspecified    diorite    dolostone    ejecta-ash    gabbro    glauconite    gneiss    gneiss-acidic    gneiss-basic    granite    graywacke    gypsum    hornfels    igneous, acid    igneous, basic    igneous, coarse crystal    igneous, fine crystal    igneous, intermediate    igneous, ultrabasic    igneous, unspecified    interbedded sedimentary    limestone, arenaceous    limestone, argillaceous    limestone, cherty    limestone, phosphatic    limestone, unspecified    limestone-sandstone    limestone-sandstone-shale    limestone-shale    limestone-siltstone    marble    marl    metaconglomerate    metamorphic, unspecified    mixed    mixed calcareous    mixed igneous-metamorphic    mixed igneous-metamorphic-sedimentary    mixed igneous-sedimentary    mixed metamorphic-sedimentary    mixed noncalcareous    obsidian    pahoehoe    phyllite    pumice    pyroclastic, unspecified    quartzite    rhyolite    sandstone, calcareous    sandstone, noncalcareous    sandstone, unspecified    sandstone-shale    sandstone-siltstone    schist, acidic    schist, basic    schist, unspecified    scoria    sedimentary, unspecified    serpentinite    shale, acid    shale, calcareous    shale, clayey    shale, noncalcareous    shale, unspecified    shale-siltstone    siltstone, calcareous    siltstone, noncalcareous    siltstone, unspecified    slate    tuff breccia    tuff, acidic    tuff, basic    tuff, unspecified    volcanic bombs    volcanic breccia, acidic    volcanic breccia, basic    volcanic breccia, unspecified    wood    other    no rock visible    no observation   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'aa',
                              null,
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'acidic-ash',
                              null,
                              '20'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'andesite',
                              null,
                              '30'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'andesitic-ash',
                              null,
                              '40'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'arkose',
                              null,
                              '50'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'basalt',
                              null,
                              '60'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'basaltic-ash',
                              null,
                              '70'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'basic-ash',
                              null,
                              '80'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'chalk',
                              null,
                              '90'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'charcoal',
                              null,
                              '100'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'chert',
                              null,
                              '110'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'cinders',
                              null,
                              '120'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'coal',
                              null,
                              '130'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'conglomerate, calcareous',
                              null,
                              '140'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'conglomerate, noncalcareous',
                              null,
                              '150'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'conglomerate, unspecified',
                              null,
                              '160'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'diorite',
                              null,
                              '170'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'dolostone',
                              null,
                              '180'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'ejecta-ash',
                              null,
                              '190'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'gabbro',
                              null,
                              '200'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'glauconite',
                              null,
                              '210'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'gneiss',
                              null,
                              '220'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'gneiss-acidic',
                              null,
                              '230'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'gneiss-basic',
                              null,
                              '240'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'granite',
                              null,
                              '250'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'graywacke',
                              null,
                              '260'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'gypsum',
                              null,
                              '270'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'hornfels',
                              null,
                              '280'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'igneous, acid',
                              null,
                              '290'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'igneous, basic',
                              null,
                              '300'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'igneous, coarse crystal',
                              null,
                              '310'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'igneous, fine crystal',
                              null,
                              '320'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'igneous, intermediate',
                              null,
                              '330'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'igneous, ultrabasic',
                              null,
                              '340'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'igneous, unspecified',
                              null,
                              '350'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'interbedded sedimentary',
                              null,
                              '360'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'limestone, arenaceous',
                              null,
                              '370'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'limestone, argillaceous',
                              null,
                              '380'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'limestone, cherty',
                              null,
                              '390'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'limestone, phosphatic',
                              null,
                              '400'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'limestone, unspecified',
                              null,
                              '410'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'limestone-sandstone',
                              null,
                              '420'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'limestone-sandstone-shale',
                              null,
                              '430'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'limestone-shale',
                              null,
                              '440'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'limestone-siltstone',
                              null,
                              '450'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'marble',
                              null,
                              '460'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'marl',
                              null,
                              '470'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'metaconglomerate',
                              null,
                              '480'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'metamorphic, unspecified',
                              null,
                              '490'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'mixed',
                              null,
                              '500'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'mixed calcareous',
                              null,
                              '510'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'mixed igneous-metamorphic',
                              null,
                              '520'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'mixed igneous-metamorphic-sedimentary',
                              null,
                              '530'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'mixed igneous-sedimentary',
                              null,
                              '540'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'mixed metamorphic-sedimentary',
                              null,
                              '550'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'mixed noncalcareous',
                              null,
                              '560'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'obsidian',
                              null,
                              '570'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'pahoehoe',
                              null,
                              '580'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'phyllite',
                              null,
                              '590'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'pumice',
                              null,
                              '600'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'pyroclastic, unspecified',
                              null,
                              '610'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'quartzite',
                              null,
                              '620'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'rhyolite',
                              null,
                              '630'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'sandstone, calcareous',
                              null,
                              '640'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'sandstone, noncalcareous',
                              null,
                              '650'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'sandstone, unspecified',
                              null,
                              '660'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'sandstone-shale',
                              null,
                              '670'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'sandstone-siltstone',
                              null,
                              '680'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'schist, acidic',
                              null,
                              '690'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'schist, basic',
                              null,
                              '700'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'schist, unspecified',
                              null,
                              '710'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'scoria',
                              null,
                              '720'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'sedimentary, unspecified',
                              null,
                              '730'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'serpentinite',
                              null,
                              '740'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'shale, acid',
                              null,
                              '750'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'shale, calcareous',
                              null,
                              '760'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'shale, clayey',
                              null,
                              '770'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'shale, noncalcareous',
                              null,
                              '780'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'shale, unspecified',
                              null,
                              '790'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'shale-siltstone',
                              null,
                              '800'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'siltstone, calcareous',
                              null,
                              '810'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'siltstone, noncalcareous',
                              null,
                              '820'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'siltstone, unspecified',
                              null,
                              '830'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'slate',
                              null,
                              '840'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'tuff breccia',
                              null,
                              '850'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'tuff, acidic',
                              null,
                              '860'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'tuff, basic',
                              null,
                              '870'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'tuff, unspecified',
                              null,
                              '880'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'volcanic bombs',
                              null,
                              '890'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'volcanic breccia, acidic',
                              null,
                              '900'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'volcanic breccia, basic',
                              null,
                              '910'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'volcanic breccia, unspecified',
                              null,
                              '920'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'wood',
                              null,
                              '930'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'other',
                              null,
                              '1000'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'no rock visible',
                              null,
                              '1010'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'plot',
                              'rockType',
                              'no observation',
                              null,
                              '1020'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'stateProvince',
        'State or Province',
        'logical',
        'yes',
        'varchar (55)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'State or Province Name (full name) where the plot is located (US and Canada only).',
     
        ' plot  Plot  stateProvince  State or Province  logical    varchar (55)  n/a  n/a  no  n/a  State or Province Name (full name) where the plot is located (US and Canada only). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'country',
        'Country',
        'logical',
        'yes',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Country where the plot is located.',
     
        ' plot  Plot  country  Country  logical    varchar (100)  n/a  n/a  no  n/a  Country where the plot is located. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'dateentered',
        'Date Entered',
        'implementation',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Date this plot was entered into VegBank',
     
        ' plot  Plot  dateentered  Date Entered  implementation    Date  n/a  n/a  no  n/a  Date this plot was entered into VegBank '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'submitter_surname',
        'Submitter_surname',
        'implementation',
        'yes',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        null,
     
        ' plot  Plot  submitter_surname  Submitter_surname  implementation    varchar (100)  n/a  n/a  no  n/a   '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'submitter_givenname',
        'Submitter_givenname',
        'implementation',
        'yes',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        null,
     
        ' plot  Plot  submitter_givenname  Submitter_givenname  implementation    varchar (100)  n/a  n/a  no  n/a   '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'submitter_email',
        'Submitter_email',
        'implementation',
        'yes',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        null,
     
        ' plot  Plot  submitter_email  Submitter_email  implementation    varchar (100)  n/a  n/a  no  n/a   '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' plot  Plot  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'notesPublic',
        'Notes Public',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'TRUE indicates that public notes pertaining to this plot exist in "vegPlot.note"',
     
        ' plot  Plot  notesPublic  Notes Public  logical    Boolean  n/a  n/a  no  n/a  TRUE indicates that public notes pertaining to this plot exist in "vegPlot.note" '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'notesMgt',
        'Notes Mgt',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'TRUE indicates that nonpublic management notes pertaining to this plot exist in "vegPlot.note"',
     
        ' plot  Plot  notesMgt  Notes Mgt  logical    Boolean  n/a  n/a  no  n/a  TRUE indicates that nonpublic management notes pertaining to this plot exist in "vegPlot.note" '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'revisions',
        'Revisions',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'TRUE indicates that revisions exist in vegPlot.Revision',
     
        ' plot  Plot  revisions  Revisions  logical    Boolean  n/a  n/a  no  n/a  TRUE indicates that revisions exist in vegPlot.Revision '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'plot',
        'emb_plot',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' plot  Plot  emb_plot  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'project',
        'Project',
        'This table stores information about a project established to collect vegetation plot data.',
        'Each plot originates as part of a project. A project can contain from one to many plots.',
        ' project  Project  This table stores information about a project established to collect vegetation plot data.  Each plot originates as part of a project. A project can contain from one to many plots.  PROJECT_ID  ID  projectName  Project Name  projectDescription  Project Description  startDate  Start Date  stopDate  Stop Date  accessionCode  Accession Code  d_obscount  Plot Count  d_lastplotaddeddate  date last plot added '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'project',
        'PROJECT_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the project table.',
        'Database generated identifier assigned to each unique project.',
     
        ' project  Project  PROJECT_ID  ID  logical    serial  PK  n/a  no  Primary key for the project table.  Database generated identifier assigned to each unique project. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'project',
        'projectName',
        'Project Name',
        'logical',
        'no',
        'varchar (150)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Project name as defined by the principal investigator.',
     
        ' project  Project  projectName  Project Name  logical  required  varchar (150)  n/a  n/a  no  n/a  Project name as defined by the principal investigator. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'project',
        'projectDescription',
        'Project Description',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Short description of the project including the original purpose for conducting the project. This can be viewed as the project abstract plus supporting metadata.',
     
        ' project  Project  projectDescription  Project Description  logical    text  n/a  n/a  no  n/a  Short description of the project including the original purpose for conducting the project. This can be viewed as the project abstract plus supporting metadata. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'project',
        'startDate',
        'Start Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Project start date.',
     
        ' project  Project  startDate  Start Date  logical    Date  n/a  n/a  no  n/a  Project start date. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'project',
        'stopDate',
        'Stop Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Project stop date.',
     
        ' project  Project  stopDate  Stop Date  logical    Date  n/a  n/a  no  n/a  Project stop date. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'project',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' project  Project  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'project',
        'd_obscount',
        'Plot Count',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Number of observations associated with this entity.',
     
        ' project  Project  d_obscount  Plot Count  denorm    Integer  n/a  n/a  no  n/a  Number of observations associated with this entity. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'project',
        'd_lastplotaddeddate',
        'date last plot added',
        'denorm',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Date a plot was last added to this project.',
     
        ' project  Project  d_lastplotaddeddate  date last plot added  denorm    Date  n/a  n/a  no  n/a  Date a plot was last added to this project. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'projectContributor',
        'Project Contributor',
        'This table stores information about a party contributing to a project.',
        'This table serves as an intersection entity used to ''link'' a party with a specific project wherein vegetation plots are described.',
        ' projectContributor  Project Contributor  This table stores information about a party contributing to a project.  This table serves as an intersection entity used to ''link'' a party with a specific project wherein vegetation plots are described.  PROJECTCONTRIBUTOR_ID  ID  PROJECT_ID  Project  PARTY_ID  Party  ROLE_ID  Role  surname  Surname  cheatRole  Role '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'projectContributor',
        'PROJECTCONTRIBUTOR_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the projectContributor table.',
        'Database generated identifier assigned to each unique contribution to a project.',
     
        ' projectContributor  Project Contributor  PROJECTCONTRIBUTOR_ID  ID  logical    serial  PK  n/a  no  Primary key for the projectContributor table.  Database generated identifier assigned to each unique contribution to a project. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'projectContributor',
        'PROJECT_ID',
        'Project',
        'logical',
        'no',
        'Integer',
        'FK',
        'project.PROJECT_ID',
        'no',
        'Foreign key into the project table',
        'Foreign key linking the contribution to a specific project.',
     
        ' projectContributor  Project Contributor  PROJECT_ID  Project  logical  required  Integer  FK  project.PROJECT_ID  no  Foreign key into the project table  Foreign key linking the contribution to a specific project. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'projectContributor',
        'PARTY_ID',
        'Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'Foreign key into the party table',
        'Foreign key linking the contribution to a specific party.',
     
        ' projectContributor  Project Contributor  PARTY_ID  Party  logical  required  Integer  FK  party.PARTY_ID  no  Foreign key into the party table  Foreign key linking the contribution to a specific party. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'projectContributor',
        'ROLE_ID',
        'Role',
        'logical',
        'yes',
        'Integer',
        'FK',
        'aux_Role.ROLE_ID',
        'no',
        'Foreign key into aux_Role table',
        'Foreign key that identifies the role that a specific party played in the project (e.g.,  PI, coPI, contact, author, research advisor, etc.).',
     
        ' projectContributor  Project Contributor  ROLE_ID  Role  logical    Integer  FK  aux_Role.ROLE_ID  no  Foreign key into aux_Role table  Foreign key that identifies the role that a specific party played in the project (e.g.,  PI, coPI, contact, author, research advisor, etc.). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'projectContributor',
        'surname',
        'Surname',
        'implementation',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' projectContributor  Project Contributor  surname  Surname  implementation    varchar (50)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'projectContributor',
        'cheatRole',
        'Role',
        'implementation',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' projectContributor  Project Contributor  cheatRole  Role  implementation    varchar (50)  n/a  n/a  no     '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'revision',
        'Revision',
        'This table constitutes a log of  changes in data deposited in the database.',
        'This table was designed to store as a single, stand-alone table information about attributes in any of the database tables.',
        ' revision  Revision  This table constitutes a log of  changes in data deposited in the database.  This table was designed to store as a single, stand-alone table information about attributes in any of the database tables.  REVISION_ID  ID  tableName  Table Name  tableAttribute  Table Attribute  tableRecord  Table Record  revisionDate  Revision Date  previousValueText  Previous Value Text  previousValueType  Previous Value Type  previousRevision_ID  Previous Revision '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'revision',
        'REVISION_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the revision table',
        'Database generated identifier assigned to each unique revision.',
     
        ' revision  Revision  REVISION_ID  ID  logical    serial  PK  n/a  no  Primary key for the revision table  Database generated identifier assigned to each unique revision. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'revision',
        'tableName',
        'Table Name',
        'logical',
        'no',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the table where the change occurred.',
     
        ' revision  Revision  tableName  Table Name  logical  required  varchar (50)  n/a  n/a  no  n/a  Name of the table where the change occurred. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'revision',
        'tableAttribute',
        'Table Attribute',
        'logical',
        'no',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The name of the attribute where the chance occurred.',
     
        ' revision  Revision  tableAttribute  Table Attribute  logical  required  varchar (50)  n/a  n/a  no  n/a  The name of the attribute where the chance occurred. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'revision',
        'tableRecord',
        'Table Record',
        'logical',
        'no',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The number of the record in which the change occurred (i.e., the value of the primary key associated with the value in which the change occurred)',
     
        ' revision  Revision  tableRecord  Table Record  logical  required  Integer  n/a  n/a  no  n/a  The number of the record in which the change occurred (i.e., the value of the primary key associated with the value in which the change occurred) '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'revision',
        'revisionDate',
        'Revision Date',
        'logical',
        'no',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The date on which the revision was made.',
     
        ' revision  Revision  revisionDate  Revision Date  logical  required  Date  n/a  n/a  no  n/a  The date on which the revision was made. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'revision',
        'previousValueText',
        'Previous Value Text',
        'logical',
        'no',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The previous value as a character string.',
     
        ' revision  Revision  previousValueText  Previous Value Text  logical  required  text  n/a  n/a  no  n/a  The previous value as a character string. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'revision',
        'previousValueType',
        'Previous Value Type',
        'logical',
        'no',
        'varchar (20)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The data type of the attribute changed.',
     
        ' revision  Revision  previousValueType  Previous Value Type  logical  required  varchar (20)  n/a  n/a  no  n/a  The data type of the attribute changed. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'revision',
        'previousRevision_ID',
        'Previous Revision',
        'logical',
        'yes',
        'Integer',
        'FK',
        'revision.REVISION_ID',
        'no',
        'Recursive foreign key',
        'Pointer to a previous record of a revision.',
     
        ' revision  Revision  previousRevision_ID  Previous Revision  logical    Integer  FK  revision.REVISION_ID  no  Recursive foreign key  Pointer to a previous record of a revision. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'soilObs',
        'Soil Observation',
        'This table stores observation on soil horizons made during the plot observation event.',
        'soilObs is child of observation in recognition of the fact that the horizons observed vary among plot observation events as a results of real change plus changes in investigators, methods and circumstances.',
        ' soilObs  Soil Observation  This table stores observation on soil horizons made during the plot observation event.  soilObs is child of observation in recognition of the fact that the horizons observed vary among plot observation events as a results of real change plus changes in investigators, methods and circumstances.  SOILOBS_ID  ID  OBSERVATION_ID  Observation  soilHorizon  Soil Horizon  soilDepthTop  Soil Depth Top  soilDepthBottom  Soil Depth Bottom  soilColor  Soil Color  soilOrganic  Soil Organic  soilTexture  Soil Texture  soilSand  Soil Sand  soilSilt  Soil Silt  soilClay  Soil Clay  soilCoarse  Soil Coarse  soilPH  Soil PH  exchangeCapacity  Exchange Capacity  baseSaturation  Base Saturation  soilDescription  Soil Description  emb_soilObs  this row embargoed. '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'SOILOBS_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for observation',
        'Database generated identifier assigned to each unique soil observation.',
     
        ' soilObs  Soil Observation  SOILOBS_ID  ID  logical    serial  PK  n/a  no  Primary key for observation  Database generated identifier assigned to each unique soil observation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'OBSERVATION_ID',
        'Observation',
        'logical',
        'no',
        'Integer',
        'FK',
        'observation.OBSERVATION_ID',
        'no',
        'Foreign key to parent plot',
        'Link to the observation event to which this soil observation is associated.',
     
        ' soilObs  Soil Observation  OBSERVATION_ID  Observation  logical  required  Integer  FK  observation.OBSERVATION_ID  no  Foreign key to parent plot  Link to the observation event to which this soil observation is associated. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilHorizon',
        'Soil Horizon',
        'logical',
        'no',
        'varchar (15)',
        'n/a',
        'n/a',
        'closed',
        'closed list - USDA',
        'The horizon to which this observation applies.',
     
        ' soilObs  Soil Observation  soilHorizon  Soil Horizon  logical  required  varchar (15)  n/a  n/a  closed  closed list - USDA  The horizon to which this observation applies.  A    B    C    E    L    O    R    unknown   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilHorizon',
                              'L',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilHorizon',
                              'O',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilHorizon',
                              'A',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilHorizon',
                              'E',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilHorizon',
                              'B',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilHorizon',
                              'C',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilHorizon',
                              'R',
                              null,
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilHorizon',
                              'unknown',
                              null,
                              '8'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilDepthTop',
        'Soil Depth Top',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The depth at which the horizon observation starts.',
     
        ' soilObs  Soil Observation  soilDepthTop  Soil Depth Top  logical    Float  n/a  n/a  no  n/a  The depth at which the horizon observation starts. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilDepthBottom',
        'Soil Depth Bottom',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The depth at which the horizon observation ends.',
     
        ' soilObs  Soil Observation  soilDepthBottom  Soil Depth Bottom  logical    Float  n/a  n/a  no  n/a  The depth at which the horizon observation ends. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilColor',
        'Soil Color',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Soil color (USDA guidelines recommended).',
     
        ' soilObs  Soil Observation  soilColor  Soil Color  logical    varchar (30)  n/a  n/a  no  n/a  Soil color (USDA guidelines recommended). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilOrganic',
        'Soil Organic',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent organic content of the soil (for methods see observation.methodsNarrative).',
     
        ' soilObs  Soil Observation  soilOrganic  Soil Organic  logical    Float  n/a  n/a  no  n/a  Percent organic content of the soil (for methods see observation.methodsNarrative). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilTexture',
        'Soil Texture',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'closed list - USDA',
        'Soil texture class.The texture classes sands, loamy sands, and sandy loams (plural terms) correspond to sand, loamy sand, and sandy loam (singular terms) in the textural triangle.',
     
        ' soilObs  Soil Observation  soilTexture  Soil Texture  logical    varchar (50)  n/a  n/a  closed  closed list - USDA  Soil texture class.The texture classes sands, loamy sands, and sandy loams (plural terms) correspond to sand, loamy sand, and sandy loam (singular terms) in the textural triangle.  Sands: Coarse Sand  Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Sands | Texture Subclass: Coarse Sand  Sands: Sand  Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Sands | Texture Subclass: Sand  Sands: Fine Sand  Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Sands | Texture Subclass: Fine Sand  Sands: Very Fine Sand  Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Sands | Texture Subclass: Very Fine Sand  Sands: (unspecified)  Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Sands | Texture Subclass: (unspecified)  Loamy Sands: Loamy Coarse Sand  Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Loamy Sands | Texture Subclass: Loamy Coarse Sand  Loamy Sands: Loamy Sand  Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Loamy Sands | Texture Subclass: Loamy Sand  Loamy Sands: Loamy Fine Sand  Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Loamy Sands | Texture Subclass: Loamy Fine Sand  Loamy Sands: Loamy Very Fine Sand  Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Loamy Sands | Texture Subclass: Loamy Very Fine Sand  Loamy Sands: (unspecified)  Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Loamy Sands | Texture Subclass: (unspecified)  Sandy Loams: Coarse Sandy Loam  Texture Group: Loamy soils | General Term: Moderately coarse-textured | Texture Class: Sandy Loams | Texture Subclass: Coarse Sandy Loam  Sandy Loams: Sandy Loam  Texture Group: Loamy soils | General Term: Moderately coarse-textured | Texture Class: Sandy Loams | Texture Subclass: Sandy Loam  Sandy Loams: Fine Sandy Loam  Texture Group: Loamy soils | General Term: Moderately coarse-textured | Texture Class: Sandy Loams | Texture Subclass: Fine Sandy Loam  Sandy Loams: Very Fine Sandy Loam  Texture Group: Loamy soils | General Term: Medium-textured | Texture Class: Sandy Loams | Texture Subclass: Very Fine Sandy Loam  Sandy Loams: (unspecified)  Texture Group: Loamy soils | General Term: Moderately coarse-textured to Medium-textured | Texture Class: Sandy Loams | Texture Subclass: (unspecified)  Loam  Texture Group: Loamy soils | General Term: Medium-textured | Texture Class: Loam | Texture Subclass: Loam  Silt Loam  Texture Group: Loamy soils | General Term: Medium-textured | Texture Class: Silt Loam | Texture Subclass: Silt Loam  Silt  Texture Group: Loamy soils | General Term: Medium-textured | Texture Class: Silt | Texture Subclass: Silt  Sandy Clay Loam  Texture Group: Loamy soils | General Term: Moderately fine-textured | Texture Class: Sandy Clay Loam | Texture Subclass: Sandy Clay Loam  Clay Loam  Texture Group: Loamy soils | General Term: Moderately fine-textured | Texture Class: Clay Loam | Texture Subclass: Clay Loam  Silty Clay Loam  Texture Group: Loamy soils | General Term: Moderately fine-textured | Texture Class: Silty Clay Loam | Texture Subclass: Silty Clay Loam  Sandy Clay  Texture Group: Clayey soils | General Term: Fine-textured | Texture Class: Sandy Clay | Texture Subclass: Sandy Clay  Silty Clay  Texture Group: Clayey soils | General Term: Fine-textured | Texture Class: Silty Clay | Texture Subclass: Silty Clay  Clay  Texture Group: Clayey soils | General Term: Fine-textured | Texture Class: Clay | Texture Subclass: Clay '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sands: Coarse Sand',
                              'Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Sands | Texture Subclass: Coarse Sand',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sands: Sand',
                              'Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Sands | Texture Subclass: Sand',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sands: Fine Sand',
                              'Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Sands | Texture Subclass: Fine Sand',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sands: Very Fine Sand',
                              'Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Sands | Texture Subclass: Very Fine Sand',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sands: (unspecified)',
                              'Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Sands | Texture Subclass: (unspecified)',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Loamy Sands: Loamy Coarse Sand',
                              'Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Loamy Sands | Texture Subclass: Loamy Coarse Sand',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Loamy Sands: Loamy Sand',
                              'Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Loamy Sands | Texture Subclass: Loamy Sand',
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Loamy Sands: Loamy Fine Sand',
                              'Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Loamy Sands | Texture Subclass: Loamy Fine Sand',
                              '8'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Loamy Sands: Loamy Very Fine Sand',
                              'Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Loamy Sands | Texture Subclass: Loamy Very Fine Sand',
                              '9'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Loamy Sands: (unspecified)',
                              'Texture Group: Sandy soils | General Term: Coarse-textured | Texture Class: Loamy Sands | Texture Subclass: (unspecified)',
                              '10'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sandy Loams: Coarse Sandy Loam',
                              'Texture Group: Loamy soils | General Term: Moderately coarse-textured | Texture Class: Sandy Loams | Texture Subclass: Coarse Sandy Loam',
                              '11'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sandy Loams: Sandy Loam',
                              'Texture Group: Loamy soils | General Term: Moderately coarse-textured | Texture Class: Sandy Loams | Texture Subclass: Sandy Loam',
                              '12'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sandy Loams: Fine Sandy Loam',
                              'Texture Group: Loamy soils | General Term: Moderately coarse-textured | Texture Class: Sandy Loams | Texture Subclass: Fine Sandy Loam',
                              '13'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sandy Loams: Very Fine Sandy Loam',
                              'Texture Group: Loamy soils | General Term: Medium-textured | Texture Class: Sandy Loams | Texture Subclass: Very Fine Sandy Loam',
                              '14'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sandy Loams: (unspecified)',
                              'Texture Group: Loamy soils | General Term: Moderately coarse-textured to Medium-textured | Texture Class: Sandy Loams | Texture Subclass: (unspecified)',
                              '15'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Loam',
                              'Texture Group: Loamy soils | General Term: Medium-textured | Texture Class: Loam | Texture Subclass: Loam',
                              '16'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Silt Loam',
                              'Texture Group: Loamy soils | General Term: Medium-textured | Texture Class: Silt Loam | Texture Subclass: Silt Loam',
                              '17'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Silt',
                              'Texture Group: Loamy soils | General Term: Medium-textured | Texture Class: Silt | Texture Subclass: Silt',
                              '18'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sandy Clay Loam',
                              'Texture Group: Loamy soils | General Term: Moderately fine-textured | Texture Class: Sandy Clay Loam | Texture Subclass: Sandy Clay Loam',
                              '19'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Clay Loam',
                              'Texture Group: Loamy soils | General Term: Moderately fine-textured | Texture Class: Clay Loam | Texture Subclass: Clay Loam',
                              '20'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Silty Clay Loam',
                              'Texture Group: Loamy soils | General Term: Moderately fine-textured | Texture Class: Silty Clay Loam | Texture Subclass: Silty Clay Loam',
                              '21'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Sandy Clay',
                              'Texture Group: Clayey soils | General Term: Fine-textured | Texture Class: Sandy Clay | Texture Subclass: Sandy Clay',
                              '22'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Silty Clay',
                              'Texture Group: Clayey soils | General Term: Fine-textured | Texture Class: Silty Clay | Texture Subclass: Silty Clay',
                              '23'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'soilObs',
                              'soilTexture',
                              'Clay',
                              'Texture Group: Clayey soils | General Term: Fine-textured | Texture Class: Clay | Texture Subclass: Clay',
                              '24'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilSand',
        'Soil Sand',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent sand in the soil horizon.',
     
        ' soilObs  Soil Observation  soilSand  Soil Sand  logical    Float  n/a  n/a  no  n/a  Percent sand in the soil horizon. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilSilt',
        'Soil Silt',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent silt in the soil horizon.',
     
        ' soilObs  Soil Observation  soilSilt  Soil Silt  logical    Float  n/a  n/a  no  n/a  Percent silt in the soil horizon. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilClay',
        'Soil Clay',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent clay in the soil horizon.',
     
        ' soilObs  Soil Observation  soilClay  Soil Clay  logical    Float  n/a  n/a  no  n/a  Percent clay in the soil horizon. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilCoarse',
        'Soil Coarse',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'percent coarse fragments in the soil, prior to removal for textural analysis',
     
        ' soilObs  Soil Observation  soilCoarse  Soil Coarse  logical    Float  n/a  n/a  no  n/a  percent coarse fragments in the soil, prior to removal for textural analysis '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilPH',
        'Soil PH',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'pH of the soil (for methods see observation.methodsNarrative).',
     
        ' soilObs  Soil Observation  soilPH  Soil PH  logical    Float  n/a  n/a  no  n/a  pH of the soil (for methods see observation.methodsNarrative). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'exchangeCapacity',
        'Exchange Capacity',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Cation exchange capacity (for methods see observation.methodsNarrative).',
     
        ' soilObs  Soil Observation  exchangeCapacity  Exchange Capacity  logical    Float  n/a  n/a  no  n/a  Cation exchange capacity (for methods see observation.methodsNarrative). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'baseSaturation',
        'Base Saturation',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Percent base saturation (for methods see observation.methodsNarrative).',
     
        ' soilObs  Soil Observation  baseSaturation  Base Saturation  logical    Float  n/a  n/a  no  n/a  Percent base saturation (for methods see observation.methodsNarrative). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'soilDescription',
        'Soil Description',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Text description of the soil.',
     
        ' soilObs  Soil Observation  soilDescription  Soil Description  logical    text  n/a  n/a  no  n/a  Text description of the soil. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilObs',
        'emb_soilObs',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' soilObs  Soil Observation  emb_soilObs  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'soilTaxon',
        'Soil Taxon',
        'This table stores the valid soilTaxon records that may be used to describe the soil of a plot.',
        null,
        ' soilTaxon  Soil Taxon  This table stores the valid soilTaxon records that may be used to describe the soil of a plot.    SOILTAXON_ID  ID  soilCode  Soil Code  soilName  Soil Name  soilLevel  Soil Level  SOILPARENT_ID  Soil Parent  soilFramework  Soil Framework  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilTaxon',
        'SOILTAXON_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the aux_Soil table.',
        'Database assigned value for a unique soil type',
     
        ' soilTaxon  Soil Taxon  SOILTAXON_ID  ID  logical    serial  PK  n/a  no  Primary key for the aux_Soil table.  Database assigned value for a unique soil type '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilTaxon',
        'soilCode',
        'Soil Code',
        'logical',
        'yes',
        'varchar (15)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'SCS Code',
     
        ' soilTaxon  Soil Taxon  soilCode  Soil Code  logical    varchar (15)  n/a  n/a  no  n/a  SCS Code '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilTaxon',
        'soilName',
        'Soil Name',
        'logical',
        'yes',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of soil type',
     
        ' soilTaxon  Soil Taxon  soilName  Soil Name  logical    varchar (100)  n/a  n/a  no  n/a  Name of soil type '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilTaxon',
        'soilLevel',
        'Soil Level',
        'logical',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Hierarchical level; 1=Order, 2=Suborder, 3=GreatGroup, 4=SubGroup, 5=Family, 6=Series',
     
        ' soilTaxon  Soil Taxon  soilLevel  Soil Level  logical    Integer  n/a  n/a  no  n/a  Hierarchical level; 1=Order, 2=Suborder, 3=GreatGroup, 4=SubGroup, 5=Family, 6=Series '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilTaxon',
        'SOILPARENT_ID',
        'Soil Parent',
        'logical',
        'yes',
        'Integer',
        'FK',
        'soilTaxon.SOILTAXON_ID',
        'no',
        'n/a',
        'Parent soil taxon in the soil taxon hierarchy for this particular framwork.  For example, in USDA soils list, the parent of a soil SubGroup would be the GreatGroup.',
     
        ' soilTaxon  Soil Taxon  SOILPARENT_ID  Soil Parent  logical    Integer  FK  soilTaxon.SOILTAXON_ID  no  n/a  Parent soil taxon in the soil taxon hierarchy for this particular framwork.  For example, in USDA soils list, the parent of a soil SubGroup would be the GreatGroup. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilTaxon',
        'soilFramework',
        'Soil Framework',
        'logical',
        'yes',
        'varchar (33)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'System in which this soil taxon is part.  This field may be used to separate multiple soil taxonomic systems.  Each unique soil taxonomic system should have all its soilTaxon records with the same soilFramework value.  Correlation of different framework taxa is not currently possible.',
     
        ' soilTaxon  Soil Taxon  soilFramework  Soil Framework  logical    varchar (33)  n/a  n/a  no  n/a  System in which this soil taxon is part.  This field may be used to separate multiple soil taxonomic systems.  Each unique soil taxonomic system should have all its soilTaxon records with the same soilFramework value.  Correlation of different framework taxa is not currently possible. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'soilTaxon',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' soilTaxon  Soil Taxon  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'stemCount',
        'Stem Count',
        'This table is intended to store information about the abundance of tree stems of a specific size.',
        null,
        ' stemCount  Stem Count  This table is intended to store information about the abundance of tree stems of a specific size.    STEMCOUNT_ID  ID  TAXONIMPORTANCE_ID  Taxon Importance  stemDiameter  DBH  stemDiameterAccuracy  DBH err  stemHeight  Ht.  stemHeightAccuracy  Ht. Err  stemCount  #  stemTaxonArea  Stem Taxon Area  emb_stemCount  this row embargoed. '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemCount',
        'STEMCOUNT_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary Key for the stemSize table.',
        'Database generated identifier assigned to each unique stem tally.',
     
        ' stemCount  Stem Count  STEMCOUNT_ID  ID  logical    serial  PK  n/a  no  Primary Key for the stemSize table.  Database generated identifier assigned to each unique stem tally. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemCount',
        'TAXONIMPORTANCE_ID',
        'Taxon Importance',
        'logical',
        'no',
        'Integer',
        'FK',
        'taxonImportance.taxonImportance_ID',
        'no',
        'Foreign key into the taxonImportance table',
        'Foreign key into the taxonImportance table, thereby associating a taxon identification with the tree stem(s).',
     
        ' stemCount  Stem Count  TAXONIMPORTANCE_ID  Taxon Importance  logical  required  Integer  FK  taxonImportance.taxonImportance_ID  no  Foreign key into the taxonImportance table  Foreign key into the taxonImportance table, thereby associating a taxon identification with the tree stem(s). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemCount',
        'stemDiameter',
        'DBH',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The diameter of the stem in centimeters. When diameter classes are used, the stemDiameter is the midpoint between the low end and high end for the diameter class;  the offset between this and the endpoints is stored in the stemDiameterAccuracy attribute.',
     
        ' stemCount  Stem Count  stemDiameter  DBH  logical    Float  n/a  n/a  no  n/a  The diameter of the stem in centimeters. When diameter classes are used, the stemDiameter is the midpoint between the low end and high end for the diameter class;  the offset between this and the endpoints is stored in the stemDiameterAccuracy attribute. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemCount',
        'stemDiameterAccuracy',
        'DBH err',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The accuracy of the stem diameter measurements in centimeters. This represents the distance between the diameter class midpoint and endpoint.',
     
        ' stemCount  Stem Count  stemDiameterAccuracy  DBH err  logical    Float  n/a  n/a  no  n/a  The accuracy of the stem diameter measurements in centimeters. This represents the distance between the diameter class midpoint and endpoint. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemCount',
        'stemHeight',
        'Ht.',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The measured height of the stem in meters. When height classes are used, the stemHeight is the midpoint between the low end and high end for the height class; the offset between this and the endpoint is stored in the stemHeightAccuracy field.',
     
        ' stemCount  Stem Count  stemHeight  Ht.  logical    Float  n/a  n/a  no  n/a  The measured height of the stem in meters. When height classes are used, the stemHeight is the midpoint between the low end and high end for the height class; the offset between this and the endpoint is stored in the stemHeightAccuracy field. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemCount',
        'stemHeightAccuracy',
        'Ht. Err',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The accuracy of the measured height of a stem, being the offset between the midpoint of the class and the endpoint, in meters.',
     
        ' stemCount  Stem Count  stemHeightAccuracy  Ht. Err  logical    Float  n/a  n/a  no  n/a  The accuracy of the measured height of a stem, being the offset between the midpoint of the class and the endpoint, in meters. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemCount',
        'stemCount',
        '#',
        'logical',
        'no',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'The default value is 1.  This field is not logically necessary, but allows for more compact entry and storage of tree stem tally data.',
        'The number of stems of a single species that have these specific stem diameter and height data in common.',
     
        ' stemCount  Stem Count  stemCount  #  logical  required  Integer  n/a  n/a  no  The default value is 1.  This field is not logically necessary, but allows for more compact entry and storage of tree stem tally data.  The number of stems of a single species that have these specific stem diameter and height data in common. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemCount',
        'stemTaxonArea',
        'Stem Taxon Area',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This is the area in m2 used to infer the presence of the stem(s) referenced in this record.  Overrides similar area field in taxonObservation, taxonImportance, and/or observation.  RESERVED VALUE: -1 is used to indicate no known boundaries were used while collecting this stem size.',
     
        ' stemCount  Stem Count  stemTaxonArea  Stem Taxon Area  logical    Float  n/a  n/a  no  n/a  This is the area in m2 used to infer the presence of the stem(s) referenced in this record.  Overrides similar area field in taxonObservation, taxonImportance, and/or observation.  RESERVED VALUE: -1 is used to indicate no known boundaries were used while collecting this stem size. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemCount',
        'emb_stemCount',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' stemCount  Stem Count  emb_stemCount  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'stemLocation',
        'Stem Location',
        'This table is intended to store location information about individual tree stems.',
        null,
        ' stemLocation  Stem Location  This table is intended to store location information about individual tree stems.    STEMLOCATION_ID  ID  STEMCOUNT_ID  Stem Count  stemCode  Stem Code  stemXPosition  Stem X Position  stemYPosition  Stem Y Position  stemHealth  Stem Health  emb_stemLocation  this row embargoed. '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemLocation',
        'STEMLOCATION_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary Key for the stemLocation table.',
        'Database generated identifier assigned to each unique stem observation.',
     
        ' stemLocation  Stem Location  STEMLOCATION_ID  ID  logical    serial  PK  n/a  no  Primary Key for the stemLocation table.  Database generated identifier assigned to each unique stem observation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemLocation',
        'STEMCOUNT_ID',
        'Stem Count',
        'logical',
        'no',
        'Integer',
        'FK',
        'stemCount.STEMCOUNT_ID',
        'no',
        'Foreign key into the stemSize table',
        'Foreign key into the stemSize table, thereby assigning a location to a particular stem of a specific size',
     
        ' stemLocation  Stem Location  STEMCOUNT_ID  Stem Count  logical  required  Integer  FK  stemCount.STEMCOUNT_ID  no  Foreign key into the stemSize table  Foreign key into the stemSize table, thereby assigning a location to a particular stem of a specific size '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemLocation',
        'stemCode',
        'Stem Code',
        'logical',
        'yes',
        'varchar (20)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name or code applied to a specific stem in the plot. This is generally a numeric label to associate a field data entry with a stem in the database.',
     
        ' stemLocation  Stem Location  stemCode  Stem Code  logical    varchar (20)  n/a  n/a  no  n/a  Name or code applied to a specific stem in the plot. This is generally a numeric label to associate a field data entry with a stem in the database. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemLocation',
        'stemXPosition',
        'Stem X Position',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The X-coordinate of the stem position in m. The user will enter the relative position of stems with respect to the plot origin (in meters) with the x-axis defined by the plot azimuth.',
     
        ' stemLocation  Stem Location  stemXPosition  Stem X Position  logical    Float  n/a  n/a  no  n/a  The X-coordinate of the stem position in m. The user will enter the relative position of stems with respect to the plot origin (in meters) with the x-axis defined by the plot azimuth. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemLocation',
        'stemYPosition',
        'Stem Y Position',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Y-coordinate of the stem position, as above.',
     
        ' stemLocation  Stem Location  stemYPosition  Stem Y Position  logical    Float  n/a  n/a  no  n/a  The Y-coordinate of the stem position, as above. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemLocation',
        'stemHealth',
        'Stem Health',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'open',
        'n/a',
        'Health of the stem referenced in this stemLocation record. Usually used to describe "dead" stems.',
     
        ' stemLocation  Stem Location  stemHealth  Stem Health  logical    varchar (50)  n/a  n/a  open  n/a  Health of the stem referenced in this stemLocation record. Usually used to describe "dead" stems.  dead  stem is dead  uprooted, but alive  stem is uprooted, but still alive  leaning  stem leans in a non-trivial manner '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'stemLocation',
                              'stemHealth',
                              'dead',
                              'stem is dead',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'stemLocation',
                              'stemHealth',
                              'uprooted, but alive',
                              'stem is uprooted, but still alive',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'stemLocation',
                              'stemHealth',
                              'leaning',
                              'stem leans in a non-trivial manner',
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stemLocation',
        'emb_stemLocation',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' stemLocation  Stem Location  emb_stemLocation  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'stratum',
        'Stratum Definition',
        'This table stores collective information about strata defined within a plot observation.',
        'This table is used to record non-species-specific information about a stratum. Examples include total cover of the stratum and maximum height of the stratum.',
        ' stratum  Stratum Definition  This table stores collective information about strata defined within a plot observation.  This table is used to record non-species-specific information about a stratum. Examples include total cover of the stratum and maximum height of the stratum.  STRATUM_ID  ID  OBSERVATION_ID  Observation  STRATUMTYPE_ID  Stratum Type  STRATUMMETHOD_ID  Stratum Method  stratumName  Stratum Name  stratumHeight  Stratum Height  stratumBase  Stratum Base  stratumCover  Stratum Cover  stratumDescription  Stratum Description '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratum',
        'STRATUM_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the stratum table.',
        'Database assigned value for a unique existence of a stratum within a plot observation.',
     
        ' stratum  Stratum Definition  STRATUM_ID  ID  logical    serial  PK  n/a  no  Primary key for the stratum table.  Database assigned value for a unique existence of a stratum within a plot observation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratum',
        'OBSERVATION_ID',
        'Observation',
        'logical',
        'no',
        'Integer',
        'FK',
        'observation.OBSERVATION_ID',
        'no',
        'Foreign key into the observation table.',
        'Link to the plot observation event with which this stratum observation is associated.',
     
        ' stratum  Stratum Definition  OBSERVATION_ID  Observation  logical  required  Integer  FK  observation.OBSERVATION_ID  no  Foreign key into the observation table.  Link to the plot observation event with which this stratum observation is associated. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratum',
        'STRATUMTYPE_ID',
        'Stratum Type',
        'logical',
        'no',
        'Integer',
        'FK',
        'stratumType.STRATUMTYPE_ID',
        'no',
        'Foreign key into the stratumType table.',
        'This attribute will link to the definition of the specific stratum observed.',
     
        ' stratum  Stratum Definition  STRATUMTYPE_ID  Stratum Type  logical  required  Integer  FK  stratumType.STRATUMTYPE_ID  no  Foreign key into the stratumType table.  This attribute will link to the definition of the specific stratum observed. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratum',
        'STRATUMMETHOD_ID',
        'Stratum Method',
        'denorm',
        'yes',
        'Integer',
        'FK',
        'stratumMethod.STRATUMMETHOD_ID',
        'no',
        null,
        null,
     
        ' stratum  Stratum Definition  STRATUMMETHOD_ID  Stratum Method  denorm    Integer  FK  stratumMethod.STRATUMMETHOD_ID  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratum',
        'stratumName',
        'Stratum Name',
        'denorm',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' stratum  Stratum Definition  stratumName  Stratum Name  denorm    varchar (30)  n/a  n/a  no     '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratum',
        'stratumHeight',
        'Stratum Height',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Average height to the top of the stratum in meters.',
     
        ' stratum  Stratum Definition  stratumHeight  Stratum Height  logical    Float  n/a  n/a  no  n/a  Average height to the top of the stratum in meters. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratum',
        'stratumBase',
        'Stratum Base',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Average height of the bottom of the stratum in meters.',
     
        ' stratum  Stratum Definition  stratumBase  Stratum Base  logical    Float  n/a  n/a  no  n/a  Average height of the bottom of the stratum in meters. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratum',
        'stratumCover',
        'Stratum Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Cover of the vegetation within the given stratum in percent.',
     
        ' stratum  Stratum Definition  stratumCover  Stratum Cover  logical    Float  n/a  n/a  no  n/a  Cover of the vegetation within the given stratum in percent. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratum',
        'stratumDescription',
        'Stratum Description',
        'implementation',
        'yes',
        'varchar (200)',
        'n/a',
        'n/a',
        'no',
        null,
        null,
     
        ' stratum  Stratum Definition  stratumDescription  Stratum Description  implementation    varchar (200)  n/a  n/a  no     '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'stratumMethod',
        'Stratum Method',
        'This table links a set of strata to a sampling protocol . This table, when combined a set of linked stratum occurrences, defines the strata used by a plot observer.',
        null,
        ' stratumMethod  Stratum Method  This table links a set of strata to a sampling protocol . This table, when combined a set of linked stratum occurrences, defines the strata used by a plot observer.    STRATUMMETHOD_ID  ID  reference_ID  Reference  stratumMethodName  Stratum Method Name  stratumMethodDescription  Stratum Method Description  stratumAssignment  Stratum Assignment  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumMethod',
        'STRATUMMETHOD_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary Key for the stratumMethod table.',
        'Database generated identifier assigned to each unique stratum methodology.',
     
        ' stratumMethod  Stratum Method  STRATUMMETHOD_ID  ID  logical    serial  PK  n/a  no  Primary Key for the stratumMethod table.  Database generated identifier assigned to each unique stratum methodology. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumMethod',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'Foreign key into the reference table',
        'Link to a publication defining the stratum method.',
     
        ' stratumMethod  Stratum Method  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  Foreign key into the reference table  Link to a publication defining the stratum method. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumMethod',
        'stratumMethodName',
        'Stratum Method Name',
        'logical',
        'no',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of the stratum method (e.g., Braun-Blanquet, TNC-ABI, NC Vegetation Survey #1, NC Vegetation Survey #2, etc.)',
     
        ' stratumMethod  Stratum Method  stratumMethodName  Stratum Method Name  logical  required  varchar (30)  n/a  n/a  no  n/a  Name of the stratum method (e.g., Braun-Blanquet, TNC-ABI, NC Vegetation Survey #1, NC Vegetation Survey #2, etc.) '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumMethod',
        'stratumMethodDescription',
        'Stratum Method Description',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This field describes the general methods used for strata. For example, this field should distinguish as to whether strata are defined as including all foliage on plants that predominantly occupy the stratum regardless of the height of that foliage, or only the foliage that actually occurs within a specified vertical slice of the community.',
     
        ' stratumMethod  Stratum Method  stratumMethodDescription  Stratum Method Description  logical    text  n/a  n/a  no  n/a  This field describes the general methods used for strata. For example, this field should distinguish as to whether strata are defined as including all foliage on plants that predominantly occupy the stratum regardless of the height of that foliage, or only the foliage that actually occurs within a specified vertical slice of the community. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumMethod',
        'stratumAssignment',
        'Stratum Assignment',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'The way that an individual''s cover is assigned to the different stratum.  Some methodologies allow an individul to span multiple strata and have stratumCover values in each stratum. Other methodologies require that all cover from an individual be assigned to the upper-most stratum.  Further information about the specifics of stratum Methodologies that deviate from the standard practice of the stratumMethod referened in the field stratumMethod_ID should be described in methodNarrative.',
     
        ' stratumMethod  Stratum Method  stratumAssignment  Stratum Assignment  logical    varchar (50)  n/a  n/a  closed  n/a  The way that an individual''s cover is assigned to the different stratum.  Some methodologies allow an individul to span multiple strata and have stratumCover values in each stratum. Other methodologies require that all cover from an individual be assigned to the upper-most stratum.  Further information about the specifics of stratum Methodologies that deviate from the standard practice of the stratumMethod referened in the field stratumMethod_ID should be described in methodNarrative.  predominant stratum  Each individual is assigned to one and only one stratum in which it most significantly occurs.  Generally, this is the tallest stratum that the individual occupies.  soley height determined  Individuals are included in each stratum they occupy, allowing one individual to be assigned to multiple strata, if it crosses the height boundary between strata. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'stratumMethod',
                              'stratumAssignment',
                              'predominant stratum',
                              'Each individual is assigned to one and only one stratum in which it most significantly occurs.  Generally, this is the tallest stratum that the individual occupies.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'stratumMethod',
                              'stratumAssignment',
                              'soley height determined',
                              'Individuals are included in each stratum they occupy, allowing one individual to be assigned to multiple strata, if it crosses the height boundary between strata.',
                              '2'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumMethod',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' stratumMethod  Stratum Method  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'stratumType',
        'Stratum Type',
        'This table stores collective information about strata defined within a plot observation.',
        'This table is used to record non-species-specific information about a stratum. Examples include total cover of the stratum and maximum height of the stratum.',
        ' stratumType  Stratum Type  This table stores collective information about strata defined within a plot observation.  This table is used to record non-species-specific information about a stratum. Examples include total cover of the stratum and maximum height of the stratum.  STRATUMTYPE_ID  ID  STRATUMMETHOD_ID  Stratum Method  stratumIndex  Stratum Index  stratumName  Stratum Name  stratumDescription  Stratum Description '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumType',
        'STRATUMTYPE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the stratum table.',
        'Database assigned value for a unique existence of a stratum within a plot observation.',
     
        ' stratumType  Stratum Type  STRATUMTYPE_ID  ID  logical    serial  PK  n/a  no  Primary key for the stratum table.  Database assigned value for a unique existence of a stratum within a plot observation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumType',
        'STRATUMMETHOD_ID',
        'Stratum Method',
        'logical',
        'no',
        'Integer',
        'FK',
        'stratumMethod.STRATUMMETHOD_ID',
        'no',
        'Foreign key into the stratumMethod table.',
        'This attribute will link to the stratum to the stratum methodology used.',
     
        ' stratumType  Stratum Type  STRATUMMETHOD_ID  Stratum Method  logical  required  Integer  FK  stratumMethod.STRATUMMETHOD_ID  no  Foreign key into the stratumMethod table.  This attribute will link to the stratum to the stratum methodology used. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumType',
        'stratumIndex',
        'Stratum Index',
        'logical',
        'yes',
        'varchar (10)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Short code used to identify the stratum',
     
        ' stratumType  Stratum Type  stratumIndex  Stratum Index  logical    varchar (10)  n/a  n/a  no  n/a  Short code used to identify the stratum '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumType',
        'stratumName',
        'Stratum Name',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name associated with this stratum by the stratumMethod',
     
        ' stratumType  Stratum Type  stratumName  Stratum Name  logical    varchar (30)  n/a  n/a  no  n/a  Name associated with this stratum by the stratumMethod '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'stratumType',
        'stratumDescription',
        'Stratum Description',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This field describes the specific stratum.  For example, a value of "F" under stratumIndex might have a stratumName = "Floating" and a stratumDescription  = "foliage floating on or near the surface of water"',
     
        ' stratumType  Stratum Type  stratumDescription  Stratum Description  logical    text  n/a  n/a  no  n/a  This field describes the specific stratum.  For example, a value of "F" under stratumIndex might have a stratumName = "Floating" and a stratumDescription  = "foliage floating on or near the surface of water" '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'taxonImportance',
        'Taxon Importance',
        'This table stores information about the importance (i.e. cover, basal area, biomass) of each taxon observed on a plot.  Records may be limited to one stratum or apply to all strata.',
        null,
        ' taxonImportance  Taxon Importance  This table stores information about the importance (i.e. cover, basal area, biomass) of each taxon observed on a plot.  Records may be limited to one stratum or apply to all strata.    taxonImportance_ID  Taxon Importance ID  taxonObservation_ID  Taxon  stratum_ID  Stratum  cover  Cover  coverCode  Original Cover Code  basalArea  Basal Area  biomass  Biomass  inferenceArea  Inference Area  stratumBase  Stratum Base Ht  stratumHeight  Stratum Max Ht  emb_taxonImportance  this row embargoed. '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'taxonImportance_ID',
        'Taxon Importance ID',
        'logical',
        'no',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database generated number which uniquely identifies this record of the table.',
     
        ' taxonImportance  Taxon Importance  taxonImportance_ID  Taxon Importance ID  logical  required  serial  PK  n/a  no  n/a  Database generated number which uniquely identifies this record of the table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'taxonObservation_ID',
        'Taxon',
        'logical',
        'no',
        'Integer',
        'FK',
        'taxonObservation.TAXONOBSERVATION_ID',
        'no',
        'n/a',
        'Foreign Key into the TaxonObservation table to link to the information about the taxon for which this importance value applies.',
     
        ' taxonImportance  Taxon Importance  taxonObservation_ID  Taxon  logical  required  Integer  FK  taxonObservation.TAXONOBSERVATION_ID  no  n/a  Foreign Key into the TaxonObservation table to link to the information about the taxon for which this importance value applies. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'stratum_ID',
        'Stratum',
        'logical',
        'yes',
        'Integer',
        'FK',
        'stratum.STRATUM_ID',
        'no',
        'n/a',
        'Foreign Key into the stratum table, if this record is limited to the importance of a taxon in one stratum. If null, all values in this record speak of the importance of the entire taxon across all strata.',
     
        ' taxonImportance  Taxon Importance  stratum_ID  Stratum  logical    Integer  FK  stratum.STRATUM_ID  no  n/a  Foreign Key into the stratum table, if this record is limited to the importance of a taxon in one stratum. If null, all values in this record speak of the importance of the entire taxon across all strata. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'cover',
        'Cover',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Cover, in percent, of the taxon (potentially limitied to one stratum if stratum_ID has a value).',
     
        ' taxonImportance  Taxon Importance  cover  Cover  logical    Float  n/a  n/a  no  n/a  Cover, in percent, of the taxon (potentially limitied to one stratum if stratum_ID has a value). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'coverCode',
        'Original Cover Code',
        'denorm',
        'yes',
        'varchar (10)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The original cover code used by the author in the Cover Method for the plot.',
     
        ' taxonImportance  Taxon Importance  coverCode  Original Cover Code  denorm    varchar (10)  n/a  n/a  no  n/a  The original cover code used by the author in the Cover Method for the plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'basalArea',
        'Basal Area',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Total basal area of the species in m2/ha (potentially limitied to one stratum if stratum_ID has a value).',
     
        ' taxonImportance  Taxon Importance  basalArea  Basal Area  logical    Float  n/a  n/a  no  n/a  Total basal area of the species in m2/ha (potentially limitied to one stratum if stratum_ID has a value). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'biomass',
        'Biomass',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The biomass of the species in g/m2 (potentially limitied to one stratum if stratum_ID has a value).',
     
        ' taxonImportance  Taxon Importance  biomass  Biomass  logical    Float  n/a  n/a  no  n/a  The biomass of the species in g/m2 (potentially limitied to one stratum if stratum_ID has a value). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'inferenceArea',
        'Inference Area',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'The area used to infer the importance values of the taxon, if not the same as observation.taxonInferenceArea.',
        'This is the area in m2 used to infer the importance values (i.e. cover, biomass, basal area) in this record.  RESERVED VALUE: -1 is used to indicate no plot boundaries were used when estimating importance values.',
     
        ' taxonImportance  Taxon Importance  inferenceArea  Inference Area  logical    Float  n/a  n/a  no  The area used to infer the importance values of the taxon, if not the same as observation.taxonInferenceArea.  This is the area in m2 used to infer the importance values (i.e. cover, biomass, basal area) in this record.  RESERVED VALUE: -1 is used to indicate no plot boundaries were used when estimating importance values. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'stratumBase',
        'Stratum Base Ht',
        'denorm',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Base of the Stratum in meters.',
     
        ' taxonImportance  Taxon Importance  stratumBase  Stratum Base Ht  denorm    Float  n/a  n/a  no  n/a  The Base of the Stratum in meters. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'stratumHeight',
        'Stratum Max Ht',
        'denorm',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Tallest part of the Stratum in meters.',
     
        ' taxonImportance  Taxon Importance  stratumHeight  Stratum Max Ht  denorm    Float  n/a  n/a  no  n/a  The Tallest part of the Stratum in meters. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonImportance',
        'emb_taxonImportance',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' taxonImportance  Taxon Importance  emb_taxonImportance  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'taxonInterpretation',
        'Taxon Interpretation',
        'This table allows all users, including the author and/or subsequent interpreters, to attach taxon names and authorities to a specific taxon observation',
        null,
        ' taxonInterpretation  Taxon Interpretation  This table allows all users, including the author and/or subsequent interpreters, to attach taxon names and authorities to a specific taxon observation    TAXONINTERPRETATION_ID  ID  TAXONOBSERVATION_ID  Taxon Observation  stemLocation_ID  Stem Location  PLANTCONCEPT_ID  Plant Concept  interpretationDate  Interpretation Date  PLANTNAME_ID  Plant Name  PARTY_ID  Party  ROLE_ID  Role  interpretationType  Interpretation Type  reference_ID  Reference  originalInterpretation  Original Interpretation  currentInterpretation  Current Interpretation  taxonFit  Taxon Fit  taxonConfidence  Taxon Confidence  collector_ID  Collector  collectionNumber  Collection Number  collectionDate  Collection Date  museum_ID  Museum  museumAccessionNumber  Museum Accession Number  groupType  Group Type  notes  Notes  notesPublic  Notes Public  notesMgt  Notes Mgt  revisions  Revisions  emb_taxonInterpretation  this row embargoed.  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'TAXONINTERPRETATION_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the TaxonInterpretation table.',
        'Database generated identifier assigned to each unique interpretation of a taxon.',
     
        ' taxonInterpretation  Taxon Interpretation  TAXONINTERPRETATION_ID  ID  logical    serial  PK  n/a  no  Primary key for the TaxonInterpretation table.  Database generated identifier assigned to each unique interpretation of a taxon. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'TAXONOBSERVATION_ID',
        'Taxon Observation',
        'logical',
        'no',
        'Integer',
        'FK',
        'taxonObservation.TAXONOBSERVATION_ID',
        'no',
        'Foreign key into the taxonObservation table.',
        'Link  to a particular taxon observation.',
     
        ' taxonInterpretation  Taxon Interpretation  TAXONOBSERVATION_ID  Taxon Observation  logical  required  Integer  FK  taxonObservation.TAXONOBSERVATION_ID  no  Foreign key into the taxonObservation table.  Link  to a particular taxon observation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'stemLocation_ID',
        'Stem Location',
        'logical',
        'yes',
        'Integer',
        'FK',
        'stemLocation.STEMLOCATION_ID',
        'no',
        'Foreign key into the StemLocation table.',
        'StemLocation record of a particular stem that is to be interpreted by this taxonInterpretation record.',
     
        ' taxonInterpretation  Taxon Interpretation  stemLocation_ID  Stem Location  logical    Integer  FK  stemLocation.STEMLOCATION_ID  no  Foreign key into the StemLocation table.  StemLocation record of a particular stem that is to be interpreted by this taxonInterpretation record. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'PLANTCONCEPT_ID',
        'Plant Concept',
        'logical',
        'no',
        'Integer',
        'FK',
        'plantConcept.PLANTCONCEPT_ID',
        'no',
        'Foreign key into the plantConcept table.',
        'Link to a taxon in the plantConcept table. The entry in the plantConcept table will in turn point to a reference and a name used in the reference, thereby defining the taxon concept. The name that should be applied to the plantConcept will be party specific and will be found in the plantUsage table. For other than legacy data, the first interpretation recorded for a taxon observation should be redundant with the information contained in taxonObservation.PLANTNAME_ID + PLANTREFERENCE_ID.',
     
        ' taxonInterpretation  Taxon Interpretation  PLANTCONCEPT_ID  Plant Concept  logical  required  Integer  FK  plantConcept.PLANTCONCEPT_ID  no  Foreign key into the plantConcept table.  Link to a taxon in the plantConcept table. The entry in the plantConcept table will in turn point to a reference and a name used in the reference, thereby defining the taxon concept. The name that should be applied to the plantConcept will be party specific and will be found in the plantUsage table. For other than legacy data, the first interpretation recorded for a taxon observation should be redundant with the information contained in taxonObservation.PLANTNAME_ID + PLANTREFERENCE_ID. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'interpretationDate',
        'Interpretation Date',
        'logical',
        'no',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The date that the interpretation was made.',
     
        ' taxonInterpretation  Taxon Interpretation  interpretationDate  Interpretation Date  logical  required  Date  n/a  n/a  no  n/a  The date that the interpretation was made. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'PLANTNAME_ID',
        'Plant Name',
        'logical',
        'yes',
        'Integer',
        'FK',
        'plantName.PLANTNAME_ID',
        'no',
        'Foreign key into the taxonName table.',
        'Foreign key into the plantName (in the plantTaxa database) table to identify the name applied by the interpreter to the plantConcept. This field is not needed except in cases where there is a publication associated with the interpretation.',
     
        ' taxonInterpretation  Taxon Interpretation  PLANTNAME_ID  Plant Name  logical    Integer  FK  plantName.PLANTNAME_ID  no  Foreign key into the taxonName table.  Foreign key into the plantName (in the plantTaxa database) table to identify the name applied by the interpreter to the plantConcept. This field is not needed except in cases where there is a publication associated with the interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'PARTY_ID',
        'Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'Foreign key into the party table.',
        'Foreign key that identifies the party that made the interpretation, which could be the observation author.',
     
        ' taxonInterpretation  Taxon Interpretation  PARTY_ID  Party  logical  required  Integer  FK  party.PARTY_ID  no  Foreign key into the party table.  Foreign key that identifies the party that made the interpretation, which could be the observation author. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'ROLE_ID',
        'Role',
        'logical',
        'no',
        'Integer',
        'FK',
        'aux_Role.ROLE_ID',
        'no',
        'Foreign key into aux_Role table',
        'Foreign key that identifies the role of the party making the interpretation (e.g.,  plot author, publication author, database manager, automated, plot contributor).',
     
        ' taxonInterpretation  Taxon Interpretation  ROLE_ID  Role  logical  required  Integer  FK  aux_Role.ROLE_ID  no  Foreign key into aux_Role table  Foreign key that identifies the role of the party making the interpretation (e.g.,  plot author, publication author, database manager, automated, plot contributor). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'interpretationType',
        'Interpretation Type',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Categories for the interpretation (e.g.,  author, computer generated, simplified for comparative analysis, correction, finer resolution).',
     
        ' taxonInterpretation  Taxon Interpretation  interpretationType  Interpretation Type  logical    varchar (30)  n/a  n/a  closed  closed list  Categories for the interpretation (e.g.,  author, computer generated, simplified for comparative analysis, correction, finer resolution).  Author  Ideally, the field workers who sampled to plot, but it could also be the person who compiled and submitted the plot to the database, or the person who published the plot.  Computer (automated)  Automated taxonomic change following a taxonomic revision.  Correction  A new interpretation was made because the interpreter has reason to believe that another determination was incorrect or of different certainty than stated.  Finer resolution  The interpreter has reason to believe that determination can be made at a finer level of taxonomic resolution.  Simplification for analysis  This is for the case where one marks up a plot to reflect the interpretaions used in an analysis of multiple plots where the plots had to have a common taxonomy for comparison purposes.  These interpretations are of relatively limited value except for documenting the analysis conducted, and many times this is better done in the supplemental material attached to the paper than in the plot database.  Taxonomic revision  Changes in interpretation made to reflect taxonomic changes. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'interpretationType',
                              'Author',
                              'Ideally, the field workers who sampled to plot, but it could also be the person who compiled and submitted the plot to the database, or the person who published the plot.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'interpretationType',
                              'Computer (automated)',
                              'Automated taxonomic change following a taxonomic revision.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'interpretationType',
                              'Simplification for analysis',
                              'This is for the case where one marks up a plot to reflect the interpretaions used in an analysis of multiple plots where the plots had to have a common taxonomy for comparison purposes.  These interpretations are of relatively limited value except for documenting the analysis conducted, and many times this is better done in the supplemental material attached to the paper than in the plot database.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'interpretationType',
                              'Correction',
                              'A new interpretation was made because the interpreter has reason to believe that another determination was incorrect or of different certainty than stated.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'interpretationType',
                              'Taxonomic revision',
                              'Changes in interpretation made to reflect taxonomic changes.',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'interpretationType',
                              'Finer resolution',
                              'The interpreter has reason to believe that determination can be made at a finer level of taxonomic resolution.',
                              '6'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'Foreign key into the reference table.',
        'Foreign key into reference table, which identifies a publication in which the interpretation was formally made, or in which the plot was used in a formal analysis.',
     
        ' taxonInterpretation  Taxon Interpretation  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  Foreign key into the reference table.  Foreign key into reference table, which identifies a publication in which the interpretation was formally made, or in which the plot was used in a formal analysis. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'originalInterpretation',
        'Original Interpretation',
        'logical',
        'no',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This interpretation corresponds to the original interpretation of the plot author, as best as can be determined.  There is no requirement that the authority match the authority of the author; only that the concepts are synonymous.',
     
        ' taxonInterpretation  Taxon Interpretation  originalInterpretation  Original Interpretation  logical  required  Boolean  n/a  n/a  no  n/a  This interpretation corresponds to the original interpretation of the plot author, as best as can be determined.  There is no requirement that the authority match the authority of the author; only that the concepts are synonymous. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'currentInterpretation',
        'Current Interpretation',
        'logical',
        'no',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This interpretation is the most accurate and precise interpretation currently available.',
     
        ' taxonInterpretation  Taxon Interpretation  currentInterpretation  Current Interpretation  logical  required  Boolean  n/a  n/a  no  n/a  This interpretation is the most accurate and precise interpretation currently available. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'taxonFit',
        'Taxon Fit',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'Indicates the degree of fit with the plant concept being assigned. Values derive from Gopal, S., and Woodcock, C. (1994), Theory and methods for accuracy assessment of thematic maps using fuzzy sets. Photogrammetric Engineering and Remote Sensing 60(2):181-188.',
     
        ' taxonInterpretation  Taxon Interpretation  taxonFit  Taxon Fit  logical    varchar (50)  n/a  n/a  closed  n/a  Indicates the degree of fit with the plant concept being assigned. Values derive from Gopal, S., and Woodcock, C. (1994), Theory and methods for accuracy assessment of thematic maps using fuzzy sets. Photogrammetric Engineering and Remote Sensing 60(2):181-188.  Absolutely correct  (Fits well)  No doubt about the match. Perfect fit.  Absolutely wrong  (Absolutely doesn''t fit)  This answer is absolutely unacceptable. Unambiguously incorrect.  Good answer  (Fits reasonably well)  Good match with the concept.  Unambiguously correct.  Reasonable or acceptable answer  (Possibly fits)  Maybe not the best possible answer but it is acceptable; this answer does not pose a problem to the user. Correct.  Understandable but wrong  (Doesn''t fit but is close)  Not a good answer. There is something about the plot that makes the answer understandable, but there is clearly a better answer. This answer would pose a problem for users.  Incorrect. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'taxonFit',
                              'Absolutely wrong',
                              '(Absolutely doesn''t fit)  This answer is absolutely unacceptable. Unambiguously incorrect.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'taxonFit',
                              'Understandable but wrong',
                              '(Doesn''t fit but is close)  Not a good answer. There is something about the plot that makes the answer understandable, but there is clearly a better answer. This answer would pose a problem for users.  Incorrect.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'taxonFit',
                              'Reasonable or acceptable answer',
                              '(Possibly fits)  Maybe not the best possible answer but it is acceptable; this answer does not pose a problem to the user. Correct.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'taxonFit',
                              'Good answer',
                              '(Fits reasonably well)  Good match with the concept.  Unambiguously correct.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'taxonFit',
                              'Absolutely correct',
                              '(Fits well)  No doubt about the match. Perfect fit.',
                              '5'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'taxonConfidence',
        'Taxon Confidence',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'Indicates the degree of confidence of the interpreter(s) in the interpretation made. This can reflect the level of familiarity with the classification or the sufficiency of information about the plot (e.g., High, Moderate, Low).',
     
        ' taxonInterpretation  Taxon Interpretation  taxonConfidence  Taxon Confidence  logical    varchar (50)  n/a  n/a  closed  n/a  Indicates the degree of confidence of the interpreter(s) in the interpretation made. This can reflect the level of familiarity with the classification or the sufficiency of information about the plot (e.g., High, Moderate, Low).  High  The party making the taxon interpretation has a high confidence in the accuracy of this interpretation. A party can have high confidence that a plot has a fit of "absolutely wrong" for a particular community.  Low  The party making the taxon interpretation has a low confidence in the accuracy of this interpretation.  Medium  The party making the taxon interpretation has a medium amount of confidence in the accuracy of this interpretation. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'taxonConfidence',
                              'High',
                              'The party making the taxon interpretation has a high confidence in the accuracy of this interpretation. A party can have high confidence that a plot has a fit of "absolutely wrong" for a particular community.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'taxonConfidence',
                              'Medium',
                              'The party making the taxon interpretation has a medium amount of confidence in the accuracy of this interpretation.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'taxonConfidence',
                              'Low',
                              'The party making the taxon interpretation has a low confidence in the accuracy of this interpretation.',
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'collector_ID',
        'Collector',
        'logical',
        'yes',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'foreign key into the Party table',
        'Party who collected the voucher which was used to make this taxonInterpretation.',
     
        ' taxonInterpretation  Taxon Interpretation  collector_ID  Collector  logical    Integer  FK  party.PARTY_ID  no  foreign key into the Party table  Party who collected the voucher which was used to make this taxonInterpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'collectionNumber',
        'Collection Number',
        'logical',
        'yes',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Collector''s identification code for the voucher.',
     
        ' taxonInterpretation  Taxon Interpretation  collectionNumber  Collection Number  logical    varchar (100)  n/a  n/a  no  n/a  The Collector''s identification code for the voucher. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'collectionDate',
        'Collection Date',
        'logical',
        'yes',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Date on which the voucher was collected.',
     
        ' taxonInterpretation  Taxon Interpretation  collectionDate  Collection Date  logical    Date  n/a  n/a  no  n/a  Date on which the voucher was collected. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'museum_ID',
        'Museum',
        'logical',
        'yes',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'foreign key into the Party table',
        'Link to the Party which is the museum which archives the voucher.',
     
        ' taxonInterpretation  Taxon Interpretation  museum_ID  Museum  logical    Integer  FK  party.PARTY_ID  no  foreign key into the Party table  Link to the Party which is the museum which archives the voucher. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'museumAccessionNumber',
        'Museum Accession Number',
        'logical',
        'yes',
        'varchar (100)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Museum Code which identifies the voucher.',
     
        ' taxonInterpretation  Taxon Interpretation  museumAccessionNumber  Museum Accession Number  logical    varchar (100)  n/a  n/a  no  n/a  Museum Code which identifies the voucher. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'groupType',
        'Group Type',
        'logical',
        'yes',
        'varchar (20)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'The type of group formed for this taxonInterpretation_ID. ',
     
        ' taxonInterpretation  Taxon Interpretation  groupType  Group Type  logical    varchar (20)  n/a  n/a  closed  n/a  The type of group formed for this taxonInterpretation_ID.   one of  One of several plant concepts is interpreted to be the TaxonObservation in question.  For example, this is either species A OR species B.  Plants observed were one or the other, but not both, but which species cannot be determined.  union  Several plant concepts are grouped to describe this taxon.  For example, taxonObservation applies to the union of both species A and species B.  Plants observed were from both species.  unknown  It is not specified how the plant concepts are grouped.  Not recommended value. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'groupType',
                              'one of',
                              'One of several plant concepts is interpreted to be the TaxonObservation in question.  For example, this is either species A OR species B.  Plants observed were one or the other, but not both, but which species cannot be determined.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'groupType',
                              'union',
                              'Several plant concepts are grouped to describe this taxon.  For example, taxonObservation applies to the union of both species A and species B.  Plants observed were from both species.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonInterpretation',
                              'groupType',
                              'unknown',
                              'It is not specified how the plant concepts are grouped.  Not recommended value.',
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'notes',
        'Notes',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'These are notes that the interpreter has included with the interpretation (generally, the reason for the interpretation).',
     
        ' taxonInterpretation  Taxon Interpretation  notes  Notes  logical    text  n/a  n/a  no  n/a  These are notes that the interpreter has included with the interpretation (generally, the reason for the interpretation). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'notesPublic',
        'Notes Public',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'TRUE indicates that public notes pertaining to this plot exist in "vegPlot.note"',
     
        ' taxonInterpretation  Taxon Interpretation  notesPublic  Notes Public  logical    Boolean  n/a  n/a  no  n/a  TRUE indicates that public notes pertaining to this plot exist in "vegPlot.note" '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'notesMgt',
        'Notes Mgt',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'TRUE indicates that nonpublic management notes pertaining to this plot exist in "vegPlot.note"',
     
        ' taxonInterpretation  Taxon Interpretation  notesMgt  Notes Mgt  logical    Boolean  n/a  n/a  no  n/a  TRUE indicates that nonpublic management notes pertaining to this plot exist in "vegPlot.note" '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'revisions',
        'Revisions',
        'logical',
        'yes',
        'Boolean',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'TRUE indicates that revisions exist in vegPlot.Revision',
     
        ' taxonInterpretation  Taxon Interpretation  revisions  Revisions  logical    Boolean  n/a  n/a  no  n/a  TRUE indicates that revisions exist in vegPlot.Revision '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'emb_taxonInterpretation',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' taxonInterpretation  Taxon Interpretation  emb_taxonInterpretation  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonInterpretation',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' taxonInterpretation  Taxon Interpretation  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'taxonObservation',
        'Taxon Observation',
        'This table contains the author''s determination of a taxon and the overall cover of that taxon.',
        'This table stores information about the original identification by the author of the plot and the taxonomic authority used by that author (i.e. a name - citation pair constituting a taxonomic concept).  The table also contains a record of cumulative cover (cover across all strata) of the taxon when not divided into strata.',
        ' taxonObservation  Taxon Observation  This table contains the author''s determination of a taxon and the overall cover of that taxon.  This table stores information about the original identification by the author of the plot and the taxonomic authority used by that author (i.e. a name - citation pair constituting a taxonomic concept).  The table also contains a record of cumulative cover (cover across all strata) of the taxon when not divided into strata.  TAXONOBSERVATION_ID  ID  OBSERVATION_ID  Observation  authorPlantName  Author Plant Name  reference_ID  Reference  taxonInferenceArea  Taxon Inference Area  accessionCode  Accession Code  emb_taxonObservation  this row embargoed.  int_origPlantConcept_ID  Original Interpretation, Plant Concept ID  int_origPlantSciFull  Original Interpretation, full Scientific Name  int_origPlantSciNameNoAuth  Original Interpretation, Scientific Name without authors  int_origPlantCommon  Original Interpretation, Common Name  int_origPlantCode  Original Interpretation, USDA Code  int_currPlantConcept_ID  Current Interpretation, Plant Concept ID  int_currPlantSciFull  Current Interpretation, full Scientific Name  int_currPlantSciNameNoAuth  Current Interpretation, Scientific Name without authors  int_currPlantCommon  Current Interpretation, Common Name  int_currPlantCode  Current Interpretation, USDA Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'TAXONOBSERVATION_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key of the table.',
        'Database generated identifier assigned to each unique observation of a taxon in a plot.',
     
        ' taxonObservation  Taxon Observation  TAXONOBSERVATION_ID  ID  logical    serial  PK  n/a  no  Primary key of the table.  Database generated identifier assigned to each unique observation of a taxon in a plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'OBSERVATION_ID',
        'Observation',
        'logical',
        'no',
        'Integer',
        'FK',
        'observation.OBSERVATION_ID',
        'no',
        'Foreign key into the Observation table.',
        'Link to the parent observation event of this taxon observation.',
     
        ' taxonObservation  Taxon Observation  OBSERVATION_ID  Observation  logical  required  Integer  FK  observation.OBSERVATION_ID  no  Foreign key into the Observation table.  Link to the parent observation event of this taxon observation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'authorPlantName',
        'Author Plant Name',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The taxon name that the author of the plot used to refer to a taxon observed within the plot.',
     
        ' taxonObservation  Taxon Observation  authorPlantName  Author Plant Name  logical    varchar (255)  n/a  n/a  no  n/a  The taxon name that the author of the plot used to refer to a taxon observed within the plot. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'reference_ID',
        'Reference',
        'logical',
        'yes',
        'Integer',
        'FK',
        'reference.reference_ID',
        'no',
        'Foreign key into the reference table.',
        'The authority for the taxon that was used by the plot author. If the authority is unknown the author of the plot is the authority. For other than legacy data, this field plus plantName_ID will be sufficient to determine taxonInterpretation.plantConcept_ID.',
     
        ' taxonObservation  Taxon Observation  reference_ID  Reference  logical    Integer  FK  reference.reference_ID  no  Foreign key into the reference table.  The authority for the taxon that was used by the plot author. If the authority is unknown the author of the plot is the authority. For other than legacy data, this field plus plantName_ID will be sufficient to determine taxonInterpretation.plantConcept_ID. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'taxonInferenceArea',
        'Taxon Inference Area',
        'logical',
        'yes',
        'Float',
        'n/a',
        'n/a',
        'no',
        'The area used to infer the presence of the taxon, if not the same as observation.taxonInferenceArea.',
        'This is the area in m2 used to infer the presence of a given taxon.  Generally this should be equal to observation.taxonInferenceArea, but at times this area may be larger or smaller for a specific taxon.  RESERVED VALUE: -1 is used to indicate that no known plot boundaries were used when recording this species on the plot.  That is, this species may occur outside the plot area as indicated in the plot and observation tables.',
     
        ' taxonObservation  Taxon Observation  taxonInferenceArea  Taxon Inference Area  logical    Float  n/a  n/a  no  The area used to infer the presence of the taxon, if not the same as observation.taxonInferenceArea.  This is the area in m2 used to infer the presence of a given taxon.  Generally this should be equal to observation.taxonInferenceArea, but at times this area may be larger or smaller for a specific taxon.  RESERVED VALUE: -1 is used to indicate that no known plot boundaries were used when recording this species on the plot.  That is, this species may occur outside the plot area as indicated in the plot and observation tables. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' taxonObservation  Taxon Observation  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'emb_taxonObservation',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' taxonObservation  Taxon Observation  emb_taxonObservation  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'int_origPlantConcept_ID',
        'Original Interpretation, Plant Concept ID',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Plant Concept ID for the Original Interpretation.',
     
        ' taxonObservation  Taxon Observation  int_origPlantConcept_ID  Original Interpretation, Plant Concept ID  denorm    Integer  n/a  n/a  no  n/a  The Plant Concept ID for the Original Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'int_origPlantSciFull',
        'Original Interpretation, full Scientific Name',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The full Scientific Name, with authors, for the Original Interpretation.',
     
        ' taxonObservation  Taxon Observation  int_origPlantSciFull  Original Interpretation, full Scientific Name  denorm    varchar (255)  n/a  n/a  no  n/a  The full Scientific Name, with authors, for the Original Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'int_origPlantSciNameNoAuth',
        'Original Interpretation, Scientific Name without authors',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Scientific Name without authors for the Original Interpretation.',
     
        ' taxonObservation  Taxon Observation  int_origPlantSciNameNoAuth  Original Interpretation, Scientific Name without authors  denorm    varchar (255)  n/a  n/a  no  n/a  The Scientific Name without authors for the Original Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'int_origPlantCommon',
        'Original Interpretation, Common Name',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Common Name for the Original Interpretation.',
     
        ' taxonObservation  Taxon Observation  int_origPlantCommon  Original Interpretation, Common Name  denorm    varchar (255)  n/a  n/a  no  n/a  The Common Name for the Original Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'int_origPlantCode',
        'Original Interpretation, USDA Code',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The USDA Code, if available, for the Original Interpretation.',
     
        ' taxonObservation  Taxon Observation  int_origPlantCode  Original Interpretation, USDA Code  denorm    varchar (255)  n/a  n/a  no  n/a  The USDA Code, if available, for the Original Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'int_currPlantConcept_ID',
        'Current Interpretation, Plant Concept ID',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Plant Concept ID for the Current Interpretation, which is often that same as the Original Interpretation.',
     
        ' taxonObservation  Taxon Observation  int_currPlantConcept_ID  Current Interpretation, Plant Concept ID  denorm    Integer  n/a  n/a  no  n/a  The Plant Concept ID for the Current Interpretation, which is often that same as the Original Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'int_currPlantSciFull',
        'Current Interpretation, full Scientific Name',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The full Scientific Name, with authors,for the Current Interpretation.',
     
        ' taxonObservation  Taxon Observation  int_currPlantSciFull  Current Interpretation, full Scientific Name  denorm    varchar (255)  n/a  n/a  no  n/a  The full Scientific Name, with authors,for the Current Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'int_currPlantSciNameNoAuth',
        'Current Interpretation, Scientific Name without authors',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Scientific Name without authors for the Current Interpretation.',
     
        ' taxonObservation  Taxon Observation  int_currPlantSciNameNoAuth  Current Interpretation, Scientific Name without authors  denorm    varchar (255)  n/a  n/a  no  n/a  The Scientific Name without authors for the Current Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'int_currPlantCommon',
        'Current Interpretation, Common Name',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The Common Name for the Current Interpretation.',
     
        ' taxonObservation  Taxon Observation  int_currPlantCommon  Current Interpretation, Common Name  denorm    varchar (255)  n/a  n/a  no  n/a  The Common Name for the Current Interpretation. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonObservation',
        'int_currPlantCode',
        'Current Interpretation, USDA Code',
        'denorm',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'The USDA Code, if available, for the Current Interpretation.',
     
        ' taxonObservation  Taxon Observation  int_currPlantCode  Current Interpretation, USDA Code  denorm    varchar (255)  n/a  n/a  no  n/a  The USDA Code, if available, for the Current Interpretation. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'taxonAlt',
        'Taxon Alt',
        'This table shows alternate taxa that are to be grouped for a  taxonInterpretation.',
        'When this table is used, the taxonInterpretation that is referenced here is interpreting the taxonObservation as the combination of all plantConcepts referenced in this table with the same taxonInterpretation_ID.  TaxonInterpretation.groupType shows what type of group this is (one of, union, unknown).',
        ' taxonAlt  Taxon Alt  This table shows alternate taxa that are to be grouped for a  taxonInterpretation.  When this table is used, the taxonInterpretation that is referenced here is interpreting the taxonObservation as the combination of all plantConcepts referenced in this table with the same taxonInterpretation_ID.  TaxonInterpretation.groupType shows what type of group this is (one of, union, unknown).  taxonAlt_ID  ID  taxonInterpretation_ID  Taxon Interpretation  plantConcept_ID  Plant Concept  taxonAltFit  Taxon Fit  taxonAltConfidence  Taxon Confidence  taxonAltNotes  Taxon Alt Notes  emb_taxonAlt  this row embargoed. '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonAlt',
        'taxonAlt_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database generated number to uniquely identify this record, and thus taxonGroup.',
     
        ' taxonAlt  Taxon Alt  taxonAlt_ID  ID  logical    serial  PK  n/a  no  n/a  Database generated number to uniquely identify this record, and thus taxonGroup. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonAlt',
        'taxonInterpretation_ID',
        'Taxon Interpretation',
        'logical',
        'no',
        'Integer',
        'FK',
        'taxonInterpretation.TAXONINTERPRETATION_ID',
        'no',
        'n/a',
        'Links to the taxonInterpretation for which several plantConcepts are grouped to form an irregular taxon.  The plantConcept referenced here is one member of the group.',
     
        ' taxonAlt  Taxon Alt  taxonInterpretation_ID  Taxon Interpretation  logical  required  Integer  FK  taxonInterpretation.TAXONINTERPRETATION_ID  no  n/a  Links to the taxonInterpretation for which several plantConcepts are grouped to form an irregular taxon.  The plantConcept referenced here is one member of the group. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonAlt',
        'plantConcept_ID',
        'Plant Concept',
        'logical',
        'no',
        'Integer',
        'FK',
        'plantConcept.PLANTCONCEPT_ID',
        'no',
        'n/a',
        'Links to the plantConcept that is part of the taxonGroup formed by all records in this table with the same taxonInterpretation_ID.',
     
        ' taxonAlt  Taxon Alt  plantConcept_ID  Plant Concept  logical  required  Integer  FK  plantConcept.PLANTCONCEPT_ID  no  n/a  Links to the plantConcept that is part of the taxonGroup formed by all records in this table with the same taxonInterpretation_ID. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonAlt',
        'taxonAltFit',
        'Taxon Fit',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'Indicates the degree of fit with the plant concept being assigned. Values derive from Gopal, S., and Woodcock, C. (1994), Theory and methods for accuracy assessment of thematic maps using fuzzy sets. Photogrammetric Engineering and Remote Sensing 60(2):181-188.',
     
        ' taxonAlt  Taxon Alt  taxonAltFit  Taxon Fit  logical    varchar (50)  n/a  n/a  closed  n/a  Indicates the degree of fit with the plant concept being assigned. Values derive from Gopal, S., and Woodcock, C. (1994), Theory and methods for accuracy assessment of thematic maps using fuzzy sets. Photogrammetric Engineering and Remote Sensing 60(2):181-188.  Absolutely correct  (Fits well)  No doubt about the match. Perfect fit.  Absolutely wrong  (Absolutely doesn''t fit)  This answer is absolutely unacceptable. Unambiguously incorrect.  Good answer  (Fits reasonably well)  Good match with the concept.  Unambiguously correct.  Reasonable or acceptable answer  (Possibly fits)  Maybe not the best possible answer but it is acceptable; this answer does not pose a problem to the user. Correct.  Understandable but wrong  (Doesn''t fit but is close)  Not a good answer. There is something about the plot that makes the answer understandable, but there is clearly a better answer. This answer would pose a problem for users.  Incorrect. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonAlt',
                              'taxonAltFit',
                              'Absolutely wrong',
                              '(Absolutely doesn''t fit)  This answer is absolutely unacceptable. Unambiguously incorrect.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonAlt',
                              'taxonAltFit',
                              'Understandable but wrong',
                              '(Doesn''t fit but is close)  Not a good answer. There is something about the plot that makes the answer understandable, but there is clearly a better answer. This answer would pose a problem for users.  Incorrect.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonAlt',
                              'taxonAltFit',
                              'Reasonable or acceptable answer',
                              '(Possibly fits)  Maybe not the best possible answer but it is acceptable; this answer does not pose a problem to the user. Correct.',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonAlt',
                              'taxonAltFit',
                              'Good answer',
                              '(Fits reasonably well)  Good match with the concept.  Unambiguously correct.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonAlt',
                              'taxonAltFit',
                              'Absolutely correct',
                              '(Fits well)  No doubt about the match. Perfect fit.',
                              '5'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonAlt',
        'taxonAltConfidence',
        'Taxon Confidence',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'closed',
        'n/a',
        'Indicates the degree of confidence of the interpreter(s) in the interpretation made. This can reflect the level of familiarity with the classification or the sufficiency of information about the plot (e.g., High, Moderate, Low).',
     
        ' taxonAlt  Taxon Alt  taxonAltConfidence  Taxon Confidence  logical    varchar (50)  n/a  n/a  closed  n/a  Indicates the degree of confidence of the interpreter(s) in the interpretation made. This can reflect the level of familiarity with the classification or the sufficiency of information about the plot (e.g., High, Moderate, Low).  High  The party making the taxon interpretation has a high confidence in the accuracy of this interpretation. A party can have high confidence that a plot has a fit of "absolutely wrong" for a particular community.  Low  The party making the taxon interpretation has a low confidence in the accuracy of this interpretation.  Medium  The party making the taxon interpretation has a medium amount of confidence in the accuracy of this interpretation. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonAlt',
                              'taxonAltConfidence',
                              'High',
                              'The party making the taxon interpretation has a high confidence in the accuracy of this interpretation. A party can have high confidence that a plot has a fit of "absolutely wrong" for a particular community.',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonAlt',
                              'taxonAltConfidence',
                              'Medium',
                              'The party making the taxon interpretation has a medium amount of confidence in the accuracy of this interpretation.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'taxonAlt',
                              'taxonAltConfidence',
                              'Low',
                              'The party making the taxon interpretation has a low confidence in the accuracy of this interpretation.',
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonAlt',
        'taxonAltNotes',
        'Taxon Alt Notes',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'These are notes that the interpreter has included with the interpretation (generally, the reason for the interpretation).',
     
        ' taxonAlt  Taxon Alt  taxonAltNotes  Taxon Alt Notes  logical    text  n/a  n/a  no  n/a  These are notes that the interpreter has included with the interpretation (generally, the reason for the interpretation). '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'taxonAlt',
        'emb_taxonAlt',
        'this row embargoed.',
        'denorm',
        'yes',
        'Integer',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'This value mimics the default embargo value for the plot that this record belongs to.',
     
        ' taxonAlt  Taxon Alt  emb_taxonAlt  this row embargoed.  denorm    Integer  n/a  n/a  no  n/a  This value mimics the default embargo value for the plot that this record belongs to. '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'telephone',
        'Telephone',
        'Telephone numbers for the various individuals and organizations in the party table.',
        null,
        ' telephone  Telephone  Telephone numbers for the various individuals and organizations in the party table.    TELEPHONE_ID  ID  PARTY_ID  Party  phoneNumber  Phone Number  phoneType  Phone Type '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'telephone',
        'TELEPHONE_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for the telephone table.',
        'Database generated identifier assigned to each unique telephone contact record.',
     
        ' telephone  Telephone  TELEPHONE_ID  ID  logical    serial  PK  n/a  no  Primary key for the telephone table.  Database generated identifier assigned to each unique telephone contact record. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'telephone',
        'PARTY_ID',
        'Party',
        'logical',
        'no',
        'Integer',
        'FK',
        'party.PARTY_ID',
        'no',
        'Foreign key into the party table',
        'This is the ''link'' between a PARTY and an entry in the TELEPHONE table.',
     
        ' telephone  Telephone  PARTY_ID  Party  logical  required  Integer  FK  party.PARTY_ID  no  Foreign key into the party table  This is the ''link'' between a PARTY and an entry in the TELEPHONE table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'telephone',
        'phoneNumber',
        'Phone Number',
        'logical',
        'no',
        'varchar (30)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Telephone number.',
     
        ' telephone  Telephone  phoneNumber  Phone Number  logical  required  varchar (30)  n/a  n/a  no  n/a  Telephone number. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'telephone',
        'phoneType',
        'Phone Type',
        'logical',
        'no',
        'varchar (20)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'This is the type of telephone: home, work, fax, cell, secretary, other.',
     
        ' telephone  Telephone  phoneType  Phone Type  logical  required  varchar (20)  n/a  n/a  closed  closed list  This is the type of telephone: home, work, fax, cell, secretary, other.  Cell    Fax    Home    Not specified    Secretary    Work   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'telephone',
                              'phoneType',
                              'Work',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'telephone',
                              'phoneType',
                              'Home',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'telephone',
                              'phoneType',
                              'Cell',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'telephone',
                              'phoneType',
                              'Fax',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'telephone',
                              'phoneType',
                              'Secretary',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'telephone',
                              'phoneType',
                              'Not specified',
                              null,
                              '6'
                       );
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'userDefined',
        'User Defined',
        'This table contains the definitions of user-defined variables.  The table structure stems from desire to keep the user-defined variables separate from the main body of the database.',
        'This table contains the definitions of user-defined variables.  The table structure stems from desire to keep the user-defined variables separate from the main body of the database.',
        ' userDefined  User Defined  This table contains the definitions of user-defined variables.  The table structure stems from desire to keep the user-defined variables separate from the main body of the database.  This table contains the definitions of user-defined variables.  The table structure stems from desire to keep the user-defined variables separate from the main body of the database.  USERDEFINED_ID  ID  userDefinedName  User Defined Name  userDefinedMetadata  User Defined Metadata  userDefinedCategory  User Defined Category  userDefinedType  User Defined Type  tableName  Table Name  accessionCode  Accession Code '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'userDefined',
        'USERDEFINED_ID',
        'ID',
        'logical',
        'yes',
        'serial',
        'PK',
        'n/a',
        'no',
        'Primary key for userDefined',
        'Database generated identifier assigned to each unique user-defined variable.',
     
        ' userDefined  User Defined  USERDEFINED_ID  ID  logical    serial  PK  n/a  no  Primary key for userDefined  Database generated identifier assigned to each unique user-defined variable. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'userDefined',
        'userDefinedName',
        'User Defined Name',
        'logical',
        'yes',
        'varchar (50)',
        'n/a',
        'n/a',
        'open',
        'open list',
        'Name of the user-defined variable.',
     
        ' userDefined  User Defined  userDefinedName  User Defined Name  logical    varchar (50)  n/a  n/a  open  open list  Name of the user-defined variable.  Depth to permafrost    Microbial biomass    Slope convexity   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedName',
                              'Microbial biomass',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedName',
                              'Slope convexity',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedName',
                              'Depth to permafrost',
                              null,
                              '3'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'userDefined',
        'userDefinedMetadata',
        'User Defined Metadata',
        'logical',
        'yes',
        'text',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Metadata about this user-defined variable.',
     
        ' userDefined  User Defined  userDefinedMetadata  User Defined Metadata  logical    text  n/a  n/a  no  n/a  Metadata about this user-defined variable. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'userDefined',
        'userDefinedCategory',
        'User Defined Category',
        'logical',
        'yes',
        'varchar (30)',
        'n/a',
        'n/a',
        'closed',
        'closed list',
        'Category of variable; included to facilitate queries for specific types of data.',
     
        ' userDefined  User Defined  userDefinedCategory  User Defined Category  logical    varchar (30)  n/a  n/a  closed  closed list  Category of variable; included to facilitate queries for specific types of data.  Disturbance and land use    Environment    Geology and geomorphology    Moisture    Not specified    Soil, chemical attributes    Soil, physical attributes    Subplots    Topography   '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedCategory',
                              'Soil, physical attributes',
                              null,
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedCategory',
                              'Soil, chemical attributes',
                              null,
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedCategory',
                              'Geology and geomorphology',
                              null,
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedCategory',
                              'Moisture',
                              null,
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedCategory',
                              'Environment',
                              null,
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedCategory',
                              'Topography',
                              null,
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedCategory',
                              'Disturbance and land use',
                              null,
                              '7'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedCategory',
                              'Subplots',
                              null,
                              '8'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'userDefined',
                              'userDefinedCategory',
                              'Not specified',
                              null,
                              '9'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'userDefined',
        'userDefinedType',
        'User Defined Type',
        'logical',
        'no',
        'varchar (20)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Database data type of the user-defined variable.',
     
        ' userDefined  User Defined  userDefinedType  User Defined Type  logical  required  varchar (20)  n/a  n/a  no  n/a  Database data type of the user-defined variable. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'userDefined',
        'tableName',
        'Table Name',
        'logical',
        'no',
        'varchar (50)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Name of table with which this user-defined variable is associated.  For example soilBHorizonColor may be defined by the data contributor as associated with the observation table.',
     
        ' userDefined  User Defined  tableName  Table Name  logical  required  varchar (50)  n/a  n/a  no  n/a  Name of table with which this user-defined variable is associated.  For example soilBHorizonColor may be defined by the data contributor as associated with the observation table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'userDefined',
        'accessionCode',
        'Accession Code',
        'logical',
        'yes',
        'varchar (255)',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number).',
     
        ' userDefined  User Defined  accessionCode  Accession Code  logical    varchar (255)  n/a  n/a  no  n/a  Code that uniquely references this record, allowing reference to this record for this version of this database.  Better than a primary key, which is automatically generated by a database and not globally unique.  VegBank Accession codes are only generated by VegBank, and therefore data integrity can be guaranteed, unlike with a primary key (number). '
        
               );
                
               
        INSERT INTO dba_tableDescription (  tableName , tableLabel , tableNotes , tableDescription , tableKeywords ) values (
        'embargo',
        'Embargo on Plot',
        'Embargo of plot data.',
        null,
        ' embargo  Embargo on Plot  Embargo of plot data.    embargo_ID  Embargo ID  plot_ID  Plot ID  embargoReason  Embargo Reason  embargoStart  Embargo Start  embargoStop  Embargo Stop  defaultStatus  Default Status '
        );
        
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'embargo',
        'embargo_ID',
        'Embargo ID',
        'logical',
        'no',
        'serial',
        'PK',
        'n/a',
        'no',
        'n/a',
        'Database generated unique key for each record in this table.',
     
        ' embargo  Embargo on Plot  embargo_ID  Embargo ID  logical  required  serial  PK  n/a  no  n/a  Database generated unique key for each record in this table. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'embargo',
        'plot_ID',
        'Plot ID',
        'logical',
        'no',
        'Integer',
        'FK',
        'plot.PLOT_ID',
        'no',
        'n/a',
        'Foreign key to the plot to which this embargo applies.',
     
        ' embargo  Embargo on Plot  plot_ID  Plot ID  logical  required  Integer  FK  plot.PLOT_ID  no  n/a  Foreign key to the plot to which this embargo applies. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'embargo',
        'embargoReason',
        'Embargo Reason',
        'logical',
        'no',
        'text',
        'n/a',
        'n/a',
        'closed',
        'Author stipulation,Rare species,Landownership,Bad data,Other',
        'Reason why the plot is embargoed.  This field, as all fields in this table, are private and cannot be viewed or downloaded by VegBank users.',
     
        ' embargo  Embargo on Plot  embargoReason  Embargo Reason  logical  required  text  n/a  n/a  closed  Author stipulation,Rare species,Landownership,Bad data,Other  Reason why the plot is embargoed.  This field, as all fields in this table, are private and cannot be viewed or downloaded by VegBank users.  Author stipulation  Plot Author requires that plot be embargoed  Rare Species  There are rare species on this plot whose exact location should not be revealed to all users.  Land Ownership  Land owner requires plot data to be embargoed  Bad Data  The data pertaining to this plot have been determined to have errors.  Other  None of the above reasons. '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'embargoReason',
                              'Author stipulation',
                              'Plot Author requires that plot be embargoed',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'embargoReason',
                              'Rare Species',
                              'There are rare species on this plot whose exact location should not be revealed to all users.',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'embargoReason',
                              'Land Ownership',
                              'Land owner requires plot data to be embargoed',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'embargoReason',
                              'Bad Data',
                              'The data pertaining to this plot have been determined to have errors.',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'embargoReason',
                              'Other',
                              'None of the above reasons.',
                              '99'
                       );
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'embargo',
        'embargoStart',
        'Embargo Start',
        'logical',
        'no',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Start date for the embargo.',
     
        ' embargo  Embargo on Plot  embargoStart  Embargo Start  logical  required  Date  n/a  n/a  no  n/a  Start date for the embargo. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'embargo',
        'embargoStop',
        'Embargo Stop',
        'logical',
        'no',
        'Date',
        'n/a',
        'n/a',
        'no',
        'n/a',
        'Stop date for the embargo.',
     
        ' embargo  Embargo on Plot  embargoStop  Embargo Stop  logical  required  Date  n/a  n/a  no  n/a  Stop date for the embargo. '
        
               );
                
               
            INSERT INTO dba_fieldDescription ( tableName, fieldName , fieldLabel , fieldModel , fieldNulls , fieldType , fieldKey , fieldReferences , fieldList , fieldNotes , fieldDefinition, fieldKeywords )
               values (
        'embargo',
        'defaultStatus',
        'Default Status',
        'logical',
        'no',
        'Integer',
        'n/a',
        'n/a',
        'closed',
        '0-6, according to confidStatus values',
        'Level of embargo for users that do not have special permission found in userPermission table.',
     
        ' embargo  Embargo on Plot  defaultStatus  Default Status  logical  required  Integer  n/a  n/a  closed  0-6, according to confidStatus values  Level of embargo for users that do not have special permission found in userPermission table.  0  Public  1  1 km radius  2  10 km radius  3  100 km radius  4  Location embargo  5  Public embargo on data  6  Full embargo on data '
        
               );
                
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'defaultStatus',
                              '0',
                              'Public',
                              '1'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'defaultStatus',
                              '1',
                              '1 km radius',
                              '2'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'defaultStatus',
                              '2',
                              '10 km radius',
                              '3'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'defaultStatus',
                              '3',
                              '100 km radius',
                              '4'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'defaultStatus',
                              '4',
                              'Location embargo',
                              '5'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'defaultStatus',
                              '5',
                              'Public embargo on data',
                              '6'
                       );
               
                     INSERT INTO dba_fieldlist ( tableName , fieldName , listValue , listValueDescription , listValueSortOrder )
                       values (
                             'embargo',
                              'defaultStatus',
                              '6',
                              'Full embargo on data',
                              '7'
                       );
               