SELECT 
    plot.latitude,
    plot.longitude,
    plot.authorPlotCode,
    plot.stateProvince,
    plot.area,
    plot.permanence,
    plot.elevation,
    plot.slopeAspect,
    plot.locationNarrative,
    plot.country,
    plot.slopeGradient,
    plot.accessionCode as plotAccessionCode,
    dba_confidentialitystatus.confidentialitytext,
    observation.authorObsCode,
    observation.obsStartDate,
    observation.obsEndDate,
    observation.plotValidationLevel as plotValidationLevel,
    CASE         
        plotValidationLevel         
        WHEN CAST(-1 AS int)  THEN '(-1) observation has not yet been fully rectified by user and is not complete.'        
        WHEN CAST(1 AS int) THEN '(1) sufficient for determining type occurrence.'        
        WHEN CAST(2 AS int) THEN '(2) sufficient for inclusion in a classification revision.'        
        WHEN CAST(3 AS int) THEN '(3) fully compliant with recommendations.'        
    END 
    plotValidationLevelDescr, 
    observation.taxonObservationArea,
    observation.autoTaxonCover,
    observation.interp_current_partyname,
    observation.dateentered,
    observation.effortlevel,
    observation.floristicQuality,
    observation.bryophyteQuality,
    observation.lichenQuality,
    observation.accessionCode as obsAccessionCode,
    project.accessionCode as projectAccessionCode,
    project.projectName,
    coverMethod.accessionCode as coverMethodAccessionCode,
    coverMethod.coverType,
    stratumMethod.accessionCode as stratumMethodAccessionCode,
    stratumMethod.stratumMethodName,
    stratummethod.stratumMethodDescription
FROM plot    
    left join dba_confidentialitystatus on dba_confidentialitystatus.confidentialityStatus = plot.confidentialityStatus    
    right join observation on plot.plot_id = observation.plot_id    
    left join coverMethod on observation.covermethod_ID = coverMethod.covermethod_ID    
    left join stratumMethod on observation.stratummethod_ID = stratumMethod.stratummethod_ID    
    left join project on observation.project_id = project.project_id        
WHERE 
    observation.accessionCode = %s;