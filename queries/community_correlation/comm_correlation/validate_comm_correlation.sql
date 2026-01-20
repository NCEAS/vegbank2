-- Validate comm concept codes
SELECT comm_correlation_temp.vb_cc_code
  FROM comm_correlation_temp LEFT JOIN commconcept
    ON comm_correlation_temp.vb_cc_code = 'cc.' || commconcept.commconcept_id
  WHERE commconcept.commconcept_id IS NULL;

-- Validate correlated comm concept codes in comm status table
SELECT comm_correlation_temp.vb_correlated_cc_code
  FROM comm_correlation_temp LEFT JOIN commstatus
    ON comm_correlation_temp.vb_correlated_cc_code = 'cc.' || commstatus.commconcept_id
  WHERE commstatus.commconcept_id IS NULL;
