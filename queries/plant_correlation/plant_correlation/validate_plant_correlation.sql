-- Validate plant concept codes
SELECT plant_correlation_temp.vb_pc_code
  FROM plant_correlation_temp LEFT JOIN plantconcept
    ON plant_correlation_temp.vb_pc_code = 'pc.' || plantconcept.plantconcept_id
  WHERE plantconcept.plantconcept_id IS NULL;

-- Validate correlated plant concept codes in plant status table
SELECT plant_correlation_temp.vb_correlated_pc_code
  FROM plant_correlation_temp LEFT JOIN plantstatus
    ON plant_correlation_temp.vb_correlated_pc_code = 'pc.' || plantstatus.plantconcept_id
  WHERE plantstatus.plantconcept_id IS NULL;
