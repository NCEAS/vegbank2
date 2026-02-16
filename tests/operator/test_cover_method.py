"""Test module for the 'CommunityConcept' operator class"""
from vegbank.operators import (
    CoverMethod,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = CoverMethod(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.cover_method"
    )
