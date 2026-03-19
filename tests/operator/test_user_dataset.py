"""Test module for the 'UserDataset' operator class"""
from vegbank.operators import (
    UserDataset,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = UserDataset(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.user_dataset"
    )
