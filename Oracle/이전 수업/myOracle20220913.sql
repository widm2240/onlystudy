/* 사번, 이름, 직위명, 부서명*/
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
/* 제품명 prod_name, 고객명 cust_name , 판매방식 channel_class, 판매직원 , 판매일자 sales_date */
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
 
 /*부서코드, 부서명, 상위부서명 */
 select * from departments;
 
 select a.department_id, a.department_name, b.department_name parent_name
 from departments a, departments b
 where a.parent_id=b.department_id;
 
/* 동등조인, 안티조인, 세미조인, 셀프조인 - 내부조인(inner join) */
/* 셀프조인은 다시한번 더 공부를 해보도록 합시다. */

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

/*매니저사번 -> 매니저명, 소속지원숫자*/
/*a의 매니저를 검색했을때 b의 임플로이아이디가 나오게 되며 b의 임플로이 이름이지만 이것을 b.emp_name은 mnager_name 이다라고 표기를 했다.*/
select * from employees;
select b.emp_name manager_name ,count(*)
from employees a, employees b
where a.manager_id=b.employee_id
group by b.emp_name
order by b.emp_name;

/*부서코드 department_id->부서명 department_name, 소속직원 숫자*/
/*employees에 있는 직원을 가져다가 부서만 작성하는 것이기 때문에 a사원들을 b부서에 넣었을때*/
select * from departments;
select b.department_name, count(*)
from employees a, departments b
where a.department_id=b.department_id
group by b.department_name
order by b.department_name;

/*월급이 5000~10000불 사이인 직원의 사번, 이름, 월급, 부서명*/
/**/
select a.employee_id, a.emp_name, a.salary, b.department_name
from employees a, departments b
where a.department_id=b.department_id and a.salary between 5000 and 10000; /*salary>=5000 and salary <=10000*/

/*위와 같은 답이 나오겠지만 아래의 처리방식이 더 빠르게 작용이 된다 하지만 이번에 더 늦은 이유는 a와 b의 클래스 양의 차이 때문이다.*/
select a.employee_id, a.emp_name, a.salary, b.department_name
from (select *from employees where salary between 5000 and 10000) a,
    departments b
where a.department_id=b.department_id;

/*위와 같은 답이 나오겠지만 아래의 처리방식이 더더(이유는 상세하게 작성) 빠르게 작용이 된다 하지만 이번에 더 늦은 이유는 a와 b의 클래스 양의 차이 때문이다.*/
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

/*제품별 prod_subcategory 매출액합계 -> 제품명 prod_name, 매출액합계*/
select * from sales;
select * from products;
select sum(a.amount_sold) from sales a;

select b.prod_name, sum(a.amount_sold) total
from sales a, products b
where a.prod_id=b.prod_id
group by b.prod_name
order by total desc;

/*고객별 매출액합계 - > 고객명, 매출액합계*/
select * from sales;
select * from customers;
/*sales에 있는 cust_id를 검색시 customers 의 cust_id를 검색 후 customers의 cust_ name으로 노출*/
select b.cust_name, sum(a.amount_sold) total
from sales a, customers b
where a.cust_id = b.cust_id
group by b.cust_name
order by total desc;

/*상위부서가 없는 부서에 속한 직원의 명단, 부서명
이름1 부서명
이름2 부서명*/
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
                        
                        