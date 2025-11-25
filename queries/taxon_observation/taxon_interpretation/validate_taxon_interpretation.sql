-- Validate taxon observation codes

SELECT taxon_interpretation_temp.vb_to_code
FROM 
    taxon_interpretation_temp LEFT JOIN taxonobservation 
ON
    taxon_interpretation_temp.vb_to_code = 'to.' || taxonobservation.taxonobservation_id
WHERE taxonobservation.taxonobservation_id IS NULL;

-- Validate plant concept codes

SELECT taxon_interpretation_temp.vb_pc_code
FROM 
    taxon_interpretation_temp LEFT JOIN plantconcept
ON
    taxon_interpretation_temp.vb_pc_code = 'pc.' || plantconcept.plantconcept_id
WHERE plantconcept.plantconcept_id IS NULL;

-- Validate party codes

SELECT taxon_interpretation_temp.vb_py_code
FROM 
    taxon_interpretation_temp LEFT JOIN party
ON
    taxon_interpretation_temp.vb_py_code = 'py.' || party.party_id
WHERE party.party_id IS NULL;

-- Validate role codes

SELECT taxon_interpretation_temp.vb_ro_code
FROM 
    taxon_interpretation_temp LEFT JOIN aux_role
ON
    taxon_interpretation_temp.vb_ro_code = 'ro.' || aux_role.role_id
WHERE aux_role.role_id IS NULL;

-- Validate reference codes. Additional AND statement is added because this is an optional foreign key. 

SELECT taxon_interpretation_temp.vb_rf_code
FROM 
    taxon_interpretation_temp LEFT JOIN reference
ON
    taxon_interpretation_temp.vb_rf_code = 'rf.' || reference.reference_id
WHERE reference.reference_id IS NULL AND taxon_interpretation_temp.vb_rf_code IS NOT NULL;

-- Leaving out collector_id and museum_id for now as they are not used in the DB. Check with team. 