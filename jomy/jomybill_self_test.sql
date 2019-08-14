ALTER procedure e_bill
(
@customername varchar(50),
@unit float
)

--SELECT * FROM CUSTOMER_MASTER
--SELECT * FROM SLAB_MASTER
--EXEC E_BILL 'EDWIN',175
--EXEC E_BILL 'albert',175
--EXEC E_BILL 175
AS
BEGIN

	DECLARE @CUSTID INT
	DECLARE @SLABID INT
	DECLARE @AMT FLOAT=0
	DECLARE @TEMPUNIT INT=@unit
	DECLARE @FROM_UNIT INT
	DECLARE @TO_UNIT INT
	DECLARE @RATE FLOAT
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
