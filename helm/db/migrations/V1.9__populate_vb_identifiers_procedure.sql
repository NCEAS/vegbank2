----------------------------------------------------------------------------
-- Creates a procedure to populate the identifiers table dynamically
-- with the new 'vb_code' identifier_type
----------------------------------------------------------------------------

CREATE VIEW vb_code_source_map AS
SELECT * FROM identifiers_source_map WHERE id_type = 'vb_code';

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
      ON CONFLICT (identifier_type, identifier_value) DO NOTHING;
    $f$, r.table_code, r.pk_column, r.id_type,
         r.table_code, r.pk_column, r.source_table);
    EXECUTE sql; -- Run the dynamically built query
  END LOOP;
END$$;

CALL populate_vb_code_identifiers();