-- Validate comm concept codes
SELECT comm_status_temp.vb_cc_code
  FROM comm_status_temp LEFT JOIN commconcept
    ON comm_status_temp.vb_cc_code = 'cc.' || commconcept.commconcept_id
  WHERE commconcept.commconcept_id IS NULL;

-- Validate parent comm concept codes
SELECT comm_status_temp.vb_parent_cc_code
  FROM comm_status_temp LEFT JOIN commconcept
    ON comm_status_temp.vb_parent_cc_code = 'cc.' || commconcept.commconcept_id
  WHERE commconcept.commconcept_id IS NULL
    AND comm_status_temp.vb_parent_cc_code IS NOT NULL;

-- Validate party codes
SELECT comm_status_temp.vb_py_code
  FROM comm_status_temp LEFT JOIN party
    ON comm_status_temp.vb_py_code = 'py.' || party.party_id
  WHERE party.party_id IS NULL
    AND comm_status_temp.vb_py_code IS NOT NULL;

-- Validate reference codes
SELECT comm_status_temp.vb_rf_code
  FROM comm_status_temp LEFT JOIN reference
    ON comm_status_temp.vb_rf_code = 'rf.' || reference.reference_id
  WHERE reference.reference_id IS NULL
    AND comm_status_temp.vb_rf_code IS NOT NULL;
