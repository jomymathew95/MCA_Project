create table jomy_emp_master(emp_id int,emp_name varchar(25),join_date date,salary float,sex varchar(10),dept int)

create table jomy_dept(dept_id int,dept_name varchar(25),active varchar(10))

create table jomy_salary_pay(emp_id int,sal_date date,drawnsalary float,pf float)


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





