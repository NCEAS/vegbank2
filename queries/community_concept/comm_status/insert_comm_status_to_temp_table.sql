-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO comm_status_temp
    (
        user_cc_code,
        vb_rf_code,
        user_rf_code,
        commconceptstatus,
        vb_parent_cc_code,
        user_parent_cc_code,
        commlevel,
        startdate,
        stopdate,
        commpartycomments,
        vb_py_code,
        user_py_code,
        user_cs_code,
        vb_cc_code
    )
VALUES (%s, %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s, %s);
