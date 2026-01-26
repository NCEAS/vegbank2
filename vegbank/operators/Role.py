import os
from operators import Operator


class Role(Operator):
    """
    Defines operations related to the exchange of party roles with VegBank.

    Role: A role assignable to a party in the context of some
        contribution

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "role"
        self.table_code = "ar"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)

    def configure_query(self, *args, **kwargs):
        base_columns = {'*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'ar_code': "'ar.' || ar.role_id",
            'name': "ar.rolecode",
            'description': "ar.roledescription",
        }
        from_sql = """\
            FROM ar
            """
        order_by_sql = """\
            ORDER BY ar.role_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "ar",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM aux_role AS ar",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': None,
                    'params': []
                },
                "ar": {
                    'sql': "ar.role_id = %s",
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
