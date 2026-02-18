CREATE TEMPORARY TABLE taxon_observation_temp(
    user_to_code TEXT NOT NULL,
    user_ob_code TEXT,
    vb_ob_code TEXT NOT NULL,
    authorplantname character varying(255) NOT NULL,
    vb_rf_code TEXT,
    taxoninferencearea double precision
);