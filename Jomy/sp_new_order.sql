USE [testdb]
GO
/****** Object:  StoredProcedure [dbo].[jomy_order2]    Script Date: 8/19/2019 5:52:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[jomy_order]
as
--exec jomy_order
begin

declare @qty_c int
declare @q_in_c int
declare @id int
declare @name varchar(25)
declare @security varchar(20)
declare @trade_date date
declare @orderid int
declare @qty int
declare @rate float
declare @value float
declare @b_s varchar(10)
declare @t_result table(id int ,name varchar(25) ,security varchar(25) ,buy_date date ,buy_orderno int ,buy_qty int ,buy_rate float ,buy_value float ,
		sell_date date ,sell_orderno int, sell_qty int, sell_rate float, sell_value float,p_l float)
declare @id_in int
declare @name_in varchar(25)
declare @security_in varchar(20)
declare @trade_date_in date
declare @orderid_in int
declare @qty_in int
declare @rate_in float
declare @value_in float
declare @b_s_in varchar(10)
declare @check_qty int



SELECT c.name,o.id,o.trade_date,o.security,o.buy_or_sell,o.qty,o.rate,o.orderid into #temp FROM jomy_order_details o
join jomy_client_master1 c on c.id=o.id


select  t.id,t.name,t.security,t.trade_date,t.orderid,t.qty,t.rate,t.buy_or_sell into #tem_1 from #temp t where t.buy_or_sell='b'

select  t.id,t.name,t.security,t.trade_date,t.orderid,t.qty,t.rate,t.buy_or_sell into #tem_2 from #temp t where t.buy_or_sell='s'

--select * from #tem_1

--select * from #tem_2



declare tem_1_cur cursor for select t1.id,t1.name,t1.security,t1.trade_date,t1.orderid,t1.qty,t1.rate,t1.buy_or_sell from #tem_1 t1
open tem_1_cur
fetch next from tem_1_cur into @id, @name,@security ,@trade_date,@orderid,@qty,@rate,@b_s


 while @@FETCH_STATUS=0
	begin


		

							declare tem_2_cur cursor for select t2.id,t2.name,t2.security,t2.trade_date,t2.orderid,t2.qty,t2.rate,t2.buy_or_sell from #tem_2 t2
							open tem_2_cur
							fetch next from tem_2_cur into @id_in, @name_in,@security_in ,@trade_date_in,@orderid_in,@qty_in,@rate_in,@b_s_in
							while @@FETCH_STATUS=0
										begin
										/*
										insert into @t_result(id ,name ,security ,buy_date ,buy_orderno  ,buy_qty ,buy_rate  ,
										sell_date ,sell_orderno , sell_qty , sell_rate  ) values
										(@id, @name,@security ,@trade_date ,@orderid ,@qty ,@rate ,@trade_date_in ,@orderid_in ,@qty_in ,@rate_in )

*/

						              if (@qty>=@qty_in)
											begin
											
										insert into @t_result(id ,name ,security ,buy_date ,buy_orderno  ,buy_qty ,buy_rate  ,
										sell_date ,sell_orderno , sell_qty , sell_rate  ) values
										(@id, @name,@security ,@trade_date ,@orderid ,@qty ,@rate ,@trade_date_in ,@orderid_in ,@qty_in ,@rate_in )

										set @qty=@qty-@qty_in

									       end

									--if (@qty>=@qty_in)
									--		begin
									--			set @qty=@qty-@qty_in


												
									--		end

									else if (@qty<@qty_in)
										
										begin

										
													set @qty_c=@qty_in
													--set @q_in_c=@qty_c-@qty

													

												insert into @t_result(id ,name ,security ,buy_date ,buy_orderno  ,buy_qty ,buy_rate  ,
													sell_date ,sell_orderno , sell_qty , sell_rate  ) values
													(@id, @name,@security ,@trade_date ,@orderid ,@qty ,@rate ,@trade_date_in ,@orderid_in ,@qty ,@rate_in )

													set @qty=@qty_c

													fetch next from tem_1_cur into @id, @name,@security ,@trade_date,@orderid,@qty,@rate,@b_s
													--print @qty
												
									
													

													
										end
	
													
											
												fetch next from tem_2_cur into @id_in, @name_in,@security_in ,@trade_date_in,@orderid_in,@qty_in,@rate_in,@b_s_in
										end
			
												close tem_2_cur
												deallocate tem_2_cur

		fetch next from tem_1_cur into @id, @name,@security ,@trade_date,@orderid,@qty,@rate,@b_s
	end
	
	close tem_1_cur												
   deallocate tem_1_cur


update @t_result set buy_value=(buy_qty*buy_rate),sell_value=(sell_qty*sell_rate)
update @t_result set p_l=(buy_value-sell_value)
select * from @t_result
end