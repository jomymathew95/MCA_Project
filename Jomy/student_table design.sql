create table jomy_student_master(stud_id int,stud_name varchar(25),join_date date,sex varchar(10),classId int)

create table jomy_class(classId int,class_name varchar(25))

create table jomy_fee_pay(stud_id int,fee_date date,fees float,deduction float)


insert into jomy_student_master(stud_id,stud_name,join_date,sex,classId)values(1,'jobi','2006-03-01','M',1)
insert into jomy_student_master(stud_id,stud_name,join_date,sex,classId)values(2,'subi','2008-12-01','M',1)
insert into jomy_student_master(stud_id,stud_name,join_date,sex,classId)values(3,'jobin','2009-04-01','M',1)
insert into jomy_student_master(stud_id,stud_name,join_date,sex,classId)values(4,'anoopa','2007-06-01','f',2)
insert into jomy_student_master(stud_id,stud_name,join_date,sex,classId)values(5,'reshmi','2009-09-01','f',3)
insert into jomy_student_master(stud_id,stud_name,join_date,sex,classId)values(6,'babu','2008-09-01','M',2)


insert into jomy_class (classId,class_name) values(1,'std 1')
insert into jomy_class (classId,class_name) values(2,'std 2')
insert into jomy_class (classId,class_name) values(3,'std 3')


insert into jomy_fee_pay(stud_id,fee_date,fees,deduction )values(1,'2010-05-01',6000,9)
insert into jomy_fee_pay(stud_id,fee_date,fees,deduction )values(2,'2010-05-01',5000,4)
insert into jomy_fee_pay(stud_id,fee_date,fees,deduction )values(3,'2010-05-01',3500,6)
insert into jomy_fee_pay(stud_id,fee_date,fees,deduction )values(4,'2010-05-01',2000,8)
insert into jomy_fee_pay(stud_id,fee_date,fees,deduction )values(5,'2010-05-01',1800,4)
insert into jomy_fee_pay(stud_id,fee_date,fees,deduction )values(1,'2010-06-01',3000,9)
insert into jomy_fee_pay(stud_id,fee_date,fees,deduction )values(2,'2010-06-01',2000,4)
insert into jomy_fee_pay(stud_id,fee_date,fees,deduction )values(4,'2010-06-01',2800,8)
insert into jomy_fee_pay(stud_id,fee_date,fees,deduction )values(5,'2010-06-01',2000,4)

select * from jomy_student_master
select * from jomy_class
select * from jomy_fee_pay