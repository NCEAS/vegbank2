from operators import Operator


class TaxonInterpretation(Operator):
    """
    Defines operations related to the exchange of taxon interpretation data with
    VegBank.

    Taxon Interpretation: The asserted association of a taxon observation with
        a specific plant name and authority. A single taxon observation can have
        multiple taxon interpretations.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "taxon_interpretation"
        self.table_code = "ti"
        self.detail_options = ("minimal", "full")

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        base_columns = {'txi.*': "*"}
        main_columns = {}
        # identify full columns
        main_columns['full'] = {
            'ti_code': "'ti.' || txi.taxoninterpretation_id",
            'to_code': "'to.' || txi.taxonobservation_id",
            'pc_code': "'pc.' || txi.plantconcept_id",
            'ob_code': "'ob.' || txo.observation_id",
            'author_obs_code': "ob.authorobscode",
            'author_plant_name': "txo.authorplantname",
            'plant_code': "code.plantname",
            'plant_name': "pc.plantname",
            'plant_label': "pc.plantconcept_id_transl",
            'py_code': "'py.' || txi.party_id",
            'party_label': "py.party_id_transl",
            'role': "ar.rolecode",
            'rf_code': "txi.reference_id",
            'rf_label': "rf.reference_id_transl",
            'interpretation_date': "txi.interpretationdate",
            'interpretation_type': "txi.interpretationtype",
            'taxon_fit': "txi.taxonfit",
            'taxon_confidence': "txi.taxonconfidence",
            'collection_number': "txi.collectionnumber",
            'group_type': "txi.grouptype",
            'notes': "txi.notes",
            'notes_public': "txi.notespublic",
            'notes_mgt': "txi.notesmgt",
            'revisions': "txi.revisions",
            'is_orig': "txi.originalinterpretation",
            'is_curr': "txi.currentinterpretation",
        }
        # identify minimal columns
        main_columns['minimal'] = {alias:col for alias, col in
            main_columns['full'].items() if alias in [
                'ti_code', 'to_code', 'pc_code', 'interpretation_date',
                'interpretation_type', 'py_code', 'rf_code', 'taxon_fit',
                'taxon_confidence', 'collection_number', 'group_type', 'notes',
                'notes_public', 'notes_mgt', 'is_orig', 'is_curr'
            ]}
        from_sql = {}
        from_sql['minimal'] = """\
            FROM txi
            """
        from_sql['full'] = from_sql['minimal'].rstrip() + """
            JOIN taxonobservation txo USING (taxonobservation_id)
            JOIN observation ob USING (observation_id)
            JOIN view_plantconcept_transl pc USING (plantconcept_id)
            LEFT JOIN LATERAL (
              SELECT pcode.plantname
                FROM plantusage pu
                JOIN plantname pcode ON pcode.plantname_id = pu.plantname_id
               WHERE pu.plantconcept_id = pc.plantconcept_id
                 AND pu.classsystem = 'Code'
               ORDER BY pu.usagestart DESC NULLS LAST
               LIMIT 1
            ) code ON true
            LEFT JOIN view_reference_transl rf ON rf.reference_id = txi.reference_id
            LEFT JOIN view_party_transl py USING (party_id)
            LEFT JOIN aux_role ar USING (role_id)
            """
        order_by_sql = """\
            ORDER BY txi.taxoninterpretation_id ASC
            """

        self.query = {}
        self.query['base'] = {
            'alias': "txi",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM taxoninterpretation AS txi",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': [
                        "(emb_taxoninterpretation < 6 OR emb_taxoninterpretation IS NULL)",
                    ],
                    'params': []
                },
                'ti': {
                    'sql': "txi.taxoninterpretation_id = %s",
                    'params': ['vb_id']
                },
                'to': {
                    'sql': "txi.taxonobservation_id = %s",
                    'params': ['vb_id']
                },
                'ob': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM taxonobservation txo
                              WHERE txi.taxonobservation_id = txo.taxonobservation_id
                                AND observation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'pc': {
                    'sql': "txi.plantconcept_id = %s",
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
