plot = [
    'authorplotcode',
    'pl_code',
    'rf_code',
    'reallatitude',
    'reallongitude',
    'locationaccuracy',
    'confidentialitystatus',
    'confidentialityreason',
    'latitude',
    'longitude',
    'authore',
    'authorn',
    'authorzone',
    'authordatum',
    'authorlocation',
    'locationnarrative',
    'plotrationalenarrative',
    'azimuth',
    'dsgpoly',
    'shape',
    'area',
    'standsize',
    'placementmethod',
    'permanence',
    'layoutnarrative',
    'elevation',
    'elevationaccuracy',
    'elevationrange',
    'slopeaspect',
    'minslopeaspect',
    'maxslopeaspect',
    'slopegradient',
    'minslopegradient',
    'maxslopegradient',
    'topoposition',
    'landform',
    'surficialdeposits',
    'rocktype',
    'stateprovince',
    'country',
    'submitter_surname',
    'submitter_givenname',
    'submitter_email',
    'pl_notes_public',
    'pl_notes_mgt',
    'pl_revisions'
]

observation = [
    'ob_code',           
    'pl_code',                           
    'pj_code',               
    'authorobscode',            
    'obsstartdate',             
    'obsenddate',               
    'dateaccuracy',             
    'dateentered',              
    'cm_code',           
    'coverdispersion',          
    'autotaxoncover',           
    'sm_code',         
    'methodnarrative',          
    'taxonobservationarea',     
    'stemsizelimit',            
    'stemobservationarea',      
    'stemsamplemethod',         
    'originaldata',             
    'effortlevel',              
    'plotvalidationlevel',      
    'floristicquality',         
    'bryophytequality',         
    'lichenquality',            
    'observationnarrative',     
    'landscapenarrative',       
    'homogeneity',              
    'phenologicaspect',         
    'representativeness',       
    'standmaturity',            
    'successionalstatus',       
    'numberoftaxa',             
    'basalarea',                
    'hydrologicregime',         
    'soilmoistureregime',       
    'soildrainage',             
    'watersalinity',            
    'waterdepth',               
    'shoredistance',            
    'soildepth',                
    'organicdepth',             
    'st_code',             
    'soiltaxonsrc',             
    'percentbedrock',           
    'percentrockgravel',        
    'percentwood',              
    'percentlitter',            
    'percentbaresoil',          
    'percentwater',             
    'percentother',             
    'nameother',                
    'treeht',                   
    'shrubht',                  
    'fieldht',                  
    'nonvascularht',            
    'submergedht',              
    'treecover',                
    'shrubcover',               
    'fieldcover',               
    'nonvascularcover',         
    'floatingcover',            
    'submergedcover',           
    'dominantstratum',          
    'growthform1type',          
    'growthform2type',          
    'growthform3type',          
    'growthform1cover',         
    'growthform2cover',         
    'growthform3cover',         
    'totalcover',                   
    'ob_notes_public',              
    'ob_notes_mgt',                 
    'ob_revisions',                
    'emb_observation',                    
    'hasobservationsynonym'
]

project = [
    'projectname', 
    'projectdescription', 
    'startdate', 
    'stopdate', 
    'pj_code'
]

#Adding soiltaxon fields now even though we're not uploading them yet, just in case. 
soiltaxon = [
    'soilcode',
    'soilname',
    'soillevel',
    'soilparent_id',
    'soilframework'
]

cover_method = [
    'user_code',
    'rf_code',
    'covertype',
    'coverestimationmethod'
]

cover_index = [
    'covermethod_id',
    'covercode',
    'upperlimit',
    'lowerlimit',
    'coverpercent',
    'indexdescription'
]

stratum_method = [
    'user_code',
    'rf_code',
    'stratummethodname',
    'stratummethoddescription',
    'stratumassignment'
]

stratum_type = [
    'stratummethod_id',
    'stratumindex',
    'stratumname',
    'stratumdescription'
]

taxon_importance = [
    'taxonobservation_id',
    'stratum_id',
    'cover',
    'basalarea',
    'biomass',
    'inferencearea'
]

taxon_observation = [
    'authorplantname',
    'rf_code',
    'taxoninferencearea' #This and inference area are actually different in the data even though they sound similar
]

stratum = [
    'vb_ob_code',
    'user_ob_code',
    'user_sr_code',
    'vb_sy_code', 
    'stratumbase', 
    'stratumheight', 
    'stratumcover'
]