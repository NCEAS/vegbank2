CREATE TEMPORARY TABLE plant_status_temp(
    user_pc_code TEXT NOT NULL,
    vb_rf_code TEXT,
    user_rf_code TEXT,
    plantconceptstatus character varying(20) NOT NULL,
    vb_parent_pc_code TEXT,
    user_parent_pc_code TEXT,
    plantlevel character varying(80),
    startdate timestamp with time zone NOT NULL,
    stopdate timestamp with time zone,
    plantpartycomments TEXT,
    vb_py_code TEXT,
    user_py_code TEXT,
    user_ps_code TEXT NOT NULL,
    vb_pc_code TEXT NOT NULL
) ON COMMIT DROP;
