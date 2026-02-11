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
    collector_id, -- This has no nonzero values currently
    collectionnumber,
    collectiondate,
    museum_id, -- This has no nonzero values currently
    museumaccessionnumber,
    grouptype,
    notes,
    notespublic,
    notesmgt
  ) VALUES (
    CAST(SUBSTRING(vb_to_code, 4) AS INT),
    CAST(SUBSTRING(vb_pc_code, 4) AS INT),
    interpretationdate,
    CAST(SUBSTRING(vb_py_code, 4) AS INT),
    CAST(SUBSTRING(vb_ro_code, 4) AS INT),
    interpretationtype,
    CAST(SUBSTRING(vb_rf_code, 4) AS INT),
    originalinterpretation,
    currentinterpretation,
    taxonfit,
    taxonconfidence,
    CAST(SUBSTRING(vb_collector_rf_code, 4) AS INT), -- This has no nonzero values currently
    collectionnumber,
    collectiondate,
    CAST(SUBSTRING(vb_museum_rf_code, 4) AS INT), -- This has no nonzero values currently
    museumaccessionnumber,
    grouptype,
    notes,
    notespublic,
    notesmgt
  )
RETURNING merge_action(),
          src.user_ti_code,
          dst.taxoninterpretation_id,
          'ti.' || dst.taxoninterpretation_id AS vb_ti_code;