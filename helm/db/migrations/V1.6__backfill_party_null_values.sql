----------------------------------------------------------------------------
-- Update party table for specific party_ids to be True
----------------------------------------------------------------------------
UPDATE Party
SET partypublic = TRUE
WHERE party_id IN (458, 456, 474, 413, 291, 347);
----------------------------------------------------------------------------
-- Everything that is still null thereafter is False
----------------------------------------------------------------------------
UPDATE Party
SET partypublic = FALSE
WHERE partypublic IS NULL;