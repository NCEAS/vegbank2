MERGE INTO taxoninterpretation dst
USING taxon_interpretation_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    taxonobservation_id,
    plantconcept_id,
    interpretationdate,
    party_id,
    role_id,
    interpretationtype,
    reference_id,
    originalinterpretation,
    currentinterpretation,
    taxonfit,
    taxonconfidence,
    collector_id,
    collectionnumber,
    collectiondate,
    museum_id,
    museumaccessionnumber,
    grouptype,
    notes,
    emb_taxoninterpretation
  ) VALUES (
    CAST(SUBSTRING(vb_to_code, 4) AS INT),
    CAST(SUBSTRING(vb_pc_code, 4) AS INT),
    interpretationdate,
    CAST(SUBSTRING(vb_py_code, 4) AS INT),
    CAST(SUBSTRING(vb_ar_code, 4) AS INT),
    interpretationtype,
    CAST(SUBSTRING(vb_rf_code, 4) AS INT),
    originalinterpretation,
    currentinterpretation,
    taxonfit,
    taxonconfidence,
    CAST(SUBSTRING(vb_collector_py_code, 4) AS INT),
    collectionnumber,
    collectiondate,
    CAST(SUBSTRING(vb_museum_py_code, 4) AS INT),
    museumaccessionnumber,
    grouptype,
    notes,
    0
  )
RETURNING merge_action(),
          src.user_ti_code,
          dst.taxoninterpretation_id,
          'ti.' || dst.taxoninterpretation_id AS vb_ti_code;
