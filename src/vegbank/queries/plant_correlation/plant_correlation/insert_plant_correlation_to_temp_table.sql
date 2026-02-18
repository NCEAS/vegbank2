-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO plant_correlation_temp
    (
        -- user-supplied fields:
        user_pc_code,
        vb_correlated_pc_code,
        user_correlated_pc_code,
        plantconvergence,
        correlationstart,
        correlationstop,
        -- api-augmented fields:
        vb_pc_code,
        user_px_code
    )
VALUES (%s, %s, %s, %s,
        %s, %s, %s, %s);
