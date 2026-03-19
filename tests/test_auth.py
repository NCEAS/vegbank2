"""Unit tests for auth.py helpers."""

from vegbank.auth import extract_orcid


def test_extract_orcid_returns_https_uri_from_https_orcid_claim():
    """Test that extract_orcid returns the canonical HTTPS URI when the orcid claim is already a full HTTPS URI."""
    claims = {"orcid": "https://orcid.org/0000-0002-1825-0097"}
    assert extract_orcid(claims) == "https://orcid.org/0000-0002-1825-0097"


def test_extract_orcid_normalises_http_orcid_claim_to_https():
    """Test that extract_orcid upgrades an http:// orcid claim URI to the canonical https:// URI."""
    claims = {"orcid": "http://orcid.org/0000-0002-1825-0097"}
    assert extract_orcid(claims) == "https://orcid.org/0000-0002-1825-0097"


def test_extract_orcid_normalises_bare_id_to_https_uri():
    """Test that extract_orcid expands a bare ORCID iD to the canonical HTTPS URI."""
    claims = {"orcid": "0000-0002-1825-0097"}
    assert extract_orcid(claims) == "https://orcid.org/0000-0002-1825-0097"


def test_extract_orcid_returns_none_for_none_input():
    """Test that extract_orcid returns None when called with None instead of a claims dict."""
    assert extract_orcid(None) is None


def test_extract_orcid_returns_none_for_empty_claims():
    """Test that extract_orcid returns None when called with an empty claims dict."""
    assert extract_orcid({}) is None
