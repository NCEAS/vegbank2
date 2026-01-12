import traceback
import pandas as pd
from operators import (
    PlotObservation, 
    Project, 
    TaxonObservation,
    table_defs_config as table_defs
)
from utilities import (
    jsonify_error_message,
    bulk_file_upload, 
    merge_df_on_field, 
    validate_file 
) 

def bulk_manager_upload(request, conn, params):
    plot_observations_file = validate_file('plot_observations', request)
    projects_file = validate_file('projects', request)
    strata_file = validate_file('strata', request)
    strata_cover_data_file = validate_file('strata_cover_data', request)
    stem_data_file = validate_file('stem_data', request)
    taxon_interpretation_file = validate_file('taxon_interpretations', request)

    if strata_cover_data_file or strata_file or taxon_interpretation_file or stem_data_file:
        taxon_observation_operator = TaxonObservation(params)
    
    new_pj_codes = []
    errors = {
        "haserror": False,
        "error":[]
    }
    project_operator = Project(params)
    pj_df = pd.read_parquet(projects_file)
    pj_validation = project_operator.validate(pj_df, "projects")
    if pj_validation.get('has_error'):
        print("project validation error:", pj_validation.get('error'))
        errors['haserror'] = True
        errors['error'].append(pj_validation.get('error'))
    pl_df = pd.read_parquet(plot_observations_file)
    plot_observation_operator = PlotObservation(params)
    pl_validation = plot_observation_operator.validate(pl_df, bulk=True)
    if pl_validation.get('has_error'):
        errors['haserror'] = True
        errors['error'].append(pl_validation.get('error'))
        print("plot observation validation error:", pl_validation.get('error'))

    if errors['haserror']:
        error_messages = " ; ".join(errors['error'])
        conn.rollback()
        raise ValueError("Errors encountered during bulk upload: " + error_messages)
    
    if projects_file:
        pjs = bulk_file_upload(project_operator.upload_project, pj_df, conn)
        new_pj_codes = pjs['new_codes']['pj']
        new_pj_codes_df = pjs['new_codes_df']['pj']
    if plot_observations_file:
        if projects_file:
            pl_df = merge_df_on_field(pl_df, new_pj_codes_df, 'pj')
        pls = bulk_file_upload(plot_observation_operator.upload_plot_observations, pl_df, conn)
        new_pl_codes = pls['new_codes']['pl'] 
        new_pl_codes_df = pls['new_codes_df']['pl']
        new_ob_codes = pls['new_codes']['ob'] 
        new_ob_codes_df = pls['new_codes_df']['ob']

    if strata_file:
        strata_df = pd.read_parquet(strata_file)
        if plot_observations_file:
            strata_df = merge_df_on_field(strata_df, new_ob_codes_df, 'ob')
        sr_validation = taxon_observation_operator.validate(strata_df, "strata_definitions")
        if sr_validation.get('has_error'):
            errors['haserror'] = True
            errors['error'].append(sr_validation.get('error'))
        else:
            srs = bulk_file_upload(taxon_observation_operator.upload_strata_definitions, strata_df, conn)
            new_sr_codes = srs['new_codes']['sr']
            new_sr_codes_df = srs['new_codes_df']['sr']
    
    if strata_cover_data_file:
        strata_cover_data_df = pd.read_parquet(strata_cover_data_file)
        if plot_observations_file:
            strata_cover_data_df = merge_df_on_field(strata_cover_data_df, new_ob_codes_df, 'ob')
        if strata_file:
            strata_cover_data_df = merge_df_on_field(strata_cover_data_df, new_sr_codes_df, 'sr')
        sc_validation = taxon_observation_operator.validate(strata_cover_data_df, "strata_cover_data")
        if sc_validation.get('has_error'):
            errors['haserror'] = True
            errors['error'].append(sc_validation.get('error'))  
        else:
            scs = bulk_file_upload(taxon_observation_operator.upload_strata_cover_data, strata_cover_data_df, conn)
            new_to_codes = scs['new_codes']['to']
            new_tm_codes = scs['new_codes']['tm']
    
    if taxon_interpretation_file:
        taxon_interpretation_df = pd.read_parquet(taxon_interpretation_file)
        ti_validation = taxon_observation_operator.validate(taxon_interpretation_df, "taxon_interpretations")
        if ti_validation.get('has_error'):
            errors['haserror'] = True
            errors['error'].append(ti_validation.get('error'))  
        else:
            taxon_observation_operator.upload_taxon_interpretations(taxon_interpretation_df, conn)
    to_return = {
        "resources":{
            "pj": new_pj_codes if projects_file else [],
            "pl": new_pl_codes if plot_observations_file else [],
            "ob": new_ob_codes if plot_observations_file else [],
            "sr": new_sr_codes if strata_file else [],
            "to": new_to_codes if strata_cover_data_file else [],
            "tm": new_tm_codes if strata_cover_data_file else []
        },
        "counts":{
            "pj": pjs['counts']['pj'] if projects_file else 0,
            "pl": pls['counts']['pl'] if plot_observations_file else 0,
            "ob": pls['counts']['ob'] if plot_observations_file else 0,
            "sr": srs['counts']['sr'] if strata_file else 0,
            "to": scs['counts']['to'] if strata_cover_data_file else 0,
            "tm": scs['counts']['tm'] if strata_cover_data_file else 0
        }
    }   
    return to_return               