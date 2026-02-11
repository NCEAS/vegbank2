CREATE TEMPORARY TABLE party_temp(
    user_py_code TEXT NOT NULL,
    surname character varying(50),
    givenname character varying(50),
    middlename character varying(50),
    organizationname character varying(100),
    email character varying(120),
    orcid TEXT,
    ror TEXT
);