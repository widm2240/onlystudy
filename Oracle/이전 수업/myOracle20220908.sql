/* abs(����) */
select * from employees;
select abs(-3.14) from dual;
select emp_name, salary from employees where abs(salary)>3000;
select mod(10,3), remainder(10,3) from dual;
select initcap('PARK JAE HYUNG') from dual;
select lower('PARK JAE HYUNG') from dual;
select 'Good'||'Morning'||'Vietnam' from dual;
select concat(concat('good','morning'),'vietnam') from dual;
select substr('good morning',1,4) from dual;
select substr(emp_name,1,5) from employees;
select instr('good morning','morning')from dual;
select emp_name from employees;
select emp_name, instr(emp_name,' ') from employees;
/* �̸�+' '+�� ���� �̸��� ���� */
select substr(emp_name,1,instr(emp_name,' ')-1) from employees;
/* �̸�+' '+�� ���� �̸��� ���� */
select substr(emp_name,instr(emp_name,' ')+1) from employees;
select ltrim('           world') from dual;
select rtrim('     world       ') as trl from dual;
select replace('Good Morning','Morning','Evening')from dual;
/* ��ȭ��ȣ(phone_number)���� '.'�� '-'���� ��ġ�ؼ� ��� */
select replace(phone_number,'.','-')from employees;
select length('Good Morning'), lengthb('Good Morning') from dual;
select sysdate, systimestamp from dual;
select to_char(sysdate, 'yymmdd hh:mi:ss') from dual;
select to_char(SYSTIMESTAMP, 'yyyy-mm-dd hh12:mi:ss') from dual;
select emp_name,nvl(manager_id, 90) from employees;
select *from channels;
select decode(channel_id, 1, 'Direct', 2, 'Partners',4,'Internet',5,'Catalog',9,'TeleSa') from channels;

drop table student;
create table student(
name varchar2(12),
mobile varchar2(12)
);
insert into student values('John','44445555');
insert into student values('Jack',null);
select*from student;
select count(name), count(mobile) student from student;
select sum(*) from sales;
select sum(salary) from employees;
select to_char(avg(salary),'9999.99') from employees;
select min(salary),max(salary) from employees;
select distinct salary from employees;
select emp_name from employees order by emp_name;
select salary, emp_name from employees order by salary, emp_name;
select job_id, sum(salary) from employees group by job_id;
/* �Ŵ�������� �������� ���� */
select manager_id, count(*) from employees group by manager_id having count(*)>1;
select * from employees;
/* ���޺� ���� ����*/
select salary, count(*) from employees group by salary order by salary desc ;
select department_id, sum(salary) from employees group by department_id order by sum(salary);

create table exp_goods (
country varchar2(10),seq number,goods varchar2(80)
);
insert into exp_goods values('�ѱ�',1,'�������ܼ�����');
insert into exp_goods values('�ѱ�',2,'�ڵ���');
insert into exp_goods values('�ѱ�',3,'��������ȸ��');
insert into exp_goods values('�ѱ�',4,'����');
insert into exp_goods values('�ѱ�',5,'LCD');
insert into exp_goods values('�ѱ�',6,'�ڵ�����ǰ');
insert into exp_goods values('�ѱ�',7,'�޴���ȭ');
insert into exp_goods values('�ѱ�',8,'ȯ��źȭ����');
insert into exp_goods values('�ѱ�',9,'�����۽ű���÷��̺μ�ǰ');
insert into exp_goods values('�ѱ�',10,'ö�Ǵº��ձݰ�');
create table exp_goods_japan (
country varchar2(10),seq number,goods varchar2(80)
);
insert into exp_goods_japan values('�Ϻ�',1,'�ڵ���');
insert into exp_goods_japan values('�Ϻ�',2,'�ڵ�����ǰ');
insert into exp_goods_japan values('�Ϻ�',3,'��������ȸ��');
insert into exp_goods_japan values('�Ϻ�',4,'����');
insert into exp_goods_japan values('�Ϻ�',5,'�ݵ�ü������');
insert into exp_goods_japan values('�Ϻ�',6,'ȭ����');
insert into exp_goods_japan values('�Ϻ�',7,'�������ܼ�����');
insert into exp_goods_japan values('�Ϻ�',8,'�Ǽ����');
insert into exp_goods_japan values('�Ϻ�',9,'���̿���Ʈ��������');
insert into exp_goods_japan values('�Ϻ�',10,'����');
select *from exp_goods_japan;
select goods from exp_goods
minus
select goods from exp_goods_japan;

create table area1 (
name varchar(12),
mobile number
);
insert into area1 values('lee',44445555);
insert into area1 values('jang',66664444);
insert into area1 values('kim',77775555);
insert into area1 values('park',55554444);

create table area2 (
area varchar(4),
phone number
);
insert into area2 values('seol',77775555);
insert into area2 values('chon',99994444);
insert into area2 values('busn',33332222);
insert into area2 values('seol',55554444);

select area1.name, area1.mobile, area2.area, area2.phone from area1, area2 where area1.mobile = area2.phone ;

select employees.employee_id, employees.emp_name, departments.department_name, employees.department_id
from employees, departments
where employees.department_id=departments.department_id;

select a.employee_id, a.emp_name, b.department_name, b.department_id
from employees a, departments b
where a.department_id=b.department_id;