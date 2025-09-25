SELECT 
    'sm.' || stratummethod.stratummethod_id AS sm_code,
    'rf.' || stratummethod.reference_id AS rf_code, 
    stratummethod.stratummethodname, 
    stratummethod.stratummethoddescription,
    stratummethod.stratumassignment,
    stratumtype.stratumindex,
    stratumtype.stratumname,
    stratumtype.stratumdescription
FROM
    stratummethod
LEFT JOIN 
    stratumtype ON stratummethod.stratummethod_id = stratumtype.stratummethod_id
LIMIT %s 
OFFSET %s;