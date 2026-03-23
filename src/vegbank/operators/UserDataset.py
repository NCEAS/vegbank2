import logging
import os
from datetime import datetime
import pandas as pd
from psycopg import connect
from psycopg.rows import dict_row
from vegbank.auth import extract_orcid
from vegbank.ezid import EZIDClient, EZIDError
from vegbank.operators.operator_parent_class import Operator
from vegbank.operators import table_defs_config as table_defs
from vegbank.utilities import load_sql, jsonify_error_message, validate_dataset_json, dry_run_check

logger = logging.getLogger(__name__)


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


    def upload_user_dataset(self, dataset, conn, validate=False, claims=None, doi=None):
        '''
        Uploads a user dataset to VegBank. If a user is submitting it via the
        endpoint, we use validate=True because users are only allowed to submit
        datasets containing only observation codes. Otherwise, the request is
        coming from one of the bulk endpoints, and all those foreign keys are
        new so they must be valid and don't need to be checked.

        If dataset sharing is not specified in the dataset payload, it is set to
        'private'.

        dataset should be a dict with the following keys:
        - name: str
        - description: str (optional)
        - type: str (e.g. 'dataset', 'normal')
        - data: dict where keys are item tables (e.g. 'observation') and
            values are lists of vb_codes (e.g. ['ob.123', 'ob.456']
        - doi: str (optional) - pre-minted reserved DOI to store as accessioncode
        '''
        user_dataset_insert_sql = """
            INSERT INTO userdataset (
                datasettype,
                datasetsharing,
                datasetname,
                datasetdescription,
                datasetstart,
                accessioncode,
                usr_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            RETURNING userdataset_id"""

        with conn.cursor() as cur:
            usr_id = self._upsert_party_and_get_usr_id(cur, claims)

            dataset_insert_data = (
                dataset['type'],
                dataset.get('sharing', 'private'),
                dataset['name'],
                dataset.get('description', ''),
                datetime.now(),
                doi,
                usr_id,
            )
            cur.execute(user_dataset_insert_sql, dataset_insert_data)
            user_dataset_id = cur.fetchone()['userdataset_id']

            new_codes_df = pd.DataFrame()
            new_codes_df['vb_record_id'] = [user_dataset_id]
            new_codes_df['vb_table_code'] = 'ds'
            new_codes_df['identifier_type'] = 'vb_code'
            new_codes_df['identifier_value'] = 'ds.' + \
                new_codes_df['vb_record_id'].astype(str)
            code_inputs = list(new_codes_df.itertuples(index=False, name=None))
            sql = load_sql(self.queries_root, 'create_codes.sql')
            cur.executemany(sql, code_inputs, returning=True)

            # Store the DOI in the identifiers table
            if doi:
                cur.execute("""
                    INSERT INTO identifiers
                        (vb_table_code, vb_record_id, identifier_type, identifier_value)
                    VALUES ('ds', %s, 'DOI', %s)
                """, (user_dataset_id, doi))

            data_tuples = []
            for item_table, codes in dataset['data'].items():
                for code in codes:
                    item_record = code[3:]
                    item_database = 'vegbank'
                    data_tuples.append(
                        (code, item_database, item_table, item_record))
            items_df = pd.DataFrame(data_tuples, columns=[
                                    'identifier', 'item_database',
                                    'item_table', 'item_record'])
            items_df['user_di_code'] = items_df.index + 1
            items_df['userdataset_id'] = user_dataset_id
            items_df['user_di_code'] = items_df['user_di_code'].astype(str)
            new_dataset_items = super().upload_to_table("user_dataset_item", 'di',
                                                        table_defs.user_dataset_item,
                                                        'userdatasetitem_id',
                                                        items_df, False, conn,
                                                        validate)

            to_return = {
                'counts': {
                    'di': {
                        "inserted" : len(new_dataset_items['resources']['di'])
                    },
                    'ds': {
                        "inserted" : 1
                    }
                },
                'resources': {
                    'ds': [
                        {
                            'action': 'inserted',
                            'user_ds_code': dataset['name'],
                            'vb_ds_code': 'ds.' + str(user_dataset_id),
                            'doi': doi,
                        }
                    ],
                    'di': new_dataset_items['resources']['di']
                }
            }
        return to_return


    def _upsert_party_and_get_usr_id(self, cur, claims) -> int | None:
        """Handle party upsert and usr_id lookup from JWT claims.

        Returns None if no ORCID is present in the claims or if no usr record
        is linked to the party yet.
        """
        orcid = extract_orcid(claims)
        if not orcid:
            return None

        given_name, family_name = self._parse_name_from_claims(claims)
        email = claims.get("email")

        party_id = self._upsert_party(cur, orcid, given_name, family_name, email)
        self._store_orcid_identifier(cur, party_id, orcid)
        return self._get_usr_id_for_party(cur, party_id, orcid)


    @staticmethod
    def _parse_name_from_claims(claims) -> tuple[str, str]:
        """Return (given_name, family_name) from JWT claims.

        Prefers the dedicated given_name/family_name claims; falls back to
        splitting the full 'name' claim when those are absent.
        """
        given = claims.get("given_name") or ""
        family = claims.get("family_name") or ""
        if not given and not family:
            parts = claims.get("name", "").split(maxsplit=1)
            given = parts[0] if parts else ""
            family = parts[1] if len(parts) > 1 else ""
        return given, family


    @staticmethod
    def _upsert_party(
        cur,
        orcid: str,
        given_name: str,
        family_name: str,
        email: str | None,
    ) -> int:
        """Insert or update the party record keyed on ORCID accessioncode.

        Uses SELECT-then-INSERT/UPDATE because party.accessioncode does not have 
        uniqueness.

        Returns the party_id of the upserted record.
        """
        cur.execute(
            "SELECT party_id FROM party WHERE accessioncode = %s LIMIT 1",
            (orcid,),
        )
        existing = cur.fetchone()

        if existing:
            party_id = existing["party_id"]
            cur.execute(
                """UPDATE party
                   SET givenname = %s, surname = %s, email = %s
                   WHERE party_id = %s""",
                (given_name, family_name, email, party_id),
            )
            return party_id

        cur.execute(
            """INSERT INTO party (givenname, surname, email, accessioncode, partytype)
               VALUES (%s, %s, %s, %s, 'person')
               RETURNING party_id""",
            (given_name, family_name, email, orcid),
        )
        return cur.fetchone()["party_id"]


    @staticmethod
    def _store_orcid_identifier(cur, party_id: int, orcid: str) -> None:
        """Record the ORCID in the identifiers table for this party (idempotent)."""
        cur.execute(
            """INSERT INTO identifiers
                   (vb_table_code, vb_record_id, identifier_type, identifier_value)
               VALUES ('py', %s, 'ORCID', %s)
               ON CONFLICT (identifier_type, identifier_value) DO NOTHING""",
            (party_id, orcid),
        )


    @staticmethod
    def _get_usr_id_for_party(cur, party_id: int, orcid: str) -> int | None:
        """Return the usr_id linked to party_id, or None if no record exists yet.

        A missing usr record is expected when the OIDC login flow has not yet
        created the usr row for this user; the dataset is created without a usr
        link and can be backfilled once the usr record exists.
        """
        cur.execute(
            "SELECT usr_id FROM usr WHERE party_id = %s LIMIT 1",
            (party_id,),
        )
        row = cur.fetchone()
        if row is None:
            logger.warning(
                "No usr record found for party_id=%s (ORCID: %s); "
                "dataset will be created without a usr link.",
                party_id, orcid,
            )
            return None
        return row["usr_id"]


    def upload_user_dataset_from_endpoint(self, request, claims=None):
        '''
        Handler for uploading a user dataset from the endpoint. To facilitate
        testing, the conneciton needs to be opened here instead of from vegbankapi.py
        Parameters:
            - dataset: dict with the same structure as the dataset parameter for upload_user_dataset
            - conn: a connection to the VegBank database
            - validate: boolean indicating whether to validate the dataset before uploading
            - claims: decoded JWT claims dict, or None in unauthenticated modes
        Returns:
            - dict with counts of inserted records and their codes
        '''
        if not request.is_json:
            return jsonify_error_message("Request body must be JSON."), 400

        dataset = request.get_json()
        dataset['type'] = 'normal'
        dataset['sharing'] = 'public'
        validate_dataset_json(dataset)

        is_dry_run = request.args.get('dry_run', 'false').lower() == 'true'

        doi = None
        ezid = None
        if not is_dry_run:
            try:
                ezid = EZIDClient()
                doi = ezid.mint_reserved()
            except (EZIDError, KeyError) as exc:
                logger.warning(
                    "DOI mint failed; dataset will be created without a DOI: %s", exc
                )

        to_return = None
        with connect(**self.params, row_factory=dict_row) as conn:
            to_return = self.upload_user_dataset(dataset, conn, validate=True, claims=claims, doi=doi)
            to_return = dry_run_check(conn, to_return, request)
        conn.close()
        return to_return
