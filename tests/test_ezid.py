"""Tests for vegbank.ezid module. These tests focus on the build_datacite_xml method and the structure of the generated XML."""
import pytest
from lxml import etree

from vegbank.ezid import EZIDClient

NS = "http://datacite.org/schema/kernel-4"
XSI = "http://www.w3.org/2001/XMLSchema-instance"

CREATORS = [
    {
        "name": "Michael Lee",
        "given_name": "Michael",
        "family_name": "Lee",
        "name_identifier": "0009-0003-3874-8604",
        "name_identifier_scheme": "ORCID",
        "name_identifier_scheme_uri": "https://orcid.org/",
        "affiliation": "University of North Carolina at Chapel Hill",
        "affiliation_identifier": "https://ror.org/0130frc33",
        "affiliation_identifier_scheme": "ROR",
        "affiliation_scheme_uri": "https://ror.org/",
    }
]

FUNDING_REFERENCES = [
    {
        "funder_name": "California Department of Fish and Wildlife",
        "funder_identifier": "https://api.crossref.org/funders/100006238",
        "funder_identifier_type": "Crossref Funder ID",
        "award_number": "P2384008",
        "award_title": "VegBank Improvements",
    },
    {
        "funder_name": "National Science Foundation",
        "funder_identifier": "https://api.crossref.org/funders/100000001",
        "funder_identifier_type": "Crossref Funder ID",
        "award_number": "0213794",
        "award_uri": "https://www.nsf.gov/awardsearch/show-award/?AWD_ID=0213794&HistoricalAwards=true",
        "award_title": "An Information Infrastructure for Vegetation Science",
    },
    {
        "funder_name": "National Science Foundation",
        "funder_identifier": "https://api.crossref.org/funders/100000001",
        "funder_identifier_type": "Crossref Funder ID",
        "award_number": "9905838",
        "award_uri": "https://www.nsf.gov/awardsearch/show-award/?AWD_ID=9905838&HistoricalAwards=true",
        "award_title": "A Perfectly Archived, Continuously Updated Database System for Analysis of North American Vegetation",
    },
]


@pytest.fixture(name="full_xml_root")
def build_full_example():
    """Provide a parsed lxml root element built from dataset metadata."""
    xml_bytes = EZIDClient.build_datacite_xml(
        doi="10.5072/FK2",
        title="Vegbank plot observations: Carolinas + Virginias pre 2015",
        publisher="Vegbank",
        publication_year=2026,
        creators=CREATORS,
        descriptions=[{"text": "NC, SC, VA, WV before additional plots added via CVS efforts.", "type": "Abstract"}],
        dates=[{"date": "2026-03-20", "type": "Created"}],
        alternate_identifiers=[
            {"value": "vegbank:VB.ds.200378.UNNAMEDDATASET", "type": "https://registry.identifiers.org/registry/vegbank"},
            {"value": "vegbank:ds.200378", "type": "https://registry.identifiers.org/registry/vegbank"},
        ],
        version="1",
        rights_list=[{
            "text": "Creative Commons Attribution 4.0 International",
            "scheme_uri": "https://spdx.org/licenses/",
            "rights_identifier_scheme": "SPDX",
            "rights_identifier": "CC-BY-4.0",
            "rights_uri": "https://creativecommons.org/licenses/by/4.0/",
        }],
        funding_references=FUNDING_REFERENCES,
    )
    return etree.fromstring(xml_bytes)


def test_import_ezid():
    """Confirm that the ezid module can be imported from vegbank."""
    import vegbank.ezid


def test_build_datacite_xml_returns_bytes():
    """Confirm that build_datacite_xml returns a bytes object with an XML declaration."""
    xml_bytes = EZIDClient.build_datacite_xml(doi="10.5072/FK2", title="Test Dataset", publisher="NCEAS", publication_year=2026)
    assert isinstance(xml_bytes, bytes)
    assert b"<?xml" in xml_bytes


def test_root_element_tag_and_namespace(full_xml_root):
    """Confirm that the root element uses the DataCite kernel-4 namespace."""
    assert full_xml_root.tag == f"{{{NS}}}resource"


def test_root_element_schema_location(full_xml_root):
    """Confirm that the root element carries the expected xsi:schemaLocation attribute."""
    schema_location = full_xml_root.get(f"{{{XSI}}}schemaLocation")
    assert schema_location is not None
    assert "http://datacite.org/schema/kernel-4" in schema_location


def test_identifier_value_and_type(full_xml_root):
    """Confirm that the DOI identifier text and identifierType attribute are set correctly."""
    el = full_xml_root.find(f"{{{NS}}}identifier")
    assert el is not None
    assert el.text == "10.5072/FK2"
    assert el.get("identifierType") == "DOI"


def test_title(full_xml_root):
    """Confirm that the dataset title is written under titles/title."""
    title = full_xml_root.find(f"{{{NS}}}titles/{{{NS}}}title")
    assert title is not None
    assert title.text == "Vegbank plot observations: Carolinas + Virginias pre 2015"


def test_publisher_and_publication_year(full_xml_root):
    """Confirm that publisher and publicationYear elements are set correctly."""
    assert full_xml_root.find(f"{{{NS}}}publisher").text == "Vegbank"
    assert full_xml_root.find(f"{{{NS}}}publicationYear").text == "2026"


def test_resource_type_text_and_general_attribute(full_xml_root):
    """Confirm that resourceType text and resourceTypeGeneral attribute default to 'Dataset'."""
    el = full_xml_root.find(f"{{{NS}}}resourceType")
    assert el.text == "Dataset"
    assert el.get("resourceTypeGeneral") == "Dataset"


def test_creator_name_fields(full_xml_root):
    """Confirm that creator name, givenName, and familyName elements are populated."""
    creator = full_xml_root.find(f"{{{NS}}}creators/{{{NS}}}creator")
    assert creator.find(f"{{{NS}}}creatorName").text == "Michael Lee"
    assert creator.find(f"{{{NS}}}givenName").text == "Michael"
    assert creator.find(f"{{{NS}}}familyName").text == "Lee"


def test_creator_name_identifier(full_xml_root):
    """Confirm that the creator ORCID nameIdentifier and its scheme attributes are correct."""
    creator = full_xml_root.find(f"{{{NS}}}creators/{{{NS}}}creator")
    name_id = creator.find(f"{{{NS}}}nameIdentifier")
    assert name_id.text == "0009-0003-3874-8604"
    assert name_id.get("nameIdentifierScheme") == "ORCID"
    assert name_id.get("schemeURI") == "https://orcid.org/"


def test_creator_affiliation(full_xml_root):
    """Confirm that the creator affiliation text and ROR identifier attributes are correct."""
    creator = full_xml_root.find(f"{{{NS}}}creators/{{{NS}}}creator")
    affil = creator.find(f"{{{NS}}}affiliation")
    assert affil.text == "University of North Carolina at Chapel Hill"
    assert affil.get("affiliationIdentifier") == "https://ror.org/0130frc33"
    assert affil.get("affiliationIdentifierScheme") == "ROR"
    assert affil.get("schemeURI") == "https://ror.org/"


def test_description_text_and_type(full_xml_root):
    """Confirm that the Abstract description text and descriptionType attribute are correct."""
    desc = full_xml_root.find(f"{{{NS}}}descriptions/{{{NS}}}description")
    assert desc.get("descriptionType") == "Abstract"
    assert "NC, SC, VA, WV" in desc.text


def test_date_value_and_type(full_xml_root):
    """Confirm that the Created date value and dateType attribute are correct."""
    date = full_xml_root.find(f"{{{NS}}}dates/{{{NS}}}date")
    assert date.text == "2026-03-20"
    assert date.get("dateType") == "Created"


def test_alternate_identifiers_count_and_values(full_xml_root):
    """Confirm that both alternateIdentifier elements are present with the correct values."""
    alts = full_xml_root.findall(f"{{{NS}}}alternateIdentifiers/{{{NS}}}alternateIdentifier")
    assert len(alts) == 2
    assert alts[0].text == "vegbank:VB.ds.200378.UNNAMEDDATASET"
    assert alts[1].text == "vegbank:ds.200378"
    for alt in alts:
        assert alt.get("alternateIdentifierType") == "https://registry.identifiers.org/registry/vegbank"


def test_version(full_xml_root):
    """Confirm that the version element is set correctly."""
    assert full_xml_root.find(f"{{{NS}}}version").text == "1"


def test_rights_identifier_and_scheme(full_xml_root):
    """Confirm that the rights element carries CC-BY-4.0 identifiers and correct label text."""
    rights = full_xml_root.find(f"{{{NS}}}rightsList/{{{NS}}}rights")
    assert rights.get("rightsIdentifier") == "CC-BY-4.0"
    assert rights.get("rightsIdentifierScheme") == "SPDX"
    assert rights.get("schemeURI") == "https://spdx.org/licenses/"
    assert rights.get("rightsURI") == "https://creativecommons.org/licenses/by/4.0/"
    assert "Creative Commons" in rights.text


def test_funding_references_count(full_xml_root):
    """Confirm that all three funding references are present."""
    refs = full_xml_root.findall(f"{{{NS}}}fundingReferences/{{{NS}}}fundingReference")
    assert len(refs) == 3


def test_funding_reference_without_award_uri(full_xml_root):
    """Confirm that a funding reference without an awardURI omits the attribute entirely."""
    refs = full_xml_root.findall(f"{{{NS}}}fundingReferences/{{{NS}}}fundingReference")
    cdfw = refs[0]
    assert cdfw.find(f"{{{NS}}}funderName").text == "California Department of Fish and Wildlife"
    award = cdfw.find(f"{{{NS}}}awardNumber")
    assert award.text == "P2384008"
    assert award.get("awardURI") is None


def test_funding_reference_with_award_uri(full_xml_root):
    """Confirm that a funding reference with an awardURI sets the attribute correctly."""
    refs = full_xml_root.findall(f"{{{NS}}}fundingReferences/{{{NS}}}fundingReference")
    nsf = refs[1]
    assert nsf.find(f"{{{NS}}}funderName").text == "National Science Foundation"
    award = nsf.find(f"{{{NS}}}awardNumber")
    assert award.text == "0213794"
    assert "AWD_ID=0213794" in award.get("awardURI")


def test_minimal_build_omits_optional_elements():
    """Confirm that optional elements are absent when not provided to build_datacite_xml."""
    xml_bytes = EZIDClient.build_datacite_xml(
        doi="10.5072/FK2",
        title="Minimal Dataset",
        publisher="Vegbank",
        publication_year=2026,
    )
    root = etree.fromstring(xml_bytes)
    assert root.find(f"{{{NS}}}descriptions") is None
    assert root.find(f"{{{NS}}}dates") is None
    assert root.find(f"{{{NS}}}alternateIdentifiers") is None
    assert root.find(f"{{{NS}}}version") is None
    assert root.find(f"{{{NS}}}rightsList") is None
    assert root.find(f"{{{NS}}}fundingReferences") is None


def test_subjects_with_taxa_scheme_attributes():
    """Confirm that taxa subjects render subjectScheme, schemeURI, and valueURI attributes."""
    xml_bytes = EZIDClient.build_datacite_xml(
        doi="10.5072/FK2",
        title="Taxa Subject Dataset",
        publisher="Vegbank",
        publication_year=2026,
        subjects=[
            {
                "value": "Lichen",
                "scheme": "Vegbank Taxonomic Observations",
                "scheme_uri": "https://www.vegbank.org",
                "value_uri": "https://www.vegbank.org/cite/to.64982",
            },
            {
                "value": "Quercus alba",
                "scheme": "Vegbank Taxonomic Observations",
                "scheme_uri": "https://www.vegbank.org",
                "value_uri": "https://www.vegbank.org/cite/to.12345",
            },
        ],
    )
    root = etree.fromstring(xml_bytes)
    subjects = root.findall(f"{{{NS}}}subjects/{{{NS}}}subject")
    assert len(subjects) == 2

    lichen = subjects[0]
    assert lichen.text == "Lichen"
    assert lichen.get("subjectScheme") == "Vegbank Taxonomic Observations"
    assert lichen.get("schemeURI") == "https://www.vegbank.org"
    assert lichen.get("valueURI") == "https://www.vegbank.org/cite/to.64982"

    quercus = subjects[1]
    assert quercus.text == "Quercus alba"
    assert quercus.get("valueURI") == "https://www.vegbank.org/cite/to.12345"


def test_subject_without_value_uri_omits_attribute():
    """Confirm that a subject dict without value_uri renders no valueURI attribute."""
    xml_bytes = EZIDClient.build_datacite_xml(
        doi="10.5072/FK2",
        title="No URI Subject Dataset",
        publisher="Vegbank",
        publication_year=2026,
        subjects=[{"value": "Lichen", "scheme": "Vegbank Taxonomic Observations", "scheme_uri": "https://www.vegbank.org"}],
    )
    root = etree.fromstring(xml_bytes)
    subject = root.find(f"{{{NS}}}subjects/{{{NS}}}subject")
    assert subject.text == "Lichen"
    assert subject.get("subjectScheme") == "Vegbank Taxonomic Observations"
    assert subject.get("valueURI") is None


def test_minimal_build_omits_subjects():
    """Confirm that subjects element is absent when no subjects are provided."""
    xml_bytes = EZIDClient.build_datacite_xml(
        doi="10.5072/FK2",
        title="Minimal Dataset",
        publisher="Vegbank",
        publication_year=2026,
    )
    root = etree.fromstring(xml_bytes)
    assert root.find(f"{{{NS}}}subjects") is None


def test_multiple_creators_all_present():
    """Confirm that all creators are written when multiple creators are provided."""
    xml_bytes = EZIDClient.build_datacite_xml(
        doi="10.5072/FK2",
        title="Multi-Creator Dataset",
        publisher="Vegbank",
        publication_year=2026,
        creators=[
            {"name": "Alice Smith"},
            {"name": "Bob Jones"},
            {"name": "Carol White"},
        ],
    )
    root = etree.fromstring(xml_bytes)
    creators = root.findall(f"{{{NS}}}creators/{{{NS}}}creator")
    assert len(creators) == 3
    names = [c.find(f"{{{NS}}}creatorName").text for c in creators]
    assert names == ["Alice Smith", "Bob Jones", "Carol White"]
