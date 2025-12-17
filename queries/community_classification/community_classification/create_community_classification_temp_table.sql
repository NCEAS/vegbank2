CREATE TEMPORARY TABLE community_classification_temp(
    user_ob_code TEXT NOT NULL,
    vb_ob_code TEXT NOT NULL,
    user_cl_code TEXT NOT NULL,
    classstartdate TIMESTAMP WITH TIME ZONE,
    classstopdate TIMESTAMP WITH TIME ZONE,
    inspection BOOLEAN,
    tableanalysis BOOLEAN,
    multivariateanalysis BOOLEAN,
    expertsystem TEXT,
    classnotes TEXT,
    user_comm_class_rf_code TEXT,
    vb_comm_class_rf_code TEXT
);