ALTER TABLE userDatasetItem ADD COLUMN itemDatabase varchar (50) ;

ALTER TABLE userDatasetItem ADD COLUMN itemTable varchar (50) ;

ALTER TABLE userDatasetItem ADD COLUMN itemRecord Integer ;

UPDATE userDatasetItem set itemDatabase='vegbank' where itemDatabase is null;

update userDatasetItem set itemTable = itemType where itemtable is null;

UPDATE userDatasetitem set itemRecord=substr(itemACcessionCode,7,-1+position('.' in substr(itemACcessionCode,7,(char_length(itemACcessionCode)-7))))::integer  where itemrecord is null;

ALTER TABLE userDatasetItem ALTER COLUMN itemDatabase SET NOT NULL;

ALTER TABLE userDatasetItem ALTER COLUMN itemTable SET NOT NULL;

ALTER TABLE userDatasetItem ALTER COLUMN itemRecord SET NOT NULL;