-- Validate comm class codes
SELECT class_contributor_temp.vb_record_identifier
  FROM class_contributor_temp LEFT JOIN commclass
    ON class_contributor_temp.vb_record_identifier = 'cl.' || commclass.commclass_id
  WHERE commclass.commclass_id IS NULL;

-- Validate party codes
SELECT class_contributor_temp.vb_py_code
  FROM class_contributor_temp LEFT JOIN party
    ON class_contributor_temp.vb_py_code = 'py.' || party.party_id
  WHERE party.party_id IS NULL;

-- Validate role codes
SELECT class_contributor_temp.vb_rl_code
  FROM class_contributor_temp LEFT JOIN aux_role
    ON class_contributor_temp.vb_rl_code = 'rl.' || aux_role.role_id
  WHERE aux_role.role_id IS NULL;