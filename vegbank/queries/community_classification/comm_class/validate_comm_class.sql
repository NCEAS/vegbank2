-- Validate ob codes
SELECT comm_class_temp.vb_ob_code
  FROM comm_class_temp LEFT JOIN observation
    ON comm_class_temp.vb_ob_code = 'ob.' || observation.observation_id
  WHERE observation.observation_id IS NULL;

-- Validate reference codes
SELECT comm_class_temp.vb_rf_code
  FROM comm_class_temp LEFT JOIN reference
    ON comm_class_temp.vb_rf_code = 'rf.' || reference.reference_id
  WHERE reference.reference_id IS NULL
    AND comm_class_temp.vb_rf_code IS NOT NULL;
