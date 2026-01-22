----------------------------------------------------------------------------
-- Update the 'identifiers_source_map' table with a missing table and then
-- re-execute procedures to populate 'identifiers' table
----------------------------------------------------------------------------

-- Add missing mapping rows
INSERT INTO identifiers_source_map (source_table, table_code, pk_column, id_type)
VALUES
  ('userdataset', 'ud', 'userdataset_id', 'accession_code'),
  ('userdataset', 'ud', 'userdataset_id', 'vb_code')
ON CONFLICT DO NOTHING;

-- Call procedures (which can handle conflicts)
CALL populate_acc_code_identifiers();
CALL populate_vb_code_identifiers();