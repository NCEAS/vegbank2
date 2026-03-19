"""Test module for the 'PlantConcept' operator class"""
from unittest.mock import MagicMock, patch
import pandas as pd
from vegbank.operators import (
    Operator,
    PlantConcept,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    plant_concept_operator = PlantConcept(params)
    assert (
        plant_concept_operator.queries_package
        == "vegbank.queries.plant_concept"
    )


def test_queries_package_upload_plant_names():
    """Check that the queries package attribute was overridden as expected when calling
    the 'upload_plant_names' function."""
    plant_concept_operator = PlantConcept(params)
    # Create a basic dataframe with the required keys
    df = pd.DataFrame([
        {
            "user_pc_code": "VB.PC.DM.001",
            "vb_pc_code": "test.dm.pc.1",
            "name": "dou.test",
            "name_type": "dou.string",
            "name_status": "name.status",
        }
    ])
    # This connection represents access to a db
    conn = MagicMock()

    # Mock return values for 'upload_to_table'
    pn_actions = {
        "resources": {
            "pn": {
                "user_pn_code": ["dou.test"],
                "vb_pn_code": ["VB.CN.001"],
            }
        },
        "counts": {"pn": 1},
    }
    pu_actions = {
        "resources": {"pu": []},
        "counts": {"pn": 0, "pu": {}},
    }

    # Side effect allows the initial call to return the first object,
    # then the subsequent to call the second object
    with patch.object(
        Operator, "upload_to_table", side_effect=[pn_actions, pu_actions]
    ) as _mocked:
        plant_concept_operator.upload_plant_names(df, conn)

    assert plant_concept_operator.queries_package == "vegbank.queries.plant_name"


def test_queries_package_upload_plant_correlations():
    """Check that the queries package attribute was overridden as expected when calling
    the 'upload_plant_correlations' function."""
    plant_concept_operator = PlantConcept(params)
    # Create a basic dataframe with the required keys
    df = pd.DataFrame([
        {
            "user_pc_code": "VB.PC.DM.001",
            "vb_pc_code": "test.dm.pc.1",
            "vb_correlated_pc_code": "VB.PC.DM.001",
            "convergence_type": "convergence",
            "correlation_start": "02.16.2026",
        }
    ])
    # This connection represents access to a db
    conn = MagicMock()

    # Mock return values for 'upload_to_table'
    px_actions = {
        "resources": {
            "px": [
                {"plantcorrelation_id": 123}
            ]
        },
        "counts": {
            "px": 1
        },
    }
    # Side effect allows the initial call to return the first object,
    # then the subsequent to call the second object
    with patch.object(
        Operator, "upload_to_table", return_value=px_actions
    ) as _mocked:
        plant_concept_operator.upload_plant_correlations(df, conn)

    assert plant_concept_operator.queries_package == "vegbank.queries.plant_correlation"