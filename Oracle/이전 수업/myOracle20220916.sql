/*직원별 매출총액*/
--employees.name, sales
select * from employees;
select * from sales;

select emp_name, sum(amount_sold)
from employees a, sales b
where a.employee_id = b.employee_id
group by emp_name
order by sum(amount_sold);

declare
    vs_name employees.emp_name%type;
    total number;
    cursor c1
    is 
        select emp_name, sum(amount_sold)
        from employees a, sales b
        where a.employee_id = b.employee_id
        group by emp_name
        order by sum(amount_sold) asc;
begin
    
    open c1;
    loop
        fetch c1 into vs_name, total;
        exit when c1%notfound;
        dbms_output.put_line(vs_name||','||total);
    end loop;
    close c1;
end;
/
/*위의 내용을 커서 3버전으로 했을 경우의 식*/

declare
begin 
    for rec in(select emp_name, sum(amount_sold) total
                from employees a, sales b
                where a.employee_id = b.employee_id
                group by emp_name
                order by sum(amount_sold))
    loop
        dbms_output.put_line(rec.emp_name||','||rec.total);
    end loop;
end;
/


/*커서 for문(커서의 두번째 버전)*/
declare
    cursor c1(x number) is
    select emp_name, department_id
    from employees
    where manager_id=x;
begin
    for rec in c1(100)
    loop
        dbms_output.put_line(rec.emp_name||','||rec.department_id);
    end loop;
end;
/
/*커서의 3번째 버전*/
declare
begin
    for rec in (select emp_name, department_id
                from employees
                where manager_id=100)
    loop
        dbms_output.put_line(rec.emp_name||','||rec.department_id);
    end loop;
end;
/


declare
begin
    for rec in (select b.department_name dname, sum(a.salary) total, count(*) cnt
                from employees a, departments b
                where a.department_id=b.department_id
                group by b.department_name)
    loop
       dbms_output.put_line(rec.dname||','||rec.total||','||rec.cnt);
    end loop;
end;
/

/*입사연도별 인원수 - to char, substr, group by*/
select * from employees;
select emp_name, to_char(hire_date, 'yyyy-mm-dd') from employees;
select emp_name, to_char(hire_date,'yyyy') from employees;
declare
begin
    for rec in substr(to_char(hire_date, 'yyyy-mm-dd'),1,4) hdate, count(*) cnt
                from employees 
                group by to_char(hire_date,'yyyy-mm-dd'))
    loop
        dbms_output.put_line(rec.hdate||','||rec.cnt);
    end loop;
end;
/
select substr(to_char(hire_date, 'yyyy-mm-dd'),1,4) hdate, count(*) cnt
                from employees 
                group by substr(to_char(hire_date, 'yyyy-mm-dd'),1,4);
                
/*사원번호, 이름, 직위명 107명 모두*/
select * from employees;
select * from jobs;

select a.employee_id, a.emp_name, b.job_title
from employees a, jobs b
where a.job_id=b.job_id;



/*부서명, 부서장이름(부서장 아이디는 departments.manager_id)*/
select *from departments;
select * from employees;

select b.department_name, a.emp_name
from employees a, departments b
where b.manager_id = a.employee_id; -- departments.manager_id가 부서명의 아이디

/*부서명, 부서장이름(부서장 아이디는 departments.manager_id), 부서원 숫자*/
select a.department_name, b.emp_name manager_name, count(c.emp_name)
from departments a, employees b, employees c
where a.manager_id = b.employee_id and a.department_id=c.department_id
group by a.department_name, b.emp_name;

/*부서명, 부서장이름(부서장 아이디는 departments.manager_id), (평균 월급이상인) 부서원 숫자*/
select salary from employees;
select avg(salary) from employees;

select a.department_name, b.emp_name manager_name, count(c.emp_name)
from departments a, employees b,
    (select emp_name, department_id
    from employees 
    where salary>=(select avg(salary) from employees)) c
where a.manager_id = b.employee_id and a.department_id=c.department_id
group by a.department_name, b.emp_name;

/* sales : 고객이름 상품이름 매입총액*/
select * from sales;    -- amount_sold
select * from products; --prod_name
select * from customers;    --cust_name

select a.cust_name, b.prod_name
from customers a, products b
where a.cust_id = b.prod_id;

/*내가 푼것이지만 틀렸음.*/
--select a.cust_name, b.prod_name, sum(c.amount_sold)
--from customers a, products b, sales c
--where a.cust_id = b.prod_id and a.cust_id=c.cust_id
--group by a.cust_name, b.prod_name
--order by sum(c.amount_sold) desc;

/*정답*/
select a.cust_name, b.prod_name, sum(c.amount_sold)
from customers a, products b, sales c
where c.prod_id = b.prod_id and a.cust_id=c.cust_id
group by a.cust_name, b.prod_name
order by a.cust_name, b.prod_name;


/*사장의 직속부하인 직원이 매니저인 사원 숫자*/
/* 직속부하명, 직원숫자*/

select * from employees;
select * from jobs;
select * from departments;

/* 내가 한 것인데 정답이 아님 수식은 어느정도 비슷하나.....
select a.emp_name, count(*)
from employees a, jobs b, departments c
where a.employee_id=c.manager_id
group by a.emp_name;
*/

/*정답*/
select a.emp_name, count(*)
from employees a, employees b
where a.manager_id in(select employee_id from employees where manager_id is null)
and a.employee_id=b.manager_id
group by a.emp_name;