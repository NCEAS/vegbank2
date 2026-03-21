import numpy as np
from vegbank.operators import table_defs_config
from vegbank.utilities import validate_required_and_missing_fields
config = {
    # Defines the required fields and table defs for each file that vegbank
    # uploads.

    "projects": {
        "required_fields": ['project_name', 'user_pj_code'],
        "table_defs": [table_defs_config.project]
    },
    "references": {
        "required_fields": ['user_rf_code'],
        "table_defs": [table_defs_config.reference]
    },
    "parties": {
        "required_fields": ['user_py_code'],
        "table_defs": [table_defs_config.party]
    },
    "soils": {
        "required_fields": ['user_so_code', 'horizon'],
        "table_defs": [table_defs_config.soil_obs]
    },
    "disturbances": {
        "required_fields": ['user_do_code', 'type'],
        "table_defs": [table_defs_config.disturbance_obs]
    },
    "community_classifications": {
        "required_fields": ['user_cl_code', 'user_ob_code', 'vb_cc_code'],
        "table_defs": [table_defs_config.comm_class, table_defs_config.comm_interp],
        "xor_fields": [
            ('user_comm_class_rf_code', 'vb_comm_class_rf_code', 'optional'),
            ('user_authority_rf_code', 'vb_authority_rf_code', 'optional'),
        ]
    },
    "community_reclassifications": {
        "required_fields": ['user_cl_code', 'vb_ob_code', 'vb_cc_code'],
        "table_defs": [table_defs_config.comm_reclass, table_defs_config.comm_interp],
        "xor_fields": [
            ('user_comm_class_rf_code', 'vb_comm_class_rf_code', 'optional'),
            ('user_authority_rf_code', 'vb_authority_rf_code', 'optional'),
        ]
    },
    "strata": {
        "required_fields": ['user_ob_code', 'user_sr_code', 'vb_sy_code'],
        "table_defs": [table_defs_config.stratum]
    },
    "strata_cover_data": {
        "required_fields": ['user_to_code', 'user_ob_code', 'author_plant_name', 'user_tm_code'],
        "table_defs": [table_defs_config.taxon_importance, table_defs_config.taxon_observation]
    },
    "stem_data": {
        "required_fields": ['user_sc_code', 'user_tm_code', 'stem_count'],
        "table_defs": [table_defs_config.stem_count, table_defs_config.stem_location]
    },
    "taxon_interpretations": {
        "required_fields": ['user_ti_code', 'user_to_code', 'vb_pc_code',
                            'vb_ar_code', 'original_interpretation',
                            'current_interpretation'],
        "table_defs": [table_defs_config.taxon_interpretation],
        "xor_fields": [
            ('user_py_code', 'vb_py_code'),
            ('user_rf_code', 'vb_rf_code', 'optional'),
            ('user_collector_py_code', 'vb_collector_py_code', 'optional'),
            ('user_museum_py_code', 'vb_museum_py_code', 'optional'),
            ]
    },
    "taxon_reinterpretations": {
        # This is for taxon interpretations that are uploaded through the taxon 
        # interpretation endpoint, which require some different fields than taxon 
        # interpretations uploaded through the plot observation endpoint, so we have 
        # a separate config for those.
        "required_fields": ['user_ti_code', 'vb_to_code', 'vb_pc_code',
                            'vb_ar_code', 'original_interpretation',
                            'current_interpretation'],
        "table_defs": [table_defs_config.reinterpretation],
        "xor_fields": [
            ('user_py_code', 'vb_py_code'),
            ('user_rf_code', 'vb_rf_code', 'optional'),
            ('user_collector_py_code', 'vb_collector_py_code', 'optional'),
            ('user_museum_py_code', 'vb_museum_py_code', 'optional'),
            ]
    },
    "contributors": {
        "required_fields": ['vb_ar_code', 'contributor_type', 'record_identifier'],
        "table_defs": [table_defs_config.contributor],
        "xor_fields": [
            ('vb_py_code', 'user_py_code')
            ]
    },
    "community_contributors": {
        "required_fields": ['vb_ar_code', 'record_identifier'],
        "table_defs": [table_defs_config.comm_contributor],
        "xor_fields": [
            ('vb_py_code', 'user_py_code')
            ]
    },
    "plot_observations": {  # This one has different config fields because the required fields depend on whether the observation is on a new plot or an existing plot.
        "new_pl_required_fields": ['user_pl_code', 'author_plot_code', 'confidentiality_status', 'user_ob_code', 'author_obs_code'],
        "old_pl_required_fields": ['vb_pl_code', 'user_ob_code', 'author_obs_code'],
        "table_defs": [table_defs_config.plot, table_defs_config.observation],
        "xor_fields": [('user_pj_code', 'vb_pj_code'), ('user_pl_code', 'vb_pl_code')]
    },
    "plant_concepts":{
        "required_fields": ['user_pc_code', 'name', 'start_date',
                           'plant_concept_status'],
        "table_defs":[table_defs_config.plant_concept, table_defs_config.plant_status],
        "xor_fields":[
            ('user_rf_code', 'vb_rf_code'),
            ('user_status_py_code', 'vb_status_py_code'),
            ('user_status_rf_code', 'vb_status_rf_code', 'optional'),
            ('user_parent_pc_code', 'vb_parent_pc_code', 'optional'),
        ]
    },
    "plant_correlations":{
        "required_fields":['convergence_type', 'correlation_start'],
        "table_defs":[table_defs_config.plant_correlation],
        "xor_fields":[
            ('user_correlated_pc_code', 'vb_correlated_pc_code')
        ]
    },
    "plant_names":{
        "required_fields": ['user_pc_code', 'name',
                           'name_type', 'name_status'],
        "table_defs":[table_defs_config.plant_name, 
                      table_defs_config.plant_usage],
        "xor_fields":[
            ('user_usage_py_code', 'vb_usage_py_code', 'optional')
        ]
    },
    "community_concepts":{
        "required_fields": ['user_cc_code', 'name', 'start_date',
                           'comm_concept_status'],
        "table_defs": [table_defs_config.comm_concept, table_defs_config.comm_name, table_defs_config.comm_status],
        "xor_fields": [('user_status_py_code', 'vb_status_py_code'),
                       ('user_rf_code', 'vb_rf_code', 'optional'),
                       ('user_parent_cc_code', 'vb_parent_cc_code', 'optional')]
    },
    "community_names":{
        "required_fields" : ['user_cc_code', 'name',
                           'name_type', 'name_status'],
        "table_defs": [table_defs_config.comm_name, table_defs_config.comm_usage],
        "xor_fields": [
            ('user_usage_py_code', 'vb_usage_py_code', 'optional')
        ]

    },
    "community_correlations":{
        "required_fields": ['convergence_type', 'correlation_start'],
        "table_defs": [table_defs_config.comm_correlation],
        "xor_fields": [
            ('vb_correlated_cc_code', 'user_correlated_cc_code'),
        ]
    },
    "cover_methods": {
        "required_fields": ['user_cm_code', 'covertype'],
        "table_defs": [table_defs_config.cover_method, table_defs_config.cover_index]
    }
}


def validate(df, file_name, endpoint_name=None):
    '''
    Runs validation checks on the provided dataframe based on the file name and the corresponding configuration in the config dictionary. If the file name is not found in the config, it returns a successful validation result. For "plot_observations", it runs a specialized validation function. For other files, it checks for required fields and XOR field pairs as defined in the config.
    Parameters:
        df (pd.DataFrame): The dataframe to be validated.
        file_name (str): The name of the file being validated, which determines the validation rules to apply.
        endpoint_name(str): we have a few files where there are different required
        fields based on which endpoint the request comes from. Example: Taxon 
        interpetations require different fields if they are uploaded through the 
        plot observation endpoint vs the taxon interpretation endpoint. This parameter allows us to specify which one and set the required fields 
        accordingly.  
    Returns:
        dict: A dictionary containing 'has_error' (bool) and 'error' (str) keys indicating the result of the validation.
    '''
    print("validating " + file_name)
    if file_name not in config:
        return {
            "has_error": False,
            "error": ""
        }

    if file_name == "plot_observations":
        return validate_plot_observations(df)
    required_fields = config[file_name]['required_fields']
    table_defs = config[file_name]['table_defs']
    xor_fields = config[file_name].get('xor_fields')
    print('file name is ' + file_name)
    if endpoint_name and endpoint_name == 'taxon-interpretations' and file_name == 'taxon_interpretations':
        print("using taxon reinterpretation config for validation of taxon interpretations because endpoint is taxon-interpretations")
        required_fields = config['taxon_reinterpretations']['required_fields']
        table_defs = config['taxon_reinterpretations']['table_defs']
        xor_fields = config['taxon_reinterpretations'].get('xor_fields')
    if endpoint_name and endpoint_name == "community-classifications" and file_name == "community_classifications":
        required_fields = config['community_reclassifications']['required_fields']
        table_defs = config['community_reclassifications']['table_defs']
        xor_fields = config['community_reclassifications'].get('xor_fields')
    if endpoint_name and endpoint_name == "community-classifications" and file_name == "contributors":
        required_fields = config['community_contributors']['required_fields']
        table_defs = config['community_contributors']['table_defs']
        xor_fields = config['community_contributors'].get('xor_fields')
    xor_validation = {
        'error': "",
        'has_error': False
    }
    if xor_fields is not None:
        xor_validation = validate_xor_pairs(df, xor_fields, file_name)
    field_validation = validate_required_and_missing_fields(
        df,
        required_fields,
        table_defs,
        file_name)
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
    pl_obs_config = config['plot_observations']

    new_plots_df = df[df['user_pl_code'].notnull() & df['vb_pl_code'].isnull()]
    old_plots_df = df[df['user_pl_code'].isnull() & df['vb_pl_code'].notnull()]
    if not new_plots_df.empty:
        new_validation = validate_required_and_missing_fields(
            new_plots_df,
            pl_obs_config['new_pl_required_fields'],
            pl_obs_config['table_defs'],
            "observations on new plots")
    else:
        new_validation = {
            'error': "",
            'has_error': False
        }
    if not old_plots_df.empty:
        old_validation = validate_required_and_missing_fields(
            old_plots_df,
            pl_obs_config['old_pl_required_fields'],
            pl_obs_config['table_defs'],
            "observations on existing plots")
    else:
        old_validation = {
            'error': "",
            'has_error': False
        }
    xor_validation = validate_xor_pairs(
        df, pl_obs_config['xor_fields'], "plot_observations")

    validation['error'] += new_validation['error'] + \
        old_validation['error'] + xor_validation['error']
    validation['has_error'] = new_validation['has_error'] or old_validation['has_error'] or xor_validation['has_error']
    return validation


def validate_xor_pairs(df, xor_pairs, file_name):
    '''
    Takes a list of column name pairs and verifies that each pair has only one of the two columns populated per row.
    Parameters:
        df (pd.DataFrame): The dataframe to be validated.
        xor_pairs (list): A list of tuples, where each tuple contains two column names that should be mutually exclusive.
        file_name (str): The name of the file being validated (used in error messages).
    Returns:
        dict: A dictionary containing 'has_error' (bool) and 'error' (str) keys indicating the result of the validation.
    '''
    to_return = {
        'has_error': False,
        'error': ""
    }

    for xor_pair in xor_pairs:
        col1, col2 = xor_pair[0], xor_pair[1]
        required = False if len(xor_pair) > 2 and xor_pair[2] == 'optional' else True
        print(f"validating xor pair {col1} and {col2} in {file_name} with required set to {required}")
        xor_err_msg = f"Rows in {file_name} must have either {col1} or {col2}, but not both. "
        if col1 not in df.columns and col2 not in df.columns:
            if required:
                print(f"xor validation failed for {col1} and {col2} in {file_name} because both columns are missing")
                to_return['has_error'] = True
                to_return['error'] += xor_err_msg
                continue
        elif (col1 in df.columns and col2 not in df.columns) | (col1 not in df.columns and col2 in df.columns):
            if col1 in df.columns:
                if df[col1].isnull().any() and required:
                    to_return['has_error'] = True
                    to_return['error'] += xor_err_msg
                    continue
            if col2 in df.columns:
                if df[col2].isnull().any() and required:
                    to_return['has_error'] = True
                    to_return['error'] += xor_err_msg
                    continue
        elif ((not df[((df[col1].notnull()) & (df[col2].notnull()))].empty) or
            (not df[((df[col1].isnull()) & (df[col2].isnull()))].empty and required)):
            print(
                "xor validation failed for " +
                col1 +
                " and " +
                col2 +
                " in " +
                file_name)
            print(df[((df[col1].notnull()) & (df[col2].isnull()))
                  | ((df[col1].isnull()) & (df[col2].notnull()))])
            to_return['has_error'] = True
            to_return['error'] += xor_err_msg
    return to_return


def validate_user_codes(df_1_name, data, user_codes, file_name):
    '''
    Validates that the user codes in the provided dataframe match to existing codes in the target user provided tables.
    Parameters:
        df_1_name (str): The name of the dataframe containing the user codes to be validated.
        data (dict): A dictionary containing the dataframes for all user provided tables, keyed by table name.
        user_codes (list): A list of tuples, where each tuple contains the source code column name, target code column name, and target table name to validate against.
        file_name (str): The name of the file being validated (used in error messages).
    Returns:
        dict: A dictionary containing 'has_error' (bool) and 'error' (str) keys indicating the result of the validation.
    '''
    to_return = {
        'has_error': False,
        'error': ""
    }
    if user_codes is None:
        return to_return

    df_1 = data[df_1_name]
    print("read in data for " + df_1_name + " to validate user codes: ")
    print(df_1.columns)
    for source_code, target_code, target_table in user_codes:
        print(
            f"validating {source_code} from {df_1_name} against {target_code}  in {target_table}")
        if source_code not in df_1.columns or df_1[source_code].isnull().all():
            print(
                f"{source_code} is not present in {file_name}, skipping user code validation for {source_code}")
        elif data[target_table] is None:
            to_return['has_error'] = True
            to_return['error'] += f"Validation failed for {source_code} in {file_name} because the target table {target_table} is missing. "
        else:
            df_2 = data.get(target_table)
            if df_2 is not None and target_code in df_2.columns:
                missing_codes = set(df_1[source_code].astype(
                    str)) - set(df_2[target_code].astype(str))
                # sometimes pandas reads empty cells as nan, which can cause
                # issues with validation of xor fields. We'll discard those
                # from the missing codes, and leave validation of xor fields to
                # the xor validation method.
                missing_codes.discard(np.nan)
                missing_codes.discard(None)

                if len(missing_codes) > 0:
                    print(
                        f"validation of {source_code} from {df_1_name} against {target_code}  in {target_table}  has failed")
                    print(missing_codes)
                    to_return['has_error'] = True
                    to_return['error'] += f"The following {source_code} values in {file_name} do not exist: " + ", ".join(
                        missing_codes) + ". "
            else:
                print(
                    "no data for " +
                    target_table +
                    ", skipping check of " +
                    source_code)
        if to_return['has_error'] is False:
            print(
                f"validation of {source_code} from {df_1_name} against {target_code}  in {target_table} has passed")
        else:
            print(
                f"validation of {source_code} from {df_1_name} against {target_code}  in {target_table} has failed with error: " +
                to_return['error'])

    if file_name is 'contributors':
        record_identifier_validation = validate_contributor_record_identifier_codes(
            data[df_1_name], data)
        to_return['has_error'] = to_return['has_error'] or record_identifier_validation['has_error']
        to_return['error'] += record_identifier_validation['error']
    return to_return


def validate_contributor_record_identifier_codes(df, data):
    '''
    Validates contributor user codes against the three tables the record 
    identifier can point to, as well as party. This is a special case function 
    because the contributor record identifier can point to three different 
    tables (project, plot, or observation) in addition to party, so it needs to 
    validate against all of those tables and check that the user code exists 
    in at least one of them.
    '''
    to_return = {
        'has_error': False,
        'error': ""
    }
    set_list = []
    if data.get('cl') is not None and 'user_cl_code' in data['cl'].columns:
        set_list.append(set(data['cl']['user_cl_code'].astype(str)))
    if data.get('pj') is not None and 'user_pj_code' in data['pj'].columns:
        set_list.append(set(data['pj']['user_pj_code'].astype(str)))
    if data.get('pl') is not None and 'user_ob_code' in data['pl'].columns:
        set_list.append(set(data['pl']['user_ob_code'].astype(str)))
    print(set_list)
    missing_codes = set(df['record_identifier'].astype(str))
    for s in set_list:
        missing_codes = missing_codes - s
    missing_codes.discard(np.nan)
    missing_codes.discard(None)
    if len(missing_codes) > 0:
        to_return['has_error'] = True
        to_return['error'] += f"The following record_identifier values in " + \
            "contributors do not exist in the user provided project, plot, " + \
            "or community classification tables: " + \
            ", ".join(missing_codes) + ". "
    return to_return
