-- validate reference codes
SELECT stratum_method_temp.vb_rf_code 
    FROM stratum_method_temp LEFT JOIN reference
    ON stratum_method_temp.vb_rf_code = 'rf.' || reference.reference_id
WHERE reference.reference_id IS NULL
    AND stratum_method_temp.vb_rf_code IS NOT NULL;