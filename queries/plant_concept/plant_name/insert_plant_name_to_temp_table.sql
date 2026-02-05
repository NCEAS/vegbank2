-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO plant_name_temp
    (
        plantname,
        user_pn_code
    )
VALUES (%s, %s);
