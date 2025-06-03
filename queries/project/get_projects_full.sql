SELECT
    project_id,
    projectname,
    projectdescription,
    startdate,
    stopdate,
    accessionCode as projectAccessionCode,
    d_obscount as obscount,
    d_lastplotaddeddate as lastplotaddeddate
FROM
    project
LIMIT %s
OFFSET %s;