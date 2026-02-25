/* -------------------------------------------------------------------
    Disable Plant Concept FTS triggers: plantconcept.search_vector
    will be updated by API logic instead
------------------------------------------------------------------- */

-- Disable triggers for updating plant concept search_vector
DISABLE TRIGGER trg_plantconcept_search ON plantconcept;
DISABLE TRIGGER trg_plantusage_search ON plantusage;
DISABLE TRIGGER trg_plantname_search ON plantname;
