DELETE FROM stratum_method_temp 
WHERE stratum_method_temp.user_code IN (
SELECT 
    stratum_method_temp.user_code
FROM stratum_method_temp 
LEFT JOIN stratummethod on 
    stratum_method_temp.user_code = 'sm.' || stratummethod.stratummethod_id
WHERE 
    stratummethod.stratummethod_id IS NOT NULL
) RETURNING stratum_method_temp.user_code, stratum_method_temp.stratummethodname;


-- validate reference codes
SELECT 
    nonnullrefcodes.user_code, nonnullrefcodes.rf_code
FROM
(SELECT 
    stratum_method_temp.user_code, stratum_method_temp.rf_code
FROM stratum_method_temp
WHERE rf_code IS NOT NULL) AS nonnullrefcodes
LEFT JOIN reference
ON nonnullrefcodes.rf_code = 'rf.' || reference.reference_id
WHERE reference.reference_id IS NULL;
