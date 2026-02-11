-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO soil_obs_temp
    (
        -- user-supplied fields:
        user_ob_code,
        user_so_code,
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
        soildescription,
        -- api-augmented fields:
        vb_ob_code
    )
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s, %s, %s);
