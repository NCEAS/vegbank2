"""Test module for the 'Reference' operator class"""
from vegbank.operators import (
    Reference,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = Reference(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.reference"
    )
