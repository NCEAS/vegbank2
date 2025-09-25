CREATE TEMP TABLE project_temp (
    projectname character varying(150) NOT NULL UNIQUE,
    projectdescription text,
    startdate timestamp with time zone,
    stopdate timestamp with time zone,
    user_code character varying(150) NOT NULL UNIQUE
);
