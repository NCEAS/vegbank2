INSERT INTO project (projectname, projectdescription, startdate, stopdate)
VALUES (%s, %s, %s, %s) RETURNING project_id;