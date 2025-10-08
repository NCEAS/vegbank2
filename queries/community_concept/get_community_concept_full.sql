SELECT
    commConcept.commName as defaultName,
    'rf.' || commConcept.reference_id AS rf_code,
    commConcept.commDescription,
    'cc.' || commConcept.commconcept_id AS cc_code,
    commConcept.d_obscount as obscount,
    commConcept.d_currentAccepted as currentAccepted,
    commName.dateEntered as commNameDateEntered
FROM
    commConcept
    left join commname on commconcept.commname_id = commname.commname_id
    left join reference on commName.reference_id = reference.reference_id
LIMIT %s
OFFSET %s;
