MERGE INTO stratum dst
USING stratum_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    observation_id,
    stratumtype_id,
    stratumheight,
    stratumbase,
    stratumcover
  ) VALUES (
    CAST(SUBSTRING(src.vb_ob_code, 4) AS INT),
    CAST(SUBSTRING(src.vb_sy_code, 4) AS INT),
    src.stratumheight,
    src.stratumbase,
    src.stratumcover
  )
RETURNING merge_action(),
          src.user_ob_code,
          src.user_sr_code,
          dst.stratum_id,
          'sr.' || dst.stratum_id AS vb_sr_code;