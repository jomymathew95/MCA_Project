

--exec jomy_order3


alter procedure jomy_order3
as
begin


declare @id_buy int
declare @name_buy varchar(25)
declare @security_buy varchar(20)
declare @trade_date_buy date
declare @orderid_buy int
declare @qty_buy int
declare @rate_buy float

declare @id_sell int
declare @name_sell varchar(25)
declare @security_sell varchar(20)
declare @trade_date_sell date
declare @orderid_sell int
declare @qty_sell int
declare @rate_sell float

declare @bal float

declare @result table(id int,name varchar(20),security varchar(20),buy_date date,buy_order_no int,buy_qty int,buy_rate float,buy_value float,
sell_date date,sell_order_no int,sell_qty int,sell_rate float,sell_value float,P_L float)



SELECT c.name,o.id,o.trade_date,o.security,o.buy_or_sell,o.qty,o.rate,o.orderid into #temp FROM jomy_order_details o
join jomy_client_master1 c on c.id=o.id


select  t.id,t.name,t.security,t.trade_date,t.orderid,t.qty,t.rate,t.buy_or_sell into #tem_1 from #temp t where t.buy_or_sell='b'

select  t.id,t.name,t.security,t.trade_date,t.orderid,t.qty,t.rate,t.buy_or_sell into #tem_2 from #temp t where t.buy_or_sell='s'

--select * from #tem_1

--select * from #tem_2


declare tem_1_cursor cursor for 
select  t.id,t.name,t.security,t.trade_date,t.orderid,t.qty,t.rate from #tem_1 t
open tem_1_cursor

	declare tem_2_cursor cursor for 
	select  t2.id,t2.name,t2.security,t2.trade_date,t2.orderid,t2.qty,t2.rate from #tem_2 t2
	open tem_2_cursor


	fetch next from tem_1_cursor into @id_buy,@name_buy,@security_buy,@trade_date_buy,@orderid_buy,@qty_buy,@rate_buy

	fetch next from tem_2_cursor into @id_sell,@name_sell,@security_sell,@trade_date_sell,@orderid_sell,@qty_sell,@rate_sell
			while @@FETCH_STATUS=0
			begin

				set @bal=@qty_buy-@qty_sell

				if(@bal>0)

					begin

					insert into @result (id,name ,security ,buy_date ,buy_order_no ,buy_qty ,buy_rate,
					sell_date,sell_order_no,sell_qty ,sell_rate )
					values(@id_buy,@name_buy,@security_buy,@trade_date_buy,@orderid_buy,@qty_buy,@rate_buy,@trade_date_sell,@orderid_sell,@qty_sell,@rate_sell)

					set @qty_buy=@bal

					fetch next from tem_2_cursor into @id_sell,@name_sell,@security_sell,@trade_date_sell,@orderid_sell,@qty_sell,@rate_sell
					end
				else if(@bal<0)

					begin

					insert into @result (id,name ,security ,buy_date ,buy_order_no ,buy_qty ,buy_rate,
					sell_date,sell_order_no,sell_qty ,sell_rate )
					values(@id_buy,@name_buy,@security_buy,@trade_date_buy,@orderid_buy,@qty_buy,@rate_buy,@trade_date_sell,@orderid_sell,@qty_buy,@rate_sell)

					fetch next from tem_1_cursor into @id_buy,@name_buy,@security_buy,@trade_date_buy,@orderid_buy,@qty_buy,@rate_buy

					set @qty_sell=-1*@bal
					end
				else

					begin

					insert into @result (id,name ,security ,buy_date ,buy_order_no ,buy_qty ,buy_rate,
					sell_date,sell_order_no,sell_qty ,sell_rate )
					values(@id_buy,@name_buy,@security_buy,@trade_date_buy,@orderid_buy,@qty_buy,@rate_buy,@trade_date_sell,@orderid_sell,@qty_sell,@rate_sell)


				   fetch next from tem_1_cursor into @id_buy,@name_buy,@security_buy,@trade_date_buy,@orderid_buy,@qty_buy,@rate_buy

	               fetch next from tem_2_cursor into @id_sell,@name_sell,@security_sell,@trade_date_sell,@orderid_sell,@qty_sell,@rate_sell

					end



			end
		 close tem_1_cursor  
         deallocate tem_1_cursor  
		 close tem_2_cursor  
         deallocate tem_2_cursor

update @result set buy_value=buy_qty*buy_rate,sell_value=sell_qty*sell_rate
update @result set p_l=buy_value-sell_value

select * from @result

end