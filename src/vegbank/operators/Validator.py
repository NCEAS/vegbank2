from collections import defaultdict
import numpy as np
import pandas as pd
from vegbank.operators import table_defs_config
from vegbank.utilities import validate_required_and_missing_fields

# Defines the required fields and table defs for each file that vegbank uploads
config = {
    "projects": {
        "table_defs": [table_defs_config.project],
        "required_fields": [
            'project_name',
            'user_pj_code',
        ],
        "field_type_map": {
            'start_date': 'timestamp',
            'stop_date': 'timestamp',
        },
    },
    "references": {
        "table_defs": [table_defs_config.reference],
        "required_fields": [
            'user_rf_code',
        ],
    },
    "parties": {
        "table_defs": [table_defs_config.party],
        "required_fields": [
            'user_py_code',
        ],
    },
    "soils": {
        "table_defs": [table_defs_config.soil_obs],
        "required_fields": [
            'user_so_code',
            'horizon',
        ],
        "field_type_map": {
            'depth_top': 'numeric',
            'depth_bottom': 'numeric',
            'organic': 'numeric',
            'sand': 'numeric',
            'silt': 'numeric',
            'clay': 'numeric',
            'coarse': 'numeric',
            'ph': 'numeric',
            'exchange_capacity': 'numeric',
            'base_saturation': 'numeric',
        },
    },
    "disturbances": {
        "table_defs": [table_defs_config.disturbance_obs],
        "required_fields": [
            'user_do_code',
            'type',
        ],
        "field_type_map": {
            'age': 'numeric',
            'extent': 'numeric',
        },
    },
    "community_classifications": {
        "table_defs": [table_defs_config.comm_class,
                       table_defs_config.comm_interp],
        "required_fields": [
            'user_cl_code',
            'user_ob_code',
            'vb_cc_code',
        ],
        "field_type_map": {
            # comm_class
            'class_start_date': 'timestamp',
            'class_stop_date': 'timestamp',
            'inspection': 'boolean',
            'multivariateanalysis': 'boolean',
            'tableanalysis': 'boolean',
            # comm_interp
            'nomenclatural_type': 'boolean',
            'type': 'boolean',
        },
        "xor_fields": [
            ('user_comm_class_rf_code', 'vb_comm_class_rf_code', 'optional'),
            ('user_authority_rf_code', 'vb_authority_rf_code', 'optional'),
        ],
    },
    "community_reclassifications": {
        "table_defs": [table_defs_config.comm_reclass,
                       table_defs_config.comm_interp],
        "required_fields": [
            'user_cl_code',
            'vb_ob_code',
            'vb_cc_code',
        ],
        "field_type_map": {
            # comm_class
            'class_start_date': 'timestamp',
            'class_stop_date': 'timestamp',
            'inspection': 'boolean',
            'multivariate_analysis': 'boolean',
            'table_analysis': 'boolean',
            # comm_interp
            'nomenclatural_type': 'boolean',
            'type': 'boolean',
        },
        "xor_fields": [
            ('user_comm_class_rf_code', 'vb_comm_class_rf_code', 'optional'),
            ('user_authority_rf_code', 'vb_authority_rf_code', 'optional'),
        ],
    },
    "strata": {
        "table_defs": [table_defs_config.stratum],
        "required_fields": [
            'user_ob_code',
            'user_sr_code',
            'vb_sy_code',
        ],
        "field_type_map": {
            'stratum_base': 'numeric',
            'stratum_cover': 'numeric',
            'stratum_height': 'numeric',
        },
    },
    "strata_cover_data": {
        "table_defs": [table_defs_config.taxon_importance,
                       table_defs_config.taxon_observation],
        "required_fields": [
            'user_to_code',
            'user_ob_code',
            'author_plant_name',
            'user_tm_code',
        ],
        "field_type_map": {
            # taxon observation
            'taxon_inference_area': 'numeric',
            # taxon importance
            'basal_area': 'numeric',
            'biomass': 'numeric',
            'cover': 'numeric',
            'inference_area': 'numeric',
            'stratum_base': 'numeric',
            'stratum_height': 'numeric',
        },
    },
    "stem_data": {
        "table_defs": [table_defs_config.stem_count,
                       table_defs_config.stem_location],
        "required_fields": [
            'user_sc_code',
            'user_tm_code',
            'stem_count',
        ],
    },
    "taxon_interpretations": {
        "table_defs": [table_defs_config.taxon_interpretation],
        "required_fields": [
            'user_ti_code',
            'user_to_code',
            'vb_pc_code',
            'vb_ar_code',
            'original_interpretation',
            'current_interpretation',
        ],
        "field_type_map": {
            'collection_date': 'timestamp',
            'current_interpretation': 'boolean',
            'interpretation_date': 'timestamp',
            'notes_mgt': 'boolean',
            'notes_public': 'boolean',
            'original_interpretation': 'boolean',
        },
        "xor_fields": [
            ('user_py_code', 'vb_py_code'),
            ('user_rf_code', 'vb_rf_code', 'optional'),
            ('user_collector_py_code', 'vb_collector_py_code', 'optional'),
            ('user_museum_py_code', 'vb_museum_py_code', 'optional'),
        ],
    },
    "taxon_reinterpretations": {
        # This is for taxon interpretations that are uploaded through the taxon 
        # interpretation endpoint, which require some different fields than taxon 
        # interpretations uploaded through the plot observation endpoint, so we have 
        # a separate config for those.
        "table_defs": [table_defs_config.reinterpretation],
        "required_fields": [
            'user_ti_code',
            'vb_to_code',
            'vb_pc_code',
            'vb_ar_code',
            'original_interpretation',
            'current_interpretation',
        ],
        "field_type_map": {
            'collection_date': 'timestamp',
            'current_interpretation': 'boolean',
            'interpretation_date': 'timestamp',
            'notes_mgt': 'boolean',
            'notes_public': 'boolean',
            'original_interpretation': 'boolean',
        },
        "xor_fields": [
            ('user_py_code', 'vb_py_code'),
            ('user_rf_code', 'vb_rf_code', 'optional'),
            ('user_collector_py_code', 'vb_collector_py_code', 'optional'),
            ('user_museum_py_code', 'vb_museum_py_code', 'optional'),
        ],
    },
    "contributors": {
        "table_defs": [table_defs_config.contributor],
        "required_fields": [
            'vb_ar_code',
            'contributor_type',
            'record_identifier',
        ],
        "xor_fields": [
            ('vb_py_code', 'user_py_code'),
        ],
    },
    "community_contributors": {
        "table_defs": [table_defs_config.comm_contributor],
        "required_fields": [
            'vb_ar_code',
            'record_identifier',
        ],
        "xor_fields": [
            ('vb_py_code', 'user_py_code'),
        ],
    },
    "plot_observations": {
        # This one has different config fields because the required fields
        # depend on whether the observation is on a new plot or an existing
        # plot.
        "table_defs": [table_defs_config.plot,
                       table_defs_config.observation],
        "new_pl_required_fields": [
            'user_pl_code',
            'author_plot_code',
            'confidentiality_status',
            'user_ob_code',
            'author_obs_code',
        ],
        "old_pl_required_fields": [
            'vb_pl_code',
            'user_ob_code',
            'author_obs_code',
        ],
        "field_type_map": {
            # plot
            'area': 'numeric',
            'azimuth': 'numeric',
            'confidentiality_status': 'integer',
            'elevation': 'numeric',
            'elevation_accuracy': 'numeric',
            'elevation_range': 'numeric',
            'latitude': 'numeric',
            'location_accuracy': 'numeric',
            'longitude': 'numeric',
            'max_slope_aspect': 'numeric',
            'max_slope_gradient': 'numeric',
            'min_slope_aspect': 'numeric',
            'min_slope_gradient': 'numeric',
            'pl_notes_mgt': 'boolean',
            'pl_notes_public': 'boolean',
            'permanence': 'boolean',
            'real_latitude': 'numeric',
            'real_longitude': 'numeric',
            'slope_aspect': 'numeric',
            'slope_gradient': 'numeric',
            # observation
            'auto_taxon_cover': 'boolean',
            'basal_area': 'numeric',
            'date_entered': 'timestamp',
            'field_cover': 'numeric',
            'field_ht': 'numeric',
            'floating_cover': 'numeric',
            'growthform_1_cover': 'numeric',
            'growthform_2_cover': 'numeric',
            'growthform_3_cover': 'numeric',
            'has_observation_synonym': 'boolean',
            'nonvascular_cover': 'numeric',
            'nonvascular_ht': 'numeric',
            'ob_notes_mgt': 'boolean',
            'ob_notes_public': 'boolean',
            'obs_end_date': 'timestamp',
            'obs_start_date': 'timestamp',
            'organic_depth': 'numeric',
            'percent_bare_soil': 'numeric',
            'percent_bedrock': 'numeric',
            'percent_litter': 'numeric',
            'percent_other': 'numeric',
            'percent_rock_gravel': 'numeric',
            'percent_water': 'numeric',
            'percent_wood': 'numeric',
            'shore_distance': 'numeric',
            'shrub_cover': 'numeric',
            'shrub_ht': 'numeric',
            'soil_depth': 'numeric',
            'stem_observation_area': 'numeric',
            'stem_size_limit': 'numeric',
            'submerged_cover': 'numeric',
            'submerged_ht': 'numeric',
            'taxon_observation_area': 'numeric',
            'total_cover': 'numeric',
            'tree_cover': 'numeric',
            'tree_ht': 'numeric',
            'water_depth': 'numeric',
        },
        "xor_fields": [
            ('user_pj_code', 'vb_pj_code'),
            ('user_pl_code', 'vb_pl_code'),
        ],
    },
    "plant_concepts":{
        "table_defs": [table_defs_config.plant_concept,
                       table_defs_config.plant_name,
                       table_defs_config.plant_status],
        "required_fields": [
            'user_pc_code',
            'name',
            'start_date',
            'plant_concept_status',
        ],
        "field_type_map": {
            # plant status
            'start_date': 'timestamp',
            'stop_date': 'timestamp',
        },
        "xor_fields": [
            ('user_rf_code', 'vb_rf_code'),
            ('user_status_py_code', 'vb_status_py_code'),
            ('user_status_rf_code', 'vb_status_rf_code', 'optional'),
            ('user_parent_pc_code', 'vb_parent_pc_code', 'optional'),
        ]
    },
    "plant_correlations": {
        "table_defs": [table_defs_config.plant_correlation],
        "required_fields":[
            'convergence_type',
            'correlation_start',
        ],
        "field_type_map": {
            'correlation_start': 'timestamp',
            'correlation_stop': 'timestamp',
        },
        "xor_fields": [
            ('user_correlated_pc_code', 'vb_correlated_pc_code'),
        ],
    },
    "plant_names": {
        "table_defs": [table_defs_config.plant_name,
                      table_defs_config.plant_usage],
        "required_fields": [
            'user_pc_code',
            'name',
            'name_type',
            'name_status',
        ],
        "field_type_map": {
            # plant usage
            'usage_start': 'timestamp',
            'usage_stop': 'timestamp',
        },
        "xor_fields": [
            ('user_usage_py_code', 'vb_usage_py_code', 'optional'),
        ],
    },
    "community_concepts": {
        "table_defs": [table_defs_config.comm_concept,
                       table_defs_config.comm_name,
                       table_defs_config.comm_status],
        "required_fields": [
            'user_cc_code',
            'name',
            'start_date',
            'comm_concept_status',
        ],
        "field_type_map": {
            # comm status
            'start_date': 'timestamp',
            'stop_date': 'timestamp',
        },
        "xor_fields": [
            ('user_status_py_code', 'vb_status_py_code'),
            ('user_rf_code', 'vb_rf_code', 'optional'),
            ('user_parent_cc_code', 'vb_parent_cc_code', 'optional'),
        ],
    },
    "community_names": {
        "table_defs": [table_defs_config.comm_name,
                       table_defs_config.comm_usage],
        "required_fields" : [
            'user_cc_code',
            'name',
            'name_type',
            'name_status',
        ],
        "field_type_map": {
            # comm usage
            'usage_start': 'timestamp',
            'usage_stop': 'timestamp',
        },
        "xor_fields": [
            ('user_usage_py_code', 'vb_usage_py_code', 'optional'),
        ],
    },
    "community_correlations":{
        "table_defs": [table_defs_config.comm_correlation],
        "required_fields": [
            'convergence_type',
            'correlation_start',
        ],
        "field_type_map": {
            'correlation_start': 'timestamp',
            'correlation_stop': 'timestamp',
        },
        "xor_fields": [
            ('vb_correlated_cc_code', 'user_correlated_cc_code'),
        ],
    },
    "cover_methods": {
        "table_defs": [table_defs_config.cover_method,
                       table_defs_config.cover_index],
        "required_fields": [
            'user_cm_code',
            'cover_type',
            'cover_code',
            'cover_percent',
        ],
        "field_type_map": {
            'cover_percent': 'numeric',
            'lower_limit': 'numeric',
            'upper_limit': 'numeric',
        },
        "xor_fields": [
            ('user_rf_code', 'vb_rf_code', 'optional'),
        ]
    },
    "stratum_methods":{
        "required_fields": ['user_sm_code', 'stratum_method_name'],
        "table_defs": [table_defs_config.stratum_method, 
                       table_defs_config.stratum_type],
        "xor_fields": [
            ('user_rf_code', 'vb_rf_code', 'optional')
        ]
    }
}


def validate(df, file_name, endpoint_name=None):
    """Run basic up-front validation on user-supplied data

    Runs validation checks on the provided dataframe based on the file name and
    the corresponding configuration in the config dictionary. If the file name
    is not found in the config, it returns a successful validation result. For
    "plot_observations", it runs a specialized validation function. For other
    files, it checks for required fields, checks designated field types, and
    validates the presence of XOR field pairs as defined in the config.

    Parameters:
        df (pd.DataFrame): The dataframe to be validated.
        file_name (str): The name of the file being validated, which determines
            the validation rules to apply.
        endpoint_name (str): we have a few files where there are different
            required fields based on which endpoint the request comes from.
            Example: Taxon interpetations require different fields if they are
            uploaded through the plot observation endpoint vs the taxon
            interpretation endpoint. This parameter allows us to specify which
            one and set the required fields accordingly.

    Returns:
        dict: A dictionary containing 'has_error' (bool) and 'error' (str) keys
            indicating the result of the validation.
    """
    print("validating " + file_name)
    if file_name not in config:
        return {
            "has_error": False,
            "error": ""
        }

    if file_name == "plot_observations":
        return validate_plot_observations(df)

    # Specify the loader config table key, which is usually just the file name,
    # except in cases where we use modified configuration for a few specific
    # tables uploaded via specific endpoints
    if (file_name == 'taxon_interpretations'
            and endpoint_name == 'taxon-interpretations'):
        table_key = 'taxon_reinterpretations'
    elif (file_name == 'community_classifications'
            and endpoint_name == 'community-classifications'):
        table_key = 'community_reclassifications'
    elif (file_name == 'contributors'
            and endpoint_name == 'community-classifications'):
        table_key = 'community_contributors'
    else:
        table_key = file_name
    print('table key is ' + table_key)

    cfg = config[table_key]
    validation = dict()
    validation['field'] = validate_required_and_missing_fields(
        df, cfg.get('required_fields'), cfg.get('table_defs'), file_name)
    validation['xor'] = validate_xor_pairs(
        df, cfg.get('xor_fields'), file_name)
    validation['type'] = validate_field_types(
        df, cfg.get('field_type_map'), file_name)
    return {
        'has_error': any(val.get('has_error') for val in validation.values()),
        'error': ' '.join(val['error'] for val in validation.values()
                          if val.get('error') is not None)
    }


def validate_plot_observations(df):
    if 'user_pl_code' not in df.columns:
        df['user_pl_code'] = None
    if 'vb_pl_code' not in df.columns:
        df['vb_pl_code'] = None

    cfg = config['plot_observations']

    validation = dict()

    new_plots_df = df[df['user_pl_code'].notnull() & df['vb_pl_code'].isnull()]
    if not new_plots_df.empty:
        validation['new'] = validate_required_and_missing_fields(
            new_plots_df, cfg['new_pl_required_fields'], cfg['table_defs'],
            "observations on new plots")

    old_plots_df = df[df['user_pl_code'].isnull() & df['vb_pl_code'].notnull()]
    if not old_plots_df.empty:
        validation['old'] = validate_required_and_missing_fields(
            old_plots_df, cfg['old_pl_required_fields'], cfg['table_defs'],
            "observations on existing plots")

    validation['xor'] = validate_xor_pairs(
        df, cfg.get('xor_fields'), "plot_observations")
    validation['type'] = validate_field_types(
        df, cfg.get('field_type_map'), 'plot_observations')

    return {
        'has_error': any(val.get('has_error') for val in validation.values()),
        'error': ' '.join(val['error'] for val in validation.values()
                          if val.get('error') is not None)
    }


def validate_xor_pairs(df, xor_pairs, file_name):
    """Validates column pairs for which values are not allowed in both fields

    Takes a list of column name pairs and verifies that each pair has only one
    of the two columns populated per row.

    Parameters:
        df (pd.DataFrame): The dataframe to be validated.
        xor_pairs (list): A list of tuples, where each tuple contains two column
            names that should be mutually exclusive.
        file_name (str): The name of the file being validated (used in error
            messages).

    Returns:
        dict: A dictionary containing 'has_error' (bool) and 'error' (str) keys
            indicating the result of the validation.
    """
    to_return = {
        'has_error': False,
        'error': ""
    }
    if xor_pairs is None:
        return to_return

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
    """Validate referential integrity across tables based on user codes

    Validates that the user codes in the provided dataframe match to existing
    codes in the target user provided tables.

    Parameters:
        df_1_name (str): The name of the dataframe containing the user codes to
            be validated.
        data (dict): A dictionary containing the dataframes for all user
            provided tables, keyed by table name.
        user_codes (list): A list of tuples, where each tuple contains the
            source code column name, target code column name, and target table
            name to validate against.
        file_name (str): The name of the file being validated (used in error
            messages).

    Returns:
        dict: A dictionary containing 'has_error' (bool) and 'error' (str) keys
            indicating the result of the validation.
    """
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


def validate_field_types(df, field_type_map, file_name):
    """Validates that provided fields are the correct type

    Parameters:
        df (pd.DataFrame): The dataframe to be validated.
        field_type_map (dict): A mapping of column names to types, or None
        file_name (str): The name of the file being validated (used in error
             messages).
    Returns:
        dict: A dictionary containing 'has_error' (bool) and 'error' (str) keys.
    """
    no_error = {
        'has_error': False,
        'error': ""
    }
    if field_type_map is None:
        return no_error

    TYPE_VALIDATORS = {
        "boolean": is_valid_boolean,
        "numeric": is_valid_numeric,
        "integer": is_valid_integer,
        "timestamp": is_valid_timestamptz,
    }

    invalid_fields = defaultdict(list)

    for field, db_type in field_type_map.items():
        if field.lower() not in df.columns:
            continue
        validator = TYPE_VALIDATORS.get(db_type)
        if validator and not validator(df[field]):
            invalid_fields[db_type].append(field)

    if invalid_fields:
        messages = []
        for type_label, columns in invalid_fields.items():
            col_list = ", ".join(columns)
            messages.append(f"The following column(s) for {file_name} " +
                            f"must be {type_label}: {col_list}.")
        return {
            'has_error': True,
            'error': " ".join(messages),
        }
    else:
        return no_error


def is_valid_boolean(series: pd.Series) -> bool:
    """Return True if all non-null values are boolean-compatible.

    Accepts bool dtypes, numeric 0/1, and 'true'/'false' (case-insensitive).
    """
    if pd.api.types.is_bool_dtype(series):
        return True
    if pd.api.types.is_numeric_dtype(series):
        return series.dropna().isin([0, 1]).all()
    if (pd.api.types.is_object_dtype(series)
            or pd.api.types.is_string_dtype(series)):
        return series.dropna().astype(str).str.lower().isin(["true", "false"]).all()
    return False


def is_valid_numeric(series: pd.Series) -> bool:
    """Return True if all non-null values are numeric.

    Rejects booleans rather than allowing them as 0.0/1.0.
    """
    if pd.api.types.is_bool_dtype(series):
        return False
    try:
        pd.to_numeric(series, errors='raise')
        return True
    except (ValueError, TypeError):
        return False


def is_valid_integer(series: pd.Series) -> bool:
    """Return True if all non-null values are numeric with no fractional part.

    Rejects booleans rather than allowing them as 0/1.
    """
    if pd.api.types.is_bool_dtype(series):
        return False
    try:
        coerced = pd.to_numeric(series, errors='raise')
        return (coerced.dropna() == coerced.dropna().astype(int)).all()
    except (ValueError, TypeError):
        return False


def is_valid_timestamptz(series: pd.Series) -> bool:
    """Return True if all non-null values can be parsed as tz-aware timestamps."""
    coerced = pd.to_datetime(series, errors='coerce', utc=True)
    invalid_mask = coerced.isna() & series.notna()
    return not invalid_mask.any()
