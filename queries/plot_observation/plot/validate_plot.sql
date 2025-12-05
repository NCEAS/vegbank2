DELETE FROM plot_temp 
WHERE plot_temp.vb_pl_code IN (
SELECT 
    plot_temp.vb_pl_code
FROM plot_temp 
LEFT JOIN plot ON 
    plot_temp.vb_pl_code = 'pl.' || plot.plot_id
WHERE 
    plot.plot_id IS NOT NULL AND plot_temp.vb_pl_code IS NOT NULL
) RETURNING plot_temp.vb_pl_code;

SELECT 
    plot_temp.vb_parent_pl_code
FROM plot_temp
LEFT JOIN plot ON 
    plot_temp.vb_parent_pl_code = 'pl.' || plot.plot_id
WHERE 
    plot.plot_id IS NULL AND plot_temp.vb_parent_pl_code IS NOT NULL;