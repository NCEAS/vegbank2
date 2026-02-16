"""Test module for the 'CommunityConcept' operator class"""
from vegbank.operators import (
    NamedPlace,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = NamedPlace(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.named_place"
    )
