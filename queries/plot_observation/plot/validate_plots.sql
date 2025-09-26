DELETE FROM plot_temp 
WHERE plot_temp.pl_code IN (
SELECT 
    plot_temp.pl_code
FROM plot_temp 
LEFT JOIN plot ON 
    plot_temp.pl_code = 'pl.' || plot.plot_id
WHERE 
    plot.plot_id IS NOT NULL
) RETURNING plot_temp.pl_code, plot_temp.authorplotcode;

-- validate reference codes

SELECT 
    nonnullrefcodes.pl_code, nonnullrefcodes.rf_code
FROM
(SELECT 
    plot_temp.pl_code, plot_temp.rf_code
FROM plot_temp
WHERE rf_code IS NOT NULL) AS nonnullrefcodes
LEFT JOIN reference
ON nonnullrefcodes.rf_code = 'rf.' || reference.reference_id
WHERE reference.reference_id IS NULL;
