SELECT 
    commClass.*,
    commInterpretation.*
FROM
    commClass
    LEFT JOIN commInterpretation on commClass.commClass_ID = commInterpretation.commClass_ID
LIMIT %s 
OFFSET %s;