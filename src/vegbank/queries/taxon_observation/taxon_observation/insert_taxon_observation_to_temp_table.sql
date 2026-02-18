-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO taxon_observation_temp
    (
        user_to_code,
        user_ob_code,
        vb_ob_code,
        authorplantname,
        vb_rf_code,
        taxoninferencearea
    )
VALUES (%s, %s, %s, %s, %s, %s);