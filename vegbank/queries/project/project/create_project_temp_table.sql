CREATE TEMP TABLE project_temp (
    user_pj_code TEXT NOT NULL,
    projectname character varying(150) NOT NULL,
    projectdescription text,
    startdate timestamp with time zone,
    stopdate timestamp with time zone
);
