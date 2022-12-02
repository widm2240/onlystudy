/* abs(숫자) */
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
/* 이름+' '+성 에서 이름만 추출 */
select substr(emp_name,1,instr(emp_name,' ')-1) from employees;
/* 이름+' '+성 에서 이름만 추출 */
select substr(emp_name,instr(emp_name,' ')+1) from employees;
select ltrim('           world') from dual;
select rtrim('     world       ') as trl from dual;
select replace('Good Morning','Morning','Evening')from dual;
/* 전화번호(phone_number)에서 '.'을 '-'으로 대치해서 출력 */
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
/* 매니저사번별 부하직원 숫자 */
select manager_id, count(*) from employees group by manager_id having count(*)>1;
select * from employees;
/* 월급별 직원 숫자*/
select salary, count(*) from employees group by salary order by salary desc ;
select department_id, sum(salary) from employees group by department_id order by sum(salary);

create table exp_goods (
country varchar2(10),seq number,goods varchar2(80)
);
insert into exp_goods values('한국',1,'원유제외석유류');
insert into exp_goods values('한국',2,'자동차');
insert into exp_goods values('한국',3,'전자집적회로');
insert into exp_goods values('한국',4,'선박');
insert into exp_goods values('한국',5,'LCD');
insert into exp_goods values('한국',6,'자동차부품');
insert into exp_goods values('한국',7,'휴대전화');
insert into exp_goods values('한국',8,'환식탄화수소');
insert into exp_goods values('한국',9,'무선송신기디스플레이부속품');
insert into exp_goods values('한국',10,'철또는비합금강');
create table exp_goods_japan (
country varchar2(10),seq number,goods varchar2(80)
);
insert into exp_goods_japan values('일본',1,'자동차');
insert into exp_goods_japan values('일본',2,'자동차부품');
insert into exp_goods_japan values('일본',3,'전자집적회로');
insert into exp_goods_japan values('일본',4,'선박');
insert into exp_goods_japan values('일본',5,'반도체웨이퍼');
insert into exp_goods_japan values('일본',6,'화물차');
insert into exp_goods_japan values('일본',7,'원유제외석유류');
insert into exp_goods_japan values('일본',8,'건설기계');
insert into exp_goods_japan values('일본',9,'다이오드트랜지스터');
insert into exp_goods_japan values('일본',10,'기계류');
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