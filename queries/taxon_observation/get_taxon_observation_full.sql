SELECT 
    'to.' || t.taxonobservation_id AS to_code,
    t.authorplantname, 
    t.emb_taxonobservation, 
    t.int_currplantcode, 
    t.int_currplantcommon, 
    'pc' || t.int_currplantconcept_id AS int_curr_pc_code,
    t.int_currplantscifull, 
    t.int_currplantscinamenoauth, 
    t.int_origplantcode, 
    t.int_origplantcommon, 
    'pc' || t.int_origplantconcept_id AS int_orig_pc_code,
    t.int_origplantscifull, 
    t.int_origplantscinamenoauth, 
    t.maxcover, 
    'ob.' || t.observation_id AS ob_code,
    'rf.' || t.reference_id AS rf_code,
    t.taxoninferencearea
FROM
observation
CROSS JOIN LATERAL
(
    SELECT 
        *
    FROM    
        view_taxonobs_withmaxcover
    WHERE 
        view_taxonobs_withmaxcover.observation_id = observation.observation_id
    ORDER BY 
        maxcover DESC
    LIMIT %s
) as t
LIMIT %s 
OFFSET %s;
