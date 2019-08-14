USE [testdb]
GO
/****** Object:  StoredProcedure [dbo].[BILL_GO1]    Script Date: 07-08-2019 16:41:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BILL_GO1]
(
@UNIT FLOAT
--EXEC BILL_GO1 100
--select * from slab_master_new
--select * from customer_master_new
--select * from BILL_TABLE_GO
--
)

AS
BEGIN
DECLARE @CUSTOM_ID INT
DECLARE @AMOUNT FLOAT
DECLARE @BILL varchar(50)=GETDATE();



--select @UNIT=unit_used from BILL_TABLE_GO order by CUSTOMER_ID

		select s.sln,s.slab_id as stable_slab_id,s.from_unit,s.to_unit,s.rate ,c.customer_id,c.name,c.slab_id as ctable_slab_id
		INTO #TEMPTABLE
		from slab_master_new s 
		 join 
		customer_master_new c on
		 s.slab_id=c.slab_id

		SELECT s.customer_id as cus_id, 
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
		GROUP BY customer_id 

SELECT * FROM #T



------------------------------------------------------------------------------------



	select B.bill_no,c.cus_id,c.TOTAL,B.Unit_used,B.meter_rent
	into #new_temp
	from #T c
	join 
	BILL_TABLE_GO B
	on 
	c.cus_id=B.CUSTOMER_ID

	--select * from #new_temp order by BILL_NO

	SELECT B.bill_no,b.cus_id,b.TOTAL,B.Unit_used,B.meter_rent,
	CAST(NULL AS float) AS gst,CAST(NULL AS float) AS ttotal
INTO   #TEMP2
FROM #new_temp b

--select * from #TEMP2

select t.bill_no,t.cus_id,t.TOTAL,t.Unit_used,t.meter_rent,(t.TOTAL+t.METER_RENT) as ttotal into #temp3 from #TEMP2 t
select a.bill_no,a.cus_id,a.TOTAL,a.Unit_used,a.meter_rent,a.ttotal,((a.ttotal*18)/100) as gst into #temp4 from #temp3 a
select a.bill_no,a.cus_id,a.TOTAL,a.Unit_used,a.meter_rent,a.ttotal,a.gst,(a.ttotal+a.gst) as Bill_Amount,@BILL as Updated_date into #temp5 from #temp4 a
select * from #temp5

select * from slab_master_new
select * from customer_master_new




END










