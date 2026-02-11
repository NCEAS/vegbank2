INSERT INTO stratummethod (
    reference_id, 
    stratummethodname, 
    stratummethoddescription,
    stratumassignment
)
SELECT 
    CAST(SUBSTRING(rf_code, 4, LENGTH(rf_code) - 3) AS INT) AS reference_id, 
    stratummethodname, 
    stratummethoddescription,
    stratumassignment
FROM stratum_method_temp
RETURNING stratummethod_id, 'sm.' || stratummethod_id AS sm_code, stratummethodname;