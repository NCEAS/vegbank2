CREATE TEMPORARY TABLE cover_method_temp(
    user_cm_code character varying(30) NOT NULL,
    user_rf_code character varying(30),
    vb_rf_code TEXT,
    covertype character varying(30) NOT NULL,
    coverestimationmethod character varying(80)
) ON COMMIT DROP;