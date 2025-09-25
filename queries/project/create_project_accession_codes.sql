UPDATE project
SET accessioncode = CONCAT('pj.', project_id)
WHERE project_id = ANY(%s)
AND accessioncode IS NULL
RETURNING accessioncode, projectname;