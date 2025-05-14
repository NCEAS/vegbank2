SELECT 
    count(t.*)
FROM
observation
CROSS JOIN LATERAL
(
    SELECT 
        *
    FROM    
        view_taxonobs_withmaxcover
    WHERE 
        view_taxonobs_withmaxcover.observation_id = observation.observation_id
    ORDER BY 
        maxcover DESC
    LIMIT %s
) as t;