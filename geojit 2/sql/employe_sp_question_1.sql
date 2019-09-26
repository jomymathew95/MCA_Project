alter procedure employee1
(
--exec employee1 '20100501'
@salary_date date

)
as
begin

select * from temp

select t.emp_name,t.dept_name,t.net_salary from temp t where t.sal_date=@salary_date


end