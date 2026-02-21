"""Route tests for vegbankapi endpoints."""

import io
from unittest.mock import MagicMock, patch
import pytest
from vegbank import vegbankapi
from vegbank.vegbankapi import app


@pytest.fixture(name="test_client")
def setup_test_client():
    """Provide a Flask test client with testing mode enabled."""
    app.testing = True
    with app.test_client() as client:
        yield client


@pytest.fixture(autouse=True)
def default_allow_uploads_true(monkeypatch):
    """Default uploads to enabled unless a test overrides it."""
    monkeypatch.setattr("vegbank.vegbankapi.allow_uploads", True)


@pytest.fixture(name="mock_db_connection_context")
def setup_mock_db_connection_context():
    """Provide a mocked database connection and context manager."""
    mock_conn = MagicMock()
    mock_db_connect_ctx = MagicMock()
    mock_db_connect_ctx.__enter__.return_value = mock_conn
    mock_db_connect_ctx.__exit__.return_value = False
    return mock_db_connect_ctx


def test_plot_observations_post_rejected_when_allow_uploads_false(
    monkeypatch, test_client
):
    """Test that a post request to the plot-observations endpoint is rejected when
    allow_uploads is false."""
    monkeypatch.setattr("vegbank.vegbankapi.allow_uploads", False)
    with patch.object(
        vegbankapi.PlotObservation, "upload_all", autospec=True
    ) as mock_upload_all:
        response = test_client.post("/plot-observations")

    assert response.status_code == 403
    mock_upload_all.assert_not_called()


def test_plot_observations_get_dispatches_to_operator(test_client):
    """Test that a get request to the plot-observations endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.PlotObservation,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/plot-observations/ob.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_plot_observations_post_calls_upload_all_when_uploads_allowed(test_client):
    """Test that a post request to the plot-observations endpoint is accepted when
    allow_uploads is true."""
    with patch.object(
        vegbankapi.PlotObservation,
        "upload_all",
        autospec=True,
        return_value=(
            {"uploaded": True},
            201,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_upload_all:
        response = test_client.post("/plot-observations")

    assert response.status_code == 201
    assert mock_upload_all.call_count == 1


def test_taxon_observations_get_dispatches_to_operator(test_client):
    """Test that a get request to the taxon-observations endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.TaxonObservation,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/taxon-observations/to.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_taxon_observations_post_calls_upload_pipeline_when_uploads_allowed(
    test_client, mock_db_connection_context
):
    """Test that a post request to the taxon-observations endpoint is accepted
    when allow_uploads is true and follows the expected upload sequence."""
    mock_db_connect_ctx = mock_db_connection_context
    mock_df = MagicMock(name="taxon_observations_dataframe")
    fake_response = ({"uploaded": True}, 201)

    with (
        patch("vegbank.vegbankapi.connect", return_value=mock_db_connect_ctx),
        patch(
            "vegbank.vegbankapi.pd.read_parquet",
            return_value=mock_df,
        ) as mock_read_parquet,
        patch.object(
            vegbankapi.TaxonObservation,
            "upload_strata_definitions",
            autospec=True,
            return_value={
                "counts": {"to": 1}
            },  # Note: The return value above is purely placeholder data
        ) as mock_upload_strata_definitions,
        patch(
            "vegbank.vegbankapi.dry_run_check",
            return_value=fake_response,
        ) as mock_dry_run_check,
    ):
        response = test_client.post(
            "/taxon-observations",
            data={"file": (io.BytesIO(b"dummy"), "taxon_observations.parquet")},
        )

    assert response.status_code == 201
    assert mock_read_parquet.call_count == 1
    assert mock_upload_strata_definitions.call_count == 1
    assert mock_dry_run_check.call_count == 1


def test_taxon_importances_get_dispatches_to_operator(test_client):
    """Test that a get request to the taxon-importances endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.TaxonImportance,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/taxon-importances/ti.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_taxon_importances_post_returns_405_when_uploads_allowed(test_client):
    """Test that a post request to the taxon-importances endpoint returns 405
    when allow_uploads is true."""
    response = test_client.post("/taxon-importances")

    assert response.status_code == 405


def test_stem_counts_get_dispatches_to_operator(test_client):
    """Test that a get request to the stem-counts endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.StemCount,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/stem-counts/sc.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_stem_counts_post_returns_405_when_uploads_allowed(test_client):
    """Test that a post request to the stem-counts endpoint returns 405 when
    allow_uploads is true."""
    response = test_client.post("/stem-counts")

    assert response.status_code == 405


def test_strata_cover_data_post_calls_upload_pipeline_when_uploads_allowed(
    test_client, mock_db_connection_context
):
    """Test that a post request to the strata-cover-data endpoint is accepted
    when allow_uploads is true and follows the expected upload sequence."""
    mock_db_connect_ctx = mock_db_connection_context
    mock_df = MagicMock(name="strata_cover_dataframe")
    fake_response = ({"uploaded": True}, 201)

    with (
        patch("vegbank.vegbankapi.connect", return_value=mock_db_connect_ctx),
        patch(
            "vegbank.vegbankapi.read_parquet_file",
            return_value=mock_df,
        ) as mock_read_parquet_file,
        patch.object(
            vegbankapi.TaxonObservation,
            "upload_strata_cover_data",
            autospec=True,
            return_value={
                "counts": {"ti": 1}
            },  # Note: The return value above is purely placeholder data
        ) as mock_upload_strata_cover_data,
        patch(
            "vegbank.vegbankapi.dry_run_check",
            return_value=fake_response,
        ) as mock_dry_run_check,
    ):
        response = test_client.post("/strata-cover-data")

    assert response.status_code == 201
    assert mock_read_parquet_file.call_count == 1
    assert mock_upload_strata_cover_data.call_count == 1
    assert mock_dry_run_check.call_count == 1


def test_strata_cover_data_post_returns_500_on_upload_error(test_client):
    """Test that a post request to the strata-cover-data endpoint returns 500
    when an upload error occurs."""
    with patch(
        "vegbank.vegbankapi.read_parquet_file",
        side_effect=Exception("Forced exceptipn"),
    ):
        response = test_client.post("/strata-cover-data")

    assert response.status_code == 500
