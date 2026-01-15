-- Step 1: Insert only new comm names
WITH new_comms AS (
    INSERT INTO commname (commname)
    SELECT DISTINCT tmp.commname
    FROM comm_usage_name_temp tmp
    WHERE NOT EXISTS (
        SELECT 1
        FROM commname cn
        WHERE cn.commname = tmp.commname
    )
    RETURNING commname_id,
              commname AS user_cn_code
),
-- Step 2: Get max IDs for existing comm names
existing_comms AS (
    SELECT
        MAX(cn.commname_id) AS commname_id,
        cn.commname AS user_cn_code
    FROM commname cn
    INNER JOIN comm_usage_name_temp tmp ON cn.commname = tmp.commname
    GROUP BY cn.commname
)
-- Combine results
SELECT user_cn_code,
       commname_id,
       'cn.' || commname_id AS vb_cn_code
  FROM new_comms
UNION ALL
SELECT user_cn_code,
       commname_id,
       'cn.' || commname_id AS vb_cn_code
  FROM existing_comms;
