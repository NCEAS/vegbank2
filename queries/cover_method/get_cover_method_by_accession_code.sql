SELECT 
    'cm.' || covermethod.covermethod_id AS cm_code,
    'rf.' || covermethod.reference_id AS rf_code, 
    covermethod.covertype, 
    covermethod.coverestimationmethod,
    coverindex.covercode,
    coverindex.upperlimit,
    coverindex.lowerlimit,
    coverindex.coverpercent,
    coverindex.indexdescription
FROM
    covermethod
LEFT JOIN 
    coverIndex ON covermethod.covermethod_id = coverIndex.covermethod_id
WHERE
    covermethod.accessioncode = %s;