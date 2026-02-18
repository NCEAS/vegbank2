-- Validate observation codes

SELECT user_dataset_item_temp.itemrecord
FROM 
    user_dataset_item_temp LEFT JOIN observation 
ON
    user_dataset_item_temp.itemaccessioncode = 'ob.' || observation.observation_id
WHERE observation.observation_id IS NULL;