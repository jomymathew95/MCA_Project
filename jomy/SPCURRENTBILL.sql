
select * from customer_master
select * from slab_master

ALTER procedure SPcurrentbill
(
@UNIT INT,
@customername varchar(50)=''
)

AS
	
BEGIN
DECLARE @sladid INT;
DECLARE @customer_id INT;
DECLARE @FROMUNIT INT;
DECLARE @TOUNIT INT;
DECLARE @RATE INT;
DECLARE @AMT INT =0;



		SELECT @sladid=A.slabid,@customer_id=A.customer_id FROM customer_master A WHERE @customername=A.name

		DECLARE ROW_CURSOR1 CURSOR FOR SELECT B.from_unit,B.to_unit,B.rate FROM slab_master B WHERE B.slabid=@sladid;
		OPEN ROW_CURSOR1;
		FETCH NEXT FROM ROW_CURSOR1 INTO @FROMUNIT,@TOUNIT,@RATE;
WHILE @@FETCH_STATUS=0
		begin
		
		SET @fromunit= case when (@fromunit = 0) then 1 else @fromunit end;
		--select @tounit-@fromunit+1;

								if @UNIT > (@tounit-@fromunit+1)
								begin
									SET @amT += (@tounit-@fromunit+1)*@rate;
									SET @unit -= (@tounit-@fromunit+1);
								end
								else
								begin
									SET @amT += @UNIT*@rate;
									break;
								end

		fetch next from ROW_CURSOR1 into @fromunit,@tounit,@rate;
	end

close ROW_CURSOR1;
	deallocate ROW_CURSOR1;
	

END
select @customerid as CustomerId, @customer_name as CustomerName, @cu as Unit, @amount as bill; 


EXEC SPcurrentbill 175,'ALBERT'