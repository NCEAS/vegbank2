----------------------------------------------------------------------------
-- Creates a procedure to populate the identifier table dynamically
----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE populate_identifiers()
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
      INSERT INTO identifier (vb_table_code, vb_record_id, identifier_type, identifier_value)
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