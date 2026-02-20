-- Validate plantname codes
SELECT plant_concept_temp.vb_pn_code
  FROM plant_concept_temp LEFT JOIN plantname
    ON plant_concept_temp.vb_pn_code = 'pn.' || plantname.plantname_id
  WHERE plantname.plantname_id IS NULL;

-- Validate reference codes
SELECT plant_concept_temp.vb_rf_code
  FROM plant_concept_temp LEFT JOIN reference
    ON plant_concept_temp.vb_rf_code = 'rf.' || reference.reference_id
  WHERE reference.reference_id IS NULL;
