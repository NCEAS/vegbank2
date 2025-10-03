SELECT                  
    accessioncode as taxonObservationAccessionCode, 
    authorplantname, 
    emb_taxonobservation, 
    int_currplantcode, 
    int_currplantcommon, 
    int_currplantconcept_id, 
    int_currplantscifull, 
    int_currplantscinamenoauth, 
    int_origplantcode, 
    int_origplantcommon, 
    int_origplantconcept_id, 
    int_origplantscifull, 
    int_origplantscinamenoauth, 
    maxcover, 
    observation_id, 
    reference_id, 
    taxoninferencearea, 
    taxonobservation_id
FROM    
    view_taxonobs_withmaxcover
WHERE 
    taxonobservation_id = %s
