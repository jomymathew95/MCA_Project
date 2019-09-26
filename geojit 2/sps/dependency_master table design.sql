create table Dependency_master(slno int identity,dependency varchar(30),client_type char(10),active char(4) DEFAULT 'Y',euser varchar(20),lastupdatedon dateTime DEFAULT GETDATE())

insert into Dependency_master (dependency,client_type,euser) values('Self','I','')
insert into Dependency_master (dependency,client_type,euser) values('Depended Child','I','')
insert into Dependency_master (dependency,client_type,euser) values('Depended parent','I','')
insert into Dependency_master (dependency,client_type,euser) values('Spouse','I','')
insert into Dependency_master (dependency,client_type,euser) values('Director','N','')
insert into Dependency_master (dependency,client_type,euser) values('Partner','N','')
insert into Dependency_master (dependency,client_type,euser) values('Trustee','N','')
insert into Dependency_master (dependency,client_type,euser) values('Authorised person','N','')
/*
Self, Depended Child, Depended parent & Spouse 
Director/Partner/Trustee/ Authorised person
DEFAULT 'Y'


*/