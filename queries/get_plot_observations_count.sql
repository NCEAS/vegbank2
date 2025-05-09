SELECT 
    count(*)
FROM 
    observation 
    join plot on observation.plot_id = plot.plot_id
WHERE plot.confidentialitystatus < 4;