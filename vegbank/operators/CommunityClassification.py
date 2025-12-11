import os
from operators import Operator
from utilities import QueryParameterError


class CommunityClassification(Operator):
    """
    Defines operations related to the exchange of community classification data
    with VegBank, potentially including community interpretations and
    classification contributors.

    Community Classification: Information about a classification activity
        leading one or more parties to apply a community concept to a
        plot observation
    Community Interpretation: The assignment of a specific community concept
        to a plot observations
    Classification Contributor: Party who contributed to the classification
        activity, acting in some role

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "community_classification"
        self.table_code = "cl"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.full_get_parameters = ('limit', 'offset')
        self.nested_options = ("true", "false")
        self.detail_options = ("minimal", "full")

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        if self.with_nested == 'true':
            query_type += "_nested"

        base_columns = {'*': "*"}
        main_columns = {}
        # identify full shallow columns
        main_columns['minimal'] = {
            'cl_code': "'cl.' || cl.commclass_id",
            'ob_code': "'ob.' || cl.observation_id",
            'class_start_date': "cl.classstartdate",
            'class_stop_date': "cl.classstopdate",
            'inspection': "cl.inspection",
            'table_analysis': "cl.tableanalysis",
            'multivariate_analysis': "cl.multivariateanalysis",
            'expert_system': "cl.expertsystem",
            'class_publication_rf_code': "'rf.' || cl.classpublication_id",
            'class_publication_rf_label': "rf.reference_id_transl",
            'class_notes': "cl.classnotes",
        }
        # identify minimal shallow colunms
        main_columns['full'] = main_columns['minimal'] | {
            'author_obs_code': "ob.authorobscode",
        }
        # identify full & nested columns with nesting
        nested_columns = {
            'interpretations': "interpretations",
            'contributors': "contributors",
        }
        main_columns['full_nested'] = main_columns['full'] | nested_columns
        main_columns['minimal_nested'] = main_columns['minimal'] | nested_columns
        from_sql = {}
        from_sql['minimal'] = """\
            FROM cl
            LEFT JOIN view_reference_transl rf ON reference_id = cl.classpublication_id
            """
        from_sql['full'] = from_sql['minimal'].rstrip() + """
            JOIN observation ob USING (observation_id)
            """
        from_sql_common_nested =  """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'py_code', 'py.' || party_id,
                         'party', py.party_id_transl,
                         'role', ar.rolecode)) AS contributors
                FROM classcontributor co
                LEFT JOIN view_party_transl py USING (party_id)
                LEFT JOIN aux_role ar USING (role_id)
                WHERE co.commclass_id = cl.commclass_id
            ) co ON true
            """.rstrip()
        from_sql['full_nested'] = from_sql['full'].rstrip() + \
            from_sql_common_nested.rstrip() + """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'ci_code', 'ci.' || ci.comminterpretation_id,
                         'cc_code', 'cc.' || ci.commconcept_id,
                         'comm_code', code.commname,
                         'comm_name', cc.commname,
                         'comm_label', cc.commconcept_id_transl,
                         'class_fit', classfit,
                         'class_confidence', classconfidence,
                         'comm_authority_rf_code', 'rf.' || ci.commauthority_id,
                         'comm_authority_name', rf.reference_id_transl,
                         'notes', notes,
                         'type', type,
                         'nomenclatural_type', nomenclaturaltype
                       )) AS interpretations
                FROM comminterpretation ci
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
                WHERE ci.commclass_id = cl.commclass_id
            ) AS ci ON true
            """
        from_sql['minimal_nested'] = from_sql['minimal'].rstrip() + \
            from_sql_common_nested.rstrip() + """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'ci_code', 'ci.' || ci.comminterpretation_id,
                         'cc_code', 'cc.' || ci.commconcept_id,
                         'comm_code', code.commname,
                         'comm_name', cc.commname
                       )) AS interpretations
                FROM comminterpretation ci
                JOIN commconcept cc USING (commconcept_id)
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
                WHERE ci.commclass_id = cl.commclass_id
            ) AS ci ON true
            """
        order_by_sql = """\
            ORDER BY cl.commclass_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "cl",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM commclass AS cl",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': [
                        "emb_commclass < 6",
                    ],
                    'params': []
                },
                "cl": {
                    'sql': "cl.commclass_id = %s",
                    'params': ['vb_id']
                },
                'ob': {
                    'sql': "cl.observation_id = %s",
                    'params': ['vb_id']
                },
                'cc': {
                    'sql': """\
                        EXISTS (
                            SELECT commconcept_id
                              FROM comminterpretation ci
                              WHERE cl.commclass_id = ci.commclass_id
                                AND commconcept_id = %s)
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
