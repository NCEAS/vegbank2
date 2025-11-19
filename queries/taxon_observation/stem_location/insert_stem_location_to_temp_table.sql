INSERT INTO stem_location_temp
    (
        user_sl_code,
        vb_sc_code,
        stemcode, 
        stemxposition,
        stemyposition,
        stemhealth
    )
VALUES (%s, %s, %s, %s, %s, %s);