-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO plant_concept_temp
    (
        user_pc_code,
        user_rf_code,
        vb_rf_code,
        plantname,
        plantdescription,
        vb_pn_code
    )
VALUES (%s, %s, %s, %s, %s, %s);
