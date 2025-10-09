INSERT INTO stratum 
    (
        observation_id, 
        stratumtype_id, 
        stratumbase, 
        stratumheight, 
        stratumcover
    )
VALUES
(
    %s, %s, %s, %s, %s
)
RETURNING stratum_id;