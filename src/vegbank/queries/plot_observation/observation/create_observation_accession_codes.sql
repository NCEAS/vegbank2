UPDATE observation
SET accessioncode = CONCAT('ob.', observation_id)
WHERE observation_id = ANY(%s)
AND accessioncode IS NULL
RETURNING accessioncode, authorobscode;