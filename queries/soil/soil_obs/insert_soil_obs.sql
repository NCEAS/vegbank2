MERGE INTO soilobs dst
USING soil_obs_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
      observation_id,
      soilhorizon,
      soildepthtop,
      soildepthbottom,
      soilcolor,
      soilorganic,
      soiltexture,
      soilsand,
      soilsilt,
      soilclay,
      soilcoarse,
      soilph,
      exchangecapacity,
      basesaturation,
      soildescription
  ) VALUES (
    CAST(SUBSTRING(src.vb_ob_code, 4) AS INT),
    src.soilhorizon,
    src.soildepthtop,
    src.soildepthbottom,
    src.soilcolor,
    src.soilorganic,
    src.soiltexture,
    src.soilsand,
    src.soilsilt,
    src.soilclay,
    src.soilcoarse,
    src.soilph,
    src.exchangecapacity,
    src.basesaturation,
    src.soildescription
  )
RETURNING merge_action(),
          src.user_so_code,
          dst.soilobs_id,
          'so.' || dst.soilobs_id AS vb_so_code;
