-- Validate commname codes
SELECT comm_usage_temp.vb_cn_code
  FROM comm_usage_temp LEFT JOIN commname
    ON comm_usage_temp.vb_cn_code = 'cn.' || commname.commname_id
  WHERE commname.commname_id IS NULL;

-- Validate commconcept codes
SELECT comm_usage_temp.vb_cc_code
  FROM comm_usage_temp LEFT JOIN commconcept
    ON comm_usage_temp.vb_cc_code = 'cc.' || commconcept.commconcept_id
  WHERE commconcept.commconcept_id IS NULL;

-- Validate commstatus codes
SELECT comm_usage_temp.vb_cs_code
  FROM comm_usage_temp LEFT JOIN commstatus
    ON comm_usage_temp.vb_cs_code = 'cs.' || commstatus.commstatus_id
  WHERE commstatus.commstatus_id IS NULL;

-- Validate party codes
SELECT comm_usage_temp.vb_py_code
  FROM comm_usage_temp LEFT JOIN party
    ON comm_usage_temp.vb_py_code = 'py.' || party.party_id
  WHERE party.party_id IS NULL
    AND comm_usage_temp.vb_py_code IS NOT NULL;
