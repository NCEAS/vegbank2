"""
The 'identifiers_queries' module contains data-access logic for the 'identifiers' table.
"""

from psycopg import connect
from psycopg.rows import dict_row

# TODO: Determine if this should be a class
# TODO: Finish function docstring
def get_identifier_by_value(params: dict, identifier_value: str):
    """
    Return the identifier row (dict) for an exact identifier_value match
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
