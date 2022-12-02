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

/* getDname() - �μ��ڵ� �Է�, �μ��� ���*/
-- �Ʒ� ���� �ٽ� Ȯ���غ���

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

/* �Է� : �μ��ڵ�, ���: �μ���, �μ��ο���, �����հ�*/
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
    dbms_output.put_line('�μ���['||strDname||'], �ѱ޿�['||total_sal||'], ���ο���['||howmany||']');
end;
/
exec getSum(80);
/* getDname() <- �Լ�, getSum <- ���ν���*/
select * from user_source where type='PROCEDURE';

declare
    strName employees.emp_name%type;
    strDname departments.department_name%type;
begin
    getSum(90); -- ���ν����� �ڵ�� ������ ȣ���Ҷ��� execute���� �ʿ� ����.
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
    dbms_output.put_line('�μ���='||department_name);
end;
/
/*in, out, in out ���忡 ���� ���� ����*/
/*�Ʒ� ��� ���� ������ �ϴ���*/
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

/*���� ó����*/
declare
    vi_num number:=0;
begin
    vi_num:= 10/8;
    dbms_output.put_line('success['||vi_num||']');
    
    
    exception 
        when zero_divide then
--            dbms_output.put_line('�����߻� - Divided by Zero');
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
        dbms_output.put_line('ã�� ���߽��ϴ�.');
    end if;
end;
/

/*cusor��*/
declare
    vs_name employees.emp_name%type;        -- 0~3000 ������ ��� �̸��� ���� �ϰ��� vs_name������ ����.
    cursor c1 (a number, b number) -- (1) Ŀ�� ����   a��� ������ ���ڿ� b��� ���ڸ� ����ڴ�.
    is 
        select emp_name from employees where salary between a and b;  -- select �̸��� ǥ�� from ��𿡼�? employees���� ���? salary �ȿ����� a�� b��
begin
    open c1(0,3000); -- (2)Ŀ�� ����        a�� b�� 0�� 3000�� �ְڴ�.
    loop
        fetch c1 into vs_name; -- (3) ������ ����ϱ�(fetch)
        exit when c1%notfound;
        dbms_output.put_line('emp_name='||vs_name);
    end loop;
    close c1; --(4) Ŀ�� �ݱ�
end;
/

declare
    vs_name employees.emp_name%type;
    vs_did employees.department_id%type;
    cursor c1(x number) --(1) Ŀ���� ����
    is select emp_name, department_id
        from employees
        where manager_id=x;
begin
    open c1(15);   --(2) Ŀ�� ����(sql����)
    loop
        fetch c1 into vs_name, vs_did;   --(3) ������ ���  // �� ���� ���� into���� ���� ������ �� ���� ���ƾ� ��.
        exit when c1%notfound;
        dbms_output.put_line(vs_name||','||vs_did);
    end loop;
    close c1; -- (4) Ŀ�� �ݱ� (�޸� ��ȯ)
end;
/ 

/* �μ���, �μ��� �ο��� �μ������� �����հ� */
select * from departments;
select * from employees;

select b.department_name, sum(a.salary), count(*)   -- b.�μ���, a.�����հ�, a��b�� �ο��� �� ǥ���ϰڴ�.
from employees a, departments b                     -- employees�� a��ΰ� departments�� b�� �θ鼭 �̰����� �������ڴ�.
where a.department_id = b.department_id             -- a.department_id�� b.department_id�� ���� ���� �������ڴ�. where�� ���� ������ from���� ���� �����̱� ����
group by b.department_name;                       -- select ������ gruop�� �ְڴ�. �׷��� a�� �ȵǴ� ������? a�� department_name�� ���ݾ�

declare
vs_dname departments.department_name%type;
total employees.salary%type;
howmany number; -- ���� �ο����� �����ϰ� �Է��� �����Ƿ� �Ʒ� select�� count�� ��ã��.
    cursor c1 
    is select b.department_name, sum(a.salary), count(*)
    from employees a, departments b
    where a.department_id=b.department_id
    group by b.department_name;    -- where�� �ΰ��ϱ� �׷���̸� ����
begin
    open c1;
    loop
        fetch c1 into vs_dname, total, howmany;   -- �̰������� howmany�� ������
        exit when c1%notfound;
        dbms_output.put_line(vs_dname||','||total||','||howmany);
    end loop;
    close c1;
end;
/