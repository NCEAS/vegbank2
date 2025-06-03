SELECT
    commConcept.commName as defaultName,
    commConcept.reference_ID,
    commConcept.commDescription,
    commConcept.accessionCode,
    commConcept.d_obscount as obscount,
    commConcept.d_currentAccepted as currentAccepted,
    commName.dateEntered as commNameDateEntered,
    reference.accessionCode as referenceAccessionCode
FROM
    commConcept
    left join commname on commconcept.commname_id = commname.commname_id
    left join reference on commName.reference_id = reference.reference_id
LIMIT %s
OFFSET %s;