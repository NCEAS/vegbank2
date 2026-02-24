UPDATE stratummethod
SET accessioncode = CONCAT('sm.', stratummethod_id)
WHERE stratummethod_id = ANY(%s)
AND accessioncode IS NULL
RETURNING accessioncode, stratummethodname;