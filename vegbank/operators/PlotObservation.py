from flask import jsonify, request, send_file
import psycopg
from psycopg import connect, ClientCursor
from psycopg.rows import dict_row
import pandas as pd
import numpy as np
import io
import time
import operators.table_defs_config as table_defs_config
import traceback
from operators.operator_parent_class import Operator
from utilities import jsonify_error_message, convert_to_parquet, allowed_file

class PlotObservation(Operator):
    '''
    Defines operations related to plot and observation data management, 
    including retrieval and upload functionalities.
    Plots: Represents a specific area of land where vegetation data is collected.
    Observations: Represents the data collected from a plot at a specific time, 
    including attributes that may change in between different observation events.

    Inherits from the Operator parent class to utilize common default values.
    '''
    def __init__(self):
        super().__init__()

    def get_plot_observations(self, request, params, accession_code):
        """
        Retrieve either a single plot observation by accession code, 
        or a list of plot observations with pagination and detail level options.
        Parameters:
            request (Request): The request object containing query parameters.
            params (dict): Database connection parameters. 
            Set via env variable in vegbankapi.py. Keys are: 
                dbname, user, host, port, password
            accession_code (str or None): The unique identifier for the observation being retrieved. 
                                           If None, retrieves all observations and their plots.
        URL Parameters:
            detail (str, optional): Level of detail for the response. 
                                    Can be either 'minimal' or 'full'. Defaults to 'full'.
            limit (int, optional): Maximum number of records to return. Defaults to 1000.
            offset (int, optional): Number of records to skip before starting to return records. Defaults to 0.
        Returns:
            Response: A JSON response containing the plot observations data and count.
                      If 'detail' is specified, it can be either 'minimal' or 'full'.
                      Returns an error message with a 400 status code for invalid parameters.
        Raises:
            ValueError: If 'limit' or 'offset' are not non-negative integers.
        """

        create_parquet = request.args.get("create_parquet", "false").lower() == "true"
        detail = request.args.get("detail", self.default_detail)
        if detail not in ("minimal", "full"):
            return jsonify_error_message("When provided, 'detail' must be 'minimal' or 'full'."), 400
        try:
            limit = int(request.args.get("limit", self.default_limit))
            offset = int(request.args.get("offset", self.default_offset))
        except ValueError:
            return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400
        
        with open(self.QUERIES_FOLDER + "/plot_observation/get_plot_observations_count.sql", "r") as file:
            count_sql = file.read()

        if accession_code is not None:
            sql = open(self.QUERIES_FOLDER + "/plot_observation/get_plot_observation_by_accession_code.sql", "r").read()
            data = (accession_code, )
        else:
            data = (limit, offset, )
            if detail == "minimal":
                with open(self.QUERIES_FOLDER + "/plot_observation/get_plot_observations_minimal.sql", "r") as file:
                    sql = file.read()
            else:
                with open(self.QUERIES_FOLDER + "/plot_observation/get_plot_observations_full.sql", "r") as file:
                    sql = file.read()
        
        to_return = {}
        with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
            if(create_parquet is False):
                conn.row_factory=dict_row
            else:
                print("about to make plotobs parquet file")
                df_parquet = convert_to_parquet(sql, data, conn)
                print(df_parquet)
                conn.close()
                return send_file(io.BytesIO(df_parquet), mimetype='application/octet-stream', as_attachment=True, download_name='plot_observations.parquet')
            with conn.cursor() as cur:
                cur.execute(sql, data)
                to_return["data"] = cur.fetchall()

                if accession_code is None:
                    cur.execute(count_sql)
                    to_return["count"] = cur.fetchall()[0]["count"]
                else:
                    to_return["count"] = len(to_return["data"])
            conn.close()   
        return jsonify(to_return)

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

    def get_observation_details(self, params, accession_code):
        """
        Retrieves observation details for a given accession code from the database.
        This method connects to the PostgreSQL database using the provided parameters,
        executes SQL queries to fetch observation details, associated taxa, and communities,
        and returns the results in a JSON format.

        Parameters:
            params : dict
                A dictionary containing the database connection parameters.
            accession_code : str
                The unique identifier for the observation being retrieved.
        Returns:
            Response: A JSON response containing the observation details, including the count of records,
                associated taxa, and communities if available.
        Raises:
            Exception
                If there is an error in executing the SQL queries or connecting to the database.
        """
        
        to_return = {}
        with psycopg.connect(**params, row_factory=dict_row) as conn:
            with conn.cursor() as cur:
                with open(self.QUERIES_FOLDER + "get_observation_details.sql", "r") as file:
                    sql = file.read() 
                data = (accession_code, )
                cur.execute(sql, data)
                to_return["data"] = cur.fetchall()
                to_return["count"] = len(to_return["data"])
                print(to_return)
                if(len(to_return["data"]) != 0):
                    taxa = []
                    with open(self.QUERIES_FOLDER + "/taxon_observation/get_taxa_for_observation.sql", "r") as file:
                        sql = file.read() 
                    data = (accession_code, )
                    cur.execute(sql, data)
                    taxa = cur.fetchall()
                    to_return["data"][0].update({"taxa": taxa})
                    communities = []
                    with open(self.QUERIES_FOLDER + "/community_concept/get_community_for_observation.sql", "r") as file:
                        sql = file.read() 
                    data = (accession_code, )
                    cur.execute(sql, data)
                    communities = cur.fetchall()
                    to_return["data"][0].update({"communities": communities})
            conn.close()      
        return jsonify(to_return)