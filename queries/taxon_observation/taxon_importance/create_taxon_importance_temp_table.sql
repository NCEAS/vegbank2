CREATE TEMPORARY TABLE taxon_importance_temp(
    user_tm_code TEXT NOT NULL,
    user_to_code TEXT,
    vb_to_code TEXT NOT NULL,
    user_sr_code TEXT,
    vb_sr_code TEXT,
    cover double precision,
    basalarea double precision,
    biomass double precision,
    inferencearea double precision
);