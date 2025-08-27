SELECT 
    'cm.' || covermethod_id AS cm_code,
    'rf.' || reference_id AS rf_code, 
    covertype, 
    coverestimationmethod
FROM
    covermethod;