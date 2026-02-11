MERGE INTO taxonimportance dst
USING taxon_importance_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    taxonobservation_id,
    stratum_id,
    cover,
    basalarea,
    biomass,
    inferencearea
  ) VALUES (
    CAST(SUBSTRING(vb_to_code, 4) AS INT),
    CAST(SUBSTRING(vb_sr_code, 4) AS INT),
    cover,
    basalarea,
    biomass,
    inferencearea
  )
RETURNING merge_action(),
          src.user_tm_code,
          dst.taxonimportance_id,
          'tm.' || dst.taxonimportance_id AS vb_tm_code;