import os
import textwrap
from vegbank.operators.operator_parent_class import Operator


class TaxonImportance(Operator):
    """
    Defines operations related to the exchange of taxon importance data with
    VegBank, including stem details.

    Taxon Importance: Information about the importance (i.e. cover, basal area,
        biomass) of a taxon observation. The importance of a taxon observation
        may be recorded not only for the plot as a whole, but also within one or
        more specified strata.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "taxon_importance"
        self.table_code = "tm"
        self.queries_package = f"{self.queries_package}.{self.name}"
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
            'ob_code': "'ob.' || txo.observation_id",
            'author_obs_code': "ob.authorobscode",
            'to_code': "'to.' || tm.taxonobservation_id",
            'author_plant_name': "txo.authorplantname",
            'sr_code': "'sr.' || tm.stratum_id",
            'stratum_name': f"({textwrap.dedent("""\
                CASE WHEN tm.stratum_id IS NULL THEN '<All>'
                     ELSE COALESCE(sr.stratumname, sy.stratumname) END""")})",
            'tm_code': "'tm.' || tm.taxonimportance_id",
            'cover': "tm.cover",
            'cover_code': "tm.covercode",
            'basal_area': "tm.basalarea",
            'biomass': "tm.biomass",
            'inference_area': "tm.inferencearea",
            'stratum_base': "tm.stratumbase",
            'stratum_height': "tm.stratumheight",
        }
        # identify full columns with nesting
        main_columns['full_nested'] = main_columns['full'] | {
            'stems': "stems",
        }
        # identify minimal columns
        main_columns['minimal'] = {
            name: col for name, col in main_columns['full'].items()
            if name not in ['author_obs_code', 'author_plant_name',
                            'stratum_name']}
        # identify minimal columns with nesting
        main_columns['minimal_nested'] = main_columns['minimal'] | {
            'stems': "stems",
        }

        from_sql = {}
        from_sql['minimal'] = """\
            FROM tm
            JOIN taxonobservation txo USING (taxonobservation_id)
            """
        from_sql['full'] = from_sql['minimal'].rstrip() + """
            LEFT JOIN stratum sr USING (stratum_id)
            LEFT JOIN stratumtype sy USING (stratumtype_id)
            JOIN observation ob ON txo.observation_id = ob.observation_id
            """
        from_sql_nested = """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'sc_code', 'sc.' || stemcount_id,
                         'diameter', stemdiameter,
                         'diameter_accuracy', stemdiameteraccuracy,
                         'height', stemheight,
                         'height_accuracy', stemheightaccuracy,
                         'count', stemcount,
                         'taxon_area', stemtaxonarea
                       )) AS stems
                FROM (
                  SELECT sc.stemcount_id,
                         sc.stemdiameter,
                         sc.stemdiameteraccuracy,
                         sc.stemheight,
                         sc.stemheightaccuracy,
                         sc.stemcount,
                         sc.stemtaxonarea
                    FROM stemcount sc
                    WHERE sc.taxonimportance_id = tm.taxonimportance_id
                    ORDER BY stemcount_id
                )
            ) AS stems ON true
            """
        from_sql['full_nested'] = from_sql['full'].rstrip() + from_sql_nested
        from_sql['minimal_nested'] = from_sql['minimal'].rstrip() + from_sql_nested
        order_by_sql = """\
            ORDER BY tm.taxonimportance_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "tm",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM taxonimportance AS tm",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': [
                        "(emb_taxonimportance < 6 OR emb_taxonimportance IS NULL)",
                    ],
                    'params': []
                },
                "tm": {
                    'sql': "tm.taxonimportance_id = %s",
                    'params': ['vb_id']
                },
                "to": {
                    'sql': "tm.taxonobservation_id = %s",
                    'params': ['vb_id']
                },
                "ob": {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM taxonobservation txo
                              WHERE tm.taxonobservation_id = txo.taxonobservation_id
                                AND observation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'pc': {
                    'sql': """\
                        EXISTS (
                            SELECT plantconcept_id
                              FROM taxoninterpretation txi
                              JOIN taxonobservation txo USING (taxonobservation_id)
                              WHERE tm.taxonobservation_id = txi.taxonobservation_id
                                AND plantconcept_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'bundle': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM bundle bb
                              JOIN taxonobservation txo USING (observation_id)
                              WHERE tm.taxonobservation_id = txo.taxonobservation_id)
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
