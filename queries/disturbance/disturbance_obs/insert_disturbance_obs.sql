MERGE INTO disturbanceobs dst
USING disturbance_obs_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
      observation_id,
      disturbancetype,
      disturbanceintensity,
      disturbanceage,
      disturbanceextent,
      disturbancecomment
  ) VALUES (
    CAST(SUBSTRING(src.vb_ob_code, 4) AS INT),
    src.disturbancetype,
    src.disturbanceintensity,
    src.disturbanceage,
    src.disturbanceextent,
    src.disturbancecomment
  )
RETURNING merge_action(),
          src.user_do_code,
          dst.disturbanceobs_id,
          'do.' || dst.disturbanceobs_id AS vb_do_code;
