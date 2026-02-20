MERGE INTO plantusage dst
USING plant_usage_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    plantname_id,
    plantname,
    plantconcept_id,
    usagestart,
    usagestop,
    plantnamestatus,
    classsystem,
    party_id,
    plantstatus_id
  ) VALUES (
    CAST(SUBSTRING(src.vb_pn_code, 4) AS INT),
    src.plantname,
    CAST(SUBSTRING(src.vb_pc_code, 4) AS INT),
    src.usagestart,
    src.usagestop,
    src.plantnamestatus,
    src.classsystem,
    CAST(SUBSTRING(src.vb_py_code, 4) AS INT),
    CAST(SUBSTRING(src.vb_ps_code, 4) AS INT)
  )
RETURNING merge_action(),
          src.user_pu_code as user_pu_code,
          dst.plantusage_id,
          'pu.' || dst.plantusage_id AS vb_pu_code;
