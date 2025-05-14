SELECT 
    taxonObservation.accessionCode as taxonObservationAccessionCode,
    taxonInterpretation.accessionCode as taxonInterpretationAccessionCode,
    taxonObservation.observation_ID,
    taxonInterpretation.plantconcept_ID,
    taxonImportance.cover,
    taxonImportance.basalArea,
    taxonImportance.biomass,
    taxonImportance.inferenceArea,
    taxonInterpretation.taxonFit,
    taxonInterpretation.taxonConfidence
FROM
    taxonObservation
    left join taxonInterpretation on taxonObservation.taxonObservation_ID = taxonInterpretation.taxonObservation_ID
    left join taxonImportance on taxonInterpretation.taxonObservation_ID = taxonImportance.taxonObservation_ID
LIMIT %s 
OFFSET %s;