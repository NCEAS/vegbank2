-- Ordering of input parameters is handled via list order in table_defs_config.py
INSERT INTO taxon_interpretation_temp
(
    user_ti_code,
    user_to_code,
    vb_to_code,
    vb_pc_code,
    interpretationdate,
    user_py_code,
    vb_py_code,
    user_ro_code,
    vb_ro_code,
    interpretationtype,
    user_rf_code,
    vb_rf_code,
    originalinterpretation,
    currentinterpretation,
    taxonfit,
    taxonconfidence,
    user_collector_rf_code,
    vb_collector_rf_code, -- This has no nonzero values currently
    collectionnumber,
    collectiondate,
    user_museum_rf_code,
    vb_museum_rf_code, -- This has no nonzero values currently
    museumaccessionnumber,
    grouptype,
    notes,
    notespublic,
    notesmgt
)
VALUES
(
    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
);