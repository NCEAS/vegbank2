-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO comm_concept_temp
    (
        user_cc_code,
        user_rf_code,
        vb_rf_code,
        commname,
        commdescription,
        vb_cn_code
    )
VALUES (%s, %s, %s, %s, %s, %s);
