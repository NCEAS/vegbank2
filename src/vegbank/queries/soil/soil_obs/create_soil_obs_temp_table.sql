CREATE TEMPORARY TABLE soil_obs_temp(
    -- user-supplied fields:
    user_ob_code TEXT NOT NULL,
    user_so_code TEXT NOT NULL,
    soilhorizon CHARACTER VARYING(15) NOT NULL,
    soildepthtop DOUBLE PRECISION,
    soildepthbottom DOUBLE PRECISION,
    soilcolor CHARACTER VARYING(30),
    soilorganic DOUBLE PRECISION,
    soiltexture CHARACTER VARYING(15),
    soilsand DOUBLE PRECISION,
    soilsilt DOUBLE PRECISION,
    soilclay DOUBLE PRECISION,
    soilcoarse DOUBLE PRECISION,
    soilph DOUBLE PRECISION,
    exchangecapacity DOUBLE PRECISION,
    basesaturation DOUBLE PRECISION,
    soildescription TEXT,
    -- api-augmented fields:
    vb_ob_code TEXT NOT NULL
);
