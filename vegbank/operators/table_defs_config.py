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
    'user_tm_code',
    'user_to_code',
    'vb_to_code',
    'user_sr_code',
    'vb_sr_code',
    'cover',
    'basal_area',
    'biomass',
    'inference_area'
]

taxon_observation = [
    'user_to_code',
    'user_ob_code',
    'vb_ob_code',
    'author_plant_name',
    'vb_rf_code',
    'taxon_inference_area' #This and inference area are actually different in the data even though they sound similar
]

stratum = [
    'vb_ob_code',
    'user_ob_code',
    'user_sr_code',
    'vb_sy_code', 
    'stratum_base', 
    'stratum_height', 
    'stratum_cover'
]

taxon_interpretation = [
    'user_ti_code',
    'user_to_code',
    'vb_to_code',
    'vb_pc_code',
    'interpretation_date',
    'user_py_code',
    'vb_py_code',
    'user_ro_code',
    'vb_ro_code',
    'interpretation_type',
    'user_rf_code',
    'vb_rf_code',
    'original_interpretation',
    'current_interpretation',
    'taxon_fit',
    'taxon_confidence',
    'user_collector_rf_code',
    'vb_collector_rf_code', #Currently always null
    'collection_number',
    'collection_date',
    'user_museum_rf_code',
    'vb_museum_rf_code', #Currently always null
    'museum_accession_number',
    'group_type',
    'notes',
    'notes_public',
    'notes_mgt'   
]

party = [
    'user_py_code',
    'surname',
    'given_name',
    'middle_name',
    'organization_name',
    'email',
    'orcid',
    'ror'
]