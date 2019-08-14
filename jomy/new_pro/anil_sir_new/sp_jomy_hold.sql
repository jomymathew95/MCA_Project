

alter procedure jomy_hold

--exec jomy_hold


--select * from jomy_AMC_slab
--select * from jomy_holding
--select * from jomy_client_master
as 
begin


select c.clientid,c.client_name,h.holding,s.description,s.H_G_C,s.H into #temp from jomy_client_master c
join 
jomy_holding h
on c.clientid=h.clientid
join 
jomy_AMC_slab s
on
c.AMC_SLAB=s.id




ALTER TABLE #temp ADD amc float
ALTER TABLE #temp ADD servic float
ALTER TABLE #temp ADD tot float

update #temp set amc=case when (holding>200000) then t.h else t.H_G_C end from #temp t

update #temp set servic=(amc*12.5)/100 from #temp

update #temp set tot=(amc+servic) from #temp


insert into result(clientid,client_name,holding,amc_slab_desc,amc_charge,service_charge,total_charge)
select t.clientid,t.client_name,t.holding,t.description,t.amc,t.servic,t.tot
From #temp t



select * from result



end
