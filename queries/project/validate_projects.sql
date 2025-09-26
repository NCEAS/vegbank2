DELETE FROM project_temp 
WHERE project_temp.user_code IN (
SELECT 
    project_temp.user_code
FROM project_temp 
LEFT JOIN project on 
    project_temp.user_code = 'pj.' || project.project_id
WHERE 
    project.project_id IS NOT NULL
) RETURNING project_temp.user_code, project_temp.projectname;
