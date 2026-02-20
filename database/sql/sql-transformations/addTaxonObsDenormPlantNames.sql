
ALTER TABLE taxonObservation ADD COLUMN int_origPlantConcept_ID Integer  ;

ALTER TABLE taxonObservation ADD COLUMN int_origPlantSciName varchar (255) ;

ALTER TABLE taxonObservation ADD COLUMN int_origPlantSciNameNoAuth varchar (255) ;

ALTER TABLE taxonObservation ADD COLUMN int_origPlantCommon varchar (255) ;

ALTER TABLE taxonObservation ADD COLUMN int_origPlantCode varchar (255) ;

ALTER TABLE taxonObservation ADD COLUMN int_currPlantConcept_ID Integer  ;

ALTER TABLE taxonObservation ADD COLUMN int_currPlantSciName varchar (255) ;

ALTER TABLE taxonObservation ADD COLUMN int_currPlantSciNameNoAuth varchar (255) ;

ALTER TABLE taxonObservation ADD COLUMN int_currPlantCommon varchar (255) ;

ALTER TABLE taxonObservation ADD COLUMN int_currPlantCode varchar (255) ;