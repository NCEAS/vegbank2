-- $Id: create_extras.sql,v 1.6 2006-06-29 04:27:16 mlee Exp $
-- 
-- Runs extra SQL on the data model after it is created to make things as they need to be
-- CHIEFLY default values and extra things like custom sequences
-- POPULATION of tables is NOT handled here, neither are triggers
--  NO TABLES ARE CREATED HERE -- they should all be created from db_model_vegbank.xml !

-- default values moved to main db model document, as were sequences, so there's nothing left that's needed here.