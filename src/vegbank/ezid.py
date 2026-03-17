"""EZID client for DOI minting."""

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
    """Client for the EZID DOI service."""

    def __init__(self, base_url: str, username: str, password: str):
        self.base_url = base_url.rstrip("/")
        self._auth = (username, password)
        self._timeout = 30

    def mint(self, shoulder: str, metadata: dict[str, str]) -> str:
        """Mint a new identifier under the given shoulder. Returns the minted identifier."""
        resp = requests.post(
            f"{self.base_url}/shoulder/{shoulder}",
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
