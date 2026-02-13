"""Test module for the 'PlotObservation' operator class"""
from unittest.mock import MagicMock
import pandas as pd
import pytest
from vegbank.operators import (
    PlotObservation,
)

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    plot_observation_operator = PlotObservation(params)
    assert plot_observation_operator.queries_package == "vegbank.queries.plot_observation"


def test_upload_disturbance_queries_package_override():
    """Check that the queries package attribute was overridden as expected when calling
    the 'upload_disturbance' function."""
    plot_observation_operator = PlotObservation(params)
    # TODO: Simulate realistic values for df and conn to make this test more reliable
    df = pd.DataFrame()
    conn = MagicMock()

    with pytest.raises(ValueError):
        plot_observation_operator.upload_disturbance(df, conn)

    assert plot_observation_operator.queries_package == "vegbank.queries.disturbance"


def test_upload_soil_queries_package_override():
    """Check that the queries package attribute was overridden as expected when calling
    the 'upload_soil' function."""
    plot_observation_operator = PlotObservation(params)
    # TODO: Simulate realistic values for df and conn to make this test more reliable
    df = pd.DataFrame()
    conn = MagicMock()

    with pytest.raises(ValueError):
        plot_observation_operator.upload_soil(df, conn)

    assert plot_observation_operator.queries_package == "vegbank.queries.soil"
