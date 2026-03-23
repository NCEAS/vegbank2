MERGE INTO covermethod dst
USING cover_method_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    reference_id,
    covertype,
    coverestimationmethod
  ) VALUES (
    CAST(SUBSTRING(vb_rf_code, 4) AS INT),
    covertype,
    coverestimationmethod
  )
RETURNING merge_action(),
          src.user_cm_code as user_cm_code,
          dst.covermethod_id,
          'cm.' || dst.covermethod_id AS vb_cm_code;
