WITH pn AS (
  SELECT plantconcept_id,
         JSON_OBJECT_AGG(classsystem, RTRIM(plantname)) AS usage_names,
         JSON_OBJECT_AGG(classsystem, plantnamestatus) AS usage_statuses
    FROM plantusage
    GROUP BY plantconcept_id
), ps AS (
  SELECT *
  FROM (
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY plantconcept_id
                          ORDER BY startdate DESC) as rn
    FROM
        plantstatus)
  WHERE rn = 1
), px_group AS (
  SELECT plantstatus_id,
         JSON_AGG(correlation) AS correlations
    FROM (
      SELECT plantstatus_id,
             JSON_BUILD_OBJECT('pc_code', 'pc.' || plantconcept_id,
                               'plant_name', plantname,
                               'convergence', plantconvergence) AS correlation
        FROM plantcorrelation
        JOIN plantconcept USING (plantconcept_id)
        WHERE correlationstop IS NULL
    )
    GROUP BY plantstatus_id
)
SELECT 'pc.' || pc.plantconcept_id AS pc_code,
       pc.plantname AS plant_name,
       pn.usage_names ->> 'Code' AS plant_code,
       pc.plantdescription AS plant_description,
       'rf.' || pc.reference_id AS concept_rf_code,
       rf_pc.shortname AS concept_rf_name,
       'rf.' || ps.reference_id AS status_rf_code,
       rf_ps.shortname AS status_rf_name,
       pn.usage_names::text AS usage_names,
       pn.usage_statuses::text AS usage_statuses,
       pc.d_obscount as obs_count,
       ps.plantlevel AS plant_level,
       ps.plantconceptstatus AS status,
       ps.startdate AS start_date,
       ps.stopdate AS stop_date,
       (ps.stopdate IS NULL OR now() < ps.stopdate) AND
         LOWER(ps.plantconceptstatus) = 'accepted' AS current_accepted,
       'py.' || py.party_id AS py_code,
       COALESCE(py.surname, py.organizationname) AS party,
       ps.plantpartycomments AS plant_party_comments,
       'pc.' || ps.plantparent_id AS parent_pc_code,
       pa.plantname AS parent_name,
       children::text AS children,
       px_group.correlations AS correlations
  FROM plantconcept pc
  LEFT JOIN pn USING (plantconcept_id)
  LEFT JOIN ps USING(plantconcept_id)
  LEFT JOIN plantconcept pa ON (pa.plantconcept_id = ps.plantparent_id)
  LEFT JOIN reference rf_pc ON pc.reference_id = rf_pc.reference_id
  LEFT JOIN reference rf_ps ON ps.reference_id = rf_ps.reference_id
  LEFT JOIN party py ON py.party_id = ps.party_id
  LEFT JOIN (
    SELECT plantparent_id AS parent_id,
           JSON_OBJECT_AGG('pc.' || plantconcept_id, plantname) AS children
      FROM plantstatus ch_status
      JOIN plantconcept ch_concept USING (plantconcept_id)
      GROUP BY plantparent_id
    ) children ON children.parent_id = pc.plantconcept_id
  LEFT JOIN px_group USING (plantstatus_id)
  LIMIT %s
  OFFSET %s
