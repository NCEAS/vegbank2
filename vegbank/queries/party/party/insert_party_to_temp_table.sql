INSERT INTO party_temp
    (
        user_py_code,
        surname,
        givenname,
        middlename,
        organizationname,
        email,
        orcid,
        ror
    )
VALUES (%s, %s, %s, %s, %s, %s, %s, %s);