"""Route tests for vegbankapi endpoints."""
import io
from unittest.mock import MagicMock, patch
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
            vegbankapi.PlotObservation, "upload_all", autospec=True
        ) as mock_upload_all:
            response = client.post("/plot-observations")

    assert response.status_code == 403
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
        ) as mock_get_vegbank_resources:
            response = client.get("/plot-observations/ob.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


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
            autospec=True,
            return_value=({"uploaded": True}, 201),
        ) as mock_upload_all:
            response = client.post("/plot-observations")

    assert response.status_code == 201
    assert mock_upload_all.call_count == 1


def test_taxon_observations_get_dispatches_to_operator():
    """Test that a get request to the taxon-observations endpoint calls the expected
    operator class and function."""
    app.testing = True
    with app.test_client() as client:
        with patch.object(
            vegbankapi.TaxonObservation,
            "get_vegbank_resources",
            autospec=True,
            return_value=({"ok": True}, 200),
        ) as mock_get_vegbank_resources:
            response = client.get("/taxon-observations/to.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_taxon_observations_post_calls_upload_pipeline_when_uploads_allowed(monkeypatch):
    """Test that a post request to the taxon-observations endpoint is accepted when
    allow_uploads is true and follows the expected upload sequence."""
    monkeypatch.setattr("vegbank.vegbankapi.allow_uploads", True)
    app.testing = True

    mock_conn = MagicMock()
    mock_db_connect_ctx = MagicMock()
    mock_db_connect_ctx.__enter__.return_value = mock_conn
    mock_db_connect_ctx.__exit__.return_value = False
    mock_df = MagicMock(name="taxon_observations_dataframe")
    fake_response = ({"uploaded": True}, 201)

    with app.test_client() as client:
        with patch("vegbank.vegbankapi.connect", return_value=mock_db_connect_ctx), patch(
            "vegbank.vegbankapi.pd.read_parquet",
            return_value=mock_df,
        ) as mock_read_parquet, patch.object(
            vegbankapi.TaxonObservation,
            "upload_strata_definitions",
            autospec=True,
            return_value={"counts": {"to": 1}},
        ) as mock_upload_strata_definitions, patch(
            "vegbank.vegbankapi.dry_run_check",
            return_value=fake_response,
        ) as mock_dry_run_check:
            response = client.post(
                "/taxon-observations",
                data={"file": (io.BytesIO(b"dummy"), "taxon_observations.parquet")}
            )

    assert response.status_code == 201
    assert mock_read_parquet.call_count == 1
    assert mock_upload_strata_definitions.call_count == 1
    assert mock_dry_run_check.call_count == 1
