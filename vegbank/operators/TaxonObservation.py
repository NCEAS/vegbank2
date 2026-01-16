import os
import traceback
import pandas as pd
import numpy as np
from flask import jsonify
from psycopg.rows import dict_row
from psycopg import ClientCursor
from operators import table_defs_config
from operators import Operator
from utilities import QueryParameterError, validate_required_and_missing_fields


class TaxonObservation(Operator):
    """
    Defines operations related to the exchange of taxon observation data with
    VegBank, including taxon importance and (some) taxon interpretation details.

    Taxon Observation: A record of a plant observed within a particular plot
        observation.
    Taxon Importance: Information about the importance (i.e. cover, basal area,
        biomass) of a taxon observation. The importance of a taxon observation
        may be recorded not only for the plot as a whole, but also within one or
        more specified strata.
    Taxon Interpretation: The asserted association of a taxon observation with
        a specific plant name and authority. A single taxon observation can have
        multiple taxon interpretations. The current and original interpretations
        (which may be the same) are returned here.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "taxon_observation"
        self.table_code = "to"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.nested_options = ("true", "false")
        self.table_defs = {
            "strata_cover_data": [table_defs_config.taxon_observation, table_defs_config.taxon_importance],
            "strata_definitions": [table_defs_config.stratum],
            "stem_data": [table_defs_config.stem_location, table_defs_config.stem_count],
            "taxon_interpretations": [table_defs_config.taxon_interpretation]
        }
        self.required_fields = {
            "strata_cover_data": ['user_to_code', 'user_ob_code', 'author_plant_name', 'user_tm_code'],
            "strata_definitions": ['vb_ob_code', 'user_ob_code', 'user_sr_code', 'vb_sy_code'],
            "stem_data": ['user_sc_code', 'user_tm_code', 'vb_tm_code', 'stem_count'],
            "taxon_interpretations": ['user_ti_code', 'user_to_code', 'vb_pc_code', 'vb_py_code', 'vb_ro_code', 'original_interpretation', 'current_interpretation']
        }

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        if self.with_nested == 'true':
            query_type += "_nested"

        base_columns = {'*': "*"}
        main_columns = {}
        # identify full shallow columns
        main_columns['full'] = {
            'to_code': "'to.' || txo.taxonobservation_id",
            'ob_code': "'ob.' || txo.observation_id",
            'author_plant_name': "txo.authorplantname",
            'int_curr_plant_code': "txo.int_currplantcode",
            'int_curr_plant_common': "txo.int_currplantcommon",
            'int_curr_pc_code': "'pc.' || txo.int_currplantconcept_id",
            'int_curr_plant_sci_full': "txo.int_currplantscifull",
            'int_curr_plant_sci_name_no_auth': "txo.int_currplantscinamenoauth",
            'int_orig_plant_code': "txo.int_origplantcode",
            'int_orig_plant_common': "txo.int_origplantcommon",
            'int_orig_pc_code': "'pc.' || txo.int_origplantconcept_id",
            'int_orig_plant_sci_full': "txo.int_origplantscifull",
            'int_orig_plant_sci_name_no_auth': "txo.int_origplantscinamenoauth",
            'taxon_inference_area': "txo.taxoninferencearea",
            'rf_code': "rf.reference_id",
            'rf_label': "rf.reference_id_transl",
        }
        # identify full columns with nesting
        main_columns['full_nested'] = main_columns['full'] | {
            'taxon_importance': "importances",
        }
        from_sql = {}
        from_sql['full'] = """\
            FROM txo
            LEFT JOIN view_reference_transl rf USING (reference_id)
            """
        from_sql['full_nested'] = from_sql['full'].rstrip() + """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'tm_code', 'tm.' || taxonimportance_id,
                         'sm_code', 'sm.' || stratum_id,
                         'stratum_name', COALESCE(stratumname, '<All>'),
                         'cover', cover,
                         'cover_code', covercode,
                         'basal_area', basalarea,
                         'biomass', biomass,
                         'inference_area', inferencearea,
                         'stratum_base', stratumbase,
                         'stratum_height', stratumheight
                       )) AS importances
                FROM (
                  SELECT tm.taxonimportance_id,
                         tm.cover,
                         tm.covercode,
                         tm.basalarea,
                         tm.biomass,
                         tm.inferencearea,
                         tm.stratumbase,
                         tm.stratumheight,
                         sr.stratumname,
                         sr.stratum_id
                    FROM taxonimportance tm
                    LEFT JOIN stratum sr USING (stratum_id)
                    WHERE tm.taxonobservation_id = txo.taxonobservation_id
                    ORDER BY stratum_id
                )
            ) AS tm ON true
            """
        order_by_sql = """\
            ORDER BY txo.taxonobservation_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "txo",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM taxonobservation AS txo",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': [
                        "emb_taxonobservation < 6",
                    ],
                    'params': []
                },
                "to": {
                    'sql': "txo.taxonobservation_id = %s",
                    'params': ['vb_id']
                },
                "ob": {
                    'sql': "txo.observation_id = %s",
                    'params': ['vb_id']
                },
                'pc': {
                    'sql': """\
                        EXISTS (
                            SELECT plantconcept_id
                              FROM taxoninterpretation txi
                              WHERE txo.taxonobservation_id = txi.taxonobservation_id
                                AND plantconcept_id = %s)
                        """,
                    'params': ['vb_id']
                },
            },
            'order_by': {
                'sql': order_by_sql,
                'params': []
            },
        }
        self.query['select'] = {
            "always": {
                'columns': main_columns[query_type],
                'params': []
            },
        }
        self.query['from'] = {
            'sql': from_sql[query_type],
            'params': []
        }

    def upload_strata_cover_data(self, df, conn):
        """
        takes a parquet file in the strata cover data format from the loader module and uploads it to the taxon observation,
        taxon importance, and taxon interpretation tables. 
        Parameters:
            file (FileStorage): The uploaded parquet file containing taxon observations.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """

        table_defs = [table_defs_config.taxon_importance, table_defs_config.taxon_observation]
        required_fields = ['user_to_code', 'vb_ob_code', 'author_plant_name', 'user_tm_code']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, "strata cover data")
        if validation['has_error']:
            raise ValueError(validation['error'])
        
        df['user_to_code'] = df['user_to_code'].astype(str)
        taxon_observation_codes = super().upload_to_table("taxon_observation", 'to', table_defs_config.taxon_observation, 'taxonobservation_id', df, True, conn)
        

        to_codes_df = pd.DataFrame(taxon_observation_codes['resources']['to'])
        to_codes_df = to_codes_df[['user_to_code', 'vb_to_code']]

        df = df.merge(to_codes_df, on='user_to_code', how='left')

        df['user_tm_code'] = df['user_tm_code'].astype(str)
        taxon_importance_codes = super().upload_to_table("taxon_importance", 'tm', table_defs_config.taxon_importance, 'taxonimportance_id', df, True, conn)
        print(taxon_importance_codes)
        to_return = {
            'resources':{
                'to': taxon_observation_codes['resources']['to'],
                'tm': taxon_importance_codes['resources']['tm']
            },
            'counts':{
                'to': taxon_observation_codes['counts']['to'],
                'tm': taxon_importance_codes['counts']['tm']
            }
        }
        return to_return

    def upload_strata_definitions(self, df, conn):
        """
        takes a parquet file of strata definitions and uploads it to the stratum table.
        Parameters:
            file (FileStorage): The uploaded parquet file containing strata definitions.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """

        table_defs = [table_defs_config.stratum]
        required_fields = ['vb_ob_code', 'user_ob_code', 'user_sr_code', 'vb_sy_code']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, "strata definitions")
        if validation['has_error']:
            raise ValueError(validation['error'])

        df['user_sr_code'] = df['user_sr_code'].astype(str)
        new_strata =  super().upload_to_table("stratum", 'sr', table_defs_config.stratum, 'stratum_id', df, True, conn)
        return new_strata
    
    def upload_stem_data(self, df, conn):
        """
        takes a parquet file in the stem data format from the loader module and uploads it to the stem count
         and stem location tables. 
        Parameters:
            file (FileStorage): The uploaded parquet file containing stem data.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """
        stem_location_def_for_validation = table_defs_config.stem_location.copy()
        stem_location_def_for_validation.remove('vb_sc_code') #we remove the extra vb code because it will be added during the process, but is still required for the insert later on.
        table_defs = [stem_location_def_for_validation, table_defs_config.stem_count]
        required_fields = ['user_sc_code', 'user_tm_code', 'vb_tm_code', 'stem_count']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, "stem data")
        if validation['has_error']:
            raise ValueError(validation['error'])
        
        df['user_sc_code'] = df['user_sc_code'].astype(str) # Ensure user_sc_code is string for consistent merging
        stem_count_codes = super().upload_to_table("stem_count", 'sc', table_defs_config.stem_count, 'stemcount_id', df, True, conn)
        sc_codes_df = pd.DataFrame(stem_count_codes['resources']['sc'])
        sc_codes_df = sc_codes_df[['user_sc_code', 'vb_sc_code']]

        df = df.merge(sc_codes_df, on='user_sc_code', how='left')

        stem_location_codes = {'resources':{'sl':[]}, 'counts':{'sl':0}}

        #Normally this step happens in the upload_to_table method, but stem locations are optional, so we do some extra preprocessing here to allow for that. We create a subset dataframe with only the stem location columns, clean it up, and then upload it if there is any data to upload. This throws an error if the user submits location data without a user sl code.
        sl_df = df[df.columns.intersection(table_defs_config.stem_location)].copy()
        sl_df = sl_df.reindex(columns=table_defs_config.stem_location)
        sl_df.replace({pd.NaT: None, np.nan: None}, inplace=True)

        sl_df.dropna(subset=['stem_code', 'stem_x_position', 'stem_y_position', 'stem_health'], inplace=True, how='all') #Drop rows where all stem location fields are null
        print(sl_df)
        sl_df_no_code = sl_df[sl_df['user_sl_code'].isnull()] #Check if there are any rows with stem location data but no user_sl_code
        if not sl_df_no_code.empty:
            raise ValueError("All stem location records must have a user_sl_code when any stem location fields are provided.")
        if not sl_df.empty: #If there is any stem location data to upload, proceed with the upload
            sl_df['user_sl_code'] = sl_df['user_sl_code'].astype(str) # Ensure user_sl_code is string for consistent merging
            stem_location_codes = super().upload_to_table("stem_location", 'sl', table_defs_config.stem_location, 'stemlocation_id', sl_df, True, conn)
        to_return = {
            'resources':{
                'sc': stem_count_codes['resources']['sc'],
                'sl': stem_location_codes['resources']['sl']
            },
            'counts':{
                'sc': stem_count_codes['counts']['sc'],
                'sl': stem_location_codes['counts']['sl']
            }
        }
        return to_return
    
    def upload_taxon_interpretations(self, df, conn):
        """
        takes a parquet file of taxon interpretations and uploads it to the taxon interpretation table.
        Parameters:
            file (FileStorage): The uploaded parquet file containing taxon interpretations.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """

        table_defs = [table_defs_config.taxon_interpretation]
        required_fields = ['user_ti_code', 'user_to_code', 'vb_pc_code', 'vb_py_code', 'vb_ro_code', 'original_interpretation', 'current_interpretation']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, "taxon interpretations")
        if validation['has_error']:
            raise ValueError(validation['error'])

        df['interpretation_date'] = pd.Timestamp.now()

        df['user_ti_code'] = df['user_ti_code'].astype(str) # Ensure user_ti_codes are strings for consistent merging
        new_taxon_interpretations =  super().upload_to_table("taxon_interpretation", 'ti', table_defs_config.taxon_interpretation, 'taxoninterpretation_id', df, True, conn)
        return new_taxon_interpretations