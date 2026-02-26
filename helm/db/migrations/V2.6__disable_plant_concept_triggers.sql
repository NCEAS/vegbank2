/* -------------------------------------------------------------------
    Disable Plant Concept FTS triggers: plantconcept.search_vector
    will be updated by API logic instead
------------------------------------------------------------------- */

-- Disable triggers for updating plant concept search_vector
ALTER TABLE plantconcept DISABLE TRIGGER trg_plantconcept_search;
ALTER TABLE plantusage DISABLE TRIGGER trg_plantusage_search;
ALTER TABLE plantname DISABLE TRIGGER trg_plantname_search;
