"""Test module for vegbank.utilties"""
from importlib.resources import files
from pathlib import Path
from vegbank.utilities import load_sql

def test_queries_sql_exists():
    """Confirm that queries resources exists within vegbank"""
    base = files("vegbank.queries").iterdir()
    base_length = len(list(base))
    # This cannot be an exact number as we may add to the queries
    # There are 19 folders and/or files as of writing this test
    assert base_length >= 19


def test_load_sql():
    """Confirm that 'load_sql' returns the expect .sql from the queries folder"""
    queries_package = "vegbank.queries"
    insert_tn = "community_classification"
    insert_tn_condensed = "comm_class"
    temp_table_path = (
        f"{insert_tn}/{insert_tn_condensed}/create_{insert_tn_condensed}_temp_table.sql"
    )

    # Load the sql via function
    sql = load_sql(queries_package, temp_table_path)

    # Load the file directly for expected result
    expected_path = Path("vegbank/queries") / temp_table_path
    expected_sql = expected_path.read_text(encoding="utf-8")
    assert sql == expected_sql
