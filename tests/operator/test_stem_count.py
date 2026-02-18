"""Test module for the 'StemCount' operator class"""
from vegbank.operators import (
    StemCount,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = StemCount(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.stem_count"
    )
