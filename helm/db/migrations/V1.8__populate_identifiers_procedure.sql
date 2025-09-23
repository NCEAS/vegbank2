----------------------------------------------------------------------------
-- Creates a procedure to populate the identifiers table dynamically
-- with the 'accession_code' identifier_type
----------------------------------------------------------------------------

-- Create a mapping table to iterate over for an the identifier import procedure
CREATE TABLE identifier_source_map (
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
  ('userDefined', 'ud', 'userdefined_id', 'accession_code');

CREATE OR REPLACE PROCEDURE populate_acc_code_identifiers()
LANGUAGE plpgsql -- PL/pgSQL is used for dynamic or iterative logic, rather than a static query
AS $$ -- Begin body of the procedure
DECLARE -- Declare variables
  r RECORD; -- Holds one row at a time from the 'identifier_source_map'
  sql TEXT; -- Holds the dynamically built SQL string
BEGIN
  FOR r IN SELECT * FROM identifier_source_map LOOP
    -- Use Postgres' format() function to safely build a SQL statement
    -- Dollar-quoting (\$f\$ ... \$f\$) makes it easier to write multi-line SQL
    -- without escaping single quotes; \$f\$ could also be written as \$\$
    sql := format($f$
      -- := assigns the string result from format() to the variable sql
      INSERT INTO identifiers (vb_table_code, vb_record_id, identifier_type, identifier_value)
      SELECT
        %L,    -- literal (adds quotes, escapes safely): table code string (e.g., 'pl')
        %I,    -- identifier (column names): PK column name (e.g., plot_id)
        %L,    -- literal (adds quotes, escapes safely): identifier type (e.g., 'accessioncode')
        accessionCode
      FROM %s  -- raw substitution: table name (e.g., plot)
      WHERE accessionCode IS NOT NULL
      ON CONFLICT (identifier_type, identifier_value) DO NOTHING;
    $f$, r.table_code, r.pk_column, r.id_type, r.source_table);
    EXECUTE sql; -- Run the dynamically built query
  END LOOP;
END$$;

CALL populate_acc_code_identifiers();