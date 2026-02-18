MERGE INTO stemlocation dst
USING stem_location_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    stemcount_id,
    stemcode, 
    stemxposition,
    stemyposition,
    stemhealth
  ) VALUES (
    CAST(SUBSTRING(vb_sc_code, 4) AS INT),
    stemcode, 
    stemxposition,
    stemyposition,
    stemhealth
  )
RETURNING merge_action(),
          src.user_sl_code,
          dst.stemlocation_id,
          'sl.' || dst.stemlocation_id AS vb_sl_code;