MERGE INTO commstatus dst
USING comm_status_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    commconcept_id,
    reference_id,
    commconceptstatus,
    commparent_id,
    commlevel,
    startdate,
    stopdate,
    commpartycomments,
    party_id
  ) VALUES (
    CAST(SUBSTRING(src.vb_cc_code, 4) AS INT),
    CAST(SUBSTRING(src.vb_rf_code, 4) AS INT),
    src.commconceptstatus,
    CAST(SUBSTRING(src.vb_parent_cc_code, 4) AS INT),
    src.commlevel,
    src.startdate,
    src.stopdate,
    src.commpartycomments,
    CAST(SUBSTRING(src.vb_py_code, 4) AS INT)
  )
RETURNING merge_action(),
          src.user_cc_code as user_cs_code,
          dst.commstatus_id,
          'cs.' || dst.commstatus_id AS vb_cs_code;
