CREATE TEMPORARY TABLE taxon_interpretation_temp(
    user_ti_code TEXT NOT NULL,
    user_to_code TEXT NOT NULL,
    vb_to_code TEXT NOT NULL,
    vb_pc_code TEXT NOT NULL,
    interpretationdate timestamp with time zone NOT NULL,
    user_py_code TEXT,
    vb_py_code TEXT,
    user_ro_code TEXT,
    vb_ro_code TEXT,
    interpretationtype character varying(30),
    user_rf_code TEXT,
    vb_rf_code TEXT,
    originalinterpretation boolean NOT NULL,
    currentinterpretation boolean NOT NULL,
    taxonfit character varying(50),
    taxonconfidence character varying(50),
    user_collector_rf_code TEXT,
    vb_collector_rf_code TEXT, -- This has no nonzero values currently
    collectionnumber character varying(100),
    collectiondate timestamp with time zone,
    user_museum_rf_code TEXT,
    vb_museum_rf_code TEXT, -- This has no nonzero values currently
    museumaccessionnumber character varying(100),
    grouptype character varying(20),
    notes text,
    notespublic boolean,
    notesmgt boolean
);