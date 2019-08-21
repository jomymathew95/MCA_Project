



/*


select * from jomy_emp_master
select * from jomy_dept
select * from jomy_salary_pay


*/




select em.emp_id ,em.emp_name ,em.join_date ,em.salary ,em.sex ,em.dept as dept_id ,d.dept_name, d.active ,s.sal_date,s.drawnsalary,s.pf,s.drawnsalary-s.pf as net_salary 
into #temp from  jomy_emp_master em
join 
jomy_dept d on em.dept=d.dept_id
join
jomy_salary_pay s on em.emp_id=s.emp_id

drop table #temp

select * from #temp


--1-----


select t.emp_name,t.dept_name,t.net_salary  from #temp t

--2---

SELECT top 1 t.dept_name, sum(t.net_salary)as maximum_salary  FROM #temp t  GROUP BY t.dept_name order by maximum_salary desc

--3----

SELECT DISTINCT  t.emp_id,t.emp_name  from #temp t where t.emp_name like 's%'

--4---

select distinct t.dept_name,t.emp_name,t.emp_id  from  #temp t where t.sex='m'

--5-- 

select distinct top 3 t.emp_id,t.emp_name,t.pf from #temp t order by t.pf desc

--6--

SELECT top 1 t.emp_id,t.emp_name,(t.net_Salary)as maximum_salary  FROM  #temp t group by t.emp_id,t.emp_name,t.net_salary

--7--

select distinct t.emp_id,t.emp_name,t.join_date from #temp t where t.join_date>'2008-02-01'

select  count(distinct t.emp_id)as count from #temp t where t.join_date>'2008-02-01'

--8--

select distinct t.emp_id,t.emp_name,t.join_date from #temp t where t.emp_name in(select t1.emp_name from jomy_emp_master t1 
 group by t1.emp_name having count(t1.emp_name)>1 )

 --9--error
select * from #temp
 select t.dept_name,avg(t.net_salary) from #temp t group by t.dept_name

 --10--

 select t.emp_id,t.emp_name,sal_date
  from #temp t 
  where t.sal_date='2010-05-01' 
  and t.emp_id not in(select t.emp_id from #temp t where t.sal_date='2010-06-01')

















