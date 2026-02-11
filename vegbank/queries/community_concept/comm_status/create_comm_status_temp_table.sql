CREATE TEMPORARY TABLE comm_status_temp(
    user_cc_code TEXT NOT NULL,
    vb_rf_code TEXT,
    user_rf_code TEXT,
    commconceptstatus character varying(20) NOT NULL,
    vb_parent_cc_code TEXT,
    user_parent_cc_code TEXT,
    commlevel character varying(80),
    startdate timestamp with time zone NOT NULL,
    stopdate timestamp with time zone,
    commpartycomments TEXT,
    vb_py_code TEXT,
    user_py_code TEXT,
    user_cs_code TEXT NOT NULL,
    vb_cc_code TEXT NOT NULL
);
