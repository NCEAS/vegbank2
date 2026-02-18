-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO plant_status_temp
    (
        user_pc_code,
        vb_rf_code,
        user_rf_code,
        plantconceptstatus,
        vb_parent_pc_code,
        user_parent_pc_code,
        plantlevel,
        startdate,
        stopdate,
        plantpartycomments,
        vb_py_code,
        user_py_code,
        user_ps_code,
        vb_pc_code
    )
VALUES (%s, %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s, %s);
