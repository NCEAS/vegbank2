-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO comm_class_temp
    (
        user_ob_code,
        user_cl_code,
        classstartdate,
        classstopdate,
        inspection,
        tableanalysis,
        multivariateanalysis,
        expertsystem,
        vb_rf_code,
        user_rf_code,
        classnotes,
        vb_ob_code
    )
VALUES (%s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s);
