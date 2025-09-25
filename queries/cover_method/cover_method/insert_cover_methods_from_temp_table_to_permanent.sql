INSERT INTO covermethod (
    reference_id, 
    covertype, 
    coverestimationmethod
)
SELECT 
    CAST(SUBSTRING(rf_code, 4, LENGTH(rf_code) - 3) AS INT) AS reference_id, 
    covertype, 
    coverestimationmethod
FROM cover_method_temp
RETURNING covermethod_id, 'cm.' || covermethod_id AS cm_code, covertype;