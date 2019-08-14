
ALTER procedure jomy_electric_bill
(

--EXEC jomy_electric_bill 200
	@unit float
)
AS
BEGIN

		
		

		select s.sln,s.slab_id as stable_slab_id,s.from_unit,s.to_unit,s.rate ,c.customer_id,c.name,c.slab_id as ctable_slab_id
		INTO #TEMPTABLE
		from slab_master_new s 
		join 
		customer_master_new c on
		 s.slab_id=c.slab_id

		
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
		FROM #TEMPTABLE AS s GROUP BY customer_id ,s.name 

SELECT * FROM #T
select * from #TEMPTABLE
END