select 
    latitude, 
    longitude, 
    observation.accessionCode, 
    observation.authorObsCode 
    from plot join observation on plot.plot_id = observation.plot_id
    WHERE plot.confidentialitystatus < 4
    AND plot.accessionCode != 'VB.pl.78985.001SCHIEB96A'
    AND observation.accessionCode is not NULL
    AND (plot.latitude is not null AND plot.longitude is not null);