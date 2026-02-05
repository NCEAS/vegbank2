-- Validate plantname codes
SELECT plant_usage_temp.vb_pn_code
  FROM plant_usage_temp LEFT JOIN plantname
    ON plant_usage_temp.vb_pn_code = 'pn.' || plantname.plantname_id
  WHERE plantname.plantname_id IS NULL;

-- Validate plantconcept codes
SELECT plant_usage_temp.vb_pc_code
  FROM plant_usage_temp LEFT JOIN plantconcept
    ON plant_usage_temp.vb_pc_code = 'pc.' || plantconcept.plantconcept_id
  WHERE plantconcept.plantconcept_id IS NULL;

-- Validate plantstatus codes
SELECT plant_usage_temp.vb_ps_code
  FROM plant_usage_temp LEFT JOIN plantstatus
    ON plant_usage_temp.vb_ps_code = 'ps.' || plantstatus.plantstatus_id
  WHERE plantstatus.plantstatus_id IS NULL;

-- Validate party codes
SELECT plant_usage_temp.vb_py_code
  FROM plant_usage_temp LEFT JOIN party
    ON plant_usage_temp.vb_py_code = 'py.' || party.party_id
  WHERE party.party_id IS NULL
    AND plant_usage_temp.vb_py_code IS NOT NULL;
