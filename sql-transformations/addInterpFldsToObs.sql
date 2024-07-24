
ALTER TABLE observation ADD COLUMN interp_orig_ci_ID Integer ;

ALTER TABLE observation ADD COLUMN interp_orig_cc_ID Integer ;

ALTER TABLE observation ADD COLUMN interp_orig_sciname text ;

ALTER TABLE observation ADD COLUMN interp_orig_code text ;

ALTER TABLE observation ADD COLUMN interp_orig_party_id Integer ;

ALTER TABLE observation ADD COLUMN interp_orig_partyname text ;

ALTER TABLE observation ADD COLUMN interp_current_ci_ID Integer ;

ALTER TABLE observation ADD COLUMN interp_current_cc_ID Integer ;

ALTER TABLE observation ADD COLUMN interp_current_sciname text ;

ALTER TABLE observation ADD COLUMN interp_current_code text ;

ALTER TABLE observation ADD COLUMN interp_current_party_id Integer ;

ALTER TABLE observation ADD COLUMN interp_current_partyname text ;

ALTER TABLE observation ADD COLUMN interp_bestfit_ci_ID Integer ;

ALTER TABLE observation ADD COLUMN interp_bestfit_cc_ID Integer ;

ALTER TABLE observation ADD COLUMN interp_bestfit_sciname text ;

ALTER TABLE observation ADD COLUMN interp_bestfit_code text ;

ALTER TABLE observation ADD COLUMN interp_bestfit_party_id Integer ;

ALTER TABLE observation ADD COLUMN interp_bestfit_partyname text ;