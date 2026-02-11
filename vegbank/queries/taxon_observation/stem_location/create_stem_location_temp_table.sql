CREATE TEMPORARY TABLE stem_location_temp(
    user_sl_code TEXT NOT NULL,
    vb_sc_code TEXT NOT NULL,
    stemcode character varying(20), 
    stemxposition double precision,
    stemyposition double precision,
    stemhealth character varying(50)
);