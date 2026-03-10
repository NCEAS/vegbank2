MERGE INTO stemcount dst
USING stem_count_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    taxonimportance_id,
    stemcount,
    stemdiameter,
    stemdiameteraccuracy,
    stemheight,
    stemheightaccuracy,
    stemtaxonarea,
    emb_stemcount
  ) VALUES (
    CAST(SUBSTRING(vb_tm_code, 4) AS INT),
    stemcount,
    stemdiameter,
    stemdiameteraccuracy,
    stemheight,
    stemheightaccuracy,
    stemtaxonarea,
    0
  )
RETURNING merge_action(),
          src.user_sc_code,
          dst.stemcount_id,
          'sc.' || dst.stemcount_id AS vb_sc_code;
