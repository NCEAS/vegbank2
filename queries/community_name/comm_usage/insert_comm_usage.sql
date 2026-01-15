MERGE INTO commusage dst
USING comm_usage_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    commname_id,
    commname,
    commconcept_id,
    usagestart,
    usagestop,
    commnamestatus,
    classsystem,
    party_id,
    commstatus_id
  ) VALUES (
    CAST(SUBSTRING(src.vb_cn_code, 4) AS INT),
    src.commname,
    CAST(SUBSTRING(src.vb_cc_code, 4) AS INT),
    src.usagestart,
    src.usagestop,
    src.commnamestatus,
    src.classsystem,
    CAST(SUBSTRING(src.vb_py_code, 4) AS INT),
    CAST(SUBSTRING(src.vb_cs_code, 4) AS INT)
  )
RETURNING merge_action(),
          src.user_cu_code as user_cu_code,
          dst.commusage_id,
          'cu.' || dst.commusage_id AS vb_cu_code;
