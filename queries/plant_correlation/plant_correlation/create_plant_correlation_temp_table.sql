CREATE TEMPORARY TABLE plant_correlation_temp(
    -- user-supplied fields:
    user_pc_code TEXT NOT NULL,
    vb_correlated_pc_code TEXT,
    user_correlated_pc_code TEXT,
    plantconvergence character varying(20) NOT NULL,
    correlationstart timestamp with time zone NOT NULL,
    correlationstop timestamp with time zone,
    -- api-augmented fields:
    vb_pc_code TEXT NOT NULL,
    user_px_code TEXT NOT NULL
);
