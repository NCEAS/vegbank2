MERGE INTO party dst
USING party_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    surname,
    givenname,
    middlename,
    organizationname,
    email,
    d_obscount
  ) VALUES (
    src.surname,
    src.givenname,
    src.middlename,
    src.organizationname,
    src.email,
    0
  )
RETURNING merge_action(),
          src.user_py_code,
          dst.party_id,
          'py.' || dst.party_id AS vb_py_code;
