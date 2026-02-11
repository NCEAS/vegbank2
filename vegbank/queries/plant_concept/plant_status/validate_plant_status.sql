-- Validate plant concept codes
SELECT plant_status_temp.vb_pc_code
  FROM plant_status_temp LEFT JOIN plantconcept
    ON plant_status_temp.vb_pc_code = 'pc.' || plantconcept.plantconcept_id
  WHERE plantconcept.plantconcept_id IS NULL;

-- Validate parent plant concept codes
SELECT plant_status_temp.vb_parent_pc_code
  FROM plant_status_temp LEFT JOIN plantconcept
    ON plant_status_temp.vb_parent_pc_code = 'pc.' || plantconcept.plantconcept_id
  WHERE plantconcept.plantconcept_id IS NULL
    AND plant_status_temp.vb_parent_pc_code IS NOT NULL;

-- Validate party codes
SELECT plant_status_temp.vb_py_code
  FROM plant_status_temp LEFT JOIN party
    ON plant_status_temp.vb_py_code = 'py.' || party.party_id
  WHERE party.party_id IS NULL
    AND plant_status_temp.vb_py_code IS NOT NULL;

-- Validate reference codes
SELECT plant_status_temp.vb_rf_code
  FROM plant_status_temp LEFT JOIN reference
    ON plant_status_temp.vb_rf_code = 'rf.' || reference.reference_id
  WHERE reference.reference_id IS NULL
    AND plant_status_temp.vb_rf_code IS NOT NULL;
