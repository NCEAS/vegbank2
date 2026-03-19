"""Test module for the 'Party' operator class"""
from vegbank.operators import (
    Party,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = Party(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.party"
    )
