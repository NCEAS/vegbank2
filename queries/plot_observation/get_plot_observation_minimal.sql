SELECT
    'pl.' || plot.plot_id AS pl_code,
    plot.latitude,
    plot.longitude,
    'ob.' || observation.observation_id AS ob_code,
    authorplotcode, 
    authorobscode, 
    stateprovince,
    country
FROM 
    observation 
    left join plot on observation.plot_id = plot.plot_id
WHERE plot.confidentialitystatus < 4
ORDER BY observation.observation_id ASC
LIMIT %s
OFFSET %s;
