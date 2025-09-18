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

-- Create procedure to insert new vb_codes for the tables above
CREATE OR REPLACE PROCEDURE populate_vb_code_identifiers()
LANGUAGE plpgsql -- PL/pgSQL is used for dynamic or iterative logic, rather than a static query
AS $$ -- Begin body of the procedure
DECLARE -- Declare variables
  r RECORD; -- Holds one row at a time from the 'identifier_source_map'
  sql TEXT; -- Holds the dynamically built SQL string
BEGIN
  FOR r IN SELECT * FROM vb_code_source_map LOOP
    -- Use Postgres' format() function to safely build a SQL statement
    -- Dollar-quoting (\$f\$ ... \$f\$) makes it easier to write multi-line SQL
    -- without escaping single quotes; \$f\$ could also be written as \$\$
    sql := format($f$
      -- := assigns the string result from format() to the variable sql
      INSERT INTO identifiers (vb_table_code, vb_record_id, identifier_type, identifier_value)
      SELECT
        %L,               -- table code string: e.g., 'pl'
        %I,               -- PK column name: e.g., plot_id
        %L,               -- identifier type: e.g., 'accessioncode'
        %L || '.' || %I   -- build identifier_value: e.g. 'pl' || '.' || plot_id
      FROM %s             -- table name: e.g., plot
      WHERE accessionCode IS NOT NULL
      ON CONFLICT (identifier_type, identifier_value) DO NOTHING;
    $f$, r.table_code, r.pk_column, r.id_type,
         r.table_code, r.pk_column, r.source_table);
    EXECUTE sql; -- Run the dynamically built query
  END LOOP;
END$$;

CALL populate_vb_code_identifiers();