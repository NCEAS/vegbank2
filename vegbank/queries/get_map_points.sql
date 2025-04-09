select 
    latitude, 
    longitude, 
    observation.accessionCode, 
    observation.authorObsCode 
    from plot join observation on plot.plot_id = observation.plot_id;