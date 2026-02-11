-- Validate commname codes
SELECT comm_concept_temp.vb_cn_code
  FROM comm_concept_temp LEFT JOIN commname
    ON comm_concept_temp.vb_cn_code = 'cn.' || commname.commname_id
  WHERE commname.commname_id IS NULL;

-- Validate reference codes
SELECT comm_concept_temp.vb_rf_code
  FROM comm_concept_temp LEFT JOIN reference
    ON comm_concept_temp.vb_rf_code = 'rf.' || reference.reference_id
  WHERE reference.reference_id IS NULL;
