INSERT INTO project_temp (
    user_pj_code, projectname, projectdescription, startdate, stopdate
    )
VALUES(
    %s, %s, %s, %s, %s
);