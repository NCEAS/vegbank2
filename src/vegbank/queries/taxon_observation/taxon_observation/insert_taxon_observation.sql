MERGE INTO taxonobservation dst
USING taxon_observation_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    observation_id,
    authorplantname,
    reference_id,
    taxoninferencearea,
    emb_taxonobservation
  ) VALUES (
    CAST(SUBSTRING(src.vb_ob_code, 4) AS INT),
    src.authorplantname,
    CAST(SUBSTRING(src.vb_rf_code, 4) AS INT),
    src.taxoninferencearea,
    0
  )
RETURNING merge_action(),
          src.user_to_code,
          dst.taxonobservation_id,
          'to.' || dst.taxonobservation_id AS vb_to_code;
