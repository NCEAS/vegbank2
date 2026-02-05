MERGE INTO plantcorrelation dst
USING (
  SELECT tmp.*,
         old_concept.plantstatus_id as correlated_plantstatus_id
    FROM plant_correlation_temp tmp
    LEFT JOIN LATERAL (
      SELECT *
        FROM plantstatus ps
        WHERE ps.plantconcept_id = CAST(SUBSTRING(tmp.vb_correlated_pc_code, 4) AS INT)
        ORDER BY ps.startdate DESC
        LIMIT 1
      ) AS old_concept ON TRUE
) src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    plantstatus_id,
    plantconcept_id,
    plantconvergence,
    correlationstart,
    correlationstop
  ) VALUES (
    correlated_plantstatus_id,
    CAST(SUBSTRING(src.vb_pc_code, 4) AS INT),
    src.plantconvergence,
    src.correlationstart,
    src.correlationstop
  )
RETURNING merge_action(),
          src.user_px_code,
          dst.plantcorrelation_id,
          'px.' || dst.plantcorrelation_id AS vb_px_code;
