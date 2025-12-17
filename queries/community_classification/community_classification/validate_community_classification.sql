-- Validate observation codes

SELECT community_classification_temp.vb_ob_code
FROM 
    community_classification_temp LEFT JOIN observation 
ON
    community_classification_temp.vb_ob_code = 'ob.' || observation.observation_id
WHERE observation.observation_id IS NULL;

-- Validate reference codes

SELECT community_classification_temp.vb_comm_class_rf_code
FROM 
    community_classification_temp LEFT JOIN reference 
ON
    community_classification_temp.vb_comm_class_rf_code = 'rf.' || reference.reference_id
WHERE reference.reference_id IS NULL AND community_classification_temp.vb_comm_class_rf_code IS NOT NULL;