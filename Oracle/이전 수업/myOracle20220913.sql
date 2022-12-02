/* ���, �̸�, ������, �μ���*/
select * from employees;
select * from jobs;
select a.employee_id, a.emp_name, b.job_title, c.department_name 
from employees a, jobs b, departments c 
where a.job_id=b.job_id and a.department_id=c.department_id;
select * from sales;
select * from products;
select * from customers;
select * from channels;
select * from employees;
/* ��ǰ�� prod_name, ���� cust_name , �ǸŹ�� channel_class, �Ǹ����� , �Ǹ����� sales_date */
select a.product_name, b.customer_name, c.channel_title, d.emp_name, e sales_date
from products a, customers b, channels c, employees d, sales e
where a.prod_name=b.cust_name and a.prod_name=b.customer_name ;

select b.prod_name, c.cust_name,d.channel_desc, d.channel_id, e.emp_name, a.sales_date
from sales a, products b, customers c, channels d, employees e
where a.prod_id=b.prod_id and a.cust_id=c.cust_id and a.channel_id=d.channel_id and a.employee_id=e.employee_id;

select a.department_id, a.department_name
from departments a, employees b
where a.department_id=b.department_id 
order by a.department_name;

select a.employee_id, a.emp_name, b.emp_name manager_name
 from employees a, employees b
 where a.manager_id=b.employee_id;
 
 /*�μ��ڵ�, �μ���, �����μ��� */
 select * from departments;
 
 select a.department_id, a.department_name, b.department_name parent_name
 from departments a, departments b
 where a.parent_id=b.department_id;
 
/* ��������, ��Ƽ����, ��������, �������� - ��������(inner join) */
/* ���������� �ٽ��ѹ� �� ���θ� �غ����� �սô�. */

create table A(
c1 varchar2(4), c2 varchar2(4));
create table B(
c3 varchar2(4), c4 varchar2(4));
insert into A values('5','e');
insert into B values('e','Y3');
select * from A;
select * from B;
select * from A, B 
where A.c2=B.c3(+);

/*�Ŵ������ -> �Ŵ�����, �Ҽ���������*/
/*a�� �Ŵ����� �˻������� b�� ���÷��̾��̵� ������ �Ǹ� b�� ���÷��� �̸������� �̰��� b.emp_name�� mnager_name �̴ٶ�� ǥ�⸦ �ߴ�.*/
select * from employees;
select b.emp_name manager_name ,count(*)
from employees a, employees b
where a.manager_id=b.employee_id
group by b.emp_name
order by b.emp_name;

/*�μ��ڵ� department_id->�μ��� department_name, �Ҽ����� ����*/
/*employees�� �ִ� ������ �����ٰ� �μ��� �ۼ��ϴ� ���̱� ������ a������� b�μ��� �־�����*/
select * from departments;
select b.department_name, count(*)
from employees a, departments b
where a.department_id=b.department_id
group by b.department_name
order by b.department_name;

/*������ 5000~10000�� ������ ������ ���, �̸�, ����, �μ���*/
/**/
select a.employee_id, a.emp_name, a.salary, b.department_name
from employees a, departments b
where a.department_id=b.department_id and a.salary between 5000 and 10000; /*salary>=5000 and salary <=10000*/

/*���� ���� ���� ���������� �Ʒ��� ó������� �� ������ �ۿ��� �ȴ� ������ �̹��� �� ���� ������ a�� b�� Ŭ���� ���� ���� �����̴�.*/
select a.employee_id, a.emp_name, a.salary, b.department_name
from (select *from employees where salary between 5000 and 10000) a,
    departments b
where a.department_id=b.department_id;

/*���� ���� ���� ���������� �Ʒ��� ó������� ����(������ ���ϰ� �ۼ�) ������ �ۿ��� �ȴ� ������ �̹��� �� ���� ������ a�� b�� Ŭ���� ���� ���� �����̴�.*/
select a.employee_id, a.emp_name, a.salary, b.department_name
from (select employee_id, emp_name, salary, department_id from employees where salary between 5000 and 10000) a,
    departments b
where a.department_id=b.department_id;

select avg(salary) from employees;

select * from employees;

select count(*)
from employees
where salary>=(select avg(salary) from employees);
commit;
update employees
 set salary=(select avg(salary) from employees);
delete from employees
where salary<=(select avg(salary) from employees);
rollback;

select count(*)
from employees
where department_id in(select department_id from departments where parent_id is null);

select employee_id, emp_name, job_id
from employees
where(employee_id,job_id) in (select employee_id, job_id from job_history);

select * from job_history;
select employee_id, job_id from employees;

/*��ǰ�� prod_subcategory ������հ� -> ��ǰ�� prod_name, ������հ�*/
select * from sales;
select * from products;
select sum(a.amount_sold) from sales a;

select b.prod_name, sum(a.amount_sold) total
from sales a, products b
where a.prod_id=b.prod_id
group by b.prod_name
order by total desc;

/*���� ������հ� - > ����, ������հ�*/
select * from sales;
select * from customers;
/*sales�� �ִ� cust_id�� �˻��� customers �� cust_id�� �˻� �� customers�� cust_ name���� ����*/
select b.cust_name, sum(a.amount_sold) total
from sales a, customers b
where a.cust_id = b.cust_id
group by b.cust_name
order by total desc;

/*�����μ��� ���� �μ��� ���� ������ ���, �μ���
�̸�1 �μ���
�̸�2 �μ���*/
select * from employees;
select * from departments;
select * from departments where parent_id is null;

select a.emp_name, b.department_name
from employees a, departments b
where a.department_id in(select department_id from departments where parent_id is null)
and a.department_id = b.department_id;

select a.emp_name,b.department_name 
from employees a,   
    (select department_id, department_name
    from departments 
    where parent_id is null) b
where a.department_id=b.department_id;

select a.department_id, avg(salary)
from employees a
where a.department_id in(select department_id from departments where parent_id=90)
group by a.department_id;


update employees a
set a.salary=(select sal
                from (select b.department_id, avg(c.salary) as sal
                     from departments b, employees c
                     where b.partent_id=90
                     and b.department_id = c.department_id
                     group by b.department_id) d
                where a.department_id=d.department_id)
where a.department in (select department_id 
                        from departments    
                        where parent_id=90)
                        
                        