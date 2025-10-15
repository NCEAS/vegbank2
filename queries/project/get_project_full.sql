SELECT
    'pj.' || project_id AS pj_code,
    projectname,
    projectdescription,
    startdate,
    stopdate,
    d_obscount as obscount,
    d_lastplotaddeddate as lastplotaddeddate
FROM
    project
LIMIT %s
OFFSET %s;
