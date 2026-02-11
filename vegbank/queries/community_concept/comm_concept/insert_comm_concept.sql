MERGE INTO commconcept dst
USING comm_concept_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    commname_id,
    reference_id,
    commname,
    commdescription
  ) VALUES (
    CAST(SUBSTRING(src.vb_cn_code, 4) AS INT),
    CAST(SUBSTRING(src.vb_rf_code, 4) AS INT),
    src.commname,
    src.commdescription
  )
RETURNING merge_action(),
          src.user_cc_code,
          dst.commconcept_id,
          'cc.' || dst.commconcept_id AS vb_cc_code;
