CREATE TEMPORARY TABLE taxon_importance_temp(
    user_tm_code TEXT NOT NULL,
    vb_to_code TEXT NOT NULL,
    vb_sr_code TEXT NOT NULL,
    cover double precision,
    basalarea double precision,
    biomass double precision,
    inferencearea double precision
);