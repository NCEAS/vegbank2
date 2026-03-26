-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO taxon_interpretation_temp
(
    user_ti_code,
    vb_pc_code,
    interpretationdate,
    user_py_code,
    vb_py_code,
    vb_ar_code,
    interpretationtype,
    user_rf_code,
    vb_rf_code,
    originalinterpretation,
    currentinterpretation,
    taxonfit,
    taxonconfidence,
    user_collector_py_code,
    vb_collector_py_code,
    collectionnumber,
    collectiondate,
    user_museum_py_code,
    vb_museum_py_code,
    museumaccessionnumber,
    grouptype,
    notes,
    user_to_code,
    vb_to_code
)
VALUES
(
    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
);
