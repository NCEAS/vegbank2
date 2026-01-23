MERGE INTO commclass dst
USING comm_class_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    observation_id,
    classstartdate,
    classstopdate,
    inspection,
    tableanalysis,
    multivariateanalysis,
    expertsystem,
    classpublication_id,
    classnotes
  ) VALUES (
    CAST(SUBSTRING(src.vb_ob_code, 4) AS INT),
    src.classstartdate,
    src.classstopdate,
    src.inspection,
    src.tableanalysis,
    src.multivariateanalysis,
    src.expertsystem,
    CAST(SUBSTRING(src.vb_rf_code, 4) AS INT),
    src.classnotes
  )
RETURNING merge_action(),
          src.user_cl_code,
          dst.commclass_id,
          'cl.' || dst.commclass_id AS vb_cl_code;
