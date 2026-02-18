"""Test module for the 'Project' operator class"""
from vegbank.operators import (
    Project,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    cover_method_operator = Project(params)
    assert (
        cover_method_operator.queries_package
        == "vegbank.queries.project"
    )
