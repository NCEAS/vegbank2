DELETE FROM observation_temp 
WHERE observation_temp.ob_code IN (
SELECT 
    observation_temp.ob_code
FROM observation_temp 
LEFT JOIN observation ON 
    observation_temp.ob_code = 'ob.' || observation.observation_id
WHERE 
    observation.observation_id IS NOT NULL
) RETURNING observation_temp.ob_code, observation_temp.authorobscode;

-- Validate plot codes

SELECT observation_temp.ob_code, observation_temp.pl_code
FROM 
    observation_temp LEFT JOIN plot 
ON
    observation_temp.pl_code = 'pl.' || plot.plot_id
WHERE plot.plot_id IS NULL;

-- validate project codes

SELECT observation_temp.ob_code, observation_temp.pj_code
FROM 
    observation_temp LEFT JOIN project 
ON
    observation_temp.pj_code = 'pj.' || project.project_id
WHERE project.project_id IS NULL;

-- validate cover method codes

SELECT observation_temp.ob_code, observation_temp.cm_code
FROM 
    observation_temp LEFT JOIN covermethod 
ON
    observation_temp.cm_code = 'cm.' || covermethod.covermethod_id
WHERE covermethod.covermethod_id IS NULL;

-- validate stratum method codes

SELECT observation_temp.ob_code, observation_temp.sm_code
FROM 
    observation_temp LEFT JOIN stratummethod 
ON
    observation_temp.sm_code = 'sm.' || stratummethod.stratummethod_id
WHERE stratummethod.stratummethod_id IS NULL;

-- validate soil taxon codes

SELECT observation_temp.ob_code, observation_temp.st_code
FROM 
    observation_temp LEFT JOIN soiltaxon 
ON
    observation_temp.st_code = 'st.' || soiltaxon.soiltaxon_id
WHERE soiltaxon.soiltaxon_id IS NULL;