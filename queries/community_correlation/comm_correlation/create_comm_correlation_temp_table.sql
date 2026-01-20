CREATE TEMPORARY TABLE comm_correlation_temp(
    -- user-supplied fields:
    user_cc_code TEXT NOT NULL,
    vb_correlated_cc_code TEXT,
    user_correlated_cc_code TEXT,
    commconvergence character varying(20) NOT NULL,
    correlationstart timestamp with time zone NOT NULL,
    correlationstop timestamp with time zone,
    -- api-augmented fields:
    vb_cc_code TEXT NOT NULL,
    user_cx_code TEXT NOT NULL
);
