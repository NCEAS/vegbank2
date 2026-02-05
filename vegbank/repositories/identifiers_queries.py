"""
The 'identifiers_queries' module contains data-access logic for the 'identifiers' table.
"""

from psycopg import connect
from psycopg.rows import dict_row

# TODO: Determine if this should be a class
def get_identifier_by_value(params: dict, identifier_value: str):
    """
    Return the identifier row (dict) for an exact identifier_value match

    Parameters:
        params (dict): Parameters used to connect to the VegBank PostgreSQL
            database (e.g., dbname, user, host, port, password).
        identifier_value (str): The identifier value to search for in the
            `identifiers` table.
    Return:
        dict or None: A dictionary representing the matching identifier record
            if found, with keys corresponding to the selected database columns
            (`identifier_id`, `vb_table_code`, `vb_record_id`, `identifier_type`,
            `identifier_value`). Returns None if no matching identifier exists.
    """
    with connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT identifier_id,
                       vb_table_code,
                       vb_record_id,
                       identifier_type,
                       identifier_value
                FROM identifiers
                WHERE identifier_value = %s
                LIMIT 1
                """,
                (identifier_value,),
            )
            return cur.fetchone()
