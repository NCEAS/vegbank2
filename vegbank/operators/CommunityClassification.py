import os
from operators import Operator
from utilities import QueryParameterError


class CommunityClassification(Operator):
    """
    Defines operations related to the exchange of community classification data
    with VegBank, including community interpretations.

    Community Classification: Information about a classification activity
        leading one or more parties to apply a community concept to a
        plot observation
    Community Interpretation: The assignment of a specific community concept
        to a plot observations

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "community_classification"
        self.table_code = "cl"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.full_get_parameters = ('limit', 'offset')

    def configure_query(self, *args, **kwargs):
        base_columns = {'cl.*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'cl_code': "'cl.' || cl.commclass_id",
            'ob_code': "'ob.' || cl.observation_id",
            'class_start_date': "cl.classstartdate",
            'class_stop_date': "cl.classstopdate",
            'inspection': "cl.inspection",
            'table_analysis': "cl.tableanalysis",
            'multivariate_analysis': "cl.multivariateanalysis",
            'expert_system': "cl.expertsystem",
            'class_notes': "cl.classnotes",
            'cc_code': "'cc.' || cc.commconcept_id",
            'comm_name': "cc.commname",
            'comm_code': "cl.commcode",
            'comm_framework': "cl.commframework",
            'comm_level': "cl.commlevel",
            'emb_comm_class': "cl.emb_commclass",
            'cc_code': "'cc.' || ci.commconcept_id",
            'class_fit': "ci.classfit",
            'class_confidence': "ci.classconfidence",
            'comm_authority_rf_code': "'rf.' || ci.commauthority_id",
            'interpretation_notes': "ci.notes",
            'interpretation_type': "ci.type",
            'interpretation_nomenclatural_type': "ci.nomenclaturaltype",
            'emb_comm_interpretation': "ci.emb_comminterpretation",
        }
        main_columns['minimal'] = {
            'cl_code': "'cl.' || cl.commclass_id",
            'ob_code': "'ob.' || cl.observation_id",
            'cc_code': "'cc.' || cc.commconcept_id",
            'comm_name': "cc.commname",
        }
        from_sql = """\
            FROM cl
            LEFT JOIN comminterpretation ci USING (commclass_id)
            LEFT JOIN commconcept cc USING (commconcept_id)
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
                'sql': """\
                    FROM commclass AS cl
                    LEFT JOIN comminterpretation ci USING (commclass_id)
                    """,
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': None,
                    'params': []
                },
                "cl": {
                    'sql': "cl.commclass_id = %s",
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
