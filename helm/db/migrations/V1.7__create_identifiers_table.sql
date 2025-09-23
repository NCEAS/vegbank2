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


-- Creates a mapping table to iterate over for an the identifier import procedure
CREATE TABLE IF NOT EXISTS identifier_source_map (
  source_table TEXT NOT NULL,   -- table name
  table_code   TEXT NOT NULL,   -- short code for the table
  pk_column    TEXT NOT NULL,   -- primary key column of the source table
  id_type      TEXT NOT NULL    -- identifier type (e.g., AccessionCode)
);

-- Manually insert the mapping data
INSERT INTO identifier_source_map (source_table, table_code, pk_column, id_type) VALUES
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
  ('userDefined', 'ud', 'userdefined_id', 'accession_code')
ON CONFLICT DO NOTHING;