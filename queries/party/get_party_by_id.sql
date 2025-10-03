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
    party.party_id = %s
AND party.partypublic IS NOT false;
