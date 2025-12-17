INSERT INTO community_classification_temp (
    user_ob_code,
    vb_ob_code,
    user_cl_code,
    classstartdate,
    classstopdate,
    inspection,
    tableanalysis,
    multivariateanalysis,
    expertsystem,
    classnotes,
    user_comm_class_rf_code,
    vb_comm_class_rf_code
)
VALUES(
    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
);