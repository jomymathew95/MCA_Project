 
 
 
 ---functions------

 select * from temp

 select t.net_salary from temp t where t.sal_date =(select max(t.sal_date) from temp t where t.emp_id=1) order by t.sal_date)

 select max(t.sal_date) from temp t where t.emp_id=1
 create function emp(@emp_id int)
 returns  date

 begin
			 declare @sal date

			

			-- SELECT @sal_Date=t.sal_date FROM temp t WHERE t.emp_id=@emp_id

			 set @sal=select t.net_salary from temp where t.sal_date =(select max(t.sal_date) from temp t where t.emp_id=@emp_id)

			

			 return @sal
 end

 select * from emp()