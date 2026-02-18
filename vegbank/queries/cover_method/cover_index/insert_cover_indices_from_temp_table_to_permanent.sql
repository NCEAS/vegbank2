INSERT INTO coverindex (
    covermethod_id, 
    covercode, 
    upperlimit,
    lowerlimit,
    coverpercent,
    indexdescription
)
SELECT 
    covermethod_id,
    covercode, 
    upperlimit,
    lowerlimit,
    coverpercent,
    indexdescription
FROM cover_index_temp
RETURNING covermethod_id, coverindex_id, covercode;