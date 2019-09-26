
/*create table jomy_emp_master(emp_id int,emp_name varchar(25),join_date date,salary float,sex varchar(10),dept int)

create table jomy_dept(dept_id int,dept_name varchar(25),active varchar(10))

create table jomy_salary_pay(emp_id int,sal_date date,drawnsalary float,pf float)

drop table jomy_emp_master
drop table jomy_dept
drop table jomy_salary_pay


insert into jomy_emp_master(emp_id,emp_name,join_date,salary,sex,dept)values(1,'jobi','2016-03-01',30000,'M',1)
insert into jomy_emp_master(emp_id,emp_name,join_date,salary,sex,dept)values(2,'subin','2008-12-01',20000,'M',1)
insert into jomy_emp_master(emp_id,emp_name,join_date,salary,sex,dept)values(3,'jobi','2009-04-01',25000,'M',1)
insert into jomy_emp_master(emp_id,emp_name,join_date,salary,sex,dept)values(4,'anoop','2007-06-01',28000,'M',2)
insert into jomy_emp_master(emp_id,emp_name,join_date,salary,sex,dept)values(5,'reshmi','2009-09-01',18000,'f',3)
insert into jomy_emp_master(emp_id,emp_name,join_date,salary,sex,dept)values(6,'babu','2008-09-01',23000,'M',2)


insert into jomy_dept (dept_id,dept_name,active) values(1,'software','y')
insert into jomy_dept (dept_id,dept_name,active) values(2,'hardware','y')
insert into jomy_dept (dept_id,dept_name,active) values(3,'administration','y')

insert into jomy_salary_pay(emp_id,sal_date,drawnsalary,pf )values(1,'2010-05-01',30000,1000)
insert into jomy_salary_pay(emp_id,sal_date,drawnsalary,pf )values(2,'2010-05-01',20000,400)
insert into jomy_salary_pay(emp_id,sal_date,drawnsalary,pf )values(3,'2010-05-01',25000,600)
insert into jomy_salary_pay(emp_id,sal_date,drawnsalary,pf )values(4,'2010-05-01',20000,800)
insert into jomy_salary_pay(emp_id,sal_date,drawnsalary,pf )values(5,'2010-05-01',18000,400)
insert into jomy_salary_pay(emp_id,sal_date,drawnsalary,pf )values(1,'2010-06-01',30000,1000)
insert into jomy_salary_pay(emp_id,sal_date,drawnsalary,pf )values(2,'2010-06-01',20000,400)
insert into jomy_salary_pay(emp_id,sal_date,drawnsalary,pf )values(4,'2010-06-01',28000,800)
insert into jomy_salary_pay(emp_id,sal_date,drawnsalary,pf )values(5,'2010-06-01',20000,400)





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

 --9--
 select t.dept_name,avg(t.net_salary) from #temp t group by t.dept_name

 --10--

 select t.emp_id,t.emp_name,sal_date
  from #temp t 
  where t.sal_date='2010-05-01' 
  and t.emp_id not in(select t.emp_id from #temp t where t.sal_date='2010-06-01')



   ---functions------

   --1-----lastest salary given to an employye passing employe id---------


select * from #temp

 select t.net_salary from #temp t where t.sal_date =(select max(t.sal_date) from #temp t where t.emp_id=1) order by t.sal_date)

 select max(t.sal_date) from #temp t where t.emp_id=1


 select t.net_salary from #temp t where t.sal_date in (select max(t.sal_date) from #temp t where t.emp_id=4) and t.emp_id=4

alter function emp(@emp_id int)
 returns  float

 begin
			 declare @sal float

		

			 set @sal= (select t.net_salary from temp t where t.sal_date in (select max(t.sal_date) from temp t where t.emp_id=@emp_id) and t.emp_id=@emp_id)

			

			 return @sal
 end

 select emp(4) fr

















