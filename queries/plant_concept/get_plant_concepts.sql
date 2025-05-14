SELECT 
   plantConcept.plantconcept_id,
   plantConcept.plantname,
   plantConcept.plantcode,
   plantConcept.plantDescription,
   plantConcept.d_obscount,
   plantConcept.d_currentaccepted,
   reference.title as refTitle,
   reference.accessionCode as refAccessionCode
FROM  
   plantConcept
   LEFT JOIN reference on plantConcept.reference_id = reference.reference_id
WHERE 
   plantConcept.accessionCode = %s;