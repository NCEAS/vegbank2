MERGE INTO comminterpretation dst
USING comm_interp_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    commclass_id,
    commconcept_id,
    classfit,
    classconfidence,
    commauthority_id,
    notes,
    type,
    nomenclaturaltype
  ) VALUES (
    CAST(SUBSTRING(src.vb_cl_code, 4) AS INT),
    CAST(SUBSTRING(src.vb_cc_code, 4) AS INT),
    src.classfit,
    src.classconfidence,
    CAST(SUBSTRING(src.vb_rf_code, 4) AS INT),
    src.notes,
    src.type,
    src.nomenclaturaltype
  )
RETURNING merge_action(),
          src.user_ci_code as user_ci_code,
          dst.comminterpretation_id,
          'ci.' || dst.comminterpretation_id AS vb_ci_code;
