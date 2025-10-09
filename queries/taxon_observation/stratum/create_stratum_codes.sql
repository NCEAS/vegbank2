INSERT INTO identifier 
(
    vb_record_id,
    vb_table_code,
    identifier_type,
    identifier_value
)
VALUES
(
    %s, %s, %s, %s
)
RETURNING identifier_id;