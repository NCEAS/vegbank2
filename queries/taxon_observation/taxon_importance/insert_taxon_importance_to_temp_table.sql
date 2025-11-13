INSERT INTO taxon_importance_temp
    (
        user_tm_code,
        vb_to_code,
        vb_sr_code,
        cover,
        basalarea,
        biomass,
        inferencearea
    )
VALUES (%s, %s, %s, %s, %s, %s, %s);