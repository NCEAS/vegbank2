MERGE INTO plantstatus dst
USING plant_status_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    plantconcept_id,
    reference_id,
    plantconceptstatus,
    plantparent_id,
    plantlevel,
    startdate,
    stopdate,
    plantpartycomments,
    party_id
  ) VALUES (
    CAST(SUBSTRING(src.vb_pc_code, 4) AS INT),
    CAST(SUBSTRING(src.vb_rf_code, 4) AS INT),
    src.plantconceptstatus,
    CAST(SUBSTRING(src.vb_parent_pc_code, 4) AS INT),
    src.plantlevel,
    src.startdate,
    src.stopdate,
    src.plantpartycomments,
    CAST(SUBSTRING(src.vb_py_code, 4) AS INT)
  )
RETURNING merge_action(),
          src.user_pc_code as user_ps_code,
          dst.plantstatus_id,
          'ps.' || dst.plantstatus_id AS vb_ps_code;
