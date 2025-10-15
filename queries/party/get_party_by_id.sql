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
WHERE
    party.party_id = %s
AND party.partypublic IS NOT false;
