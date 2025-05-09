SELECT
    commConcept.*, 
    commName.reference_id as commNameReferenceID,
    commName.dateEntered as commNameDateEntered
FROM
    commConcept
    left join commname on commconcept.commname_id = commname.commname_id
LIMIT %s
OFFSET %s;