--create table that stores a list of newly requested accession codes, but these elements aren't in the db yet:
drop table dba_preassignacccode;
create table dba_preassignacccode (
  dba_preassignacccode_id serial, 
  dba_requestnumber int not null, 
  databasekey varchar(20) not null, 
  tableabbrev varchar(10) not null, 
  confirmcode varchar(70) not null, 
  accessioncode varchar(100), 
  primary key (dba_preassignacccode_id)
  );

-- create a unique sequence that feeds the dba_requestnumber field:
drop sequence dba_preassignacccode_dba_requestnumber_seq;
create sequence dba_preassignacccode_dba_requestnumber_seq;
 
 -- set the default value for confirm code
 alter table dba_preassignacccode alter column confirmcode set default (replace(replace(replace(replace(now(),' ','T'),'-',''),':',''),'.','d') || 'R' || floor(random()*1000000));
 
 --we need a one row table for getting the sequence value:
 drop table dba_onerow;
 create table dba_onerow (
   dba_onerow_id int,
   primary key (dba_onerow_id)
   );
   
 --populate dba_onerow (just one empty row of data):  
 insert into dba_onerow (dba_onerow_id) values (1);
