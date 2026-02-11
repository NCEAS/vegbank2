UPDATE covermethod
SET accessioncode = CONCAT('cm.', covermethod_id)
WHERE covermethod_id = ANY(%s)
AND accessioncode IS NULL
RETURNING accessioncode, covertype;