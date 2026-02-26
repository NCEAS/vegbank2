/* -------------------------------------------------------------------
    Disable all FTS triggers
    We will maintain search_vector columns at the API layer instead
------------------------------------------------------------------- */

-- Disable triggers for updating plant concept search_vector
ALTER TABLE plantconcept DISABLE TRIGGER trg_plantconcept_search;
ALTER TABLE plantusage DISABLE TRIGGER trg_plantusage_search;
ALTER TABLE plantname DISABLE TRIGGER trg_plantname_search;

-- Disable triggers for updating comm concept search_vector
ALTER TABLE commconcept DISABLE TRIGGER trg_commconcept_search;
ALTER TABLE commusage DISABLE TRIGGER trg_commusage_search;
ALTER TABLE commname DISABLE TRIGGER trg_commname_search;

-- Disable triggers for updating party search_vector
ALTER TABLE party DISABLE TRIGGER trg_party_search;

-- Disable triggers for updating project search_vector
ALTER TABLE project DISABLE TRIGGER trg_project_search;

-- Disable triggers for updating observation search_vector
ALTER TABLE observation DISABLE TRIGGER trg_observation_obsearch;
ALTER TABLE plot DISABLE TRIGGER trg_plot_to_ob_search;
ALTER TABLE place DISABLE TRIGGER trg_place_to_ob_search;
ALTER TABLE namedplace DISABLE TRIGGER trg_namedplace_to_ob_search;
ALTER TABLE commclass DISABLE TRIGGER trg_commclass_to_obsearch;
ALTER TABLE comminterpretation DISABLE TRIGGER trg_comminterp_to_obsearch;
ALTER TABLE commconcept DISABLE TRIGGER trg_commconcept_to_obsearch;
ALTER TABLE commusage DISABLE TRIGGER trg_commusage_to_obsearch;
ALTER TABLE commname DISABLE TRIGGER trg_commname_to_obsearch;
ALTER TABLE taxonobservation DISABLE TRIGGER trg_taxonobs_to_obsearch;
ALTER TABLE taxoninterpretation DISABLE TRIGGER trg_taxoninterp_to_obsearch;
ALTER TABLE plantconcept DISABLE TRIGGER trg_plantconcept_to_obsearch;
ALTER TABLE plantusage DISABLE TRIGGER trg_plantusage_to_obsearch;
ALTER TABLE plantname DISABLE TRIGGER trg_plantname_to_obsearch;
