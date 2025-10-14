SELECT 
    'py.' || party_id AS py_code,
    salutation, 
    givenName, 
    middleName,
    surName, 
    organizationName,
    contactInstructions
FROM
    party
WHERE partypublic IS NOT false
LIMIT %s 
OFFSET %s;
