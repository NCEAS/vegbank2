plot = [
    'user_pl_code',
    'authorplotcode',
    'vb_parent_pl_code',
    'user_parent_pl_code',
    'real_latitude',
    'real_longitude',
    'location_accuracy',
    'confidentiality_status',
    'confidentiality_reason',
    'author_e',
    'author_n',
    'author_zone',
    'author_datum',
    'author_location',
    'location_narrative',
    'azimuth',
    'dsgpoly',
    'shape',
    'area',
    'stand_size',
    'placement_method',
    'permanence',
    'layout_narrative',
    'elevation',
    'elevation_accuracy',
    'elevation_range',
    'slope_aspect',
    'min_slope_aspect',
    'max_slope_aspect',
    'slope_gradient',
    'min_slope_gradient',
    'max_slope_gradient',
    'topo_position',
    'landform',
    'surficial_deposits',
    'rock_type',
    'quadrangle_name',
    'county',
    'state_province',
    'country',
    'continent',
    'submitter_surname',
    'submitter_givenname',
    'submitter_email',
    'pl_notes_public',
    'pl_notes_mgt'
]

observation = [
    'user_ob_code',
    'vb_pl_code',
    'user_pl_code',                                      
    'user_pj_code',  
    'vb_pj_code',             
    'author_obs_code',            
    'obs_start_date',             
    'obs_end_date',               
    'date_accuracy',             
    'date_entered',              
    'vb_cm_code',           
    'cover_dispersion',          
    'auto_taxon_cover',           
    'vb_sm_code',         
    'method_narrative',          
    'taxon_observation_area',     
    'stem_size_limit',            
    'stem_observation_area',      
    'stem_sample_method',         
    'original_data',             
    'effort_level',                  
    'floristic_quality',         
    'bryophyte_quality',         
    'lichen_quality',            
    'observation_narrative',     
    'landscape_narrative',       
    'homogeneity',              
    'phenologic_aspect',               
    'stand_maturity',            
    'successional_status',                  
    'basal_area',                
    'hydrologic_regime',         
    'soil_moisture_regime',       
    'soil_drainage',             
    'water_salinity',            
    'water_depth',               
    'shore_distance',            
    'soil_depth',                
    'organic_depth',             
    'vb_so_code',             
    'soil_taxon_src',             
    'percent_bedrock',           
    'percent_rock_gravel',        
    'percent_wood',              
    'percent_litter',            
    'percent_bare_soil',          
    'percent_water',             
    'percent_other',             
    'name_other',                
    'tree_ht',                   
    'shrub_ht',                  
    'field_ht',                  
    'nonvascular_ht',            
    'submerged_ht',              
    'tree_cover',                
    'shrub_cover',               
    'field_cover',               
    'nonvascular_cover',         
    'floating_cover',            
    'submerged_cover',           
    'dominant_stratum',          
    'growthform_1_type',          
    'growthform_2_type',          
    'growthform_3_type',          
    'growthform_1_cover',         
    'growthform_2_cover',         
    'growthform_3_cover',         
    'total_cover',                   
    'ob_notes_public',              
    'ob_notes_mgt',                 
    'ob_revisions',                
    'emb_observation',                    
    'has_observation_synonym'
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