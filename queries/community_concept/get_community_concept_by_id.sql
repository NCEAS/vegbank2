SELECT
    commConcept.commName as defaultName,
    commConcept.reference_ID,
    commConcept.commDescription,
    commConcept.accessionCode,
    commConcept.d_obscount as obscount,
    commConcept.d_currentAccepted as currentAccepted,
    commUsage.usageStart,
    commUsage.usageStop,
    commUsage.commNameStatus,
    commUsage.classSystem,
    commUsage.party_ID,
    commName.commName,
    commName.dateEntered as commNameDateEntered,
    party.accessionCode as partyAccessionCode
FROM
    commconcept
    left join commUsage on commconcept.commconcept_id = commUsage.commconcept_id
    left join commname on commUsage.commname_id = commname.commname_id
    left join party on commUsage.party_id = party.party_id
WHERE  
    commConcept.commconcept_id = %s;
