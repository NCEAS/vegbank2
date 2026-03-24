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
        """Upload a user dataset to VegBank.

        When ``validate=True`` (endpoint submissions), item codes are verified
        to be existing VegBank observation codes. Bulk-endpoint calls set
        ``validate=False`` because all foreign keys are guaranteed valid by the
        caller. Dataset sharing defaults to ``'private'`` when not specified.

        Args:
            dataset: Dict describing the dataset, with keys:
                - ``name`` (str): Dataset name.
                - ``description`` (str, optional): Human-readable description.
                - ``type`` (str): Dataset type (e.g. ``'dataset'``, ``'normal'``).
                - ``sharing`` (str, optional): Sharing level; defaults to ``'private'``.
                - ``data`` (dict): Mapping of item table names to lists of VegBank codes
                  (e.g. ``{'observation': ['ob.1', 'ob.2']}``).
            conn: Active psycopg database connection.
            validate: If ``True``, validate item codes before inserting.
            claims: Decoded JWT claims dict, or ``None`` for unauthenticated uploads.
            doi: Pre-minted reserved DOI to store as the dataset accession code.

        Returns:
            Dict with keys ``counts`` and ``resources`` describing inserted records
            and their generated VegBank codes.
        """
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
        """Handle party upsert and usr_id lookup/creation from JWT claims.

        Returns ``None`` if no ORCID is present in the claims.
        Always returns a valid usr_id when an ORCID is available, creating a
        usr record on the fly if one does not yet exist.

        Args:
            cur: Active psycopg cursor.
            claims: Decoded JWT claims dict, or ``None``.

        Returns:
            The ``usr_id`` for the authenticated user, or ``None`` if the
            claims contain no ORCID.
        """
        orcid = extract_orcid(claims)
        if not orcid:
            return None

        given_name, family_name = self._parse_name_from_claims(claims)
        email = claims.get("email") or ""

        party_id = self._upsert_party(cur, orcid, given_name, family_name, email)
        self._store_orcid_identifier(cur, party_id, orcid)
        return self._get_or_create_usr(cur, party_id, email, claims)


    @staticmethod
    def _parse_name_from_claims(claims) -> tuple[str, str]:
        """Return ``(given_name, family_name)`` parsed from JWT claims.

        Prefers the dedicated ``given_name`` / ``family_name`` claims; falls
        back to splitting the full ``name`` claim when those are absent.

        Args:
            claims: Decoded JWT claims dict.

        Returns:
            Two-tuple of ``(given_name, family_name)``, both empty strings if
            no name information is available.
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

        Uses SELECT-then-INSERT/UPDATE because ``party.accessioncode`` does not
        have a uniqueness constraint.

        Args:
            cur: Active psycopg cursor.
            orcid: Canonical ORCID URI (e.g. ``"https://orcid.org/0000-0002-1825-0097"``).
            given_name: User's given name.
            family_name: User's family name.
            email: User's email address, or ``None``.

        Returns:
            The ``party_id`` of the upserted party record.
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
        """Record the ORCID in the identifiers table for this party (idempotent).

        Args:
            cur: Active psycopg cursor.
            party_id: Primary key of the party record.
            orcid: Canonical ORCID URI to store.
        """
        cur.execute(
            """INSERT INTO identifiers
                   (vb_table_code, vb_record_id, identifier_type, identifier_value)
               VALUES ('py', %s, 'ORCID', %s)
               ON CONFLICT (identifier_type, identifier_value) DO NOTHING""",
            (party_id, orcid),
        )


    @staticmethod
    def _get_or_create_usr(cur, party_id: int, email: str, claims) -> int:
        """Return the usr_id linked to party_id, creating the usr row if absent.

        Args:
            cur: Active psycopg cursor.
            party_id: Primary key of the associated party record.
            email: User's email address.
            claims: Decoded JWT claims dict used to populate ``preferred_name``.

        Returns:
            The ``usr_id`` of the existing or newly created usr record.
        """
        cur.execute(
            "SELECT usr_id FROM usr WHERE party_id = %s LIMIT 1",
            (party_id,),
        )
        row = cur.fetchone()
        if row is not None:
            return row["usr_id"]

        preferred_name = (claims or {}).get("name", "") if claims else ""
        cur.execute(
            """INSERT INTO usr (party_id, email_address, preferred_name, permission_type, begin_time)
               VALUES (%s, %s, %s, 1, NOW())
               RETURNING usr_id""",
            (party_id, email, preferred_name),
        )
        usr_id = cur.fetchone()["usr_id"]
        logger.info("Created usr record usr_id=%s for party_id=%s", usr_id, party_id)
        return usr_id


    def upload_user_dataset_from_endpoint(self, request, claims=None):
        """Handle an HTTP request to upload a user dataset.

        Parses the JSON body, mints a reserved DOI, persists the dataset, and
        publishes the DOI after the DB transaction commits. The database
        connection is opened here (rather than in ``vegbankapi.py``) to
        facilitate isolated testing.

        Args:
            request: Flask request object. Must have a JSON body matching the
                structure expected by :meth:`upload_user_dataset`.
            claims: Decoded JWT claims dict, or ``None`` in unauthenticated modes.

        Returns:
            Dict with ``counts`` and ``resources`` describing inserted records,
            or a ``(JSON error response, status code)`` tuple on failure.
        """
        if not request.is_json:
            return jsonify_error_message("Request body must be JSON."), 400

        dataset = request.get_json()
        dataset['type'] = 'normal'
        dataset['sharing'] = 'public'
        validate_dataset_json(dataset)

        is_dry_run = request.args.get('dry_run', 'false').lower() == 'true'

        # Mint a reserved DOI and store it with the dataset record
        ezid, doi = self._mint_doi() if not is_dry_run else (None, None)

        with connect(**self.params, row_factory=dict_row) as conn:
            to_return = self.upload_user_dataset(dataset, conn, validate=True, claims=claims, doi=doi)
            to_return = dry_run_check(conn, to_return, request)
        conn.close()

        # Publish the DOI with full DataCite metadata after the DB commit.
        if doi and ezid:
            vb_ds_code = to_return['resources']['ds'][0]['vb_ds_code']
            self._publish_doi(ezid, doi, dataset, vb_ds_code, claims)

        return to_return

    def _mint_doi(self) -> tuple["EZIDClient | None", "str | None"]:
        """Attempt to mint a reserved DOI.

        Returns:
            Two-tuple of ``(EZIDClient, doi_string)`` on success, or
            ``(None, None)`` if the EZID service is unavailable.
        """
        try:
            ezid = EZIDClient()
            doi = ezid.mint_reserved()
            return ezid, doi
        except EZIDError as exc:
            logger.warning("DOI mint failed; dataset will be created without a DOI: %s", exc)
            return None, None

    def _publish_doi(self, ezid: "EZIDClient", doi: str, dataset: dict, vb_ds_code: str, claims) -> None:
        """Publish a reserved DOI with full DataCite metadata.

        Must be called after the DB transaction commits so the VegBank accession
        code is available for the alternate identifier field.

        Args:
            ezid: Authenticated EZID client instance.
            doi: Reserved DOI string to publish (e.g. ``"doi:10.5072/FK2XXXXX"``).
            dataset: Dataset dict containing at least a ``name`` key.
            vb_ds_code: VegBank accession code for the dataset (e.g. ``"ds.42"``).
            claims: Decoded JWT claims dict used to build the creator metadata.
        """
        orcid = extract_orcid(claims)
        xml_bytes = EZIDClient.build_datacite_xml(
            doi=doi.replace("doi:", ""),
            title=f'Vegbank plot observations: "{dataset["name"]}"',
            publisher="VegBank",
            publication_year=datetime.now().year,
            creators=self._build_datacite_creators(claims, orcid),
            alternate_identifiers=[{
                "value": f"vegbank:{vb_ds_code}",
                "type": "VegBank Accession Code",
            }],
            rights_list=[{
                "text": "Creative Commons Attribution 4.0 International",
                "rights_uri": "https://creativecommons.org/licenses/by/4.0/",
                "rights_identifier": "CC-BY-4.0",
                "rights_identifier_scheme": "SPDX",
                "scheme_uri": "https://spdx.org/licenses/",
            }],
            dates=[{"date": datetime.now().strftime("%Y-%m-%d"), "type": "Created"}],
        )
        try:
            ezid.update_identifier(doi, {
                "_status": "public",
                "_profile": "datacite",
                "datacite": xml_bytes.decode("utf-8"),
                "_target": f"{ezid.default_target_url}/{doi}",
            })
        except EZIDError as exc:
            logger.error("Failed to publish DOI %s for dataset %s: %s", doi, vb_ds_code, exc)

    @staticmethod
    def _build_datacite_creators(claims, orcid: str | None) -> list[dict]:
        """Build the DataCite creators list from JWT claims and ORCID.

        Always includes the creator name from the token. The ORCID
        ``nameIdentifier`` element is added only when available.

        Args:
            claims: Decoded JWT claims dict, or ``None``.
            orcid: Canonical ORCID URI, or ``None`` if unavailable.

        Returns:
            List of creator dicts compatible with ``EZIDClient.build_datacite_xml``.
            Empty list when ``claims`` is ``None``.
        """
        if not claims:
            return []
        creator: dict = {
            "name": claims.get("name", ""),
            "given_name": claims.get("given_name"),
            "family_name": claims.get("family_name"),
        }
        if orcid:
            creator["name_identifier"] = orcid
            creator["name_identifier_scheme"] = "ORCID"
            creator["name_identifier_scheme_uri"] = "https://orcid.org/"
        return [creator]
