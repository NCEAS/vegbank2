-- Validate plot codes

SELECT observation_temp.vb_pl_code
FROM 
    observation_temp LEFT JOIN plot 
ON
    observation_temp.vb_pl_code = 'pl.' || plot.plot_id
WHERE plot.plot_id IS NULL;

-- validate project codes

SELECT observation_temp.vb_pj_code
FROM 
    observation_temp LEFT JOIN project 
ON
    observation_temp.vb_pj_code = 'pj.' || project.project_id
WHERE project.project_id IS NULL AND observation_temp.vb_pj_code IS NOT NULL;

-- validate cover method codes

SELECT observation_temp.vb_cm_code
FROM 
    observation_temp LEFT JOIN covermethod 
ON
    observation_temp.vb_cm_code = 'cm.' || covermethod.covermethod_id
WHERE covermethod.covermethod_id IS NULL AND observation_temp.vb_cm_code IS NOT NULL;

-- validate stratum method codes

SELECT observation_temp.vb_sm_code
FROM 
    observation_temp LEFT JOIN stratummethod 
ON
    observation_temp.vb_sm_code = 'sm.' || stratummethod.stratummethod_id
WHERE stratummethod.stratummethod_id IS NULL AND observation_temp.vb_sm_code IS NOT NULL;

-- validate soil taxon codes

SELECT observation_temp.vb_so_code
FROM 
    observation_temp LEFT JOIN soiltaxon 
ON
    observation_temp.vb_so_code = 'so.' || soiltaxon.soiltaxon_id
WHERE soiltaxon.soiltaxon_id IS NULL AND observation_temp.vb_so_code IS NOT NULL;