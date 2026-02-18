-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO plant_usage_temp
    (
        -- user-supplied fields:
        user_pc_code,
        plantname,
        classsystem,
        plantnamestatus,
        usagestart,
        usagestop,
        vb_py_code,
        user_py_code,
        -- api-augmented fields:
        vb_pc_code,
        vb_ps_code,
        vb_pn_code,
        user_pu_code
    )
VALUES (%s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s);
