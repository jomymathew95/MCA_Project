alter procedure jomy_commission
--(
--exec jomy_commission
--)
AS
BEGIN

declare @empprice float
declare @c float
declare @TEMP5 table (man int)

select e.empid,e.empname,e.managerid,e.sales,e.emp_PriBC,e.emp_PerBC,e.Manager_com,m.name into #temp1
from jomy_employe e
join jomy_manager m
on
e.managerid=m.Manager




update #temp1 set emp_PriBC=((t.sales/10000)*100) from #temp1 t
update #temp1 set emp_PerBC=((sales*20)/100) from #temp1  t where t.sales>200000

select t.empid,t.empname,t.managerid,t.sales,t.emp_PriBC,isnull(t.emp_PerBC,0)as emp_PerBC,isnull(t.Manager_com,0)as Manager_com into #temp7 from #temp1 t

update #temp7 set Manager_com=((emp_PriBC*10)/100)+((emp_PerBC*20)/100) from #temp7



update jomy_employe
set
jomy_employe.emp_PriBC=#temp7.emp_PriBC,
jomy_employe.emp_perbc=#temp7.emp_perbc,
jomy_employe.Manager_com=#temp7.Manager_com
from
#temp7 
where #temp7.empid=jomy_employe.empid

select * from jomy_employe




end

