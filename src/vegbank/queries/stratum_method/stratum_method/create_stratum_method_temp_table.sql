CREATE TEMPORARY TABLE stratum_method_temp(
    user_sm_code TEXT NOT NULL,
    user_rf_code TEXT,
    vb_rf_code TEXT,
    stratummethodname TEXT NOT NULL,
    stratummethoddescription TEXT,
    stratumassignment TEXT
) ON COMMIT DROP;