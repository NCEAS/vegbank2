SELECT
    commConcept.*, 
    commName.reference_id as commNameReferenceID,
    commName.dateEntered as commNameDateEntered
FROM
    commconcept
    left join commname on commconcept.commname_id = commname.commname_id
WHERE  
    commConcept.accessionCode = %s;