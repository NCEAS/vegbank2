SELECT 
    observation_id,
    authorPlantName, 
    accessionCode,
    int_origplantscifull,
    int_origplantscinamenoauth,
    int_origplantcommon,
    int_origplantcode,
    int_currplantscifull,
    int_currplantscinamenoauth,
    int_currplantcommon,
    int_currplantcode,
    maxcover
FROM
    view_taxonobs_withmaxcover
WHERE observation_id = %s AND maxcover is not null
ORDER BY maxcover DESC
LIMIT 5;