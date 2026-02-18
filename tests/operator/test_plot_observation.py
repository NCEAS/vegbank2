"""Test module for the 'PlotObservation' operator class"""
from unittest.mock import MagicMock, patch
import pandas as pd
from vegbank.operators import (
    Operator,
    PlotObservation,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    plot_observation_operator = PlotObservation(params)
    assert plot_observation_operator.queries_package == "vegbank.queries.plot_observation"


def test_queries_package_override_upload_disturbance():
    """Check that the queries package attribute was overridden as expected when calling
    the 'upload_disturbance' function."""
    plot_observation_operator = PlotObservation(params)
    # Create a dataframe with the required keys
    df = pd.DataFrame([
        {
            "vb_ob_code": "VB.DM.001",
            "user_ob_code": "SOIL_A",
            "user_do_code": "SOIL_B",
            "type": "test.data"
        }
    ])
    # This connection represents access to a db
    conn = MagicMock()
    # Create fake return value to allow 'upload_disturbance' to access return values
    fake_return_after_upload = {
        "resources": {
            "do": []
        },
        "counts": {
            "do": 0
        }
    }
    with patch.object(
        Operator, "upload_to_table", return_value=fake_return_after_upload
    ) as _mocked:
        plot_observation_operator.upload_disturbance(df, conn)

    assert plot_observation_operator.queries_package == "vegbank.queries.disturbance"


def test_queries_package_upload_soil():
    """Check that the queries package attribute was overridden as expected when calling
    the 'upload_soil' function."""
    plot_observation_operator = PlotObservation(params)
    # Create a dataframe with the required keys
    df = pd.DataFrame([
        {
            "vb_ob_code": "VB.DM.001",
            "user_ob_code": "SOIL_A",
            "user_so_code": "SO.123",
            "horizon": "test.horizon.value",
        }
    ])
    # This connection represents access to a db
    conn = MagicMock()
    # Create fake return value to allow 'upload_soil' to access return values
    fake_return_after_upload = {
        "resources": {
            "so": []
        },
        "counts": {
            "so": 0
        }
    }
    with patch.object(
        Operator, "upload_to_table", return_value=fake_return_after_upload
    ) as _mocked:
        plot_observation_operator.upload_soil(df, conn)

    assert plot_observation_operator.queries_package == "vegbank.queries.soil"
