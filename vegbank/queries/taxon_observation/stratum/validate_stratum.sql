-- Validate stratum type codes

SELECT stratum_temp.vb_sy_code
FROM 
    stratum_temp LEFT JOIN stratumtype 
ON
    stratum_temp.vb_sy_code = 'sy.' || stratumtype.stratumtype_id
WHERE stratumtype.stratumtype_id IS NULL;

-- Validate observation codes

SELECT stratum_temp.vb_ob_code
FROM 
    stratum_temp LEFT JOIN observation 
ON
    stratum_temp.vb_ob_code = 'ob.' || observation.observation_id
WHERE observation.observation_id IS NULL;