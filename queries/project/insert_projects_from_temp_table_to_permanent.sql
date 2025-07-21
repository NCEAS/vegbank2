INSERT INTO project (projectname, projectdescription, startdate, stopdate)
SELECT projectname, projectdescription, startdate, stopdate
FROM project_temp
RETURNING project_id;