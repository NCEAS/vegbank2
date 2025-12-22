import traceback
import pandas as pd
from operators import (
    PlotObservation, 
    Project
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
    new_pj_codes = []
    if projects_file:
        project_operator = Project(params)
        pj_df = pd.read_parquet(projects_file)
        pjs = bulk_file_upload(project_operator.upload_project, 'pj', pj_df, conn)
        new_pj_codes = pjs['new_codes']
        new_pj_codes_df = pjs['new_codes_df']
    if plot_observations_file:
        plot_observation_operator = PlotObservation(params)
        pl_df = pd.read_parquet(plot_observations_file)
        if projects_file:
            pl_df = merge_df_on_field(pl_df, new_pj_codes_df, 'pj')
        pls = bulk_file_upload(plot_observation_operator.upload_plot_observations, 'pl', pl_df, conn)
        new_pl_codes = pls['new_codes'] 
        new_pl_codes_df = pls['new_codes_df']
    to_return = {
        "resources":{
            "pj": new_pj_codes['resources']['pj'] if projects_file else [],
            "pl": new_pl_codes['resources']['pl'] if plot_observations_file else []
        },
        "counts":{
            "pj": new_pj_codes['counts']['pj'] if projects_file else 0,
            "pl": new_pl_codes['counts']['pl'] if plot_observations_file else 0
        }
    }   
    return to_return               