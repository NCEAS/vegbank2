MERGE INTO stratummethod dst
USING stratum_method_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    reference_id,
    stratummethodname,
    stratummethoddescription,
    stratumassignment
  ) VALUES (
    CAST(SUBSTRING(vb_rf_code, 4) AS INT),
    stratummethodname,
    stratummethoddescription,
    stratumassignment
  )
RETURNING merge_action(),
          src.user_sm_code as user_sm_code,
          dst.stratummethod_id,
          'sm.' || dst.stratummethod_id AS vb_sm_code;