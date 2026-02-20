CREATE TEMPORARY TABLE comm_class_temp(
    user_ob_code TEXT,
    user_cl_code TEXT NOT NULL,
    classstartdate TIMESTAMP WITH TIME ZONE,
    classstopdate TIMESTAMP WITH TIME ZONE,
    inspection BOOLEAN,
    tableanalysis BOOLEAN,
    multivariateanalysis BOOLEAN,
    expertsystem TEXT,
    vb_rf_code TEXT,
    user_rf_code TEXT,
    classnotes TEXT,
    vb_ob_code TEXT NOT NULL
);
