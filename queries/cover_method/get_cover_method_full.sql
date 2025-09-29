SELECT 'cm.' || cm.covermethod_id AS cm_code,
       cm.covertype AS cover_type,
       cm.coverestimationmethod AS cover_estimation_method,
       'rf.' || cm.reference_id AS rf_code,
       rf.shortname AS rf_name,
       cv.covercode AS cover_code,
       cv.lowerlimit AS lower_limit,
       cv.upperlimit AS upper_limit,
       cv.coverpercent AS cover_percent,
       cv.indexdescription AS index_description
  FROM covermethod cm
  LEFT JOIN reference rf USING (reference_id)
  LEFT JOIN coverindex cv USING (covermethod_id)
  LIMIT %s
  OFFSET %s
