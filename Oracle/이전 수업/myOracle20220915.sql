select emp_name,salary,showLevel(salary) from employees;

drop function showLevel;

select*from countries;
drop function getFullName;

create or replace function getFullName(abbr varchar2)
return countries.country_name%type
is
    strFullName countries.country_name%type :='';
begin
    select country_name into strFullName
    from countries
    where country_iso_code=abbr;
    return strFullName;
end;
/
select country_iso_code, getFullName(country_iso_code) from countries;

/* getDname() - 부서코드 입력, 부서명 출력*/
-- 아래 내용 다시 확인해보기

drop function getDname;
select * from departments;
create or replace function getDname(did varchar2)
return departments.department_name%TYPE
is
    strName departments.department_name%TYPE :='';
begin
    select department_name into strName
    from departments
    where  department_id=did;
    return strName;
end;
/
select emp_name,getDname(department_id) from employees;

/* 입력 : 부서코드, 출력: 부서명, 부서인원수, 월급합계*/
create or replace procedure getSum(did departments.department_id%type)
is
  strDname departments.department_name%type;
  total_sal number :=0;
  howmany number :=0;
begin
    select department_name into strDname
    from departments where department_id=did;
    select sum(salary),count(*) into total_sal, howmany
    from employees
    where department_id=did
    group by department_id;
    dbms_output.put_line('부서명['||strDname||'], 총급여['||total_sal||'], 총인원수['||howmany||']');
end;
/
exec getSum(80);
/* getDname() <- 함수, getSum <- 프로시저*/
select * from user_source where type='PROCEDURE';

declare
    strName employees.emp_name%type;
    strDname departments.department_name%type;
begin
    getSum(90); -- 프로시저를 코드블럭 내에서 호출할때는 execute문이 필요 없다.
    select emp_name,getDname(department_id)
    into strName, strDname
    from employees
    where department_id=90 and rownum=1;
    dbms_output.put_line(strName||'-'||strDname);
end;
/

create or replace procedure getDepname(
did number, dname out varchar2)
is
begin
    select department_name into dname
    from departments
    where department_id=did;
end;
/
declare
    department_name departments.department_name%type;
    dep_id number :=90;
begin
    getDepname(dep_id, department_name);
    dbms_output.put_line('부서명='||department_name);
end;
/
/*in, out, in out 문장에 대한 상세한 설명*/
/*아래 양식 어케 만들어야 하는지*/
drop procedure getNum;


create or replace procedure getNum(
a in number, b out number, c in out number)

begin
    dbms_output.put_line(a||','||b||','||c);
    a:=1;
    b:=2;
    c:=3;
    dbms_output.put_line(a||','||b||','||c);
end;
declare
    x number:=10;
    y number:=20;
    z number:=30;
begin
    procedure(x,y,z)
    dbms_output.put_line(x||','||y||','||z);
end;
/

/*예외 처리문*/
declare
    vi_num number:=0;
begin
    vi_num:= 10/8;
    dbms_output.put_line('success['||vi_num||']');
    
    
    exception 
        when zero_divide then
--            dbms_output.put_line('오류발생 - Divided by Zero');
--            dbms_output.put_line('sql error code ['||sqlcode||']');
--            dbms_output.put_line('error message ['||sqlerrm||']');
        when invalid_number then
    
        when no_data_found then
end;
/

declare
    vs_name employees.emp_name%type;
begin
    select emp_name into vs_name from employees
    where manager_id is null;
    DBMS_OUTPUT.PUT_line(vs_name);
    
    exception when others then
    if sql%notfound then
        dbms_output.put_line('찾지 못했습니다.');
    end if;
end;
/

/*cusor문*/
declare
    vs_name employees.emp_name%type;        -- 0~3000 사이의 사람 이름을 도출 하고자 vs_name변수를 만듬.
    cursor c1 (a number, b number) -- (1) 커서 선언   a라는 임의이 숫자와 b라는 숫자를 만들겠다.
    is 
        select emp_name from employees where salary between a and b;  -- select 이름을 표기 from 어디에서? employees에서 어디에? salary 안에서도 a와 b를
begin
    open c1(0,3000); -- (2)커서 열기        a와 b에 0과 3000을 넣겠다.
    loop
        fetch c1 into vs_name; -- (3) 데이터 사용하기(fetch)
        exit when c1%notfound;
        dbms_output.put_line('emp_name='||vs_name);
    end loop;
    close c1; --(4) 커서 닫기
end;
/

declare
    vs_name employees.emp_name%type;
    vs_did employees.department_id%type;
    cursor c1(x number) --(1) 커서를 선언
    is select emp_name, department_id
        from employees
        where manager_id=x;
begin
    open c1(15);   --(2) 커서 열기(sql실행)
    loop
        fetch c1 into vs_name, vs_did;   --(3) 데이터 사용  // 이 곳에 들어가는 into문은 위의 셀렉에 들어간 값과 같아야 함.
        exit when c1%notfound;
        dbms_output.put_line(vs_name||','||vs_did);
    end loop;
    close c1; -- (4) 커서 닫기 (메모리 반환)
end;
/ 

/* 부서명, 부서별 인원수 부서직원의 월급합계 */
select * from departments;
select * from employees;

select b.department_name, sum(a.salary), count(*)   -- b.부서명, a.월급합계, a와b의 인원수 를 표기하겠다.
from employees a, departments b                     -- employees를 a라두고 departments를 b로 두면서 이곳에서 가져오겠다.
where a.department_id = b.department_id             -- a.department_id와 b.department_id가 같은 놈을 가져오겠다. where이 들어가는 이유는 from에서 조인 문장이기 때문
group by b.department_name;                       -- select 내용을 gruop에 넣겠다. 그런데 a로 안되는 이유는? a는 department_name이 없잖아

declare
vs_dname departments.department_name%type;
total employees.salary%type;
howmany number; -- 나는 인원수를 제외하고 입력을 했으므로 아래 select에 count가 못찾음.
    cursor c1 
    is select b.department_name, sum(a.salary), count(*)
    from employees a, departments b
    where a.department_id=b.department_id
    group by b.department_name;    -- where가 두개니까 그룹바이를 썼어야
begin
    open c1;
    loop
        fetch c1 into vs_dname, total, howmany;   -- 이곳에서도 howmany를 제외함
        exit when c1%notfound;
        dbms_output.put_line(vs_dname||','||total||','||howmany);
    end loop;
    close c1;
end;
/