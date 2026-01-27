import os
from operators import Operator


class UserDataset(Operator):
    """
    Defines operations related to the exchange of user datasets with VegBank.

    User Dataset: A user-defined collection of plot observations, each of which
        is stored in VegBank.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "user_dataset"
        self.table_code = "ds"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)

    def configure_query(self, *args, **kwargs):
        base_columns = {'*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'ds_code': "'ds.' || ds.userdataset_id",
            'accession_code': "accessioncode",
            'start': "ds.datasetstart",
            'stop': "ds.datasetstop",
            'name': "ds.datasetname",
            'description': "ds.datasetdescription",
            'type': "ds.datasettype",
            'owner_label': "py.party_id_transl",
            'owner_email': "usr.email_address",
            'obs_count':  "(SELECT COUNT(*) FROM userdatasetitem dsi" +
                          " WHERE dsi.userdataset_id = ds.userdataset_id)",
        }
        from_sql = """\
            FROM ds
            LEFT JOIN usr USING (usr_id)
            LEFT JOIN view_party_transl AS py USING (party_id)
            """
        order_by_sql = """\
            ORDER BY ds.userdataset_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "ds",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM userdataset AS ds",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': [
                        "ds.datasetsharing = 'public'",
                        "ds.datasettype IN ('dataset', 'normal')",
                    ],
                    'params': []
                },
                "ds": {
                    'sql': "ds.userdataset_id = %s",
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
