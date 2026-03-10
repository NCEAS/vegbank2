import os
import textwrap
from vegbank.operators import Operator


class StemCount(Operator):
    """
    Defines operations related to the exchange of stem count data with VegBank.

    StemCounts: Information about the abundance of tree stems of a specific
        size, associated with a specific plant taxon (optionally within a
        specific stratum) observed in the context of a specific plot observation

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "stem_count"
        self.table_code = "sc"
        self.queries_package = f"{self.queries_package}.{self.name}"

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        base_columns = {'*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'ob_code': "'ob.' || txo.observation_id",
            'to_code': "'to.' || tm.taxonobservation_id",
            'tm_code': "'tm.' || sc.taxonimportance_id",
            'sr_code': "'sr.' || tm.stratum_id",
            'stratum_name': f"({textwrap.dedent("""\
                CASE WHEN tm.stratum_id IS NULL THEN '<All>'
                     ELSE COALESCE(sr.stratumname, sy.stratumname) END""")})",
            'sc_code': "'sc.' || sc.stemcount_id",
            'diameter': "sc.stemdiameter",
            'diameter_accuracy': "sc.stemdiameteraccuracy",
            'height': "sc.stemheight",
            'height_accuracy': "sc.stemheightaccuracy",
            'count': "sc.stemcount",
            'taxon_area': "sc.stemtaxonarea"
        }
        from_sql = {}
        from_sql['full'] = """\
            FROM sc
            JOIN taxonimportance tm USING (taxonimportance_id)
            JOIN taxonobservation txo USING (taxonobservation_id)
            LEFT JOIN stratum sr USING (stratum_id)
            LEFT JOIN stratumtype sy USING (stratumtype_id)
            """
        order_by_sql = """\
            ORDER BY sc.stemcount_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "sc",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM stemcount AS sc",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': None,
                    'params': []
                },
                "sc": {
                    'sql': "sc.stemcount_id = %s",
                    'params': ['vb_id']
                },
                'tm': {
                    'sql': "sc.taxonimportance_id = %s",
                    'params': ['vb_id']
                },
                'to': {
                    'sql': """\
                        EXISTS (
                            SELECT taxonobservation_id
                              FROM taxonimportance tm
                              WHERE sc.taxonimportance_id = tm.taxonimportance_id
                                AND taxonobservation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                "ob": {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM taxonobservation txo
                              JOIN taxonimportance tm USING (taxonobservation_id)
                              WHERE sc.taxonimportance_id = tm.taxonimportance_id
                                AND observation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'bundle': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM bundle bb
                              JOIN taxonobservation txo USING (observation_id)
                              JOIN taxonimportance tm USING (taxonobservation_id)
                              WHERE sc.taxonimportance_id = tm.taxonimportance_id)
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
