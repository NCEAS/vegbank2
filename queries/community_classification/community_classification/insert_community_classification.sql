MERGE INTO commclass dst
USING community_classification_temp src
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
    classnotes,
    classpublication_id
  ) VALUES (
    CAST(SUBSTRING(vb_ob_code, 4) AS INT),
    classstartdate,
    classstopdate,
    inspection,
    tableanalysis,
    multivariateanalysis,
    expertsystem,
    classnotes,
    CAST(SUBSTRING(vb_comm_class_rf_code, 4) AS INT)
  )
RETURNING merge_action(),
          src.user_cl_code,
          dst.commclass_id,
          'cl.' || dst.commclass_id AS vb_cl_code;