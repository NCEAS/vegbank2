INSERT INTO stratumtype (
    stratummethod_id,
    stratumindex,
    stratumname,
    stratumdescription
)
SELECT 
    stratummethod_id,
    stratumindex,
    stratumname,
    stratumdescription
FROM stratum_type_temp
RETURNING stratummethod_id, stratumtype_id, stratumname;