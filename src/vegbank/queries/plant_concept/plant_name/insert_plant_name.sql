-- Step 1: Insert only new plant names
WITH new_plants AS (
    INSERT INTO plantname (plantname)
    SELECT DISTINCT tmp.plantname
    FROM plant_name_temp tmp
    WHERE NOT EXISTS (
        SELECT 1
        FROM plantname pn
        WHERE pn.plantname = tmp.plantname
    )
    RETURNING plantname_id,
              plantname AS user_pn_code
),
-- Step 2: Get max IDs for existing plant names
existing_plants AS (
    SELECT
        MAX(pn.plantname_id) AS plantname_id,
        pn.plantname AS user_pn_code
    FROM plantname pn
    INNER JOIN plant_name_temp tmp ON pn.plantname = tmp.plantname
    GROUP BY pn.plantname
)
-- Combine results
SELECT user_pn_code,
       plantname_id,
       'pn.' || plantname_id AS vb_pn_code
  FROM new_plants
UNION ALL
SELECT user_pn_code,
       plantname_id,
       'pn.' || plantname_id AS vb_pn_code
  FROM existing_plants;
