WITH cn AS (
  SELECT commconcept_id,
         JSON_OBJECT_AGG(classsystem, RTRIM(commname)) ->> 'Code' AS comm_code,
         JSON_AGG(usage) AS usages
    FROM (
      SELECT commconcept_id,
             classsystem,
             commname,
             JSON_BUILD_OBJECT('class_system', classsystem,
                               'comm_name', RTRIM(commname),
                               'status', commnamestatus) AS usage
        FROM commusage
    )
    GROUP BY commconcept_id
), cs AS (
  SELECT *
  FROM (
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY commconcept_id
                          ORDER BY startdate DESC) as rn
    FROM
        commstatus)
  WHERE rn = 1
), cx_group AS (
  SELECT commstatus_id,
         JSON_AGG(correlation) AS correlations
    FROM (
      SELECT commstatus_id,
             JSON_BUILD_OBJECT('cc_code', 'cc.' || commconcept_id,
                               'comm_name', commname,
                               'convergence', commconvergence) AS correlation
        FROM commcorrelation
        JOIN commconcept USING (commconcept_id)
        WHERE correlationstop IS NULL
    )
    GROUP BY commstatus_id
)
SELECT 'cc.' || cc.commconcept_id AS cc_code,
       cc.commname AS comm_name,
       cn.comm_code AS comm_code,
       cc.commdescription AS comm_description,
       'rf.' || cc.reference_id AS concept_rf_code,
       rf_cc.shortname AS concept_rf_name,
       'rf.' || cs.reference_id AS status_rf_code,
       rf_cs.shortname AS status_rf_name,
       cn.usages as usages,
       cc.d_obscount as obs_count,
       cs.commlevel AS comm_level,
       cs.commconceptstatus AS status,
       cs.startdate AS start_date,
       cs.stopdate AS stop_date,
       (cs.stopdate IS NULL OR now() < cs.stopdate) AND
         LOWER(cs.commconceptstatus) = 'accepted' AS current_accepted,
       'py.' || py.party_id AS py_code,
       COALESCE(py.surname, py.organizationname) AS party,
       cs.commpartycomments AS comm_party_comments,
       'cc.' || cs.commparent_id AS parent_cc_code,
       pa.commname AS parent_name,
       children AS children,
       cx_group.correlations AS correlations
  FROM commconcept cc
  LEFT JOIN cn USING (commconcept_id)
  LEFT JOIN cs USING (commconcept_id)
  LEFT JOIN commconcept pa ON (pa.commconcept_id = cs.commparent_id)
  LEFT JOIN reference rf_cc ON cc.reference_id = rf_cc.reference_id
  LEFT JOIN reference rf_cs ON cs.reference_id = rf_cs.reference_id
  LEFT JOIN party py ON py.party_id = cs.party_id
  LEFT JOIN (
    SELECT parent_id,
           JSON_AGG(child) AS children
      FROM (
        SELECT commparent_id AS parent_id,
               JSON_BUILD_OBJECT('cc_code', 'cc.' || commconcept_id,
                                 'comm_name', commname) AS child
          FROM commstatus ch_status
          JOIN commconcept ch_concept USING (commconcept_id)
      )
      GROUP BY parent_id
    ) children ON children.parent_id = cc.commconcept_id
  LEFT JOIN cx_group USING (commstatus_id)
  LIMIT %s
  OFFSET %s
