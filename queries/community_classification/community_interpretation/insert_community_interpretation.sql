MERGE INTO comminterpretation dst
USING community_interpretation_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    commconcept_id,
    commclass_id,
    classfit,
    classconfidence,
    notes
  ) VALUES (
    CAST(SUBSTRING(vb_cc_code, 4) AS INT),
    CAST(SUBSTRING(vb_cl_code, 4) AS INT),
    classfit,
    classconfidence,
    interpnotes
  )
RETURNING merge_action(),
          src.user_ci_code,
          dst.comminterpretation_id,
          'ci.' || dst.comminterpretation_id AS vb_ci_code;