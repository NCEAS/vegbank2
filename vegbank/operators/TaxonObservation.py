import os
import traceback
import pandas as pd
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
        multiple taxon interpretations.

    Inherits from the Operator parent class to utilize common default values and
    methods.

    Note that TaxonObservation deviates from the base Operator class in 2 ways:
    1. Skips querying the db for the full record count, because it takes too long
       (self.include_full_count is False)
    2. Uses an extra query parameter `num_taxa` for capping the number of taxa
       returned per plot observation
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "taxon_observation"
        self.table_code = "to"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.default_num_taxa = 5
        self.include_full_count = False
        self.full_get_parameters = ('num_taxa', 'limit', 'offset')

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        This only applies validations specific to taxon observations, then
        dispatches to the parent validation method for more general (and more
        permissive) validations.

        Parameters:
            request_args (ImmutableMultiDict): Query parameters provided
                as part of the request.

        Returns:
            dict: A dictionary of validated parameters with defaults applied.

        Raises:
            QueryParameterError: If any supplied parameters are invalid.
        """
        # specifically require detail to be "full" for taxon observations
        if request_args.get("detail", self.default_detail) not in ("full"):
            raise QueryParameterError("When provided, 'detail' must be 'full'.")

        # first dispatch to the base validation method
        params = super().validate_query_params(request_args)

        # now validate param specific to this class
        try:
            params['num_taxa'] = int(request_args.get("num_taxa",
                                                      self.default_num_taxa))
        except ValueError:
            raise QueryParameterError(
                "When provided, 'num_taxa' must be a non-negative integer."
            )
        if params['num_taxa'] < 0:
            raise QueryParameterError(
                "When provided, 'num_taxa' must be a non-negative integer."
            )

        return params
    
    def upload_strata_cover_data(self, file, conn):
        """
        takes a parquet file in the strata cover data format from the loader module and uploads it to the taxon observation,
        taxon importance, and taxon interpretation tables. 
        Parameters:
            file (FileStorage): The uploaded parquet file containing taxon observations.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """
        df = pd.read_parquet(file)

        table_defs = [table_defs_config.taxon_importance, table_defs_config.taxon_observation]
        required_fields = ['user_to_code', 'vb_ob_code', 'author_plant_name', 'user_tm_code']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, "strata cover data")
        if validation['has_error']:
            raise ValueError(validation['error'])
        
        taxon_observation_codes = super().upload_to_table("taxon_observation", 'to', table_defs_config.taxon_observation, 'taxonobservation_id', df, True, conn)
        

        to_codes_df = pd.DataFrame(taxon_observation_codes['resources']['to'])
        to_codes_df = to_codes_df[['user_to_code', 'vb_to_code']]

        df = df.merge(to_codes_df, on='user_to_code', how='left')

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
        return jsonify(to_return)

    def upload_strata_definitions(self, file, conn):
        """
        takes a parquet file of strata definitions and uploads it to the stratum table.
        Parameters:
            file (FileStorage): The uploaded parquet file containing strata definitions.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """
        df = pd.read_parquet(file)

        table_defs = [table_defs_config.stratum]
        required_fields = ['vb_ob_code', 'user_ob_code', 'user_sr_code', 'vb_sy_code']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, "strata definitions")
        if validation['has_error']:
            raise ValueError(validation['error'])

        new_strata =  super().upload_to_table("stratum", 'sr', table_defs_config.stratum, 'stratum_id', df, True, conn)
        return jsonify(new_strata)
    
    def upload_stem_data(self, file, conn):
        """
        takes a parquet file in the stem data format from the loader module and uploads it to the stem count
         and stem location tables. 
        Parameters:
            file (FileStorage): The uploaded parquet file containing stem data.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """
        df = pd.read_parquet(file)

        table_defs = [table_defs_config.stem_location, table_defs_config.stem_count]
        required_fields = ['user_sc_code', 'user_tm_code', 'stem_count', 'user_sl_code']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, "stem data")
        if validation['has_error']:
            raise ValueError(validation['error'])
        
        stem_count_codes = super().upload_to_table("stem_count", 'sc', table_defs_config.stem_count, 'stemcount_id', df, True, conn)
        

        sc_codes_df = pd.DataFrame(stem_count_codes['resources']['sc'])
        sc_codes_df = sc_codes_df[['user_sc_code', 'vb_sc_code']]

        df = df.merge(sc_codes_df, on='user_sc_code', how='left')

        stem_location_codes = super().upload_to_table("stem_location", 'sl', table_defs_config.stem_location, 'stemlocation_id', df, True, conn)
        print(stem_location_codes)
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