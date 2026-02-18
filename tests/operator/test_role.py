"""Test module for the 'Role' operator class"""
from vegbank.operators import (
    Role,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = Role(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.role"
    )
