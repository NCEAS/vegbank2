CREATE TEMPORARY TABLE cover_index_temp (
    user_ci_code TEXT NOT NULL,
    vb_cm_code TEXT NOT NULL,
    covercode character varying(10) NOT NULL,
    upperlimit double precision,
    lowerlimit double precision,
    coverpercent double precision NOT NULL,
    indexdescription text
);