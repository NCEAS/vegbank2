SELECT 
    t.accessioncode as taxonObservationAccessionCode, 
    t.authorplantname, 
    t.emb_taxonobservation, 
    t.int_currplantcode, 
    t.int_currplantcommon, 
    t.int_currplantconcept_id, 
    t.int_currplantscifull, 
    t.int_currplantscinamenoauth, 
    t.int_origplantcode, 
    t.int_origplantcommon, 
    t.int_origplantconcept_id, 
    t.int_origplantscifull, 
    t.int_origplantscinamenoauth, 
    t.maxcover, 
    t.observation_id, 
    t.reference_id, 
    t.taxoninferencearea, 
    t.taxonobservation_id
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