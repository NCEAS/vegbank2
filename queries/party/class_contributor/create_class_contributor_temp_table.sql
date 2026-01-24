CREATE TEMPORARY TABLE class_contributor_temp
    (
        user_cr_code TEXT NOT NULL,
        user_py_code TEXT NOT NULL,
        vb_rl_code TEXT,
        contributor_type TEXT NOT NULL,
        record_identifier TEXT NOT NULL,
        vb_record_identifier TEXT, 
        vb_py_code TEXT
    );