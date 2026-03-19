CREATE TEMPORARY TABLE plant_usage_temp(
    -- user-supplied fields:
    user_pc_code TEXT NOT NULL,
    plantname TEXT,
    classsystem character varying(50),
    plantnamestatus character varying(20),
    usagestart timestamp with time zone,
    usagestop timestamp with time zone,
    vb_py_code TEXT,
    user_py_code TEXT,
    -- api-augmented fields:
    vb_pc_code TEXT NOT NULL,
    vb_ps_code TEXT NOT NULL,
    vb_pn_code TEXT NOT NULL,
    user_pu_code TEXT NOT NULL
);
