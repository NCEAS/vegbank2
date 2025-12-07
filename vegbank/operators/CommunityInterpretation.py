from operators import Operator


class CommunityInterpretation(Operator):
    """
    Defines operations related to the exchange of community interpretation data
    with VegBank.

    Community Interpretation: The assignment of a specific community name and
        authority to a plot observation, via a community classification. A
        single plot observation and/or community classification record can have
        multiple associated community interpretations.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "community_interpretation"
        self.table_code = "ci"
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
            'ci_code': "'ci.' || ci.comminterpretation_id",
            'cl_code': "'cl.' || ci.commclass_id",
            'cc_code': "'cc.' || ci.commconcept_id",
            'ob_code': "'ob.' || cl.observation_id",
            'author_obs_code': "ob.authorobscode",
            'comm_code': "code.commname",
            'comm_name': "cc.commname",
            'comm_label': "cc.commconcept_id_transl",
            'comm_authority_rf_code': "'rf.' || ci.commauthority_id",
            'comm_authority_name': "rf.reference_id_transl",
            'class_start_date': "cl.classStartDate",
            'class_stop_date': "cl.classStopDate",
            'inspection': "cl.inspection",
            'table_analysis': "cl.tableAnalysis",
            'multivariate_analysis': "cl.multivariateanalysis",
            'expert_system': "cl.expertSystem",
            'class_notes': "cl.classnotes",
            'comm_framework': "cl.commframework",
            'comm_level': "cl.commLevel",
            'class_fit': "ci.classfit",
            'class_confidence': "ci.classConfidence",
            'notes': "ci.notes",
            'type': "ci.type",
            'nomenclatural_type': "ci.nomenclaturaltype",
        }
        # identify full columns with nesting
        main_columns['full_nested'] = main_columns['full'] | {
            'class_contributors': "co.class_contributors",
        }
        # identify minimal columns
        main_columns['minimal'] = {alias:col for alias, col in
            main_columns['full'].items() if alias in [
                'ci_code', 'cl_code', 'cc_code', 'class_fit',
                'class_confidence', 'comm_authority_rf_code',
                'notes', 'type', 'nomenclatural_type'
            ]}
        # identify minimal columns with nesting
        main_columns['minimal_nested'] = main_columns['minimal']
        from_sql = {}
        from_sql['minimal'] = """\
            FROM ci
            """
        from_sql['full'] = from_sql['minimal'].rstrip() + """
            JOIN commclass cl USING (commclass_id)
            JOIN observation ob USING (observation_id)
            JOIN view_commconcept_transl cc USING (commconcept_id)
            LEFT JOIN LATERAL (
              SELECT ccode.commname
                FROM commusage cu
                JOIN commname ccode ON ccode.commname_id = cu.commname_id
               WHERE cu.commconcept_id = cc.commconcept_id
                 AND cu.classsystem = 'Code'
               ORDER BY cu.usagestart DESC NULLS LAST
               LIMIT 1
            ) code ON true
            LEFT JOIN view_reference_transl rf ON rf.reference_id = ci.commauthority_id
            """
        from_sql_nested = """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'py_code', 'py.' || party_id,
                         'party', py.party_id_transl,
                         'role', ar.rolecode)) AS class_contributors
                FROM classcontributor
                LEFT JOIN view_party_transl py USING (party_id)
                LEFT JOIN aux_role ar USING (role_id)
                WHERE commclass_id = ci.commclass_id
            ) co ON true
            """
        from_sql['minimal_nested'] = from_sql['minimal']
        from_sql['full_nested'] = from_sql['full'].rstrip() + from_sql_nested
        order_by_sql = """\
            ORDER BY ci.comminterpretation_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "ci",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM comminterpretation AS ci",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': [
                        "emb_comminterpretation < 6",
                    ],
                    'params': []
                },
                'ci': {
                    'sql': "ci.comminterpretation_id = %s",
                    'params': ['vb_id']
                },
                'cl': {
                    'sql': "ci.commclass_id = %s",
                    'params': ['vb_id']
                },
                'ob': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM commclass cl
                              WHERE ci.commclass_id = cl.commclass_id
                                AND observation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'cc': {
                    'sql': "ci.commconcept_id = %s",
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
