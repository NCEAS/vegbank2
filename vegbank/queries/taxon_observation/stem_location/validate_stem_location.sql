-- Validate stem count codes

SELECT stem_location_temp.vb_sc_code
FROM 
    stem_location_temp LEFT JOIN stemcount 
ON
    stem_location_temp.vb_sc_code = 'sc.' || stemcount.stemcount_id
WHERE stemcount.stemcount_id IS NULL;