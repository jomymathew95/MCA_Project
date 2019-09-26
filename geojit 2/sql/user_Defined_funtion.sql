 
 
 
 ---functions------

 select * from temp


alter function emp(@emp_id int)
 returns  float

 begin
			 declare @sal float

		

			 set @sal= (select t.net_salary from temp t where t.sal_date in (select max(t.sal_date) from temp t where t.emp_id=@emp_id) and t.emp_id=@emp_id)

			

			 return @sal
 end
 -- select * from temp where net_salary=emp()
