-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO comm_correlation_temp
    (
        -- user-supplied fields:
        user_cc_code,
        vb_correlated_cc_code,
        user_correlated_cc_code,
        commconvergence,
        correlationstart,
        correlationstop,
        -- api-augmented fields:
        vb_cc_code,
        user_cx_code
    )
VALUES (%s, %s, %s, %s,
        %s, %s, %s, %s);
