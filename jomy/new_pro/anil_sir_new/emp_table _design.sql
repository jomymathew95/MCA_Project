create table jomy_manager(Manager int,Name varchar(25))

create table jomy_employe(empid int,empname varchar(25),managerid int,sales int,emp_PriBC float,emp_PerBC float,Manager_com float)

insert into jomy_manager(Manager,Name)values(10001,'Manager1')
insert into jomy_manager(Manager,Name)values(10002,'Manager2')
insert into jomy_manager(Manager,Name)values(10003,'Manager3')
insert into jomy_manager(Manager,Name)values(10004,'Manager4')

insert into jomy_employe(empid,empname,managerid,sales)values(1,'empname1',10001,700000)

insert into jomy_employe(empid,empname,managerid,sales)values(2,'empname2',10003,100000)

insert into jomy_employe(empid,empname,managerid,sales)values(3,'empname3',10004,500000)

insert into jomy_employe(empid,empname,managerid,sales)values(4,'empname4',10001,800000)

insert into jomy_employe(empid,empname,managerid,sales)values(5,'empname5',10004,100000)

insert into jomy_employe(empid,empname,managerid,sales)values(6,'empname6',10003,50000)

insert into jomy_employe(empid,empname,managerid,sales)values(7,'empname7',10002,50500)

insert into jomy_employe(empid,empname,managerid,sales)values(8,'empname8',10002,200000)


select * from jomy_employe
select * from jomy_manager





create procedure jomy_commission
--(
--exec jomy_commission
--)
AS
BEGIN

declare @empprice float
declare @c float

select e.empid,e.empname,e.managerid,e.sales,e.emp_PriBC,e.emp_PerBC,e.Manager_com,m.name into #temp1
from jomy_employe e
join jomy_manager m
on
e.managerid=m.Manager


--set @empprice=
update #temp1 set emp_PriBC=((t.sales/10000)*100) from #temp1 t
update #temp1 set emp_PerBC=((sales*20)/100) from #temp1  t where t.sales>200000
update #temp1 set Manager_com=((t.emp_PerBC*10)/100)+((t.emp_PriBC*15)/100) from #temp1 t


update jomy_employe
set
jomy_employe.emp_PriBC=#temp1.emp_PriBC,
jomy_employe.emp_perbc=#temp1.emp_perbc,
jomy_employe.Manager_com=#temp1.Manager_com
from
#temp1 
where #temp1.empid=jomy_employe.empid

select * from jomy_employe




end

