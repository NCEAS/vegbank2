CREATE TEMPORARY TABLE reference_temp(
    user_rf_code TEXT NOT NULL,
    doi TEXT,
    shortname character varying(250),
    fulltext TEXT,
    url TEXT
);