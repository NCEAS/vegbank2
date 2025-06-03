SELECT 
    party_ID,
    salutation, 
    givenName, 
    middleName,
    surName, 
    organizationName,
    contactInstructions,
    accessionCode as partyAccessionCode
FROM
    party
WHERE partypublic IS NOT false
LIMIT %s 
OFFSET %s;