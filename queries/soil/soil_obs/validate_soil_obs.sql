-- Validate ob codes
SELECT soil_obs_temp.vb_ob_code
  FROM soil_obs_temp LEFT JOIN observation
    ON soil_obs_temp.vb_ob_code = 'ob.' || observation.observation_id
  WHERE observation.observation_id IS NULL;
