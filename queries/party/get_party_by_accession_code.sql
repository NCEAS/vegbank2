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
WHERE
    party.accessionCode = %s
AND party.partypublic IS NOT false;