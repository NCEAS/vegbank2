SELECT
    plot.plot_id,
    plot.latitude,
    plot.longitude,
    observation.accessionCode AS obsAccessionCode,
    authorplotcode, 
    authorobscode, 
    stateprovince,
    country,
    commname.commname,
    commconcept.accessionCode AS commconceptAccessionCode
FROM 
    plot 
    join observation on plot.plot_id = observation.plot_id
    join commClass on observation.observation_id = commclass.observation_id
    join commInterpretation on commClass.commclass_id = commInterpretation.commclass_id
    join commConcept on commInterpretation.commconcept_id = commConcept.commconcept_id
    join commname on commconcept.commname_id = commname.commname_id
WHERE plot.confidentialitystatus < 4
AND observation.accessionCode is not null
ORDER BY plot.plot_id ASC
LIMIT %s
OFFSET %s;
    

