"""Test module for the 'CommunityClassification' operator class"""
from vegbank.operators import (
    CommunityClassification,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    comm_class_operator = CommunityClassification(params)
    assert (
        comm_class_operator.queries_package
        == "vegbank.queries.community_classification"
    )
