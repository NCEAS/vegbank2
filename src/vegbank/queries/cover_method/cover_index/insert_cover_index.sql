MERGE INTO coverindex dst
USING cover_index_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    covermethod_id,
    covercode,
    upperlimit,
    lowerlimit,
    coverpercent,
    indexdescription
  ) VALUES (
    CAST(SUBSTRING(vb_cm_code, 4) AS INT),
    covercode,
    upperlimit,
    lowerlimit,
    coverpercent,
    indexdescription
  )
RETURNING merge_action(),
          src.user_ci_code as user_ci_code,
          dst.coverindex_id,
          'ci.' || dst.coverindex_id AS vb_ci_code;
