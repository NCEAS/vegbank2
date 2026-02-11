UPDATE plot
SET accessioncode = CONCAT('pl.', plot_id)
WHERE plot_id = ANY(%s)
AND accessioncode IS NULL
RETURNING accessioncode, authorplotcode;