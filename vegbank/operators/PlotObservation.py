import os
import textwrap
from flask import jsonify
import psycopg
from psycopg import ClientCursor
from psycopg.rows import dict_row
import pandas as pd
import numpy as np
import traceback
from operators import Operator, table_defs_config
from utilities import jsonify_error_message, allowed_file, validate_required_and_missing_fields


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
        self.detail_options = ("minimal", "full", "geo")
        self.nested_options = ("true", "false")
        self.sort_options = ("default", "author_obs_code")
        self.default_num_taxa = 5
        self.default_num_comms = 5
        self.bulk_required_fields = ['user_ob_code', 'vb_pj_code']

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        nesting = False
        if query_type != "geo" and self.with_nested == 'true':
            query_type += "_nested"
            nesting = True

        base_columns = {'ob.*': "*"}
        base_columns_search = {
            'search_rank': "TS_RANK(ob.search_vector, " +
                           "WEBSEARCH_TO_TSQUERY('simple', %s))"
        }
        main_columns = {}
        # identify full shallow columns
        main_columns['full'] = {
            'author_plot_code': "pl.authorplotcode",
            'pl_code': "'pl.' || pl.plot_id",
            'rf_code': "'rf.' || pl.reference_id",
            'rf_label': "rf.reference_id_transl",
            'parent_pl_code': "'pl.' || parent_id",
            'location_accuracy': "pl.locationaccuracy",
            'confidentiality_status': "pl.confidentialitystatus",
            'latitude': f"({textwrap.dedent("""\
                CASE WHEN 4 <= confidentialitystatus THEN NULL
                             ELSE pl.latitude END""")})",
            'longitude': f"({textwrap.dedent("""\
                CASE WHEN 4 <= confidentialitystatus THEN NULL
                             ELSE pl.longitude END""")})",
            'author_e': f"({textwrap.dedent("""\
                CASE WHEN 1 <= confidentialitystatus THEN '<confidential>'
                             ELSE pl.authore END""")})",
            'author_n': f"({textwrap.dedent("""\
                CASE WHEN 1 <= confidentialitystatus THEN '<confidential>'
                             ELSE pl.authorn END""")})",
            'author_zone': f"({textwrap.dedent("""\
                CASE WHEN 1 <= confidentialitystatus THEN '<confidential>'
                             ELSE pl.authorzone END""")})",
            'author_datum': f"({textwrap.dedent("""\
                CASE WHEN 1 <= confidentialitystatus THEN '<confidential>'
                             ELSE pl.authordatum END""")})",
            'author_location': f"({textwrap.dedent("""\
                CASE WHEN 1 <= confidentialitystatus THEN '<confidential>'
                             ELSE pl.authorlocation END""")})",
            'location_narrative': f"({textwrap.dedent("""\
                CASE WHEN 1 <= confidentialitystatus THEN '<confidential>'
                             ELSE pl.locationnarrative END""")})",
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
            'project_name': "pj.projectname",
            'author_obs_code': "ob.authorobscode",
            'year': "EXTRACT(YEAR FROM ob.obsstartdate)",
            'obs_start_date': "ob.obsstartdate",
            'obs_end_date': "ob.obsenddate",
            'date_accuracy': "ob.dateaccuracy",
            'date_entered': "ob.dateentered",
            'cm_code': "'cm.' || ob.covermethod_id",
            'cover_method_name': "cm.covertype",
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
        # identify full columns with nesting
        main_columns['full_nested'] = main_columns['full'] | {
            'taxon_count': "taxon_count",
            'taxon_importance_count': "taxon_importance_count",
            'taxon_importance_count_returned': "taxon_importance_count_returned",
            'top_taxon_observations': "top_taxon_observations",
            'top_classifications': "top_classifications",
        }
        # identify minimal columns
        main_columns['minimal'] = {alias:col for alias, col in
            main_columns['full'].items() if alias in [
                'area', 'author_obs_code', 'author_plot_code', 'country',
                'elevation', 'latitude', 'longitude', 'ob_code', 'pl_code',
                'state_province', 'year'
            ]}
        # identify minimal columns with nesting
        main_columns['minimal_nested'] = main_columns['minimal'] | {
            'taxon_count': "taxon_count",
            'taxon_count_returned': "taxon_count_returned",
            'top_taxon_observations': "top_taxon_observations",
            'top_classifications': "top_classifications",
        }
        # identify geo columns
        main_columns['geo'] = {alias:col for alias, col in
            main_columns['full'].items() if alias in [
                'author_obs_code', 'latitude', 'longitude',
                'ob_code'
            ]}
        from_sql = {}
        from_sql['geo'] = """\
            FROM ob
            LEFT JOIN plot pl USING (plot_id)
            """
        from_sql['minimal'] = from_sql['geo']
        from_sql['full'] = from_sql['minimal'].rstrip() + """
            LEFT JOIN project pj USING (project_id)
            LEFT JOIN view_reference_transl rf USING (reference_id)
            LEFT JOIN stratummethod sm USING (stratummethod_id)
            LEFT JOIN covermethod cm USING (covermethod_id)
            """
        from_sql_nested = """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'cl_code', 'cl.' || commclass_id,
                         'ci_code', 'ci.' || comminterpretation_id,
                         'cc_code', 'cc.' || commconcept_id,
                         'comm_name', comm_name,
                         'comm_code', comm_code
                       )) AS top_classifications
                FROM (
                  SELECT cl.commclass_id,
                         ci.comminterpretation_id,
                         cc.commconcept_id,
                         cc.commname as comm_name,
                         cu.commname as comm_code
                    FROM commclass cl
                    JOIN comminterpretation ci USING (commclass_id)
                    JOIN commconcept cc USING (commconcept_id)
                    LEFT JOIN commusage cu ON cu.commconcept_id = cc.commconcept_id
                                          AND cu.classsystem = 'Code'
                    WHERE cl.observation_id = ob.observation_id
                    ORDER BY cl.commclass_id
                    LIMIT %s
                ) AS top_n_classifications
            ) AS cl ON true
            """.rstrip()
        from_sql['minimal_nested'] = from_sql['minimal'].rstrip() + \
            from_sql_nested + """
            LEFT JOIN LATERAL (
              WITH all_taxa AS (
                SELECT taxonobservation_id,
                       int_currplantconcept_id,
                       int_currplantscinamenoauth,
                       authorplantname,
                       maxcover
                  FROM view_taxonobs_withmaxcover txmc
                  WHERE txmc.observation_id = ob.observation_id
              ), returned_taxa AS (
                SELECT *
                  FROM all_taxa
                  ORDER BY maxcover DESC,
                           authorplantname
                  LIMIT %s
              )
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'to_code', 'to.' || taxonobservation_id,
                         'pc_code', 'pc.' || int_currplantconcept_id,
                         'name', COALESCE(int_currplantscinamenoauth,
                                          authorplantname),
                         'max_cover', maxcover
                       )) AS top_taxon_observations,
                     (SELECT COUNT(int_currplantconcept_id)
                        FROM all_taxa) AS taxon_count,
                     (SELECT COUNT(int_currplantconcept_id)
                        FROM returned_taxa) AS taxon_count_returned
                FROM returned_taxa
            ) AS txo ON true
            """
        from_sql['full_nested'] = from_sql['full'].rstrip() + \
            from_sql_nested + """
            LEFT JOIN LATERAL (
              WITH all_taxon_observations AS (
                SELECT txo.taxonobservation_id,
                       tm.taxonimportance_id,
                       txo.int_currplantconcept_id,
                       txo.int_currplantscinamenoauth,
                       txo.authorplantname,
                       sr.stratum_id,
                       sr.stratumname,
                       tm.cover
                  FROM taxonobservation txo
                  LEFT JOIN taxonimportance tm USING (taxonobservation_id)
                  LEFT JOIN stratum sr USING (stratum_id)
                  WHERE txo.observation_id = ob.observation_id
              ), returned_taxon_observations AS (
                SELECT *
                  FROM all_taxon_observations
                  ORDER BY COALESCE(int_currplantscinamenoauth,
                                    authorplantname),
                           cover DESC
                  LIMIT %s
              )
              SELECT (SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'to_code', 'to.' || taxonobservation_id,
                         'tm_code', 'tm.' || taxonimportance_id,
                         'pc_code', 'pc.' || int_currplantconcept_id,
                         'plant_name', COALESCE(int_currplantscinamenoauth,
                                                authorplantname),
                         'sr_code', 'sr.' || stratum_id,
                         'stratum_name', COALESCE(stratumname, '-all-'),
                         'cover', cover
                         )) AS top_taxon_observations
                        FROM returned_taxon_observations) AS top_taxon_observations,
                     (SELECT COUNT(DISTINCT int_currplantconcept_id)
                        FROM all_taxon_observations) AS taxon_count,
                     (SELECT COUNT(1)
                        FROM all_taxon_observations) AS taxon_importance_count,
                     (SELECT COUNT(1)
                        FROM returned_taxon_observations) AS taxon_importance_count_returned
            ) AS txo ON true
            """
        order_by_sql = {}
        order_by_sql['default'] = f"""\
            ORDER BY ob.observation_id {self.direction}
            """
        order_by_sql['author_obs_code'] = f"""\
            ORDER BY ob.authorobscode {self.direction},
                     ob.observation_id {self.direction}
            """

        self.query = {}
        self.query['base'] = {
            'alias': "ob",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
                'search': {
                    'columns': base_columns_search,
                    'params': ['search']
                },
            },
            'from': {
                'sql': "FROM observation AS ob",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': [
                        "emb_observation < 6",
                    ],
                    'params': []
                },
                'search': {
                    'sql': """\
                         ob.search_vector @@ WEBSEARCH_TO_TSQUERY('simple', %s)
                    """,
                    'params': ['search']
                },
                'ob': {
                    'sql': "ob.observation_id = %s",
                    'params': ['vb_id']
                },
                'cc': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM commclass cl
                              JOIN comminterpretation ci USING (commclass_id)
                              JOIN commconcept cc USING (commconcept_id)
                              WHERE ob.observation_id = cl.observation_id
                                AND commconcept_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'pc': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM taxonobservation txo
                              JOIN taxoninterpretation txi USING (taxonobservation_id)
                              JOIN plantconcept pc USING (plantconcept_id)
                              WHERE ob.observation_id = txo.observation_id
                                AND plantconcept_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'pj': {
                    'sql': "project_id = %s",
                    'params': ['vb_id']
                },
                # This gets *all* contributors, not just observationcontributors
                'py': {
                    'sql': """\
                        EXISTS (
                            SELECT py.observation_id
                             FROM view_browseparty_all py
                             WHERE ob.observation_id = py.observation_id
                               AND py.party_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'cm': {
                    'sql': "covermethod_id = %s",
                    'params': ['vb_id']
                },
                'sm': {
                    'sql': "stratummethod_id = %s",
                    'params': ['vb_id']
                }
            },
            'order_by': {
                'sql': order_by_sql[self.order_by],
                'params': []
            },
        }
        self.query['select'] = {
            "always": {
                'columns': main_columns[query_type],
                'params': []
            },
            'search': {
                'columns': {'search_rank': 'ob.search_rank'},
                'params': []
            },
        }
        self.query['from'] = {
            'sql': from_sql[query_type],
            'params': ['num_comms', 'num_taxa'] if nesting else []
        }

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        This applies validations specific to plot observations, while
        dispatching to the parent validation method for more general validation.

        Parameters:
            request_args (ImmutableMultiDict): Query parameters provided
                as part of the request.

        Returns:
            dict: A dictionary of validated parameters with defaults applied.

        Raises:
            QueryParameterError: If any supplied parameters are invalid.
        """
        # dispatch to the base validation method
        params = super().validate_query_params(request_args)

        # add params for limiting nested fields
        params['num_taxa'] = self.process_integer_param('num_taxa',
            request_args.get('num_taxa', self.default_num_taxa))
        params['num_comms'] = self.process_integer_param('num_comms',
            request_args.get('num_comms', self.default_num_comms))

        # capture search parameter, if it exists
        params['search'] = request_args.get('search')

        return params
        
    def upload_plot_observations(self, df, conn):
        """
        takes a parquet file in the plot observation data format from the loader module and uploads it to the plot and observation tables. 
        Parameters:
            file (FileStorage): The uploaded parquet file containing plots and observations.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """
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
        new_pl_required_fields = ['author_plot_code', 'real_latitude', 'real_longitude', 'confidentiality_status', 'latitude', 'longitude', 'user_ob_code', 'vb_pj_code']
        old_pl_required_fields = ['vb_pl_code', 'user_ob_code', 'vb_pj_code']
        new_validation = validate_required_and_missing_fields(new_plots_df, new_pl_required_fields, table_defs, "observations on new plots")
        old_validation = validate_required_and_missing_fields(old_plots_df, old_pl_required_fields, table_defs, "observations on existing plots")

        validation['error'] += new_validation['error'] + old_validation['error']
        validation['has_error'] = new_validation['has_error'] or old_validation['has_error'] or validation['has_error']

        if validation['has_error']:
            raise ValueError(validation['error']) 

        df['user_pl_code'] = df['user_pl_code'].astype(str)
        if not new_plots_df.empty:
            plot_codes = super().upload_to_table("plot", 'pl', table_defs_config.plot, 'plot_id', new_plots_df, True, conn)
            
            pl_codes_df = pd.DataFrame(plot_codes['resources']['pl'])
            pl_codes_df = pl_codes_df[['user_pl_code', 'vb_pl_code']]

            df = df.merge(pl_codes_df, on='user_pl_code', how='left')
            df['vb_pl_code'] = df['vb_pl_code_x'].combine_first(df['vb_pl_code_y'])
            df.drop(columns=['vb_pl_code_y'], inplace=True)

        df['user_ob_code'] = df['user_ob_code'].astype(str)
        observation_codes = super().upload_to_table("observation", 'ob', table_defs_config.observation, 'observation_id', df, True, conn)

        to_return = {
            'resources':{
                'pl': plot_codes['resources']['pl'],
                'ob': observation_codes['resources']['ob']
            },
            'counts':{
                'pl': plot_codes['counts']['pl'],
                'ob': observation_codes['counts']['ob']
            }
        }
        return to_return