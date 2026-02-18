-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO comm_name_temp
    (
        commname,
        user_cn_code
    )
VALUES (%s, %s);
