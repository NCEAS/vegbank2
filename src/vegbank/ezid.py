"""EZID client for DOI minting."""

import os
import re
from enum import Enum

import requests


class EZIDStatus(str, Enum):
    RESERVED = "reserved"
    PUBLIC = "public"
    UNAVAILABLE = "unavailable"


class EZIDError(Exception):
    """Error returned by the EZID service."""


class EZIDClient:
    """Client for the EZID DOI service.

    Reads configuration from environment variables set via Helm deployment values:
        EZID_BASE_URL   - Base URL of the EZID API
        EZID_USERNAME   - EZID API username
        EZID_PASSWORD   - EZID API password
        EZID_DOI_PREFIX - DOI prefix (e.g. doi:10.5072)
        EZID_DOI_SHOULDER - DOI shoulder for minting (e.g. FK2)
    """

    def __init__(self):
        self.base_url = os.environ["EZID_BASE_URL"].rstrip("/")
        self._auth = (os.environ["EZID_USERNAME"], os.environ["EZID_PASSWORD"])
        self.doi_prefix = os.environ["EZID_DOI_PREFIX"]
        self.doi_shoulder = os.environ["EZID_DOI_SHOULDER"]
        self._timeout = 30

    @property
    def shoulder(self) -> str:
        """Full shoulder path for minting (e.g. doi:10.5072/FK2)."""
        return f"{self.doi_prefix}/{self.doi_shoulder}"

    def mint(self, metadata: dict[str, str]) -> str:
        """Mint a new identifier using the configured shoulder. Returns the minted identifier."""
        resp = requests.post(
            f"{self.base_url}/shoulder/{self.shoulder}",
            data=metadata,
            auth=self._auth,
            headers={"Content-Type": "text/plain; charset=UTF-8"},
            timeout=self._timeout,
        )
        self._check(resp)
        return resp.text.split("|")[0].replace("success:", "").strip()

    def mint_reserved(self, title: str) -> str:
        """Mint a DOI with 'reserved' status."""
        metadata = {
            "_status": "reserved",
        }
        return self.mint(metadata)

    def update_identifier(self, identifier: str, metadata: dict[str, str]) -> str:
        """Update an existing identifier with new metadata."""
        resp = requests.post(
            f"{self.base_url}/id/{identifier}",
            data=metadata,
            auth=self._auth,
            headers={"Content-Type": "text/plain; charset=UTF-8"},
            timeout=self._timeout,
        )
        self._check(resp)
        return resp.text.split("|")[0].replace("success:", "").strip()

    @staticmethod
    def _check(resp: requests.Response) -> None:
        if resp.status_code != 200 or resp.text.startswith("error:"):
            raise EZIDError(resp.text.strip())
