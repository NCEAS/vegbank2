-- Validate observation codes
SELECT observation_contributor_temp.vb_record_identifier
  FROM observation_contributor_temp LEFT JOIN observation
    ON observation_contributor_temp.vb_record_identifier = 'ob.' || observation.observation_id
  WHERE observation.observation_id IS NULL;

-- Validate party codes
SELECT observation_contributor_temp.vb_py_code
  FROM observation_contributor_temp LEFT JOIN party
    ON observation_contributor_temp.vb_py_code = 'py.' || party.party_id
  WHERE party.party_id IS NULL;

-- Validate role codes
SELECT observation_contributor_temp.vb_rl_code
  FROM observation_contributor_temp LEFT JOIN aux_role
    ON observation_contributor_temp.vb_rl_code = 'rl.' || aux_role.role_id
  WHERE aux_role.role_id IS NULL;