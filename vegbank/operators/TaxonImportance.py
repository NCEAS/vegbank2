import os
from operators import Operator


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
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.nested_options = ("true", "false")

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        if self.with_nested == 'true':
            query_type += "_nested"

        base_columns = {'*': "*"}
        main_columns = {}
        # identify full shallow columns
        main_columns['full'] = {
            'tm_code': "'tm.' || tm.taxonimportance_id",
            'to_code': "'to.' || tm.taxonobservation_id",
            'ob_code': "'ob.' || txo.observation_id",
            'sr_code': "'sr.' || tm.stratum_id",
            'stratum_name': "COALESCE(sr.stratumname, '<All>')",
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
        from_sql = {}
        from_sql['full'] = """\
            FROM tm
            JOIN taxonobservation txo USING (taxonobservation_id)
            LEFT JOIN stratum sr USING (stratum_id)
            """
        from_sql['full_nested'] = from_sql['full'].rstrip() + """
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
