MERGE INTO stratumtype dst
USING stratum_type_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    stratummethod_id,
    stratumindex,
    stratumname,
    stratumdescription
  ) VALUES (
    CAST(SUBSTRING(vb_sm_code, 4) AS INT),
    stratumindex,
    stratumname,
    stratumdescription
  )
RETURNING merge_action(),
          src.user_st_code as user_st_code,
          dst.stratumtype_id,
          'st.' || dst.stratumtype_id AS vb_st_code;