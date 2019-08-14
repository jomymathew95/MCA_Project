ALTER procedure [dbo].[SPcurrentbill]
(
@UNIT float,
@customername varchar(50)=''

--select * from customer_master
--select * from slab_master  c
--exec SPcurrentbill 175,'robinson'
--exec SPcurrentbill 1750
)

AS
	
BEGIN
DECLARE @slabid INT;
DECLARE @customer_id INT;
DECLARE @FROMUNIT INT;
DECLARE @TOUNIT INT;
DECLARE @RATE float;
DECLARE @AMT float =0;
declare @customer_unit float = @UNIT;
declare @temptable table(Customer__ID int,Custonmer__name varchar(50),Unit_Used float,Total_amount float);




	DECLARE name_cursor CURSOR FOR SELECT a.slabid,a.customer_id FROM customer_master a WHERE a.name = case when @customername = '' then a.name else @customername end; 
	open name_cursor;
FETCH NEXT FROM name_cursor INTO @slabid,@customer_id;
			while @@FETCH_STATUS = 0
			BEGIN 
									set @AMT = 0;
									set @UNIT = @customer_unit;
						---------------------
	

								DECLARE ROW_CURSOR1 CURSOR FOR SELECT B.from_unit,B.to_unit,B.rate FROM slab_master B WHERE B.slabid=@slabid order by from_unit;
								OPEN ROW_CURSOR1;
	FETCH NEXT FROM ROW_CURSOR1 INTO @FROMUNIT,@TOUNIT,@RATE;
														WHILE @@FETCH_STATUS=0
															begin
																
																													--SET @FROMUNIT= case when (@FROMUNIT = 0) then 1 else @FROMUNIT end;
												if																	--		if @UNIT > (@TOUNIT-@FROMUNIT+1)
																													--	begin
																													--		SET @AMT += (@TOUNIT-@FROMUNIT+1)*@RATE;
																													--		SET @UNIT -= (@TOUNIT-@FROMUNIT+1);
																													--end
																													--	else
																													--	begin
																													--		SET @AMT += @UNIT*@RATE;
																													--		break;
																													--	end

																								
		
FETCH NEXT FROM ROW_CURSOR1 into @FROMUNIT,@TOUNIT,@RATE;
														end

						close ROW_CURSOR1;
						deallocate ROW_CURSOR1;
	
						
						select @customername=a.name from customer_master a where a.customer_id = @customer_id;
									insert into @temptable values(@customer_id,@customername,@customer_unit,@AMT);



fetch next from name_cursor into @slabid,@customer_id;
							end
							close name_cursor;
							deallocate name_cursor;


							select * from @temptable;
END