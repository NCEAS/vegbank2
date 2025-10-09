SELECT 
    'cl.' || commClass.commclass_id AS cl_code,
    commClass.classStartDate,
    commClass.classStopDate,
    commClass.inspection,
    commClass.tableAnalysis,
    commClass.multivariateanalysis,
    commClass.expertSystem,
    commClass.classnotes,
    commClass.commname,
    commClass.commcode,
    commClass.commframework,
    commClass.commLevel,
    commClass.emb_commclass,
    'cc.' || commInterpretation.commconcept_id AS cc_code,
    commInterpretation.classfit,
    commInterpretation.classConfidence,
    'rf.' || commInterpretation.commauthority_id AS comm_authority_rf_code,
    commInterpretation.notes,
    commInterpretation.type,
    commInterpretation.nomenclaturaltype,
    commInterpretation.emb_comminterpretation
FROM
    commClass
    LEFT JOIN commInterpretation on commClass.commClass_ID = commInterpretation.commClass_ID
LIMIT %s 
OFFSET %s;
