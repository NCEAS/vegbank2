SELECT                  
    'to.' || taxonobservation_id AS to_code,
    authorplantname, 
    emb_taxonobservation, 
    int_currplantcode, 
    int_currplantcommon, 
    'pc' || int_currplantconcept_id AS int_curr_pc_code,
    int_currplantscifull, 
    int_currplantscinamenoauth, 
    int_origplantcode, 
    int_origplantcommon, 
    'pc' || int_origplantconcept_id AS int_orig_pc_code,
    int_origplantscifull, 
    int_origplantscinamenoauth, 
    maxcover, 
    'ob.' || observation_id AS ob_code,
    'rf.' || reference_id AS rf_code,
    taxoninferencearea
FROM    
    view_taxonobs_withmaxcover
WHERE 
    taxonobservation_id = %s
