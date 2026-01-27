-- Validate ob codes
SELECT disturbance_obs_temp.vb_ob_code
  FROM disturbance_obs_temp LEFT JOIN observation
    ON disturbance_obs_temp.vb_ob_code = 'ob.' || observation.observation_id
  WHERE observation.observation_id IS NULL;
