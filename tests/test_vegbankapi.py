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
def default_access_mode_open(monkeypatch):
    """Default to open access mode (uploads enabled) unless a test overrides it."""
    monkeypatch.setenv("VB_ACCESS_MODE", "open")


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
    access mode is read_only."""
    monkeypatch.setenv("VB_ACCESS_MODE", "read_only")
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
    access mode allows uploads."""
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
    when access mode allows uploads and follows the expected upload sequence."""
    mock_df = MagicMock(name="taxon_observations_dataframe")
    fake_response = ({"uploaded": True}, 201)

    with (
        patch("vegbank.vegbankapi.connect", return_value=mock_db_connection_context),
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
    when access mode allows uploads."""
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
    access mode allows uploads."""
    response = test_client.post("/stem-counts")

    assert response.status_code == 405


def test_strata_cover_data_post_calls_upload_pipeline_when_uploads_allowed(
    test_client, mock_db_connection_context
):
    """Test that a post request to the strata-cover-data endpoint is accepted
    when access mode allows uploads and follows the expected upload sequence."""
    mock_df = MagicMock(name="strata_cover_dataframe")
    fake_response = ({"uploaded": True}, 201)

    with (
        patch("vegbank.vegbankapi.connect", return_value=mock_db_connection_context),
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


def test_stem_data_post_calls_upload_pipeline_when_uploads_allowed(
    test_client, mock_db_connection_context
):
    """Test that a post request to the stem-data endpoint is accepted
    when access mode allows uploads and follows the expected upload sequence."""
    mock_df = MagicMock(name="stem_data_dataframe")
    fake_response = ({"uploaded": True}, 201)

    with (
        patch("vegbank.vegbankapi.connect", return_value=mock_db_connection_context),
        patch(
            "vegbank.vegbankapi.read_parquet_file",
            return_value=mock_df,
        ) as mock_read_parquet_file,
        patch.object(
            vegbankapi.TaxonObservation,
            "upload_stem_data",
            autospec=True,
            return_value={
                "counts": {"stl": 1, "sc": 1}
            },  # Note: The return value above is purely placeholder data
        ) as mock_upload_stem_data,
        patch(
            "vegbank.vegbankapi.dry_run_check",
            return_value=fake_response,
        ) as mock_dry_run_check,
    ):
        response = test_client.post("/stem-data")

    assert response.status_code == 201
    assert mock_read_parquet_file.call_count == 1
    assert mock_upload_stem_data.call_count == 1
    assert mock_dry_run_check.call_count == 1


def test_stem_data_post_returns_500_on_upload_error(test_client):
    """Test that a post request to the stem-data endpoint returns 500
    when an upload error occurs."""
    with patch(
        "vegbank.vegbankapi.read_parquet_file",
        side_effect=Exception("Forced exception"),
    ):
        response = test_client.post("/stem-data")

    assert response.status_code == 500


def test_taxon_interpretations_get_dispatches_to_operator(test_client):
    """Test that a get request to the taxon-interpretations endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.TaxonInterpretation,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/taxon-interpretations/ti.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_taxon_interpretations_post_calls_upload_pipeline_when_uploads_allowed(
    test_client, mock_db_connection_context
):
    """Test that a post request to the taxon-interpretations endpoint is accepted
    when access mode allows uploads and follows the expected upload sequence."""
    mock_df = MagicMock(name="taxon_interpretations_dataframe")
    fake_response = {"uploaded": True}

    with (
        patch("vegbank.vegbankapi.connect", return_value=mock_db_connection_context),
        patch(
            "vegbank.vegbankapi.read_parquet_file",
            return_value=mock_df,
        ) as mock_read_parquet_file,
        patch.object(
            vegbankapi.TaxonObservation,
            "upload_taxon_interpretations",
            autospec=True,
            return_value={
                "counts": {"ti": 1}
            },  # Note: The return value above is purely placeholder data
        ) as mock_upload_taxon_interpretations,
        patch(
            "vegbank.vegbankapi.dry_run_check",
            return_value=fake_response,
        ) as mock_dry_run_check,
    ):
        response = test_client.post("/taxon-interpretations")

    assert response.status_code == 200
    assert mock_read_parquet_file.call_count == 1
    assert mock_upload_taxon_interpretations.call_count == 1
    assert mock_dry_run_check.call_count == 1


def test_taxon_interpretations_post_returns_500_on_upload_error(test_client):
    """Test that a post request to the taxon-interpretations endpoint returns 500
    when an upload error occurs."""
    with patch(
        "vegbank.vegbankapi.read_parquet_file",
        side_effect=Exception("Forced exception"),
    ):
        response = test_client.post("/taxon-interpretations")

    assert response.status_code == 500


def test_community_classifications_get_dispatches_to_operator(test_client):
    """Test that a get request to the community-classifications endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.CommunityClassification,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/community-classifications/cc.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_community_classifications_post_calls_upload_all_when_uploads_allowed(
    test_client,
):
    """Test that a post request to the community-classifications endpoint is accepted when
    access mode allows uploads."""
    with patch.object(
        vegbankapi.CommunityClassification,
        "upload_all",
        autospec=True,
        return_value=(
            {"uploaded": True},
            201,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_upload_all:
        response = test_client.post("/community-classifications")

    assert response.status_code == 201
    assert mock_upload_all.call_count == 1


def test_community_interpretations_get_dispatches_to_operator(test_client):
    """Test that a get request to the community-interpretations endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.CommunityInterpretation,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/community-interpretations/ci.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_community_interpretations_post_returns_405_when_uploads_allowed(
    test_client,
):
    """Test that a post request to the community-interpretations endpoint returns 405
    when access mode allows uploads."""
    response = test_client.post("/community-interpretations")

    assert response.status_code == 405


def test_community_concepts_get_dispatches_to_operator(test_client):
    """Test that a get request to the community-concepts endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.CommunityConcept,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/community-concepts/ct.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_community_concepts_post_calls_upload_all_when_uploads_allowed(
    test_client,
):
    """Test that a post request to the community-concepts endpoint is accepted when
    access mode allows uploads."""
    with patch.object(
        vegbankapi.CommunityConcept,
        "upload_all",
        autospec=True,
        return_value=(
            {"uploaded": True},
            201,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_upload_all:
        response = test_client.post("/community-concepts")

    assert response.status_code == 201
    assert mock_upload_all.call_count == 1


def test_plant_concepts_get_dispatches_to_operator(test_client):
    """Test that a get request to the plant-concepts endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.PlantConcept,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/plant-concepts/pc.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_plant_concepts_post_calls_upload_all_when_uploads_allowed(
    test_client,
):
    """Test that a post request to the plant-concepts endpoint is accepted when
    access mode allows uploads."""
    with patch.object(
        vegbankapi.PlantConcept,
        "upload_all",
        autospec=True,
        return_value=(
            {"uploaded": True},
            201,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_upload_all:
        response = test_client.post("/plant-concepts")

    assert response.status_code == 201
    assert mock_upload_all.call_count == 1


def test_parties_get_dispatches_to_operator(test_client):
    """Test that a get request to the parties endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.Party,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/parties/py.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_parties_post_calls_upload_pipeline_when_uploads_allowed(
    test_client, mock_db_connection_context
):
    """Test that a post request to the parties endpoint is accepted
    when access mode allows uploads and follows the expected upload sequence."""
    mock_df = MagicMock(name="parties_dataframe")
    fake_response = {"uploaded": True}

    with (
        patch("vegbank.vegbankapi.connect", return_value=mock_db_connection_context),
        patch(
            "vegbank.vegbankapi.pd.read_parquet",
            return_value=mock_df,
        ) as mock_read_parquet,
        patch.object(
            vegbankapi.Party,
            "upload_parties",
            autospec=True,
            return_value={
                "counts": {"py": 1}
            },  # Note: The return value above is purely placeholder data
        ) as mock_upload_parties,
        patch(
            "vegbank.vegbankapi.dry_run_check",
            return_value=fake_response,
        ) as mock_dry_run_check,
    ):
        response = test_client.post(
            "/parties",
            data={"file": (io.BytesIO(b"dummy"), "parties.parquet")},
        )

    assert response.status_code == 200
    assert mock_read_parquet.call_count == 1
    assert mock_upload_parties.call_count == 1
    assert mock_dry_run_check.call_count == 1


def test_parties_post_returns_500_on_upload_error(test_client):
    """Test that a post request to the parties endpoint returns 500
    when an upload error occurs."""
    with patch(
        "vegbank.vegbankapi.pd.read_parquet",
        side_effect=Exception("Forced exception"),
    ):
        response = test_client.post(
            "/parties",
            data={"file": (io.BytesIO(b"dummy"), "parties.parquet")},
        )

    assert response.status_code == 500


def test_projects_get_dispatches_to_operator(test_client):
    """Test that a get request to the projects endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.Project,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/projects/pj.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_projects_post_calls_upload_pipeline_when_uploads_allowed(
    test_client, mock_db_connection_context
):
    """Test that a post request to the projects endpoint is accepted
    when access mode allows uploads and follows the expected upload sequence."""
    mock_df = MagicMock(name="projects_dataframe")
    fake_response = {"uploaded": True}

    with (
        patch("vegbank.vegbankapi.connect", return_value=mock_db_connection_context),
        patch(
            "vegbank.vegbankapi.read_parquet_file",
            return_value=mock_df,
        ) as mock_read_parquet_file,
        patch.object(
            vegbankapi.Project,
            "upload_project",
            autospec=True,
            return_value={
                "counts": {"pj": 1}
            },  # Note: The return value above is purely placeholder data
        ) as mock_upload_project,
        patch(
            "vegbank.vegbankapi.dry_run_check",
            return_value=fake_response,
        ) as mock_dry_run_check,
    ):
        response = test_client.post("/projects")

    assert response.status_code == 200
    assert mock_read_parquet_file.call_count == 1
    assert mock_upload_project.call_count == 1
    assert mock_dry_run_check.call_count == 1


def test_projects_post_returns_500_on_upload_error(test_client):
    """Test that a post request to the projects endpoint returns 500
    when an upload error occurs."""
    with patch(
        "vegbank.vegbankapi.read_parquet_file",
        side_effect=Exception("Forced exception"),
    ):
        response = test_client.post("/projects")

    assert response.status_code == 500


def test_cover_methods_get_dispatches_to_operator(test_client):
    """Test that a get request to the cover-methods endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.CoverMethod,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/cover-methods/cm.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_cover_methods_post_calls_upload_cover_method_when_uploads_allowed(
    test_client,
):
    """Test that a post request to the cover-methods endpoint is accepted when
    access mode allows uploads."""
    with patch.object(
        vegbankapi.CoverMethod,
        "upload_cover_method",
        autospec=True,
        return_value=(
            {"uploaded": True},
            201,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_upload_cover_method:
        response = test_client.post("/cover-methods")

    assert response.status_code == 201
    assert mock_upload_cover_method.call_count == 1


def test_stratum_methods_get_dispatches_to_operator(test_client):
    """Test that a get request to the stratum-methods endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.StratumMethod,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/stratum-methods/sm.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_stratum_methods_post_calls_upload_stratum_method_when_uploads_allowed(
    test_client,
):
    """Test that a post request to the stratum-methods endpoint is accepted when
    access mode allows uploads."""
    with patch.object(
        vegbankapi.StratumMethod,
        "upload_stratum_method",
        autospec=True,
        return_value=(
            {"uploaded": True},
            201,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_upload_stratum_method:
        response = test_client.post("/stratum-methods")

    assert response.status_code == 201
    assert mock_upload_stratum_method.call_count == 1


def test_strata_get_dispatches_to_operator(test_client):
    """Test that a get request to the strata endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.Stratum,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/strata/sr.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_strata_post_returns_405_when_uploads_allowed(test_client):
    """Test that a post request to the strata endpoint returns 405 when
    access mode allows uploads."""
    response = test_client.post("/strata")

    assert response.status_code == 405


def test_references_get_dispatches_to_operator(test_client):
    """Test that a get request to the references endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.Reference,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/references/rf.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_references_post_calls_upload_pipeline_when_uploads_allowed(
    test_client, mock_db_connection_context
):
    """Test that a post request to the references endpoint is accepted
    when access mode allows uploads and follows the expected upload sequence."""
    mock_df = MagicMock(name="references_dataframe")
    fake_response = {"uploaded": True}

    with (
        patch("vegbank.vegbankapi.connect", return_value=mock_db_connection_context),
        patch(
            "vegbank.vegbankapi.pd.read_parquet",
            return_value=mock_df,
        ) as mock_read_parquet,
        patch.object(
            vegbankapi.Reference,
            "upload_references",
            autospec=True,
            return_value={
                "counts": {"rf": 1}
            },  # Note: The return value above is purely placeholder data
        ) as mock_upload_references,
        patch(
            "vegbank.vegbankapi.dry_run_check",
            return_value=fake_response,
        ) as mock_dry_run_check,
    ):
        response = test_client.post(
            "/references",
            data={"file": (io.BytesIO(b"dummy"), "references.parquet")},
        )

    assert response.status_code == 200
    assert mock_read_parquet.call_count == 1
    assert mock_upload_references.call_count == 1
    assert mock_dry_run_check.call_count == 1


def test_references_post_returns_500_on_upload_error(test_client):
    """Test that a post request to the references endpoint returns 500
    when an upload error occurs."""
    with patch(
        "vegbank.vegbankapi.pd.read_parquet",
        side_effect=Exception("Forced exception"),
    ):
        response = test_client.post(
            "/references",
            data={"file": (io.BytesIO(b"dummy"), "references.parquet")},
        )

    assert response.status_code == 500


def test_roles_get_dispatches_to_operator(test_client):
    """Test that a get request to the roles endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.Role,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/roles/ar.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_roles_post_calls_upload_all_when_uploads_allowed(
    test_client,
):
    """Test that a post request to the roles endpoint currently raises an AttributeError
    because Role.upload_all is not implemented."""
    with pytest.raises(AttributeError):
        test_client.post("/roles")


def test_named_places_get_dispatches_to_operator(test_client):
    """Test that a get request to the named-places endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.NamedPlace,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/named-places/np.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_named_places_post_returns_405_when_uploads_allowed(test_client):
    """Test that a post request to the named-places endpoint returns 405 when
    access mode allows uploads."""
    response = test_client.post("/named-places")

    assert response.status_code == 405


def test_user_datasets_get_dispatches_to_operator(test_client):
    """Test that a get request to the user-datasets endpoint calls the expected
    operator class and function."""
    with patch.object(
        vegbankapi.UserDataset,
        "get_vegbank_resources",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_vegbank_resources:
        response = test_client.get("/user-datasets/ds.1")

    assert response.status_code == 200
    assert mock_get_vegbank_resources.call_count == 1


def test_user_datasets_post_returns_200_when_uploads_allowed(test_client):
    """Test that a post request to the user-datasets endpoint returns 200 when
    allow_uploads is true."""
    payload = {
        "user_ds_code": "test_ds_001",
        "name": "Test Dataset 001",
        "description": "A test dataset containing 1 observation.",
        "type": "upload",
        "data": {
            "observation":[
                "ob.1"
            ]
        }
    }
    with patch.object(
        vegbankapi.UserDataset,
            "upload_user_dataset_from_endpoint",
            autospec=True,
            return_value=(
                {"uploaded": True},
                201,
            ),  # Note: The return value above is purely placeholder data
        ) as mock_upload_user_dataset:
            response = test_client.post("/user-datasets?dry_run=true", json=payload)

    assert response.status_code == 200
    assert mock_upload_user_dataset.call_count == 1


def test_overview_get_dispatches_to_repository(test_client):
    """Test that a get request to the overview endpoint calls the expected
    repository class and function."""
    with patch.object(
        vegbankapi.Overview,
        "get_summary_stats",
        autospec=True,
        return_value=(
            {"ok": True},
            200,
        ),  # Note: The return value above is purely placeholder data
    ) as mock_get_summary_stats:
        response = test_client.get("/overview")

    assert response.status_code == 200
    assert mock_get_summary_stats.call_count == 1


def test_identifiers_get_returns_400_when_identifier_missing(test_client):
    """Test that a get request to the identifiers endpoint returns 400 when
    no identifier value is provided."""
    response = test_client.get("/identifiers/")

    assert response.status_code == 400


def test_identifiers_get_returns_200_when_identifier_found(test_client):
    """Test that a get request to the identifiers endpoint returns 200 when
    a matching identifier value is found."""
    with patch.object(
        vegbankapi.IdentifiersQueries,
        "get_identifier_by_value",
        autospec=True,
        return_value={
            "vb_table_code": "to",
            "vb_record_id": 123,
        },  # Note: The return value above is purely placeholder data
    ) as mock_get_identifier_by_value:
        response = test_client.get("/identifiers/test_identifier")

    assert response.status_code == 200
    assert mock_get_identifier_by_value.call_count == 1


def test_identifiers_get_returns_404_when_identifier_not_found(test_client):
    """Test that a get request to the identifiers endpoint returns 404 when
    a matching identifier value is not found."""
    with patch.object(
        vegbankapi.IdentifiersQueries,
        "get_identifier_by_value",
        autospec=True,
        return_value=None,
    ) as mock_get_identifier_by_value:
        response = test_client.get("/identifiers/test_identifier")

    assert response.status_code == 404
    assert mock_get_identifier_by_value.call_count == 1


def test_identifiers_get_returns_500_on_identifier_query_error(test_client):
    """Test that a get request to the identifiers endpoint returns 500 when
    an identifier query error occurs."""
    with patch.object(
        vegbankapi.IdentifiersQueries,
        "get_identifier_by_value",
        autospec=True,
        side_effect=Exception("Forced exception"),
    ) as mock_get_identifier_by_value:
        response = test_client.get("/identifiers/test_identifier")

    assert response.status_code == 500
    assert mock_get_identifier_by_value.call_count == 1
