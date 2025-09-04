CREATE TEMPORARY TABLE cover_index_temp (
    covermethod_id integer NOT NULL,
    covercode character varying(10) NOT NULL,
    upperlimit double precision,
    lowerlimit double precision,
    coverpercent double precision NOT NULL,
    indexdescription text
);