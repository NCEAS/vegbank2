MERGE INTO project dst
USING project_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    projectname, 
    projectdescription,
    startdate,
    stopdate
  ) VALUES (
    projectname,
    projectdescription,
    startdate,
    stopdate
  )
RETURNING merge_action(),
          src.user_pj_code,
          dst.project_id,
          'pj.' || dst.project_id AS vb_pj_code;