import os
from vegbank.operators import Operator


class NamedPlace(Operator):
    """
    Defines operations related to the exchange of named places with VegBank.

    Named Place: A named place (geographic region, managed unit, etc) in which a
        plot may be located.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "named_place"
        self.table_code = "np"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)

    def configure_query(self, *args, **kwargs):
        base_columns = {'*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'np_code': "'np.' || np.namedplace_id",
            'system': "np.placesystem",
            'name': "np.placename",
            'description': "np.placedescription",
            'code': "np.placecode",
            'owner': "np.owner",
            'rf_label': "rf.reference_id_transl",
            'obs_count': "np.d_obscount",
        }
        from_sql = """\
            FROM np
            LEFT JOIN view_reference_transl AS rf USING (reference_id)
            """
        order_by_sql = """\
            ORDER BY np.namedplace_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "np",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM namedplace AS np",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': None,
                    'params': []
                },
                "np": {
                    'sql': "np.namedplace_id = %s",
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
