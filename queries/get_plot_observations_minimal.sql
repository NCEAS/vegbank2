SELECT
    plot.plot_id,
    plot.latitude,
    plot.longitude,
    observation.accessionCode AS obsAccessionCode,
    authorplotcode, 
    authorobscode, 
    stateprovince,
    country
FROM 
    observation 
    left join plot on observation.plot_id = plot.plot_id
WHERE plot.confidentialitystatus < 4
AND observation.accessionCode is not null
ORDER BY observation.observation_id ASC
LIMIT %s
OFFSET %s;