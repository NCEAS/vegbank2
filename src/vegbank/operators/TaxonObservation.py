import os
import traceback
import pandas as pd
import numpy as np
import logging
from vegbank.operators.operator_parent_class import Operator
from vegbank.operators import table_defs_config
from flask import jsonify
from psycopg.rows import dict_row
from psycopg import ClientCursor
from vegbank.utilities import (
    QueryParameterError,
    validate_required_and_missing_fields,
    update_obs_counts,
    update_interpreted_observations,
)


logger = logging.getLogger(__name__)
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
        self.queries_package = f"{self.queries_package}.{self.name}"
        self.detail_options = ("minimal", "full")
        self.nested_options = ("true", "false")

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        if self.with_nested == 'true':
            query_type += "_nested"

        base_columns = {'*': "*"}
        main_columns = {}
        # identify full shallow columns
        main_columns['full'] = {
            'ob_code': "'ob.' || txo.observation_id",
            'author_obs_code': "ob.authorobscode",
            'to_code': "'to.' || txo.taxonobservation_id",
            'author_plant_name': "txo.authorplantname",
            'int_curr_pc_code': "'pc.' || txo.int_currplantconcept_id",
            'int_curr_plant_code': "txo.int_currplantcode",
            'int_curr_plant_sci_full': "txo.int_currplantscifull",
            'int_curr_plant_sci_name_no_auth': "txo.int_currplantscinamenoauth",
            'int_curr_plant_common': "txo.int_currplantcommon",
            'int_orig_pc_code': "'pc.' || txo.int_origplantconcept_id",
            'int_orig_plant_code': "txo.int_origplantcode",
            'int_orig_plant_sci_full': "txo.int_origplantscifull",
            'int_orig_plant_sci_name_no_auth': "txo.int_origplantscinamenoauth",
            'int_orig_plant_common': "txo.int_origplantcommon",
            'taxon_inference_area': "txo.taxoninferencearea",
            'rf_code': "txo.reference_id",
            'rf_label': "rf.reference_id_transl",
        }
        # identify minimal shallow columns
        main_columns['minimal'] = {
            name: col for name, col in main_columns['full'].items()
            if name not in ['author_obs_code', 'author_plant_name',
                            'int_curr_plant_code', 'int_curr_plant_sci_full',
                            'int_curr_plant_sci_name_no_auth',
                            'int_curr_plant_common', 'int_orig_plant_code',
                            'int_orig_plant_sci_full',
                            'int_orig_plant_sci_name_no_auth',
                            'int_orig_plant_common', 'rf_label']}
        # identify full columns with nesting
        main_columns['full_nested'] = main_columns['full'] | {
            'taxon_importance': "importances",
        }
        # identify minimal columns with nesting
        main_columns['minimal_nested'] = main_columns['minimal'] | {
            'taxon_importance': "importances",
        }
        from_sql = {}
        from_sql['minimal'] = """\
            FROM txo
            """
        from_sql['full'] = from_sql['minimal'].rstrip() + """
            JOIN observation ob ON txo.observation_id = ob.observation_id
            LEFT JOIN view_reference_transl rf USING (reference_id)
            """
        from_sql_nested = """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'tm_code', 'tm.' || taxonimportance_id,
                         'sr_code', 'sr.' || stratum_id,
                         'stratum_name', stratumname,
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
                         CASE WHEN tm.stratum_id IS NULL THEN '<All>'
                              ELSE COALESCE(sr.stratumname, sy.stratumname)
                          END AS stratumname,
                         sr.stratum_id
                    FROM taxonimportance tm
                    LEFT JOIN stratum sr USING (stratum_id)
                    LEFT JOIN stratumtype sy USING (stratumtype_id)
                    WHERE tm.taxonobservation_id = txo.taxonobservation_id
                    ORDER BY stratum_id
                )
            ) AS tm ON true
            """
        from_sql['full_nested'] = from_sql['full'].rstrip() + from_sql_nested
        from_sql['minimal_nested'] = from_sql['minimal'].rstrip() + from_sql_nested
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
                        "(emb_taxonobservation < 6 OR emb_taxonobservation IS NULL)",
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
                'bundle': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                             FROM bundle bb
                             WHERE txo.observation_id = bb.observation_id)
                        """,
                    'params': []
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
        stem_location_def_for_validation.append('vb_sc_code')
        stem_count_def_for_validation = table_defs_config.stem_count.copy()
        stem_count_def_for_validation.append('vb_tm_code') 
        
        table_defs = [stem_location_def_for_validation, stem_count_def_for_validation]
        required_fields = ['user_sc_code', 'user_tm_code', 'vb_tm_code', 'stem_count']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, "stem data")
        if validation['has_error']:
            raise ValueError(validation['error'])
        
        
        df['user_sc_code'] = df['user_sc_code'].astype(str) # Ensure user_sc_code is string for consistent merging
        stem_count_codes = super().upload_to_table("stem_count", 'sc', stem_count_def_for_validation, 'stemcount_id', df, True, conn)
        sc_codes_df = pd.DataFrame(stem_count_codes['resources']['sc'])
        sc_codes_df = sc_codes_df[['user_sc_code', 'vb_sc_code']]

        df = df.merge(sc_codes_df, on='user_sc_code', how='left')

        stem_location_codes = {'resources':{'sl':[]}, 'counts':{'sl':0}}

        #Normally this step happens in the upload_to_table method, but stem locations are optional, so we do some extra preprocessing here to allow for that. We create a subset dataframe with only the stem location columns, clean it up, and then upload it if there is any data to upload. This throws an error if the user submits location data without a user sl code.
        
        sl_df = df[df.columns.intersection(stem_location_def_for_validation)].copy()
        sl_df = sl_df.reindex(columns=stem_location_def_for_validation)
        sl_df.replace({pd.NaT: None, np.nan: None}, inplace=True)

        sl_df.dropna(subset=['stem_code', 'stem_x_position', 'stem_y_position', 'stem_health'], inplace=True, how='all') #Drop rows where all stem location fields are null
        sl_df_no_code = sl_df[sl_df['user_sl_code'].isnull()] #Check if there are any rows with stem location data but no user_sl_code
        if not sl_df_no_code.empty:
            raise ValueError("All stem location records must have a user_sl_code when any stem location fields are provided.")
        if not sl_df.empty: #If there is any stem location data to upload, proceed with the upload
            sl_df['user_sl_code'] = sl_df['user_sl_code'].astype(str) # Ensure user_sl_code is string for consistent merging
            stem_location_codes = super().upload_to_table("stem_location", 'sl', stem_location_def_for_validation, 'stemlocation_id', sl_df, True, conn)
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
    
    def upload_taxon_interpretations(self, df, conn, reinterpret=False):
        """
        takes a parquet file of taxon interpretations and uploads it to the taxon interpretation table.
        Parameters:
            file (FileStorage): The uploaded parquet file containing taxon interpretations.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """
        
        if reinterpret: 
            taxon_interpretation_defs = table_defs_config.reinterpretation.copy()
        else:
            taxon_interpretation_defs = table_defs_config.taxon_interpretation.copy()
            taxon_interpretation_defs.append('vb_to_code')
        table_defs = [taxon_interpretation_defs]

        if reinterpret:
            required_fields = ['user_ti_code', 'vb_to_code', 'vb_pc_code', 'vb_py_code', 'vb_ar_code', 'original_interpretation', 'current_interpretation']
        else:
            required_fields = ['user_ti_code', 'user_to_code', 'vb_pc_code', 'vb_py_code', 'vb_ar_code', 'original_interpretation', 'current_interpretation']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, "taxon interpretations")
        if validation['has_error']:
            raise ValueError(validation['error'])

        # If this is a reinterpret, we need to add the user_to_code at the right 
        # index for the insert to the temp table ordering. 
        if reinterpret: 
            taxon_interpretation_defs.insert(len(taxon_interpretation_defs) - 1, 'user_to_code') 
        df['interpretation_date'] = pd.Timestamp.now()

        df['user_ti_code'] = df['user_ti_code'].astype(str) # Ensure user_ti_codes are strings for consistent merging
        new_taxon_interpretations =  super().upload_to_table("taxon_interpretation", 'ti', taxon_interpretation_defs, 'taxoninterpretation_id', df, True, conn)

        # update observation counts for related plant concepts
        pc_ids = list(set(self.extract_id_from_vb_code(code, 'pc')
                  for code in df['vb_pc_code']))
        update_obs_counts(conn, 'plantconcept', pc_ids)

        # update orig and curr interpretations in taxon observation table
        ti_codes  = [row['vb_ti_code'] for row in
                     new_taxon_interpretations['resources']['ti']]
        ti_ids = list(set(self.extract_id_from_vb_code(code, 'ti')
                  for code in ti_codes))
        update_interpreted_observations(conn, 'taxonobservation', ti_ids)

        return new_taxon_interpretations
