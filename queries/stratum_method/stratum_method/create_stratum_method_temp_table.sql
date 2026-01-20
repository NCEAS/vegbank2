CREATE TEMPORARY TABLE stratum_method_temp(
    user_code character varying(30) NOT NULL,
    rf_code character varying(30),
    stratummethodname character varying(30) NOT NULL,
    stratummethoddescription text,
    stratumassignment character varying(50)
);