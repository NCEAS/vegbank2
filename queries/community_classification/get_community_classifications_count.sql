SELECT
    count(*)
FROM
    commClass 
    left join commInterpretation on commClass.commClass_ID = commInterpretation.commClass_ID
    left join commConcept on commInterpretation.commConcept_ID = commConcept.commConcept_ID
    left join observation on commClass.observation_ID = observation.observation_ID;