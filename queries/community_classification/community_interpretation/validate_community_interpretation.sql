-- Validate community concept codes

SELECT community_interpretation_temp.vb_cc_code
FROM 
    community_interpretation_temp LEFT JOIN commconcept 
ON
    community_interpretation_temp.vb_cc_code = 'cc.' || commconcept.commconcept_id
WHERE commconcept.commconcept_id IS NULL;

-- Validate community class codes  
SELECT community_interpretation_temp.vb_cl_code
FROM 
    community_interpretation_temp LEFT JOIN commclass
ON
    community_interpretation_temp.vb_cl_code = 'cl.' || commclass.commclass_id
WHERE commclass.commclass_id IS NULL;
