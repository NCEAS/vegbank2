CREATE TEMPORARY TABLE disturbance_obs_temp(
    -- user-supplied fields:
    user_ob_code TEXT NOT NULL,
    user_do_code TEXT NOT NULL,
    disturbancetype CHARACTER VARYING(30) NOT NULL,
    disturbanceintensity CHARACTER VARYING(30),
    disturbanceage DOUBLE PRECISION,
    disturbanceextent DOUBLE PRECISION,
    disturbancecomment TEXT,
    -- api-augmented fields:
    vb_ob_code TEXT NOT NULL
);
