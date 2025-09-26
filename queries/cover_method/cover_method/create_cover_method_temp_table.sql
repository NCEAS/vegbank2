CREATE TEMPORARY TABLE cover_method_temp(
    user_code character varying(30) NOT NULL,
    rf_code character varying(30),
    covertype character varying(30) NOT NULL,
    coverestimationmethod character varying(80)
);