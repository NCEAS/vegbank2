INSERT INTO stratum_temp
    (
        vb_ob_code,
        user_ob_code,
        user_sr_code,
        vb_sy_code, 
        stratumbase, 
        stratumheight, 
        stratumcover
    )
VALUES (%s, %s, %s, %s, %s, %s, %s);