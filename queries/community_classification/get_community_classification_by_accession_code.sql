SELECT 
    commClass.accessionCode as commClassAccessionCode,
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
    commInterpretation.commconcept_ID,
    commInterpretation.classfit,
    commInterpretation.classConfidence,
    commInterpretation.commauthority_id,
    commInterpretation.notes,
    commInterpretation.type,
    commInterpretation.nomenclaturaltype,
    commInterpretation.emb_comminterpretation
FROM
    commClass
    LEFT JOIN commInterpretation on commClass.commClass_ID = commInterpretation.commClass_ID
WHERE
    commClass.accessionCode = %s;