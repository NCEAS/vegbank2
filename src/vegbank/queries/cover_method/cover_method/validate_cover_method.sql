SELECT cover_method_temp.vb_rf_code 
    FROM cover_method_temp LEFT JOIN reference
    ON cover_method_temp.vb_rf_code = 'rf.' || reference.reference_id
WHERE reference.reference_id IS NULL
    AND cover_method_temp.vb_rf_code IS NOT NULL;