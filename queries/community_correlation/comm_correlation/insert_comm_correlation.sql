MERGE INTO commcorrelation dst
USING (
  SELECT tmp.*,
         old_concept.commstatus_id as correlated_commstatus_id
    FROM comm_correlation_temp tmp
    LEFT JOIN LATERAL (
      SELECT *
        FROM commstatus cs
        WHERE cs.commconcept_id = CAST(SUBSTRING(tmp.vb_correlated_cc_code, 4) AS INT)
        ORDER BY cs.startdate DESC
        LIMIT 1
      ) AS old_concept ON TRUE
) src
ON FALSE
WHEN MATCHED THEN DO NOTHING
WHEN NOT MATCHED THEN
  INSERT (
    commstatus_id,
    commconcept_id,
    commconvergence,
    correlationstart,
    correlationstop
  ) VALUES (
    correlated_commstatus_id,
    CAST(SUBSTRING(src.vb_cc_code, 4) AS INT),
    src.commconvergence,
    src.correlationstart,
    src.correlationstop
  )
RETURNING merge_action(),
          src.user_cx_code,
          dst.commcorrelation_id,
          'cx.' || dst.commcorrelation_id AS vb_cx_code;
