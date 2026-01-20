DELETE FROM cover_method_temp 
WHERE cover_method_temp.user_code IN (
SELECT 
    cover_method_temp.user_code
FROM cover_method_temp 
LEFT JOIN covermethod on 
    cover_method_temp.user_code = 'cm.' || covermethod.covermethod_id
WHERE 
    covermethod.covermethod_id IS NOT NULL
) RETURNING cover_method_temp.user_code, cover_method_temp.covertype;


-- validate reference codes
SELECT 
    nonnullrefcodes.user_code, nonnullrefcodes.rf_code
FROM
(SELECT 
    cover_method_temp.user_code, cover_method_temp.rf_code
FROM cover_method_temp
WHERE rf_code IS NOT NULL) AS nonnullrefcodes
LEFT JOIN reference
ON nonnullrefcodes.rf_code = 'rf.' || reference.reference_id
WHERE reference.reference_id IS NULL;
