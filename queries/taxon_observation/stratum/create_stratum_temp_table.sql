CREATE TEMPORARY TABLE stratum_temp(
    vb_ob_code character varying(30) NOT NULL,
    user_ob_code character varying(30) NOT NULL,
    user_sr_code character varying(30) NOT NULL,
    vb_sy_code character varying(30) NOT NULL,
    stratumheight double precision,
    stratumbase double precision,
    stratumcover double precision
);