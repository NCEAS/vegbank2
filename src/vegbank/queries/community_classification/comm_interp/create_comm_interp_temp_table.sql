CREATE TEMPORARY TABLE comm_interp_temp(
    user_cl_code TEXT,
    vb_cc_code TEXT NOT NULL,
    classfit CHARACTER VARYING(50),
    classconfidence CHARACTER VARYING(15),
    vb_rf_code TEXT,
    user_rf_code TEXT,
    notes TEXT,
    type BOOLEAN,
    nomenclaturaltype BOOLEAN,
    user_ci_code TEXT NOT NULL,
    vb_cl_code TEXT NOT NULL
);
