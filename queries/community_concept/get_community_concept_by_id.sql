SELECT
    commConcept.commName as defaultName,
    'rf.' || commConcept.reference_id AS rf_code,
    commConcept.commDescription,
    'cc.' || commConcept.commconcept_id AS cc_code,
    commConcept.d_obscount as obscount,
    commConcept.d_currentAccepted as currentAccepted,
    commUsage.usageStart,
    commUsage.usageStop,
    commUsage.commNameStatus,
    commUsage.classSystem,
    'py.' || commUsage.party_id AS py_code,
    commName.commName,
    commName.dateEntered as commNameDateEntered
FROM
    commconcept
    left join commUsage on commconcept.commconcept_id = commUsage.commconcept_id
    left join commname on commUsage.commname_id = commname.commname_id
    left join party on commUsage.party_id = party.party_id
WHERE  
    commConcept.commconcept_id = %s;
