from operators import table_defs_config
from utilities import validate_required_and_missing_fields
config = {
    # Defines the required fields and table defs for each file that vegbank uploads. 
    
    "projects":{
        "required_fields":['project_name', 'user_pj_code'],
        "table_defs":[table_defs_config.project]
    },
    "references":{
        "required_fields":['user_rf_code'],
        "table_defs":[table_defs_config.reference]
    },
    "parties":{
        "required_fields":['user_py_code'],
        "table_defs":[table_defs_config.party]
    },
    "soils":{
        "required_fields":['user_so_code', 'horizon'],
        "table_defs":[table_defs_config.soil_obs]
    },
    "disturbances":{
        "required_fields":['user_do_code', 'type'],
        "table_defs":[table_defs_config.disturbance_obs]
    },
    "community_classifications":{
        "required_fields":['user_cc_code', 'community_name'],
        "table_defs":[table_defs_config.comm_class, table_defs_config.comm_interp]
    },
    "strata":{
        "required_fields":['user_ob_code', 'user_sr_code', 'vb_sy_code'],
        "table_defs":[table_defs_config.stratum]
    },
    "strata_cover_data":{
        "required_fields":['user_to_code', 'user_ob_code', 'author_plant_name', 'user_tm_code'],
        "table_defs":[table_defs_config.taxon_importance, table_defs_config.taxon_observation]
    },
    "stem_data":{
        "required_fields":['user_sc_code', 'user_tm_code', 'stem_count'],
        "table_defs":[table_defs_config.stem_count, table_defs_config.stem_location]
    },
    "taxon_interpretations":{
        "required_fields":['user_ti_code', 'user_to_code', 'vb_pc_code', 'vb_ro_code', 'original_interpretation', 'current_interpretation'],
        "table_defs": [table_defs_config.taxon_interpretation],
        "xor_fields":[('user_py_code', 'vb_py_code')]
    },
    "contributors":{
        "required_fields":['vb_ar_code', 'contributor_type', 'record_identifier'],
        "table_defs":[table_defs_config.contributor]
    },
    "plot_observations":{
        # Note: plot observations don't appear here because they have nonstandard requirements.
        # See the validate_plot_observations method for more. 
    }

}
def validate(df, file_name):
    if file_name not in config:
        return {
            "has_error": False,
            "error": ""
        }
    if file_name == "plot_observations":
        return validate_plot_observations(df)
    xor_validation = {
        'error': "",
        'has_error': False
    }
    if 'xor_fields' in config[file_name]:
        xor_validation = validate_xor_pairs(df, config[file_name]['xor_fields'], file_name)
    field_validation = validate_required_and_missing_fields(df, config[file_name]['required_fields'], config[file_name]['table_defs'], file_name)
    to_return = {
        'has_error': xor_validation.get('has_error', False) or field_validation.get('has_error', False),
        'error': xor_validation.get('error', '') + field_validation.get('error', '')
    }
    return to_return

def validate_plot_observations(df):
    if 'user_pl_code' not in df.columns:
        df['user_pl_code'] = None
    if 'vb_pl_code' not in df.columns:
        df['vb_pl_code'] = None

    validation = {
        'error': "",
        'has_error': False
    }
    
    if not df[(df['user_pl_code'].notnull()) & (df['vb_pl_code'].notnull())].empty:
        validation['error'] += "Rows cannot have both a vb_pl_code and a user_pl_code. For new plots, use user_pl_code. To reference existing plots, use vb_pl_code."
        validation['has_error'] = True
    if not df[(df['user_pl_code'].isnull()) & (df['vb_pl_code'].isnull())].empty:
        validation['error'] += "All rows must have either a vb_pl_code or a user_pl_code. For new plots, use user_pl_code. To reference existing plots, use vb_pl_code."
        validation['has_error'] = True
    
    new_plots_df = df[df['user_pl_code'].notnull() & df['vb_pl_code'].isnull()] 
    old_plots_df = df[df['user_pl_code'].isnull() & df['vb_pl_code'].notnull()] 

    table_defs = [table_defs_config.plot, table_defs_config.observation]
    new_pl_required_fields = ['user_pl_code', 'author_plot_code', 'confidentiality_status', 'user_ob_code']
    old_pl_required_fields = ['vb_pl_code', 'user_ob_code']
    new_validation = validate_required_and_missing_fields(new_plots_df, new_pl_required_fields, table_defs, "observations on new plots")
    old_validation = validate_required_and_missing_fields(old_plots_df, old_pl_required_fields, table_defs, "observations on existing plots")

    validation['error'] += new_validation['error'] + old_validation['error']
    validation['has_error'] = new_validation['has_error'] or old_validation['has_error'] or validation['has_error']
    return validation


def validate_xor_pairs(df, xor_pairs, file_name):
    '''
    Takes a list of column name pairs and verifies that each pair has only one of the two columns populated per row.
    Parameters:
        df (pd.DataFrame): The dataframe to be validated.
        xor_pairs (list): A list of tuples, where each tuple contains two column names that should be mutually exclusive.
        file_name (str): The name of the file being validated (used in error messages).
    '''
    to_return = {
        'has_error': False,
        'error': ""
    }
    for xor_pair in xor_pairs:
        col1, col2 = xor_pair
        if not df[((df[col1].notnull()) & (df[col2].isnull())) | ((df[col1].isnull()) & (df[col2].notnull()))].empty:
            to_return['has_error'] = True
            to_return['error'] += f"Rows in {file_name} must have either {col1} or {col2}, but not both."
    
    return to_return

def validate_user_codes(df_1_name, data, user_codes, file_name):
    print("validating user codes in " + file_name)
    df_1 = data[df_1_name]
    print(df_1.columns)
    to_return = {
        'has_error': False,
        'error': ""
    }
    for source_code, target_code, target_table in user_codes:
        df_2 = data.get(target_table)
        if df_2 is not None:
            print("checking " + source_code + " against " + target_code + " in " + target_table)
            print(df_2.columns)
            missing_codes = set(df_1[source_code].astype(str)) - set(df_2[target_code].astype(str))
            if len(missing_codes) > 0:
                to_return['has_error'] = True
                to_return['error'] += f"The following {source_code} values in {file_name} do not exist: " + ", ".join(missing_codes) + ". "  
        else:
            print("no data for " + target_table + ", skipping check of " + source_code)

    return to_return