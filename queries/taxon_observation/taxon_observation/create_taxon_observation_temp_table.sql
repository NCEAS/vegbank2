CREATE TEMPORARY TABLE taxon_observation_temp(
    user_to_code character varying(30) NOT NULL,
    vb_ob_code character varying(30) NOT NULL,
    authorplantname character varying(255) NOT NULL,
    vb_rf_code character varying(30) NOT NULL,
    taxoninferencearea double precision
);