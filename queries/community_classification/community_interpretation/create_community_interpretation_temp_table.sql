CREATE TEMPORARY TABLE community_interpretation_temp(
    user_ci_code TEXT NOT NULL,
    vb_cl_code TEXT NOT NULL,
    vb_cc_code TEXT NOT NULL,
    classfit character varying(50),
    classconfidence character varying(15),
    interpnotes TEXT
);