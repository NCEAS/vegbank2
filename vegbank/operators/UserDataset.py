import os
from datetime import datetime
import pandas as pd
from vegbank.operators.operator_parent_class import Operator 
from vegbank.operators import table_defs_config as table_defs
from utilities import validate_required_and_missing_fields, merge_vb_codes


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
        self.queries_package = f"{self.queries_package}.{self.name}"

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
    test_dataset = {
            'user_ds_code': 'test_ds_001',
            'name': 'Test Dataset 001',
            'description': 'A test dataset containing 10 observations.',
            'type': 'upload',
            'data': {
                'observation':[
                    'ob.2948',
                    'ob.2949',
                    'ob.2950',
                    'ob.2951',
                    'ob.2952',
                    'ob.2953',
                    'ob.2954',
                    'ob.2955',
                    'ob.2956',
                    'ob.2957'
                ]
            }
        }
    def upload_user_dataset(self, dataset, conn, validate=False):
        user_dataset_insert_sql = """
            INSERT INTO userdataset (datasetname, datasetdescription, datasettype, datasetstart)
            VALUES (%s, %s, %s, %s)
            RETURNING userdataset_id"""
        dataset_insert_data = (
            dataset['name'],
            dataset.get('description', ''),
            dataset['type'],
            datetime.now()
            #TODO This will eventually need to be the user id of the person uploading the dataset. Once we have the auth token we can fill this in. 
        )
        with conn.cursor() as cur: 
            cur.execute(user_dataset_insert_sql, dataset_insert_data)
            user_dataset_id = cur.fetchone()['userdataset_id']

            data_tuples = []
            for item_table, codes in dataset['data'].items():
                for code in codes:
                    item_record = code[3:]
                    item_database = 'vegbank'
                    data_tuples.append((code, item_database, item_table, item_record))
            items_df = pd.DataFrame(data_tuples, columns=['identifier', 'item_database', 'item_table', 'item_record'])
            items_df['user_di_code'] = items_df.index + 1
            items_df['userdataset_id'] = user_dataset_id
            items_df['user_di_code'] = items_df['user_di_code'].astype(str)
            new_dataset_items = super().upload_to_table("user_dataset_item", 'di', table_defs.user_dataset_item, 'userdatasetitem_id', items_df, False, conn, validate)

            to_return = {
                'userdataset_id': user_dataset_id,
                'dataset_items': new_dataset_items
            }
        return to_return
