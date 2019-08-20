create procedure jomy_order2
as
--exec order2
begin

SELECT c.name,o.id,o.trade_date,o.security,o.buy_or_sell,o.qty,o.rate,o.orderid,o.qty*o.rate as value into #temp FROM jomy_order_details o
join jomy_client_master1 c on c.id=o.id


select  t.id,t.name,t.security,t.trade_date,t.orderid,t.qty,t.rate,t.value as value into tem_1 from #temp t where t.buy_or_sell='b'

select  t.id,t.name,t.security,t.trade_date,t.orderid,t.qty,t.rate,t.value as value into tem_2 from #temp t where t.buy_or_sell='s'

select * from tem_1,tem_2


end