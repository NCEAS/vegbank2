import os
from operators import Operator
from utilities import QueryParameterError


class PlantConcept(Operator):
    """
    Defines operations related to the exchange of plant concept data with
    VegBank, including usage and status (party perspective) information.

    Plant Concept: A named plant taxon according to a reference.
    Plant Status: The asserted status of a concept, according to a party
        (a.k.a., a party perspective).
    Plant Usages: Particular names associated with a plant concept, including
        their naming system, status, and effective dates.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "plant_concept"
        self.table_code = "pc"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.full_get_parameters = ('limit', 'offset')

    def configure_query(self, *args, **kwargs):
        base_columns = {'*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'pc_code': "'pc.' || pc.plantconcept_id",
            'plant_name': "pc.plantname",
            'plant_code': "pn.plant_code",
            'plant_description': "pc.plantdescription",
            'concept_rf_code': "'rf.' || pc.reference_id",
            'concept_rf_name': "rf_pc.shortname",
            'status_rf_code': "'rf.' || ps.reference_id",
            'status_rf_name': "rf_ps.shortname",
            'usages': "pn.usages",
            'obs_count': "pc.d_obscount",
            'plant_level': "ps.plantlevel",
            'status': "ps.plantconceptstatus",
            'start_date': "ps.startdate",
            'stop_date': "ps.stopdate",
            'current_accepted': ("(ps.stopdate IS NULL OR now() < ps.stopdate)"
                                 " AND LOWER(ps.plantconceptstatus) = 'accepted'"),
            'py_code': "'py.' || py.party_id",
            'party': "COALESCE(py.surname, py.organizationname)",
            'plant_party_comments': "ps.plantpartycomments",
            'parent_pc_code': "'pc.' || ps.plantparent_id",
            'parent_name': "pa.plantname",
            'children': "children",
            'correlations': "px_group.correlations",
        }
        from_sql = """\
            FROM pc
            LEFT JOIN LATERAL (
              SELECT *
                FROM plantstatus
                WHERE plantconcept_id = pc.plantconcept_id
                ORDER BY startdate DESC
                LIMIT 1
            ) ps ON true
            LEFT JOIN plantconcept pa ON (pa.plantconcept_id = ps.plantparent_id)
            LEFT JOIN reference rf_pc ON pc.reference_id = rf_pc.reference_id
            LEFT JOIN reference rf_ps ON ps.reference_id = rf_ps.reference_id
            LEFT JOIN party py ON py.party_id = ps.party_id
            LEFT JOIN LATERAL (
              SELECT JSON_OBJECT_AGG(classsystem,
                                     RTRIM(plantname)) ->> 'Code' AS plant_code,
                     JSON_AGG(JSON_BUILD_OBJECT(
                         'class_system', classsystem,
                         'plant_name', RTRIM(plantname),
                         'status', plantnamestatus)) AS usages
                FROM plantusage
                WHERE plantconcept_id = pc.plantconcept_id
            ) pn ON true
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'pc_code', 'pc.' || ch_pc.plantconcept_id,
                         'plant_name', ch_pc.plantname
                       )) AS children
               FROM plantstatus ch_st
               JOIN plantconcept ch_pc USING (plantconcept_id)
               WHERE ch_st.plantparent_id = pc.plantconcept_id
            ) children ON true
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'pc_code', 'pc.' || plantconcept_id,
                         'plant_name', plantname,
                         'convergence', plantconvergence
                      )) AS correlations
                FROM plantcorrelation pcorr
                JOIN plantconcept USING (plantconcept_id)
                WHERE pcorr.plantstatus_id = ps.plantstatus_id
                  AND pcorr.correlationstop IS NULL
            ) px_group ON true
            """
        order_by_sql = """\
            ORDER BY pc.plantname,
                     pc.plantconcept_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "pc",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM plantconcept AS pc",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': None,
                    'params': []
                },
                "pc": {
                    'sql': """\
                        pc.plantconcept_id = %s
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
                'columns': main_columns[self.detail],
                'params': []
            },
        }
        self.query['from'] = {
            'sql': from_sql,
            'params': []
        }

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        This only applies validations specific to plant concepts, then
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
        # specifically require detail to be "full" for plant concepts
        if request_args.get("detail", self.default_detail) not in ("full"):
            raise QueryParameterError("When provided, 'detail' must be 'full'.")

        # now dispatch to the base validation method
        return super().validate_query_params(request_args)
