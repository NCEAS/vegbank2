----------------------------------------------------------------------------
-- Creates the identifier table for storing resource identifiers
----------------------------------------------------------------------------

CREATE TABLE identifiers (
  identifier_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vb_table_code TEXT NOT NULL, -- Code representing name of the table
  vb_record_id BIGINT NOT NULL, -- FK holding the PK of the resource
  identifier_type TEXT NOT NULL, -- e.g., AccessionCode, DOI, ORCID, ROR, LOCAL
  identifier_value TEXT NOT NULL, -- e.g., "vb.ob.1234.abcd", "10.1234/abcd", "0000-0002-1825-0097"
  UNIQUE (identifier_type, identifier_value) -- Prevent duplicate mappings
);

-- Create a mapping table to iterate over for the vb_code procedure
CREATE TABLE identifiers_source_map (
  source_table TEXT NOT NULL,   -- table name
  table_code   TEXT NOT NULL,   -- short code for the table
  pk_column    TEXT NOT NULL,   -- primary key column of the source table
  id_type      TEXT NOT NULL    -- identifier type (e.g., AccessionCode)
);

-- Create identifiers source map for procedures to iterate over
INSERT INTO identifiers_source_map (source_table, table_code, pk_column, id_type) VALUES
  ('aux_role', 'ar', 'role_id', 'accession_code'),
  ('commClass', 'cl', 'commclass_id', 'accession_code'),
  ('commConcept', 'cc', 'commconcept_id', 'accession_code'),
  ('commStatus', 'cs', 'commstatus_id', 'accession_code'),
  ('coverMethod', 'cm', 'covermethod_id', 'accession_code'),
  ('namedPlace', 'np', 'namedplace_id', 'accession_code'),
  ('observation', 'ob', 'observation_id', 'accession_code'),
  ('party', 'py', 'party_id', 'accession_code'),
  ('plantConcept', 'pc', 'plantconcept_id', 'accession_code'),
  ('plantStatus', 'ps', 'plantstatus_id', 'accession_code'),
  ('plot', 'pl', 'plot_id', 'accession_code'),
  ('project', 'pj', 'project_id', 'accession_code'),
  ('reference', 'rf', 'reference_id', 'accession_code'),
  ('referenceJournal', 'rj', 'referencejournal_id', 'accession_code'),
  ('referenceParty', 'rp', 'referenceparty_id', 'accession_code'),
  ('soilTaxon', 'st', 'soiltaxon_id', 'accession_code'),
  ('stratumMethod', 'sm', 'stratummethod_id', 'accession_code'),
  ('taxonObservation', 'to', 'taxonobservation_id', 'accession_code'),
  ('taxonInterpretation', 'ti', 'taxoninterpretation_id', 'accession_code'),
  ('userDefined', 'ud', 'userdefined_id', 'accession_code'),
  ('aux_role', 'ar', 'role_id', 'vb_code'),
  ('commClass', 'cl', 'commclass_id', 'vb_code'),
  ('commConcept', 'cc', 'commconcept_id', 'vb_code'),
  ('commStatus', 'cs', 'commstatus_id', 'vb_code'),
  ('coverMethod', 'cm', 'covermethod_id', 'vb_code'),
  ('namedPlace', 'np', 'namedplace_id', 'vb_code'),
  ('observation', 'ob', 'observation_id', 'vb_code'),
  ('party', 'py', 'party_id', 'vb_code'),
  ('plantConcept', 'pc', 'plantconcept_id', 'vb_code'),
  ('plantStatus', 'ps', 'plantstatus_id', 'vb_code'),
  ('plot', 'pl', 'plot_id', 'vb_code'),
  ('project', 'pj', 'project_id', 'vb_code'),
  ('reference', 'rf', 'reference_id', 'vb_code'),
  ('soilTaxon', 'st', 'soiltaxon_id', 'vb_code'),
  ('stratumMethod', 'sm', 'stratummethod_id', 'vb_code'),
  ('stratumType', 'sy', 'stratumtype_id', 'vb_code'),
  ('taxonObservation', 'to', 'taxonobservation_id', 'vb_code'),
  ('taxonInterpretation', 'ti', 'taxoninterpretation_id', 'vb_code');