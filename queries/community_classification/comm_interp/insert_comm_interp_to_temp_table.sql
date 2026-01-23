-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO comm_interp_temp
    (
        user_cl_code,
        vb_cc_code,
        classfit,
        classconfidence,
        vb_rf_code,
        user_rf_code,
        notes,
        type,
        nomenclaturaltype,
        user_ci_code,
        vb_cl_code
    )
VALUES (%s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s);
