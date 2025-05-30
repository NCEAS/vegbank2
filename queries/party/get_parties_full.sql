SELECT 
    * 
FROM
    party
WHERE partypublic IS NOT false
LIMIT %s 
OFFSET %s;