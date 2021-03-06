USE [testdb]
GO
/****** Object:  StoredProcedure [dbo].[jomy_electric_bill]    Script Date: 08-08-2019 09:37:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[jomy_electric_bill]
(
-- EXEC jomy_electric_bill 375,0
-- EXEC jomy_electric_bill 375,''

-- EXEC jomy_electric_bill 375
-- EXEC jomy_electric_bill 100,1
-- EXEC jomy_electric_bill 101,2
-- EXEC jomy_electric_bill 151,1
-- EXEC jomy_electric_bill 1000
-- EXEC jomy_electric_bill 900,1

	@unit float,
	@cu_id int=''
)
AS
BEGIN
declare @cu int

		
		

		select s.sln,s.slab_id as stable_slab_id,s.from_unit,s.to_unit,s.rate ,c.customer_id,c.name,c.slab_id as ctable_slab_id
		INTO #TEMPTABLE
		from slab_master_new s 
		join 
		customer_master_new c on
		 s.slab_id=c.slab_id
		where c.customer_id=case when (@cu_id='' Or @cu_id='0') then c.customer_id else @cu_id end 

		--- select * from #TEMPTABLE

		--select @cu_id as cus_id where s.customer_id =(case when @cu_id=0 then s.customer_id else @cu_id end),s.name as cust_name,
		SELECT s.customer_id as cus_id,s.name as cust_name,
			 SUM(CASE
				 when (@unit>=s.to_unit)
				 then
					(s.to_unit-s.from_unit)*s.rate
				
				 when @unit>s.from_unit and @unit<s.to_unit 
				 then
					(@unit-s.from_unit)*s.rate
				 else 0 
			 end) AS TOTAL
			 INTO #T
		FROM #TEMPTABLE AS s 
		GROUP BY customer_id ,s.name
        Order BY customer_id ,s.name

SELECT * FROM #T
--select t.cus_id into #temp from #T t
--select * from #temp

--select t.cus_id,t.cust_name,t.TOTAL from #T t where t.cus_id=
--case
-- when (@cu_id='' Or @cu_id='0') 
-- then  
-- t.cus_id
-- else 
-- @cu_id
--  end

--select * from #TEMPTABLE
END