MERGE INTO projectcontributor dst
USING project_contributor_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    project_id,
    party_id,
    role_id
  ) VALUES (
    CAST(SUBSTRING(vb_record_identifier, 4)AS INT),
    CAST(SUBSTRING(vb_py_code, 4) AS INT),
    CAST(SUBSTRING(vb_rl_code, 4) AS INT)
  )
RETURNING merge_action(),
          src.user_cr_code,
          dst.projectcontributor_id,
          'cr.' || dst.projectcontributor_id AS vb_cr_code;