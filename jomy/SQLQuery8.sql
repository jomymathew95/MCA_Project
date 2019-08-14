ALTER PROCEDURE BILL_GO1
(
@CUSTID INT,
@UNIT FLOAT

--EXEC BILL_GO1 175
)

AS
BEGIN
DECLARE @IID INT
--DECLARE @CUSTOM_ID INT
--DECLARE @AMOUNT FLOAT
--DECLARE @BILL_datee varchar(50)=GETDATE();
--declare @rent int=20
--declare @ggst FLOAT
--DECLARE @bill_amt FLOAT


--select a.slabid,a.customer_id from customer_master a where 
--		a.name = case when @customer_name = '' then a.name else @customer_name end;





	--SELECT CASE WHEN
	-- @CUSTID='' 
	-- THEN 
	--	SELECT C.CUSTOMER_ID= FROM customer_master_new C
	--  ELSE 
	--	@CUSTID=@CUSTID
		
		select s.sln,s.slab_id as stable_slab_id,s.from_unit,s.to_unit,s.rate ,c.customer_id,c.name,c.slab_id as ctable_slab_id
		INTO #TEMPTABLE
		from slab_master_new s 
		join 
		customer_master_new c on
		 s.slab_id=c.slab_id

	SELECT * FROM #TEMPTABLE
		-- SELECT @IID=s.slab_id FROM #TEMPTABLE S 

		
		SELECT s.customer_id as cus_id, 
			 SUM(CASE
				 when (@unit>s.to_unit)
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
--select @bill_amt,@BILL_datee,@rent,@ggst #TEMP_BILL  

--SELECT 

--insert into BILL_TABLE_GO(BILL_AMOUNT,LAST_UPDATE,METER_RENT,GST) values()




		 





END


