import os
from vegbank.operators import Operator


class Stratum(Operator):
    """
    Defines operations related to the exchange of stratum records with VegBank

    Stratum: Information about a stratum (i.e., a designated vertical layer or
        other sub-component of a plot) defined for a given plot observation.
        Taxon importance values and stem counts for observed taxa can be
        measured and recorded separately for each stratum in a plot observation.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "stratum"
        self.table_code = "sr"
        self.queries_package = f"{self.queries_package}.{self.name}"

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        base_columns = {'*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'ob_code': "'ob.' || sr.observation_id",
            'sr_code': "'sr.' || sr.stratum_id",
            'name': "sr.stratumname",
            'height': "sr.stratumheight",
            'base': "sr.stratumbase",
            'cover': "sr.stratumcover",
            'description': "sr.stratumdescription",
            'sm_code': "'sm.' || sr.stratummethod_id",
            'stratum_method_name': "sm.stratummethodname",
            'sy_code': "'sy.' || sr.stratumtype_id",
            'stratum_type_name': "sy.stratumname",
        }
        from_sql = {}
        from_sql['full'] = """\
            FROM sr
            JOIN stratummethod sm USING (stratummethod_id)
            JOIN stratumtype sy USING (stratumtype_id)
            """
        order_by_sql = """\
            ORDER BY sr.stratum_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "sr",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM stratum AS sr",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': None,
                    'params': []
                },
                "sr": {
                    'sql': "sr.stratum_id = %s",
                    'params': ['vb_id']
                },
                'ob': {
                    'sql': "sr.observation_id = %s",
                    'params': ['vb_id']
                },
                'to': {
                    'sql': """\
                        EXISTS (
                            SELECT taxonimportance_id
                             FROM taxonimportance tm
                             JOIN taxonobservation txo USING (taxonobservation_id)
                             WHERE sr.stratum_id = tm.stratum_id
                               AND txo.taxonobservation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'tm': {
                    'sql': """\
                        EXISTS (
                            SELECT taxonimportance_id
                             FROM taxonimportance tm
                             WHERE sr.stratum_id = tm.stratum_id
                               AND tm.taxonimportance_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'bundle': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                             FROM bundle bb
                             WHERE sr.observation_id = bb.observation_id)
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
