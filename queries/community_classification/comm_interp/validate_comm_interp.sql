-- Validate comm class codes
SELECT comm_interp_temp.vb_cl_code
  FROM comm_interp_temp LEFT JOIN commclass
    ON comm_interp_temp.vb_cl_code = 'cl.' || commclass.commclass_id
  WHERE commclass.commclass_id IS NULL;

-- Validate comm concept codes
SELECT comm_interp_temp.vb_cc_code
  FROM comm_interp_temp LEFT JOIN commconcept
    ON comm_interp_temp.vb_cc_code = 'cc.' || commconcept.commconcept_id
  WHERE commconcept.commconcept_id IS NULL;

-- Validate reference codes
SELECT comm_interp_temp.vb_rf_code
  FROM comm_interp_temp LEFT JOIN reference
    ON comm_interp_temp.vb_rf_code = 'rf.' || reference.reference_id
  WHERE reference.reference_id IS NULL
    AND comm_interp_temp.vb_rf_code IS NOT NULL;
