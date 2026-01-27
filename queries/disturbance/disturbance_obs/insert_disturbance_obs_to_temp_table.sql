-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO disturbance_obs_temp
    (
        -- user-supplied fields:
        user_ob_code,
        user_do_code,
        disturbancetype,
        disturbanceintensity,
        disturbanceage,
        disturbanceextent,
        disturbancecomment,
        -- api-augmented fields:
        vb_ob_code
    )
VALUES (%s, %s, %s, %s,
        %s, %s, %s, %s);
