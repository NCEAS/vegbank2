-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO comm_usage_temp
    (
        -- user-supplied fields:
        user_cc_code,
        commname,
        classsystem,
        commnamestatus,
        usagestart,
        usagestop,
        vb_py_code,
        user_py_code,
        -- api-augmented fields:
        vb_cc_code,
        vb_cs_code,
        vb_cn_code,
        user_cu_code
    )
VALUES (%s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s);
