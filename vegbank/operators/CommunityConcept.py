import os
from operators import Operator
from utilities import QueryParameterError


class CommunityConcept(Operator):
    """
    Defines operations related to the exchange of community concept data with
    VegBank, including usage and status (party perspective) information.

    Community Concept: A named community type according to a reference.
    Community Status: The asserted status of a concept, according to a party
        (a.k.a., a party perspective).
    Community Usages: Particular names associated with a community concept,
        including their naming system, status, and effective dates.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "community_concept"
        self.table_code = "cc"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.full_get_parameters = ('limit', 'offset')

    def configure_query(self, *args, **kwargs):
        base_columns = {'*': "*"}
        base_columns_search = {
            'search_rank': "TS_RANK(cc.search_vector, " +
                           "WEBSEARCH_TO_TSQUERY('simple', %s))"
        }
        main_columns = {}
        main_columns['full'] = {
            'cc_code': "'cc.' || cc.commconcept_id",
            'comm_name': "cc.commname",
            'comm_code': "cn.comm_code",
            'comm_description': "cc.commdescription",
            'concept_rf_code': "'rf.' || cc.reference_id",
            'concept_rf_name': "rf_cc.shortname",
            'status_rf_code': "'rf.' || cs.reference_id",
            'status_rf_name': "rf_cs.shortname",
            'usages': "cn.usages",
            'obs_count': "cc.d_obscount",
            'comm_level': "cs.commlevel",
            'status': "cs.commconceptstatus",
            'start_date': "cs.startdate",
            'stop_date': "cs.stopdate",
            'current_accepted': ("(cs.stopdate IS NULL OR now() < cs.stopdate)"
                                 " AND LOWER(cs.commconceptstatus) = 'accepted'"),
            'py_code': "'py.' || py.party_id",
            'party': "COALESCE(py.surname, py.organizationname)",
            'comm_party_comments': "cs.commpartycomments",
            'parent_cc_code': "'cc.' || cs.commparent_id",
            'parent_name': "pa.commname",
            'children': "children",
            'correlations': "px_group.correlations",
        }
        from_sql = """\
            FROM cc
            LEFT JOIN LATERAL (
              SELECT JSON_OBJECT_AGG(classsystem,
                                     RTRIM(commname)) ->> 'Code' AS comm_code,
                     JSON_AGG(JSON_BUILD_OBJECT(
                         'class_system', classsystem,
                         'comm_name', RTRIM(commname),
                         'status', commnamestatus)) AS usages
                FROM commusage
                WHERE commconcept_id = cc.commconcept_id
            ) cn ON true
            LEFT JOIN LATERAL (
              SELECT *
                FROM commstatus
                WHERE commconcept_id = cc.commconcept_id
                ORDER BY startdate DESC
                LIMIT 1
            ) cs ON true
            LEFT JOIN commconcept pa ON (pa.commconcept_id = cs.commparent_id)
            LEFT JOIN reference rf_cc ON cc.reference_id = rf_cc.reference_id
            LEFT JOIN reference rf_cs ON cs.reference_id = rf_cs.reference_id
            LEFT JOIN party py ON py.party_id = cs.party_id
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'cc_code', 'cc.' || ch_cc.commconcept_id,
                         'comm_name', ch_cc.commname
                       )) AS children
               FROM commstatus ch_st
               JOIN commconcept ch_cc USING (commconcept_id)
               WHERE ch_st.commparent_id = cc.commconcept_id
            ) children ON true
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'cc_code', 'cc.' || commconcept_id,
                         'comm_name', commname,
                         'convergence', commconvergence
                      )) AS correlations
                FROM commcorrelation ccorr
                JOIN commconcept USING (commconcept_id)
                WHERE ccorr.commstatus_id = cs.commstatus_id
                  AND ccorr.correlationstop IS NULL
            ) px_group ON true
            """
        order_by_sql = """\
            ORDER BY cc.commname,
                     cc.commconcept_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "cc",
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
                'sql': "  FROM commconcept AS cc",
                'params': []
            },
            'conditions': {
                "always": {
                    'sql': None,
                    'params': []
                },
                'search': {
                    'sql': """\
                         cc.search_vector @@ WEBSEARCH_TO_TSQUERY('simple', %s)
                    """,
                    'params': ['search']
                },
                "cc": {
                    'sql': "cc.commconcept_id = %s",
                    'params': ['vb_id']
                },
                'ob': {
                    'sql': """\
                        EXISTS (
                            SELECT commconcept_id
                              FROM comminterpretation ci
                              JOIN commclass cl USING (commclass_id)
                              JOIN observation ob USING (observation_id)
                              WHERE cc.commconcept_id = ci.commconcept_id
                                AND observation_id = %s)
                        """,
                    'params': ['vb_id']
                }
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
            'search': {
                'columns': {'search_rank': 'cc.search_rank'},
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

        This only applies validations specific to community concepts, then
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
        # specifically require detail to be "full" for community concepts
        if request_args.get("detail", self.default_detail) not in ("full"):
            raise QueryParameterError("When provided, 'detail' must be 'full'.")

        # now dispatch to the base validation method
        params = super().validate_query_params(request_args)

        # capture search parameter, if it exists
        params['search'] = request_args.get('search')

        return params
