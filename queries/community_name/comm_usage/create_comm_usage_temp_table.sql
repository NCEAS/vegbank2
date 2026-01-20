CREATE TEMPORARY TABLE comm_usage_temp(
    -- user-supplied fields:
    user_cc_code TEXT NOT NULL,
    commname TEXT,
    classsystem character varying(50),
    commnamestatus character varying(20),
    usagestart timestamp with time zone,
    usagestop timestamp with time zone,
    vb_py_code TEXT,
    user_py_code TEXT,
    -- api-augmented fields:
    vb_cc_code TEXT NOT NULL,
    vb_cs_code TEXT NOT NULL,
    vb_cn_code TEXT NOT NULL,
    user_cu_code TEXT NOT NULL
);
