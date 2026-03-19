"""Test module for the 'TaxonImportance' operator class"""
from vegbank.operators import (
    TaxonImportance,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = TaxonImportance(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.taxon_importance"
    )
