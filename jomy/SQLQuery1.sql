USE [testdb]
GO
/****** Object:  StoredProcedure [dbo].[SPcurrentbill]    Script Date: 05-08-2019 18:23:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SPcurrentbill]
(
@customername varchar(50)='',
@UNIT float

--select * from customer_master
--select * from customer_master
--exec SPcurrentbill 'robinson',175
--exec SPcurrentbill 175
)

AS
	
BEGIN
DECLARE @SLABID INT;
DECLARE @CUSTID INT;
DECLARE @FROM_UNIT INT;
DECLARE @TO_UNIT INT;
DECLARE @RATE float;
DECLARE @AMT float =0;
declare @TEMPUNIT float = @UNIT;
DECLARE @TEMPTA TABLE(CUSTOMERID INT,CUSTOMER_NAME VARCHAR(52),RATE FLOAT,AMOUNT FLOAT)




	DECLARE CUR_FIRST CURSOR FOR SELECT customer_id,slabid from CUSTOMER_MASTER A where A.name=case when @customername='' then A.name else @customername end;
	open CUR_FIRST;
	FETCH NEXT FROM CUR_FIRST INTO @CUSTID,@SLABID 

	WHILE @@FETCH_STATUS=0
		BEGIN
				SET @AMT=0
				SET @UNIT=@TEMPUNIT

			DECLARE CUR_SEC CURSOR FOR SELECT B.FROM_UNIT,B.TO_UNIT,B.RATE FROM slab_master B WHERE slabid=@SLABID ORDER BY from_unit;
			OPEN CUR_SEC;
			FETCH NEXT FROM CUR_SEC INTO @FROM_UNIT,@TO_UNIT,@RATE
			select @SLABID
				WHILE @@FETCH_STATUS=0
				BEGIN
					

															SET @FROM_UNIT= case when (@FROM_UNIT = 0) then 1 else @FROM_UNIT end;
																if @UNIT > (@TO_UNIT-@FROM_UNIT+1)
															begin
																SET @AMT += (@TO_UNIT-@FROM_UNIT+1)*@RATE;
																SET @UNIT -= (@TO_UNIT-@FROM_UNIT+1);
															end
															else
															begin
																SET @AMT += @UNIT*@RATE;
																break;
																
															end
															FETCH NEXT FROM CUR_SEC INTO @FROM_UNIT,@TO_UNIT,@RATE
				 	END

			CLOSE CUR_SEC;
			DEALLOCATE CUR_SEC

			--SELECT A.NAME FROM customer_master A WHERE A.customer_id=@CUSTID
			INSERT INTO @TEMPTA VALUES(@CUSTID,@customername,@TEMPUNIT,@AMT);

			FETCH NEXT FROM CUR_FIRST into @SLABID,@CUSTID;

			CLOSE CUR_FIRST;
			DEALLOCATE CUR_FIRST;

	END
		select * from @TEMPTA;

END;
