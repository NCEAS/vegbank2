SELECT 
    commname.commname,
    commconcept.accessionCode
FROM
    observation
    join commClass on observation.observation_id = commclass.observation_id
    join commInterpretation on commClass.commclass_id = commInterpretation.commclass_id
    join commConcept on commInterpretation.commconcept_id = commConcept.commconcept_id
    join commname on commconcept.commname_id = commname.commname_id
WHERE 
    observation.accessioncode = %s;