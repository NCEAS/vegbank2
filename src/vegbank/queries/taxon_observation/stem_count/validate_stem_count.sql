-- Validate taxon importance codes

SELECT stem_count_temp.vb_tm_code
FROM 
    stem_count_temp LEFT JOIN taxonimportance 
ON
    stem_count_temp.vb_tm_code = 'tm.' || taxonimportance.taxonimportance_id
WHERE taxonimportance.taxonimportance_id IS NULL;