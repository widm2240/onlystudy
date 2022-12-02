select * from employees;
set serveroutput on;
set timing on;
--declare
--    vi_num number;
--BEGIN
--    vi_num := 3+5; 
--    dbms_output.put_line(vi_num);
--end;

declare
-- vs_emp_name varchar2(80);
-- vs_dep_name varchar2(80);
   vs_emp_name employees.emp_name%type;
   vs_dep_name departments.department_name%type;
-- 두 줄 중에 아래의 방식이 훨씬 좋다. 이유는 into절이 들어가게 되면 반드시 값을 정해줘야하는데
-- %type 방식은 자동 완성형의 값을 등록해준다.
begin
    select a.emp_name, b.department_name
    into vs_emp_name, vs_dep_name
    from employees a, departments b
    where a.department_id=b.department_id
    and a.employee_id=100;
    dbms_output.put_line(vs_emp_name||' - ' ||vs_dep_name);
end;
/

declare
    vn_salary employees.salary%type;
    vn_did departments.department_id%type;
begin
    select salary 
    into vn_salary
    from employees
    where department_id=90 and rownum=1;
    dbms_output.put_line(vn_salary);
--        if vn_salary between 1 and 3000 then
--        dbms_output.put_line('낮음');
--        elsif vn_salary between 3001 and 6000 then
--        dbms_output.put_line('중간');
--        elsif vn_salary between 6001 and 10000 then
--        dbms_output.put_line('높음');
--        else
--        dbms_output.put_line('최상위');
--        end if;
        case
            when vn_salary between 1 and 3000 then
            dbms_output.put_line('낮음');
            when vn_salary between 3001 and 6000 then
            dbms_output.put_line('중간');
            when vn_salary between 6001 and 10000 then
            dbms_output.put_line('높음');
            else
            dbms_output.put_line('최상위');
        end case;
end;
/
/* 월급이 10000불인 사람의 이름과 부서명*/
select * from employees where salary = 10000;
select * from departments;
declare
    vs_emp_name employees.emp_name%type;
    vs_dep_name departments.department_name%type;
begin
    select a.emp_name, b.department_name into vs_emp_name, vs_dep_name
    from employees a, departments b
    where a.salary=10000 and a.department_id=b.department_id and rownum=1;
    dbms_output.put_line(vs_emp_name||' - '||vs_dep_name);
       
end;
/

declare
  vn_x INTEGER :=0;
  total INTEGER :=0;
begin
  while vn_x <= 100
  loop
    total:=total+vn_x; -- 1   3   6
    vn_x:=vn_x+1; --  1   2   3
  end loop;
    dbms_output.put_line('totla='||total);
  end;
/  
/* 구구단 2단 출력*/

declare
 vn_x integer := 2; 
 vn_y integer := 1;
-- total integer :=0;
--begin
--    while vn_y <= 9
--    loop
--        total := vn_x * vn_y;
--        dbms_output.put_line(vn_x|| '*' ||vn_y|| '=' || total);
--        vn_y := vn_y+1;
--    end loop;

/*아래는 선생님 답변*/
--begin
--    while vn_y<10
--    loop
--    dbms_output.put_line('2 X ' ||vn_y|| '=' || 2*vn_y);
--    vn_y:=vn_y+1;
--    end loop;



/*아래는 loop만 썼을때 사용 하는 방법*/
--begin
--    loop
--    dbms_output.put_line(vn_x||'X'||vn_y||'=' ||vn_x*vn_y);
--    exit when vn_y =9;
--    vn_y:=vn_y+1;
--    end loop;

/*아래는 for문*/
begin
 for i in /*이 사이에 reverse를 입력하면 9..1로*/1..9  /*java == > for(int i=1; i<10; i++);*/
 loop
   dbms_output.put_line('2X'||i||'='||2*i);
   end loop;

end;
/

create or replace function showLevel(sal employees.salary%type)
return varchar2
is
    str varchar2(80);
begin  
    if sal between 1 and 3000 then
        str:='하위';
    elsif sal between 3001 and 6000 then
        str:='중위';
    elsif sal between 6001 and 10000 then
        str:='상위';
    else
        str:='최상위';
    end if;
    return str;
end;
/
select emp_name, salary, showLevel(salary) from employees;