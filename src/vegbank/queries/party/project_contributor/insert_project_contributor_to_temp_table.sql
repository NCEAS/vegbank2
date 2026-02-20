INSERT INTO project_contributor_temp
    (
        user_cr_code,
        user_py_code,
        vb_ar_code,
        contributor_type,
        record_identifier,
        vb_record_identifier, 
        vb_py_code
    )
VALUES (%s, %s, %s, %s, %s, %s, %s);