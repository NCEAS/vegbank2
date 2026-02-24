-- Validate observation codes
SELECT project_contributor_temp.vb_record_identifier
  FROM project_contributor_temp LEFT JOIN project
    ON project_contributor_temp.vb_record_identifier = 'pj.' || project.project_id
  WHERE project.project_id IS NULL;

-- Validate party codes
SELECT project_contributor_temp.vb_py_code
  FROM project_contributor_temp LEFT JOIN party
    ON project_contributor_temp.vb_py_code = 'py.' || party.party_id
  WHERE party.party_id IS NULL;

-- Validate role codes
SELECT project_contributor_temp.vb_ar_code
  FROM project_contributor_temp LEFT JOIN aux_role
    ON project_contributor_temp.vb_ar_code = 'ar.' || aux_role.role_id
  WHERE aux_role.role_id IS NULL;