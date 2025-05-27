SELECT 
    * 
FROM
    party
WHERE
    party.accessionCode = %s
AND party.partypublic IS NOT false;