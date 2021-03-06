
ALTER procedure jomy_order1
as
--exec jomy_order1
begin


declare @t_result table(id int ,name varchar(25) ,security varchar(25) ,buy_date date ,buy_orderno int ,buy_qty int ,buy_rate float ,buy_value float ,
		sell_date date ,sell_orderno int, sell_qty int, sell_rate float, sell_value float,p_l float)

--
declare @balance float
declare @buy_qty int
declare @sell_qty int
declare @b_id int
declare @name varchar(25)
declare @t_security varchar(25)
declare @buy_date date
declare @buy_orderno int
declare @buy_rate float
declare @sell_date date
declare @sell_orderno int
declare @sell_rate float
declare @s_id int




SELECT c.name,o.id,o.trade_date,o.security,o.buy_or_sell,o.qty,o.rate,o.orderid into #temp FROM jomy_order_details o
join jomy_client_master1 c on c.id=o.id


select  t.id,t.name,t.security,t.trade_date,t.orderid,t.qty,t.rate,t.buy_or_sell into #tem_1 from #temp t where t.buy_or_sell='b'

select  t.id,t.name,t.security,t.trade_date,t.orderid,t.qty,t.rate,t.buy_or_sell into #tem_2 from #temp t where t.buy_or_sell='s'



select * from #tem_1

select * from #tem_2

--alter table #tem_1 
--alter table #tem_2

 declare buy_cursor cursor for  
  select id,name,security,trade_date,orderid,qty,rate from #tem_1   
  
  open buy_cursor 
  
  declare sell_cursor cursor for  
         select id,trade_date,orderid,qty,rate from #tem_2   
  
  open sell_cursor
  ------------------------------------------------------------------------------------------------- 
  
  fetch next from buy_cursor into @b_id,@name,@t_security,@buy_date,@buy_orderno,@buy_qty,@buy_rate  
 	
  fetch next from sell_cursor into @s_id,@sell_date,@sell_orderno,@sell_qty,@sell_rate  
            
        while @@FETCH_STATUS=0   
        begin  
  
           set @balance = @buy_qty-@sell_qty

		   if @balance > 0
		   begin
				insert into @t_result(id,name,security,buy_date,buy_orderno,buy_qty,buy_rate,sell_date,sell_orderno,sell_qty,sell_rate)  
					values(@b_id,@name,@t_security,@buy_date,@buy_orderno,@buy_qty,@buy_rate,@sell_date,@sell_orderno,@sell_qty,@sell_rate)
				  
             	set @buy_qty = @balance

				fetch next from sell_cursor into @s_id,@sell_date,@sell_orderno,@sell_qty,@sell_rate  
            
			end  
			else if @balance<0
			begin
				insert into @t_result(id,name,security,buy_date,buy_orderno,buy_qty,buy_rate,sell_date,sell_orderno,sell_qty,sell_rate)  
                              values(@b_id,@name,@t_security,@buy_date,@buy_orderno,@buy_qty,@buy_rate,@sell_date,@sell_orderno,@buy_qty,@sell_rate)
				
				fetch next from buy_cursor into @b_id,@name,@t_security,@buy_date,@buy_orderno,@buy_qty,@buy_rate 
				
				set @sell_qty=-1*@balance;
			end
			
	
            else
			begin
				insert into @t_result(id,name,security,buy_date,buy_orderno,buy_qty,buy_rate,sell_date,sell_orderno,sell_qty,sell_rate)  
                              values(@b_id,@name,@t_security,@buy_date,@buy_orderno,@buy_qty,@buy_rate,@sell_date,@sell_orderno,@sell_qty,@sell_rate)
				
				fetch next from sell_cursor into @s_id,@sell_date,@sell_orderno,@sell_qty,@sell_rate

				fetch next from buy_cursor into @b_id,@name,@t_security,@buy_date,@buy_orderno,@buy_qty,@buy_rate
			end            
         end  
           
  
         
           
           
  
         close buy_cursor  
         deallocate buy_cursor  
		 close sell_cursor  
         deallocate sell_cursor


update @t_result set buy_value=(buy_qty*buy_rate),sell_value=(sell_qty*sell_rate)
update @t_result set p_l=(buy_value-sell_value)
select * from @t_result order by id asc,security asc
end