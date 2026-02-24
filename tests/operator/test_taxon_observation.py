"""Test module for the 'TaxonObservation' operator class"""
from vegbank.operators import (
    TaxonObservation,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = TaxonObservation(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.taxon_observation"
    )
