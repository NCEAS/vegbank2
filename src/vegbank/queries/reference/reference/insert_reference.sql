MERGE INTO reference dst
USING reference_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    doi,
    shortname,
    fulltext,
    url
  ) VALUES (
    doi,
    shortname,
    fulltext,
    url
  )
RETURNING merge_action(),
          src.user_rf_code,
          dst.reference_id,
          'rf.' || dst.reference_id AS vb_rf_code;