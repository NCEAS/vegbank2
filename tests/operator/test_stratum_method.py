"""Test module for the 'StratumMethod' operator class"""
from vegbank.operators import (
    StratumMethod,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = StratumMethod(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.stratum_method"
    )
