WITH state_counts AS (    
    SELECT         
    stateprovince,        
    COUNT(*) AS state_count    
    FROM plot    
    GROUP BY         
    stateprovince), 
RankedRecords AS(    
    SELECT        
    plot.plot_id as plotid,         
    observation.observation_id as observationid,        
    plot.stateprovince,        
    plot.accessionCode as plotAccessionCode,        
    plot.latitude as latitude,        
    plot.longitude as longitude,        
    plot.area as area,        
    plot.permanence as permanence,         
    plot.elevation as elevation,        
    plot.slopeAspect as slopeAspect,        
    plot.locationNarrative as locationNarrative,        
    plot.country as country,        
    plot.authorPlotCode as authorPlotCode,        
    plot.stateprovince as plotstateprovince,        
    plot.slopeGradient as slopeGradient,        
    dba_confidentialitystatus.confidentialityshorttext as confidentialityStatus,        
    observation.accessionCode as obsAccessionCode,         
    observation.authorObsCode as authorObsCode,        
    observation.obsStartDate as obsStartDate,        
    observation.obsEndDate as obsEndDate,         
    observation.plotValidationLevel as plotValidationLevel,        
    observation.taxonObservationArea as taxonObservationArea,        
    observation.autoTaxonCover as autoTaxonCover,        
    observation.topTaxon1name as topTaxon1name,        
    observation.topTaxon2name as topTaxon2name,        
    observation.topTaxon3name as topTaxon3name,        
    observation.topTaxon4name as topTaxon4name,         
    observation.topTaxon5name as topTaxon5name,        
    observation.interp_current_partyname,        
    observation.dateentered as obsdateentered,        
    project.accessionCode as projectAccessionCode,        
    project.projectName as projectName,        
    coverMethod.accessionCode as coverMethodAccessionCode,        
    coverMethod.coverType as coverType,         
    stratumMethod.accessionCode as stratumMethodAccessionCode,        
    stratumMethod.stratumMethodName as stratumMethodName,        
    stratumMethod.stratumMethodDescription as stratumMethoddescription,        
    commconcept.reference_id as commconceptReference,        
    commconcept.accessioncode as commconceptAccessionCode,         
    commname.reference_id as commnameReference,         
    commname.commname as commname,        
    state_counts.state_count as num_states,        
    json_agg(            
        json_build_object(                
            'authorplantname', taxonObservation.authorplantname,                
            'cover', taxonImportance.cover            
            )            
            ORDER BY taxonImportance.cover DESC        
        ) as taxa,        
        state_counts.state_count,        
        ROW_NUMBER() OVER (PARTITION BY plot.stateprovince ORDER BY plot.plot_id) as row_num     
    FROM plot    
    left join dba_confidentialitystatus on dba_confidentialitystatus.confidentialityStatus = plot.confidentialityStatus    
    right join observation on plot.plot_id = observation.plot_id    
    left join coverMethod on observation.covermethod_ID = coverMethod.covermethod_ID    
    left join stratumMethod on observation.stratummethod_ID = stratumMethod.stratummethod_ID    
    left join project on observation.project_id = project.project_id    
    left join commclass on observation.observation_id = commclass.observation_id    
    left join comminterpretation on commclass.commclass_id = comminterpretation.commclass_id    
    left join commconcept on comminterpretation.commconcept_id = commconcept.commconcept_id    
    left join commname on commname.commname_id = commconcept.commname_id    
    left join taxonobservation on taxonobservation.observation_id = observation.observation_id    
    left join taxonimportance on taxonimportance.taxonobservation_id = taxonobservation.taxonobservation_id    
    left join stratum on taxonimportance.stratum_id = stratum.stratum_id    
    left join state_counts on plot.stateprovince = state_counts.stateprovince    
GROUP BY         
    plot.plot_id,         
    observation.observation_id,        
    plot.stateprovince,        
    plot.accessionCode ,        
    plot.latitude,        
    plot.longitude ,        
    plot.area,        
    plot.permanence,         
    plot.elevation,        
    plot.slopeAspect,        
    plot.locationNarrative,        
    plot.country,        
    plot.authorPlotCode,        
    plot.stateprovince,        
    plot.slopeGradient,        
    dba_confidentialitystatus.confidentialityshorttext,        
    observation.accessionCode,         
    observation.authorObsCode,        
    observation.obsStartDate,        
    observation.obsEndDate,         
    observation.plotValidationLevel,        
    observation.topTaxon1name,        
    observation.topTaxon2name,        
    observation.topTaxon3name,        
    observation.topTaxon4name,         
    observation.topTaxon5name,        
    observation.autoTaxonCover,        
    observation.interp_current_partyname,        
    observation.dateentered,        
    observation.taxonObservationArea,        
    project.accessionCode,        
    project.projectName,        
    coverMethod.accessionCode ,        
    coverMethod.coverType,         
    stratumMethod.accessionCode,        
    stratumMethod.stratumMethodName,        
    stratumMethod.stratumMethodDescription,        
    commconcept.reference_id,         
    commconcept.accessioncode,        
    commname.reference_id,         
    commname.commname,        
    state_counts.state_count)
SELECT     
    plotstateprovince,    
    plotAccessionCode,    
    latitude,    
    longitude,    
    area,    
    permanence,     
    elevation,    
    slopeAspect,    
    locationNarrative,    
    country,    
    authorPlotCode,    
    confidentialityStatus,    
    obsAccessionCode,     
    authorObsCode,    
    obsStartDate,    
    obsEndDate,     
    plotValidationLevel,    
    CASE         
        plotValidationLevel         
        WHEN CAST(-1 AS int)  THEN '(-1) observation has not yet been fully rectified by user and is not complete.'        
        WHEN CAST(1 AS int) THEN '(1) sufficient for determining type occurrence.'        
        WHEN CAST(2 AS int) THEN '(2) sufficient for inclusion in a classification revision.'        
        WHEN CAST(3 AS int) THEN '(3) fully compliant with recommendations.'        
    END 
    plotValidationLevelDescr,    
    topTaxon1name,    
    topTaxon2name,    
    topTaxon3name,    
    topTaxon4name,     
    topTaxon5name,    
    taxonObservationArea,    
    autoTaxonCover,    
    interp_current_partyname,    
    obsdateentered,    
    slopeGradient,    
    projectAccessionCode,    
    projectName,    
    coverMethodAccessionCode,    
    coverType,     
    stratumMethodAccessionCode,    
    stratumMethodName,    
    stratumMethoddescription,    
    commconceptReference,     
    commconceptAccessionCode,    
    commnameReference,     
    commname,    
    num_states,    
    taxa    
from RankedRecords WHERE      
    CASE WHEN (RankedRecords.state_count * 0.02) > 10 THEN row_num <= (RankedRecords.state_count * 0.02)    
    ELSE row_num <= 10    
    END;