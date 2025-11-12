import os
from flask import jsonify
import psycopg
from psycopg import ClientCursor
from psycopg.rows import dict_row
import pandas as pd
import numpy as np
import traceback
from operators import Operator, table_defs_config
from utilities import jsonify_error_message, allowed_file, QueryParameterError


class PlotObservation(Operator):
    """
    Defines operations related to the exchange of plot observation data with
    VegBank, including both plot-level and observation-level details.

    Plot: Represents a specific area of land where vegetation data is collected.
    Observation: Represents the data collected from a plot at a specific time,
        including attributes that may change in between different observation events.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "plot_observation"
        self.table_code = "ob"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.full_get_parameters = ('limit', 'offset')

    def configure_query(self, *args, **kwargs):
        base_columns = {'ob.*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'author_plot_code': "pl.authorplotcode",
            'pl_code': "'pl.' || pl.plot_id",
            'rf_code': "'rf.' || pl.reference_id",
            'parent_pl_code': "'pl.' || parent_id",
            'location_accuracy': "pl.locationaccuracy",
            'confidentiality_status': "pl.confidentialitystatus",
            'confidentiality_reason': "pl.confidentialityreason",
            'latitude': "pl.latitude",
            'longitude': "pl.longitude",
            'author_e': "pl.authore",
            'author_n': "pl.authorn",
            'author_zone': "pl.authorzone",
            'author_datum': "pl.authordatum",
            'author_location': "pl.authorlocation",
            'location_narrative': "pl.locationnarrative",
            'azimuth': "pl.azimuth",
            'dsg_poly': "pl.dsgpoly",
            'shape': "pl.shape",
            'area': "pl.area",
            'stand_size': "pl.standsize",
            'placement_method': "pl.placementmethod",
            'permanence': "pl.permanence",
            'layout_narrative': "pl.layoutnarrative",
            'elevation': "pl.elevation",
            'elevation_accuracy': "pl.elevationaccuracy",
            'elevation_range': "pl.elevationrange",
            'slope_aspect': "pl.slopeaspect",
            'min_slope_aspect': "pl.minslopeaspect",
            'max_slope_aspect': "pl.maxslopeaspect",
            'slope_gradient': "pl.slopegradient",
            'min_slope_gradient': "pl.minslopegradient",
            'max_slope_gradient': "pl.maxslopegradient",
            'topo_position': "pl.topoposition",
            'landform': "pl.landform",
            'surficial_deposits': "pl.surficialdeposits",
            'rock_type': "pl.rocktype",
            'country': "pl.country",
            'state_province': "pl.stateprovince",
            'pl_notes_public': "pl.notespublic",
            'pl_notes_mgt': "pl.notesmgt",
            'pl_revisions': "pl.revisions",
            'ob_code': "'ob.' || ob.observation_id",
            'previous_ob_code': "'ob.' || ob.previousobs_id",
            'pj_code': "'pj.' || ob.project_id",
            'author_obs_code': "ob.authorobscode",
            'obs_start_date': "ob.obsstartdate",
            'obs_end_date': "ob.obsenddate",
            'date_accuracy': "ob.dateaccuracy",
            'date_entered': "ob.dateentered",
            'cm_code': "'cm.' || ob.covermethod_id",
            'cover_dispersion': "ob.coverdispersion",
            'auto_taxon_cover': "ob.autotaxoncover",
            'sm_code': "'sm.' || sm.stratummethod_id",
            'stratum_method_name': "sm.stratummethodname",
            'stratum_method_description': "sm.stratummethoddescription",
            'stratum_assignment': "sm.stratumassignment",
            'method_narrative': "ob.methodnarrative",
            'taxon_observation_area': "ob.taxonobservationarea",
            'stem_size_limit': "ob.stemsizelimit",
            'stem_observation_area': "ob.stemobservationarea",
            'stem_sample_method': "ob.stemsamplemethod",
            'original_data': "ob.originaldata",
            'effort_level': "ob.effortlevel",
            'plot_validation_level': "ob.plotvalidationlevel",
            'floristic_quality': "ob.floristicquality",
            'bryophyte_quality': "ob.bryophytequality",
            'lichen_quality': "ob.lichenquality",
            'observation_narrative': "ob.observationnarrative",
            'landscape_narrative': "ob.landscapenarrative",
            'homogeneity': "ob.homogeneity",
            'phenologic_aspect': "ob.phenologicaspect",
            'representativeness': "ob.representativeness",
            'stand_maturity': "ob.standmaturity",
            'successional_status': "ob.successionalstatus",
            'number_of_taxa': "ob.numberoftaxa",
            'basal_area': "ob.basalarea",
            'hydrologic_regime': "ob.hydrologicregime",
            'soil_moisture_regime': "ob.soilmoistureregime",
            'soil_drainage': "ob.soildrainage",
            'water_salinity': "ob.watersalinity",
            'water_depth': "ob.waterdepth",
            'shore_distance': "ob.shoredistance",
            'soil_depth': "ob.soildepth",
            'organic_depth': "ob.organicdepth",
            'st_code': "'st.' || ob.soiltaxon_id",
            'soil_taxon_src': "ob.soiltaxonsrc",
            'percent_bed_rock': "ob.percentbedrock",
            'percent_rock_gravel': "ob.percentrockgravel",
            'percent_wood': "ob.percentwood",
            'percent_litter': "ob.percentlitter",
            'percent_bare_soil': "ob.percentbaresoil",
            'percent_water': "ob.percentwater",
            'percent_other': "ob.percentother",
            'name_other': "ob.nameother",
            'tree_ht': "ob.treeht",
            'shrub_ht': "ob.shrubht",
            'field_ht': "ob.fieldht",
            'nonvascular_ht': "ob.nonvascularht",
            'submerged_ht': "ob.submergedht",
            'tree_cover': "ob.treecover",
            'shrub_cover': "ob.shrubcover",
            'field_cover': "ob.fieldcover",
            'nonvascular_cover': "ob.nonvascularcover",
            'floating_cover': "ob.floatingcover",
            'submerged_cover': "ob.submergedcover",
            'dominant_stratum': "ob.dominantstratum",
            'growthform_1_type': "ob.growthform1type",
            'growthform_2_type': "ob.growthform2type",
            'growthform_3_type': "ob.growthform3type",
            'growthform_1_cover': "ob.growthform1cover",
            'growthform_2_cover': "ob.growthform2cover",
            'growthform_3_cover': "ob.growthform3cover",
            'total_cover': "ob.totalcover",
            'ob_notes_public': "ob.notespublic",
            'ob_notes_mgt': "ob.notesmgt",
            'ob_revisions': "ob.revisions",
            'emb_observation': "ob.emb_observation",
            'interp_orig_ci_code': "'ci.' || ob.interp_orig_ci_id",
            'interp_orig_cc_code': "'cc.' || ob.interp_orig_cc_id",
            'interp_orig_sciname': "ob.interp_orig_sciname",
            'interp_orig_code': "ob.interp_orig_code",
            'interp_orig_py_code': "'py.' || ob.interp_orig_party_id",
            'interp_orig_partyname': "ob.interp_orig_partyname",
            'interp_current_ci_code': "'ci.' || ob.interp_current_ci_id",
            'interp_current_cc_code': "'cc.' || ob.interp_current_cc_id",
            'interp_current_sciname': "ob.interp_current_sciname",
            'interp_current_code': "ob.interp_current_code",
            'interp_current_py_code': "'py.' || ob.interp_current_party_id",
            'interp_current_partyname': "ob.interp_current_partyname",
            'interp_bestfit_ci_code': "'ci.' || ob.interp_bestfit_ci_id",
            'interp_bestfit_cc_code': "'cc.' || ob.interp_bestfit_cc_id",
            'interp_bestfit_sciname': "ob.interp_bestfit_sciname",
            'interp_bestfit_code': "ob.interp_bestfit_code",
            'interp_bestfit_py_code': "'py.' || ob.interp_bestfit_party_id",
            'interp_bestfit_partyname': "ob.interp_bestfit_partyname",
            'top_taxon1_name': "ob.toptaxon1name",
            'top_taxon2_name': "ob.toptaxon2name",
            'top_taxon3_name': "ob.toptaxon3name",
            'top_taxon4_name': "ob.toptaxon4name",
            'top_taxon5_name': "ob.toptaxon5name",
            'has_observation_synonym': "ob.hasobservationsynonym",
        }
        main_columns['minimal'] = {
            'pl_code': "'pl.' || pl.plot_id",
            'latitude': "pl.latitude",
            'longitude': "pl.longitude",
            'ob_code': "'ob.' || ob.observation_id",
            'author_plot_code': "pl.authorplotcode",
            'author_obs_code': "ob.authorobscode",
            'state_province': "pl.stateprovince",
            'country': "pl.country",
        }
        from_sql = """\
            FROM ob
            LEFT JOIN plot pl USING (plot_id)
            LEFT JOIN stratummethod sm USING (stratummethod_id)
            """
        order_by_sql = """\
            ORDER BY ob.observation_id ASC
            """

        self.query = {}
        self.query['base'] = {
            'alias': "ob",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': """\
                    FROM observation AS ob
                    JOIN plot AS pl USING (plot_id)
                    """,
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': "pl.confidentialitystatus < 4",
                    'params': []
                },
                'ob': {
                    'sql': "ob.observation_id = %s",
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
                'columns': main_columns[self.detail],
                'params': []
            },
        }
        self.query['from'] = {
            'sql': from_sql,
            'params': []
        }

    def upload_plot_observations(self, request, params):
        """
        Uploads plot and observation data from a file, validates it, and inserts it into the database.
        Parameters:
            request (Request): The incoming request containing the file to be uploaded.
            params (dict): Database connection parameters.
            Set via env variable in vegbankapi.py. Keys are: 
                dbname, user, host, port, password
        Returns:
            Response: A JSON response containing the results of the upload operation, including 
                      inserted and matched records, or an error message if the operation fails.
        Raises:
            ValueError: If there are unsupported columns in the uploaded data, if references do not 
                        exist in the database, or if there are no new plots/observations to insert.
        """

        if 'file' not in request.files:
            return jsonify_error_message("No file part in the request."), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify_error_message("No selected file."), 400
        if not allowed_file(file.filename):
            return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400

        plot_fields = table_defs_config.plot
        observation_fields = table_defs_config.observation

        to_return = {}
        
        try:
            df = pd.read_parquet(file)
            print(f"Plot Observation DataFrame loaded with {len(df)} records.")
            df.columns = map(str.lower, df.columns)
            #Checking if the user submitted any unsupported columns
            additional_columns = set(df.columns) - set(plot_fields) - set(observation_fields)
            if(len(additional_columns) > 0):
                return jsonify_error_message(f"Your data must only contain fields included in the plot observation schema. The following fields are not supported: {additional_columns} ")
            
            #We don't require every field to be present, so we will add any missing columns with empty data.
            #If the user omits a required field, like pl_code on an observation, the insert to the temp table will fail. 
            missing_plot_columns = set(plot_fields) - set(df.columns)
            for column in missing_plot_columns:
                df[column] = None  # Add missing columns with empty data
            missing_obs_columns = set(observation_fields) - set(df.columns)
            for column in missing_obs_columns:
                df[column] = None
            
            #These casts fix some common issues with the time fields. Not sure if this is a good plan long term, but I'm leaving it in for now. 
            df.replace({pd.NaT: None}, inplace=True)
            df.replace({np.nan: None}, inplace=True)
            print(df.columns)
            df['obsstartdate'] = pd.to_datetime(df['obsstartdate'])
            df['obsenddate'] = pd.to_datetime(df['obsenddate'])
            df['dateentered'] = pd.to_datetime(df['dateentered'])

            pl_input_df = df[plot_fields]
            pl_input_no_duplicates = pl_input_df.drop_duplicates() # We need to remove duplicates because there may be multiple observations for the same plot, and we only want to insert each plot once.
            pl_code_duplicates = pl_input_no_duplicates[pl_input_no_duplicates.duplicated(subset=['pl_code'])] 
            if(len(pl_code_duplicates) > 0):
                return jsonify_error_message(f"Plot codes cannot be used on more than one different plot. The following codes occur more than once: {pl_code_duplicates['pl_code']}")
            
            print(f"Plot data loaded with {len(pl_input_no_duplicates)} records")

            ob_input_df = df[observation_fields]

            ob_code_duplicates = ob_input_df[ob_input_df.duplicated(subset=['ob_code'])] 
            if(len(ob_code_duplicates) > 0):
                return jsonify_error_message(f"Obs codes cannot be used on more than one different observation. The following codes occur more than once: {ob_code_duplicates['obs_code']}")
            
            print(f"Observation data loaded with {len(ob_input_df)} records")
            pl_input_no_duplicates['submitter_surname'] = "test_surname" #This will need to be updated after authentication
            pl_input_no_duplicates['submitter_givenname'] = "test_givenname" #This will need to be updated after authentication
            pl_input_no_duplicates['submitter_email'] = "test@test_email.org" #This will need to be updated after authentication
            pl_inputs = list(pl_input_no_duplicates.itertuples(index=False, name=None))

            with psycopg.connect(**params, cursor_factory=ClientCursor, row_factory=dict_row) as conn:
                
                with conn.cursor() as cur:
                    with conn.transaction():
                        
                        #Adding Plots to temp table, validating, then inserting into permanent table
                        with open(self.QUERIES_FOLDER + "/plot_observation/plot/create_plot_temp_table.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        with open(self.QUERIES_FOLDER + "/plot_observation/plot/insert_plots_to_temp_table.sql", "r") as file:
                            placeholders = ', '.join(['%s'] * len(pl_input_no_duplicates.columns))
                            sql = file.read().format(placeholders)

                        cur.executemany(sql, pl_inputs)
                        
                        print("about to run validate plots")
                        with open(self.QUERIES_FOLDER + "/plot_observation/plot/validate_plots.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        existing_plots = cur.fetchall()
                        print("existing records: " + str(existing_plots))
                        cur.nextset()
                        new_references = cur.fetchall()
                        print("new references: " + str(new_references))
                        
                        with open(self.QUERIES_FOLDER + "/plot_observation/plot/insert_plots_from_temp_table_to_permanent.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql)
                        inserted_plots = cur.fetchall()

                        if(len(inserted_plots) > 0): #This conditional provides for the case where no new plots were inserted, but existing plots were matched. In that case, we don't need to convert any user provided pl_codes into the new vegbank codes. 
                            inserted_plots_df = pd.DataFrame(inserted_plots)
                            inserted_plots_df = inserted_plots_df[['authorplotcode', 'pl_code']]
                            vb_pl_codes_df = pd.DataFrame(pl_input_no_duplicates[['pl_code', 'authorplotcode']])
                            vb_pl_codes_df.rename(columns={'pl_code': 'user_pl_code'}, inplace=True)
                            pl_codes_joined_df = pd.merge(vb_pl_codes_df, inserted_plots_df, how='left', on='authorplotcode')
                            user_pl_code_to_vb_pl_code = {}
                            for index, record in pl_codes_joined_df.iterrows():
                                user_pl_code_to_vb_pl_code[record['user_pl_code']] = record['pl_code']
                            ob_input_df['pl_code'] = ob_input_df['pl_code'].map(user_pl_code_to_vb_pl_code)

                        ob_input_df.replace({pd.NaT: None}, inplace=True)
                        obs_inputs = list(ob_input_df.itertuples(index=False, name=None))

                        #Adding Observations to temp table, validating, then inserting into permanent table
                        with open(self.QUERIES_FOLDER + "/plot_observation/observation/create_observation_temp_table.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        
                        with open(self.QUERIES_FOLDER + "/plot_observation/observation/insert_observations_to_temp_table.sql", "r") as file:
                            placeholders = ', '.join(['%s'] * len(ob_input_df.columns))
                            sql = file.read().format(placeholders)
                        cur.executemany(sql, obs_inputs)
                        
                        print("about to run validate observations")
                        with open(self.QUERIES_FOLDER + "/plot_observation/observation/validate_observations.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        existing_observations = cur.fetchall()
                        print("existing observations: " + str(existing_observations))
                        if(len(existing_observations) > 0):
                            raise ValueError("Some ob_codes provided already exist in vegbank. Please ensure you are only uploading new observations. Existing ob_codes: " + str(existing_observations))
                        
                        cur.nextset()
                        non_existant_plots = cur.fetchall()
                        print("non_existant_plots: " + str(non_existant_plots))
                        if(len(non_existant_plots) > 0):
                            raise ValueError("Some pl_codes provided do not exist in vegbank or the dataset provided. Please ensure you are only uploading observations for existing plots. Non-existant pl_codes: " + str(non_existant_plots))
                        
                        cur.nextset()
                        non_existant_projects = cur.fetchall()
                        print("non_existant_projects: " + str(non_existant_projects))
                        if(len(non_existant_projects) > 0):
                            raise ValueError("Some pj_codes provided do not exist in vegbank or the dataset provided. Please ensure you are only uploading observations for existing projects. Non-existant pj_codes: " + str(non_existant_projects))
                        
                        cur.nextset()
                        non_existant_cover_methods = cur.fetchall()
                        print("non_existant_cover_methods: " + str(non_existant_cover_methods))
                        if(len(non_existant_cover_methods) > 0):
                            raise ValueError("Some cm_codes provided do not exist in vegbank or the dataset provided. Please ensure you are only uploading observations for existing cover methods. Non-existant cm_codes: " + str(non_existant_cover_methods))

                        cur.nextset()
                        non_existant_stratum_methods = cur.fetchall()
                        print("non_existant_stratum_methods: " + str(non_existant_stratum_methods))
                        if(len(non_existant_stratum_methods) > 0):
                            raise ValueError("Some sm_codes provided do not exist in vegbank or the dataset provided. Please ensure you are only uploading observations for existing stratum methods. Non-existant sm_codes: " + str(non_existant_stratum_methods))
                        
                        cur.nextset()
                        non_existant_soil_taxa = cur.fetchall()
                        print("non_existant_soil_taxa: " + str(non_existant_soil_taxa))
                        if(len(non_existant_soil_taxa) > 0):
                            raise ValueError("Some st_codes provided do not exist in vegbank or the dataset provided. Please ensure you are only uploading observations for existing soil taxa. Non-existant st_codes: " + str(non_existant_soil_taxa))
                        
                        
                        with open(self.QUERIES_FOLDER + "/plot_observation/observation/insert_observations_from_temp_table_to_permanent.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql)
                        inserted_observations = cur.fetchall()
                        print("inserted records: " + str(inserted_observations))
                        if(len(inserted_observations) == 0):
                            raise ValueError("No new observations were found in the dataset provided.")
                
                        plot_ids = []
                        observation_ids = []
                        for record in inserted_plots:
                            plot_ids.append(record['plot_id'])
                        print("plot_ids: " + str(plot_ids))

                        for record in inserted_observations:
                            observation_ids.append(record['observation_id'])
                        print("observation_ids: " + str(observation_ids))
    
                        print("about to run create plot accession code")
                        with open(self.QUERIES_FOLDER + "/plot_observation/plot/create_plot_accession_codes.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql, (plot_ids, ))
                        new_pl_codes = cur.fetchall()

                        print("about to run create observation accession code")
                        with open(self.QUERIES_FOLDER + "/plot_observation/observation/create_observation_accession_codes.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql, (observation_ids, ))
                        new_ob_codes = cur.fetchall()
                        
                        to_return_plots = []
                        if(len(new_pl_codes) > 0):
                            pl_codes_df = pd.DataFrame(new_pl_codes)
                            pl_input_df['authorplotcode'] = pl_input_df['authorplotcode'].astype(str)
                            pl_codes_df['authorplotcode'] = pl_codes_df['authorplotcode'].astype(str)
                            joined_pl_df = pd.merge(pl_codes_df, pl_input_no_duplicates, on='authorplotcode', how='left')
                            for index, record in joined_pl_df.iterrows():
                                to_return_plots.append({
                                    "user_code": record['pl_code'], 
                                    "pl_code": record['accessioncode'],
                                    "authorplotcode": record['authorplotcode'],
                                    "action":"inserted"
                                })
                        else:  
                            joined_pl_df = pd.DataFrame()
                        for record in existing_plots:
                            to_return_plots.append({
                                "user_code": record["pl_code"],
                                "pl_code": record['pl_code'],
                                "authorplotcode": record['authorplotcode'],
                                "action":"matched"
                            })

                        ob_codes_df = pd.DataFrame(new_ob_codes)
                        ob_input_df['authorobscode'] = ob_input_df['authorobscode'].astype(str)
                        ob_codes_df['authorobscode'] = ob_codes_df['authorobscode'].astype(str)
                        joined_ob_df = pd.merge(ob_codes_df, ob_input_df, on='authorobscode', how='left')

                        to_return_observations = []
                        for index, record in joined_ob_df.iterrows():
                            to_return_observations.append({
                                "user_code": record['ob_code'], 
                                "ob_code": record['accessioncode'],
                                "authorobscode": record['authorobscode'],
                                "action":"inserted"
                            })
                        for record in existing_observations:
                            to_return_observations.append({
                                "user_code": record["ob_code"],
                                "ob_code": record['ob_code'],
                                "authorobscode": record['authorobscode'],
                                "action":"matched"
                            })
                        to_return["resources"] = {
                            "pl": to_return_plots,
                            "ob": to_return_observations
                        }
                        to_return["counts"] = {
                            "pl":{
                                "inserted": len(joined_pl_df),
                                "matched": len(existing_plots)
                            },
                            "ob":{
                                "inserted": len(joined_ob_df),
                                "matched": len(existing_observations)
                            }
                        }
            conn.close()      

            return jsonify(to_return)
        except Exception as e:
            traceback.print_exc()
            return jsonify_error_message(f"An error occurred while processing the file: {str(e)}"), 500

    def get_observation_details(self, ob_code):
        """
        Retrieves observation details for a given observation code.

        This method connects to the VegBank database and executes SQL queries
        to fetch plot observation details, associated taxon observations, and
        community classifications, returning the results in a JSON format.

        Parameters (for GET requests only):
            ob_code (str): The unique identifier for the plot observation.
        Returns:
            flask.Response: A Flask response object containing the observation
                details in JSON format.
        Raises:
            Exception: If there is an error in executing the SQL queries
                or connecting to the database.
        """
        to_return = {}
        with psycopg.connect(**self.params, row_factory=dict_row) as conn:
            with conn.cursor() as cur:
                # Prepare to query for a single resource based on its code
                try:
                    ob_id = self.extract_id_from_vb_code(ob_code)
                except QueryParameterError as e:
                    return jsonify_error_message(e.message), e.status_code
                sql_file = os.path.join(self.QUERIES_FOLDER,
                                        f'get_observation_details.sql')
                with open(sql_file, "r") as file:
                    sql = file.read()
                data = (ob_id, )
                cur.execute(sql, data)
                to_return["data"] = cur.fetchall()
                to_return["count"] = len(to_return["data"])
                print(to_return)
                if(len(to_return["data"]) != 0):
                    taxa = []
                    sql_file = os.path.join(self.QUERIES_FOLDER,
                                            f'get_taxa_for_observation.sql')
                    with open(sql_file, "r") as file:
                        sql = file.read()
                    data = (ob_id, )
                    cur.execute(sql, data)
                    taxa = cur.fetchall()
                    to_return["data"][0].update({"taxa": taxa})
                    communities = []
                    sql_file = os.path.join(self.QUERIES_FOLDER,
                                            f'get_community_for_observation.sql')
                    with open(sql_file, "r") as file:
                        sql = file.read()
                    data = (ob_id, )
                    cur.execute(sql, data)
                    communities = cur.fetchall()
                    to_return["data"][0].update({"communities": communities})
            conn.close()
        return jsonify(to_return)
