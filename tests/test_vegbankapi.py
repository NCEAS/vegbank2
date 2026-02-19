"""Route tests for plot_observations in vegbankapi."""
from unittest.mock import patch

from vegbank import vegbankapi
from vegbank.vegbankapi import app


def test_allow_uploads_false_post_blocked(monkeypatch):
    """Test that a post request to the plot-observations endpoint is rejected when
    allow_uploads is false"""
    monkeypatch.setattr("vegbank.vegbankapi.allow_uploads", False)
    # Set this to true so that exceptions can propagate if they occur
    app.testing = True
    with app.test_client() as client:
        with patch.object(
            vegbankapi.PlotObservation, "upload_all"
        ) as mock_upload_all:
            response = client.post("/plot-observations")

    assert response.status_code == 403
    assert response.get_json() == {"error": {"message": "Uploads not allowed."}}
    mock_upload_all.assert_not_called()


def test_plot_observations_get_dispatches_to_operator():
    """Test that a get request to the plot-observations endpoint calls the expected
    operator class and function."""
    # Set this to true so that exceptions can propagate if they occur
    app.testing = True
    with app.test_client() as client:
        with patch.object(
            vegbankapi.PlotObservation,
            "get_vegbank_resources",
            autospec=True,
            return_value=({"ok": True}, 200),
        ) as mock_get_resources:
            response = client.get("/plot-observations/ob.1")

    assert response.status_code == 200
    assert response.get_json() == {"ok": True}
    assert mock_get_resources.call_count == 1


def test_plot_observations_post_calls_upload_all_when_uploads_allowed(monkeypatch):
    """Test that a post request to the plot-observations endpoint is accepted when
    allow_uploads is true"""
    monkeypatch.setattr("vegbank.vegbankapi.allow_uploads", True)
    # Set this to true so that exceptions can propagate if they occur
    app.testing = True
    with app.test_client() as client:
        with patch.object(
            vegbankapi.PlotObservation,
            "upload_all",
            return_value=({"uploaded": True}, 201),
        ) as mock_upload_all:
            response = client.post("/plot-observations")

    assert response.status_code == 201
    assert response.get_json() == {"uploaded": True}
    assert mock_upload_all.call_count == 1
