----------------------------------------------------------------------------
-- Creates a procedure to populate the identifiers table dynamically
-- with the new vb_code identifier_type
----------------------------------------------------------------------------

-- Creates a mapping table to iterate over for the vb_code procedure
CREATE TABLE IF NOT EXISTS vb_code_source_map (
  source_table TEXT NOT NULL,   -- table name
  table_code   TEXT NOT NULL,   -- short code for the table
  pk_column    TEXT NOT NULL,   -- primary key column of the source table
  id_type      TEXT NOT NULL    -- identifier type (e.g., AccessionCode)
);

-- Manually insert the required vb_code table data
INSERT INTO vb_code_source_map (source_table, table_code, pk_column, id_type) VALUES
  ('aux_role', 'ar', 'role_id', 'vb_code'),
  ('commClass', 'ci', 'commclass_id', 'vb_code'),
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
  ('stratumType', 'sy', 'stratummethod_id', 'vb_code'),
  ('taxonObservation', 'to', 'taxonobservation_id', 'vb_code'),
  ('taxonInterpretation', 'ti', 'taxoninterpretation_id', 'vb_code')
ON CONFLICT DO NOTHING;

