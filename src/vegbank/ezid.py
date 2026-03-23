"""EZID client for DOI minting."""

import logging
import os
from enum import Enum

import requests as _requests
from lxml import etree

logger = logging.getLogger(__name__)


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
        EZID_DEFAULT_TARGET_URL - Base URL DOIs resolve to (e.g. https://vegbank.org/cite)
    """

    def __init__(self):
        self.base_url = os.environ["EZID_BASE_URL"].rstrip("/")
        self._auth = (os.environ["EZID_USERNAME"], os.environ["EZID_PASSWORD"])
        self.doi_prefix = os.environ["EZID_DOI_PREFIX"]
        self.doi_shoulder = os.environ["EZID_DOI_SHOULDER"]
        self.default_target_url = os.environ["EZID_DEFAULT_TARGET_URL"].rstrip("/")
        self._timeout = 30

    @property
    def shoulder(self) -> str:
        """Full shoulder path for minting (e.g. doi:10.5072/FK2)."""
        return f"{self.doi_prefix}/{self.doi_shoulder}"

    @staticmethod
    def _encode_anvl(metadata: dict[str, str]) -> str:
        """Encode a dict as ANVL plain text (key: value lines).

        Per the EZID ANVL spec, percent-signs, newlines, and carriage returns
        in *values* must be percent-encoded so the server can parse them as a
        single-line value.
        """
        def _escape(v: str) -> str:
            return v.replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A")

        return "\n".join(f"{k}: {_escape(v)}" for k, v in metadata.items())

    def mint(self, metadata: dict[str, str]) -> str:
        """Mint a new identifier using the configured shoulder. Returns the minted identifier."""
        resp = _requests.post(
            f"{self.base_url}/shoulder/{self.shoulder}",
            data=self._encode_anvl(metadata).encode("utf-8"),
            auth=self._auth,
            headers={"Content-Type": "text/plain; charset=UTF-8"},
            timeout=self._timeout,
        )
        logger.debug("EZID mint response: %s", resp.text)
        self._check(resp)
        return resp.text.split("|")[0].replace("success:", "").strip()

    def mint_reserved(self) -> str:
        """Mint a DOI with 'reserved' status."""
        return self.mint({"_status": "reserved"})

    def update_identifier(self, identifier: str, metadata: dict[str, str]) -> str:
        """Update an existing identifier with new metadata."""
        resp = _requests.post(
            f"{self.base_url}/id/{identifier}",
            data=self._encode_anvl(metadata).encode("utf-8"),
            auth=self._auth,
            headers={"Content-Type": "text/plain; charset=UTF-8"},
            timeout=self._timeout,
        )
        logger.debug("EZID update response: %s", resp.text)
        self._check(resp)
        return resp.text.split("|")[0].replace("success:", "").strip()

    @staticmethod
    def build_datacite_xml(
        doi: str,
        title: str,
        publisher: str,
        publication_year: str | int,
        resource_type: str = "Dataset",
        resource_type_general: str = "Dataset",
        creators: list[dict] | None = None,
        descriptions: list[dict] | None = None,
        dates: list[dict] | None = None,
        alternate_identifiers: list[dict] | None = None,
        version: str | None = None,
        rights_list: list[dict] | None = None,
        funding_references: list[dict] | None = None,
    ) -> bytes:
        """Build a DataCite kernel-4 XML document.

        Args:
            doi: The DOI string (e.g. "10.82902/J1RV0D26C").
            title: Dataset title.
            publisher: Publisher name.
            publication_year: Four-digit publication year.
            resource_type: Resource type label (default "Dataset").
            resource_type_general: resourceTypeGeneral attribute (default "Dataset").
            creators: List of creator dicts with optional keys:
                name, given_name, family_name,
                name_identifier, name_identifier_scheme, name_identifier_scheme_uri,
                affiliation, affiliation_identifier,
                affiliation_identifier_scheme, affiliation_scheme_uri.
            descriptions: List of dicts with keys: text, type (e.g. "Abstract").
            dates: List of dicts with keys: date, type (e.g. "Created").
            alternate_identifiers: List of dicts with keys: value, type.
            version: Version string.
            rights_list: List of dicts with optional keys:
                text, scheme_uri, rights_identifier_scheme,
                rights_identifier, rights_uri.
            funding_references: List of dicts with optional keys:
                funder_name, funder_identifier, funder_identifier_type,
                award_number, award_uri, award_title.

        Returns:
            UTF-8 encoded XML bytes.
        """
        NS = "http://datacite.org/schema/kernel-4"
        XSI = "http://www.w3.org/2001/XMLSchema-instance"
        SCHEMA_LOCATION = (
            "http://datacite.org/schema/kernel-4 "
            "http://schema.datacite.org/meta/kernel-4/metadata.xsd"
        )

        root = etree.Element(
            f"{{{NS}}}resource",
            nsmap={None: NS, "xsi": XSI},
            attrib={f"{{{XSI}}}schemaLocation": SCHEMA_LOCATION},
        )

        # identifier
        id_el = etree.SubElement(root, f"{{{NS}}}identifier", identifierType="DOI")
        id_el.text = doi

        # creators
        creators_el = etree.SubElement(root, f"{{{NS}}}creators")
        for c in creators or []:
            creator_el = etree.SubElement(creators_el, f"{{{NS}}}creator")
            etree.SubElement(creator_el, f"{{{NS}}}creatorName").text = c.get("name", "")
            if c.get("given_name"):
                etree.SubElement(creator_el, f"{{{NS}}}givenName").text = c["given_name"]
            if c.get("family_name"):
                etree.SubElement(creator_el, f"{{{NS}}}familyName").text = c["family_name"]
            if c.get("name_identifier"):
                attrib = {}
                if c.get("name_identifier_scheme"):
                    attrib["nameIdentifierScheme"] = c["name_identifier_scheme"]
                if c.get("name_identifier_scheme_uri"):
                    attrib["schemeURI"] = c["name_identifier_scheme_uri"]
                etree.SubElement(creator_el, f"{{{NS}}}nameIdentifier", **attrib).text = c["name_identifier"]
            if c.get("affiliation"):
                attrib = {}
                if c.get("affiliation_identifier"):
                    attrib["affiliationIdentifier"] = c["affiliation_identifier"]
                if c.get("affiliation_identifier_scheme"):
                    attrib["affiliationIdentifierScheme"] = c["affiliation_identifier_scheme"]
                if c.get("affiliation_scheme_uri"):
                    attrib["schemeURI"] = c["affiliation_scheme_uri"]
                etree.SubElement(creator_el, f"{{{NS}}}affiliation", **attrib).text = c["affiliation"]

        # titles
        titles_el = etree.SubElement(root, f"{{{NS}}}titles")
        etree.SubElement(titles_el, f"{{{NS}}}title").text = title

        # descriptions
        if descriptions:
            descs_el = etree.SubElement(root, f"{{{NS}}}descriptions")
            for d in descriptions:
                etree.SubElement(
                    descs_el, f"{{{NS}}}description", descriptionType=d.get("type", "Abstract")
                ).text = d.get("text", "")

        # publisher
        etree.SubElement(root, f"{{{NS}}}publisher").text = publisher

        # publicationYear
        etree.SubElement(root, f"{{{NS}}}publicationYear").text = str(publication_year)

        # resourceType
        etree.SubElement(
            root, f"{{{NS}}}resourceType", resourceTypeGeneral=resource_type_general
        ).text = resource_type

        # dates
        if dates:
            dates_el = etree.SubElement(root, f"{{{NS}}}dates")
            for d in dates:
                etree.SubElement(dates_el, f"{{{NS}}}date", dateType=d.get("type", "")).text = d.get("date", "")

        # alternateIdentifiers
        if alternate_identifiers:
            alt_el = etree.SubElement(root, f"{{{NS}}}alternateIdentifiers")
            for a in alternate_identifiers:
                etree.SubElement(
                    alt_el,
                    f"{{{NS}}}alternateIdentifier",
                    alternateIdentifierType=a.get("type", ""),
                ).text = a.get("value", "")

        # version
        if version is not None:
            etree.SubElement(root, f"{{{NS}}}version").text = str(version)

        # rightsList
        if rights_list:
            rights_el = etree.SubElement(root, f"{{{NS}}}rightsList")
            for r in rights_list:
                attrib = {}
                if r.get("scheme_uri"):
                    attrib["schemeURI"] = r["scheme_uri"]
                if r.get("rights_identifier_scheme"):
                    attrib["rightsIdentifierScheme"] = r["rights_identifier_scheme"]
                if r.get("rights_identifier"):
                    attrib["rightsIdentifier"] = r["rights_identifier"]
                if r.get("rights_uri"):
                    attrib["rightsURI"] = r["rights_uri"]
                etree.SubElement(rights_el, f"{{{NS}}}rights", **attrib).text = r.get("text", "")

        # fundingReferences
        if funding_references:
            funding_el = etree.SubElement(root, f"{{{NS}}}fundingReferences")
            for f in funding_references:
                ref_el = etree.SubElement(funding_el, f"{{{NS}}}fundingReference")
                etree.SubElement(ref_el, f"{{{NS}}}funderName").text = f.get("funder_name", "")
                if f.get("funder_identifier"):
                    attrib = {}
                    if f.get("funder_identifier_type"):
                        attrib["funderIdentifierType"] = f["funder_identifier_type"]
                    etree.SubElement(ref_el, f"{{{NS}}}funderIdentifier", **attrib).text = f["funder_identifier"]
                if f.get("award_number"):
                    attrib = {}
                    if f.get("award_uri"):
                        attrib["awardURI"] = f["award_uri"]
                    etree.SubElement(ref_el, f"{{{NS}}}awardNumber", **attrib).text = f["award_number"]
                if f.get("award_title"):
                    etree.SubElement(ref_el, f"{{{NS}}}awardTitle").text = f["award_title"]

        return etree.tostring(root, xml_declaration=True, encoding="UTF-8")

    @staticmethod
    def _check(resp: _requests.Response) -> None:
        if resp.status_code not in (200, 201) or resp.text.startswith("error:"):
            raise EZIDError(resp.text.strip())
