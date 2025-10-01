SELECT 'sm.' || sm.stratummethod_id AS sm_code,
       sm.stratummethodname AS stratum_method_name,
       sm.stratummethoddescription AS stratum_method_description,
       sm.stratumassignment AS stratum_assignment,
       'rf.' || rf.reference_id AS rf_code,
       rf.shortname AS rf_name,
       'sy.' || sy.stratumtype_id AS sy_code,
       sy.stratumindex AS stratum_index,
       sy.stratumname AS stratum_name,
       sy.stratumdescription AS stratum_description
  FROM stratummethod sm
  LEFT JOIN reference rf USING (reference_id)
  LEFT JOIN stratumtype sy USING (stratummethod_id)
  LIMIT %s
  OFFSET %s
