--creates and populates temporary tables in VegBank:
-- MUST START WITH temptbl_ to be ignored by verify script


--handled in model creation!
--DROP TABLE temptbl_std_plantnames;
--CREATE TABLE temptbl_std_plantnames
--(
--PLANTCONCEPT_ID serial ,
--plantname varchar(255), 
--sciname varchar (255),
--scinamenoauth varchar (255),
--code varchar (255),
--common varchar (255),
--PRIMARY KEY ( PLANTCONCEPT_ID )
--);

delete from temptbl_std_plantnames;

INSERT INTO temptbl_std_plantnames (plantConcept_ID, sciname, scinamenoauth,code,common, plantname) 
  SELECT plantConcept_ID, 
  (select (plantname) from view_std_plantnames_sciname as newnames
    WHERE newnames.plantconcept_ID = plantconcept.plantconcept_id limit 1), 
    (select (plantname) from view_std_plantnames_scinamenoauth  as newnames
    WHERE newnames.plantconcept_ID = plantconcept.plantconcept_id limit 1),
    (select (plantname) from view_std_plantnames_code  as newnames
    WHERE newnames.plantconcept_ID = plantconcept.plantconcept_id limit 1),
    (select (plantname) from view_std_plantnames_common  as newnames
    WHERE newnames.plantconcept_ID = plantconcept.plantconcept_id limit 1) , plantname FROM plantConcept;

--populate systems:
--UPDATE temptbl_std_plantnames SET sciname=(select min(plantname) from view_std_plantnames_sciname as newnames
--    WHERE newnames.plantconcept_ID = temptbl_std_plantnames.plantconcept_id);
    
--UPDATE temptbl_std_plantnames SET scinamenoauth=(select min(plantname) from view_std_plantnames_scinamenoauth  as newnames
--    WHERE newnames.plantconcept_ID = plantconcept.plantconcept_id);
    
--UPDATE temptbl_std_plantnames SET code=(select min(plantname) from view_std_plantnames_code  as newnames
--    WHERE newnames.plantconcept_ID = plantconcept.plantconcept_id);
    
--UPDATE temptbl_std_plantnames SET common=(select min(plantname) from view_std_plantnames_common  as newnames
--    WHERE newnames.plantconcept_ID = plantconcept.plantconcept_id);
    
--get any that aren't std:
UPDATE temptbl_std_plantnames SET sciname=(select min(plantname) from view_all_plantnames_sciname as newnames
    WHERE newnames.plantconcept_ID = temptbl_std_plantnames.plantconcept_id) WHERE sciname is null;
    
UPDATE temptbl_std_plantnames SET scinamenoauth=(select min(plantname) from view_all_plantnames_scinamenoauth  as newnames
    WHERE newnames.plantconcept_ID = temptbl_std_plantnames.plantconcept_id) WHERE scinamenoauth is null;
    
-- not code, that leaves only to USDA : UPDATE temptbl_std_plantnames SET code=(select min(plantname) from view_all_plantnames_code  as newnames
--    WHERE newnames.plantconcept_ID = temptbl_std_plantnames.plantconcept_id) WHERE code is null;
    
UPDATE temptbl_std_plantnames SET common=(select min(plantname) from view_all_plantnames_common  as newnames
    WHERE newnames.plantconcept_ID = temptbl_std_plantnames.plantconcept_id) WHERE common is null;
    
    
    
    

-- HANDLED ELSEWHERE!
--DROP TABLE temptbl_std_commnames;
--CREATE TABLE temptbl_std_commnames
--(
--COMMCONCEPT_ID serial ,
--sciname varchar (255),
--translated varchar (255),
--code varchar (255),
--common varchar (255),
--PRIMARY KEY ( commCONCEPT_ID )
--);

delete from temptbl_std_commnames;

INSERT INTO temptbl_std_commnames (commConcept_ID, sciname, translated,code,common) 
  SELECT commConcept_ID, 
  (select (commname) from view_std_commnames_sciname as newnames
    WHERE newnames.commconcept_ID = commconcept.commconcept_id limit 1), 
    (select (commname) from view_std_commnames_translated  as newnames
    WHERE newnames.commconcept_ID = commconcept.commconcept_id limit 1),
    (select (commname) from view_std_commnames_code  as newnames
    WHERE newnames.commconcept_ID = commconcept.commconcept_id limit 1),
    (select (commname) from view_std_commnames_common  as newnames
    WHERE newnames.commconcept_ID = commconcept.commconcept_id limit 1) FROM commConcept ;

--populate systems:
--UPDATE temptbl_std_commnames SET sciname=(select min(commname) from view_std_commnames_sciname as newnames
--    WHERE newnames.commconcept_ID = temptbl_std_commnames.commconcept_id);
    
--UPDATE temptbl_std_commnames SET translated=(select min(commname) from view_std_commnames_translated  as newnames
--    WHERE newnames.commconcept_ID = commconcept.commconcept_id);
    
--UPDATE temptbl_std_commnames SET code=(select min(commname) from view_std_commnames_code  as newnames
--    WHERE newnames.commconcept_ID = commconcept.commconcept_id);
    
--UPDATE temptbl_std_commnames SET common=(select min(commname) from view_std_commnames_common  as newnames
--    WHERE newnames.commconcept_ID = commconcept.commconcept_id);
    
--get any that aren't std:
UPDATE temptbl_std_commnames SET sciname=(select min(commname) from view_all_commnames_sciname as newnames
    WHERE newnames.commconcept_ID = temptbl_std_commnames.commconcept_id) WHERE sciname is null;
    
UPDATE temptbl_std_commnames SET translated=(select min(commname) from view_all_commnames_translated  as newnames
    WHERE newnames.commconcept_ID = temptbl_std_commnames.commconcept_id) WHERE translated is null;
    
UPDATE temptbl_std_commnames SET code=(select min(commname) from view_all_commnames_code  as newnames
   WHERE newnames.commconcept_ID = temptbl_std_commnames.commconcept_id) WHERE code is null;
    
UPDATE temptbl_std_commnames SET common=(select min(commname) from view_all_commnames_common  as newnames
    WHERE newnames.commconcept_ID = temptbl_std_commnames.commconcept_id) WHERE common is null;