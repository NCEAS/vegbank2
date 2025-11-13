-- Validate taxon observation codes

SELECT taxon_importance_temp.vb_to_code
FROM 
    taxon_importance_temp LEFT JOIN taxonobservation 
ON
    taxon_importance_temp.vb_to_code = 'to.' || taxonobservation.taxonobservation_id
WHERE taxonobservation.taxonobservation_id IS NULL;

-- Validate stratum codes

SELECT taxon_importance_temp.vb_sr_code
FROM 
    taxon_importance_temp LEFT JOIN stratum
ON
    taxon_importance_temp.vb_sr_code = 'sr.' || stratum.stratum_id
WHERE stratum.stratum_id IS NULL;