-- Validate observation codes

SELECT taxon_observation_temp.vb_ob_code
FROM 
    taxon_observation_temp LEFT JOIN observation 
ON
    taxon_observation_temp.vb_ob_code = 'ob.' || observation.observation_id
WHERE observation.observation_id IS NULL;

-- Validate reference codes

SELECT taxon_observation_temp.vb_rf_code
FROM 
    taxon_observation_temp LEFT JOIN reference
ON
    taxon_observation_temp.vb_rf_code = 'rf.' || reference.reference_id
WHERE reference.reference_id IS NULL;