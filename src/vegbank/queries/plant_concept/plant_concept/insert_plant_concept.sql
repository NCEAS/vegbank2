MERGE INTO plantconcept dst
USING plant_concept_temp src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    plantname_id,
    reference_id,
    plantname,
    plantdescription,
    d_obscount
  ) VALUES (
    CAST(SUBSTRING(src.vb_pn_code, 4) AS INT),
    CAST(SUBSTRING(src.vb_rf_code, 4) AS INT),
    src.plantname,
    src.plantdescription,
    0
  )
RETURNING merge_action(),
          src.user_pc_code,
          dst.plantconcept_id,
          'pc.' || dst.plantconcept_id AS vb_pc_code;
