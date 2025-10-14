SELECT
    'cl.' || commClass.commclass_id AS cl_code,
    'ob.' || observation.observation_id AS ob_code,
    commConcept.commName,
    'cc.' || commConcept.commconcept_id AS cc_code
FROM
    commClass 
    left join commInterpretation on commClass.commClass_ID = commInterpretation.commClass_ID
    left join commConcept on commInterpretation.commConcept_ID = commConcept.commConcept_ID
    left join observation on commClass.observation_ID = observation.observation_ID
LIMIT %s 
OFFSET %s;
