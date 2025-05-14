SELECT 
    taxonObservation.authorPlantName, 
    taxonObservation.int_origplantscifull,
    taxonObservation.int_origplantscinamenoauth,
    taxonObservation.int_origplantcommon,
    taxonObservation.int_origplantcode,
    taxonObservation.int_currplantscifull,
    taxonObservation.int_currplantscinamenoauth,
    taxonObservation.int_currplantcommon,
    taxonObservation.int_currplantcode,
    stratumtype.stratumname as stratum,
    taxonImportance.cover,
    taxonImportance.covercode,
    taxonImportance.basalArea,
    taxonImportance.biomass,
    taxonImportance.inferenceArea
FROM 
    observation 
    join taxonObservation on observation.observation_id = taxonObservation.observation_id
    left join taxonImportance on taxonObservation.taxonObservation_id = taxonImportance.taxonobservation_id
    join stratum on taxonImportance.stratum_id = stratum.stratum_id
    left join stratumtype on stratum.stratumtype_id = stratumtype.stratumtype_id
WHERE 
    observation.accessionCode = %s
ORDER BY
    stratumtype DESC, taxonImportance.cover DESC;