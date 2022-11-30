---------------------------------------------------
-- PLSQL 기초
---------------------------------------------------
-- PL/SQL 소스 프로그램의 기본 단위를 블록(Block)이라고 함. 
-- 선언부, 실행부, 예외 처리부로 구성됨. 


-- 익명블록
SET SERVEROUTPUT ON
DECLARE
   vi_num NUMBER;
BEGIN
   vi_num := 100;
   DBMS_OUTPUT.PUT_LINE(vi_num);

END;

-- 연산자
DECLARE
  a INTEGER := 2**2*3**2;
BEGIN
  DBMS_OUTPUT.PUT_LINE('a = ' || TO_CHAR(a));
END;

-- 주석
DECLARE
  -- 한 줄 주석, 변수선언
  a INTEGER := 2**2*3**2;
BEGIN
	/* 실행부
	   DBMS_OUTPUT을 이용한 변수값 출력 
	*/
  DBMS_OUTPUT.PUT_LINE('a = ' || TO_CHAR(a));
END;

-- DML 문
-- 실제 PL/SQL 블록을 작성하는 원래의 목적은 테이블 상에 있는 데이터를 가공하는 것
DECLARE
  vs_emp_name    VARCHAR2(80); -- 사원명 변수
  vs_dep_name    VARCHAR2(80); -- 부서명 변수
BEGIN
  SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name -- INTO 변수에 할당
    FROM employees a,
         departments b
   WHERE a.department_id = b.department_id
     AND a.employee_id = 100;


  DBMS_OUTPUT.PUT_LINE( vs_emp_name || ' - ' || vs_dep_name);
END;

DECLARE
  vs_emp_name employees.emp_name%TYPE;
  vs_dep_name departments.department_name%TYPE;
BEGIN
  SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name
    FROM employees a,
         departments b
   WHERE a.department_id = b.department_id
     AND a.employee_id = 100;


  DBMS_OUTPUT.PUT_LINE( vs_emp_name || ' - ' || vs_dep_name);
END;

set serveroutput on 
accept p_num1 prompt   '첫번째 숫자를 입력하세요 ~ '
accept p_num2 prompt   '두번째 숫자를 입력하세요 ~ '

declare  
         v_sum  number(10);
 begin
         v_sum := &p_num1 + &p_num2 ;

         dbms_output.put_line('총합은: ' ||  v_sum );
 end;
/

set serveroutput  on
accept p_empno  prompt  '사원번호를 입력하세요 ~ '
  declare
          v_sal  number(10) ;
  begin 
         select sal into v_sal
           from emp
           where empno = &p_empno;

   dbms_output.put_line('해당 사원의 월급은 ' || v_sal);
  
end;
/     

set serveroutput on
set verify off
accept   p_num   prompt  '숫자를 입력하세요 ~  '
begin
if   mod(&p_num,2) = 0  then
        dbms_output.put_line('짝수입니다.');
    else  
        dbms_output.put_line('홀수입니다.');
end if;
end;
/

set serveroutput on
set verify off
accept p_ename prompt '사원 이름을 입력하세요 ~ '
declare  
     v_ename  emp.ename%type := upper('&p_ename');
     v_sal     emp.sal%type;  

 begin  
    select  sal  into  v_sal 
      from  emp
      where ename = v_ename;
     
    if   v_sal >= 3000  then 
         dbms_output.put_line('고소득자 입니다.');
    elsif   v_sal >= 2000  then 
        dbms_output.put_line('중간 소득자 입니다.');
    else  
        dbms_output.put_line('저소득자 입니다.');
     end  if;
end;
/

set serveroutput on
declare   
      v_count    number(10) := 0 ;
begin
      loop
        v_count  :=  v_count + 1; 
   dbms_output.put_line ( '2 x ' || v_count || ' = ' ||  2*v_count);                          
        exit when v_count = 9;
     end loop;
end;
/

----------------------------------------------------------
-- 연습문제
----------------------------------------------------------
-- 1. 구구단 중 3단을 출력하는 익명 블록을 만들어보자.
-- <정답>
BEGIN
   DBMS_OUTPUT.PUT_LINE('3 * 1 = ' || 3*1);
   DBMS_OUTPUT.PUT_LINE('3 * 2 = ' || 3*2);
   DBMS_OUTPUT.PUT_LINE('3 * 3 = ' || 3*3);
   DBMS_OUTPUT.PUT_LINE('3 * 4 = ' || 3*4);
   DBMS_OUTPUT.PUT_LINE('3 * 5 = ' || 3*5);
   DBMS_OUTPUT.PUT_LINE('3 * 6 = ' || 3*6);
   DBMS_OUTPUT.PUT_LINE('3 * 7 = ' || 3*7);
   DBMS_OUTPUT.PUT_LINE('3 * 8 = ' || 3*8);
   DBMS_OUTPUT.PUT_LINE('3 * 9 = ' || 3*9);   
END;


-- 2. 사원 테이블에서 201번 사원의 이름과 이메일주소를 출력하는 익명 블록을 만들어 보자.
DECLARE
   vs_emp_name employees.emp_name%TYPE;
   vs_email    employees.email%TYPE;
BEGIN
   
   SELECT emp_name, email
     INTO vs_emp_name, vs_email
     FROM employees
    WHERE employee_id = 201;
    
   DBMS_OUTPUT.PUT_LINE ( vs_emp_name || ' - ' || vs_email);
END;

-- 사원 테이블에서 사원번호가 제일 큰 사원을 찾아낸 뒤, 이 번호 +1번으로 아래의 사원을 사원테이블에 신규 입력하는 익명 블록을 만들어 보자.
/*
<사원명>   : Harrison Ford
<이메일>   : HARRIS
<입사일자> : 현재일자
<부서번호> : 50
*/

DECLARE
   vn_max_empno employees.employee_id%TYPE;
   vs_email    employees.email%TYPE;
BEGIN
   
   SELECT MAX(employee_id)
     INTO vn_max_empno
     FROM employees;
     
   INSERT INTO employees ( employee_id, emp_name, email, hire_date, department_id )
                  VALUES ( vn_max_empno + 1, 'Harrison Ford', 'HARRIS', SYSDATE, 50);
                  
   COMMIT;                  

END;

-- SELECT * FROM employees;
DELETE FROM employees WHERE employee_id = 207;
COMMIT;

-- IF 문

DECLARE
   vn_num1 NUMBER := 1;
   vn_num2 NUMBER := 2 ;
BEGIN
	
	 IF vn_num1 >= vn_num2 THEN
	    DBMS_OUTPUT.PUT_LINE(vn_num1 ||'이 큰 수');
	 ELSE
	    DBMS_OUTPUT.PUT_LINE(vn_num2 ||'이 큰 수');	 
	 END IF;
	
END;


DECLARE
   vn_salary NUMBER := 0;
   vn_department_id NUMBER := 0;
BEGIN
	
	vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
  
   SELECT salary
     INTO vn_salary
     FROM employees
    WHERE department_id = vn_department_id
      AND ROWNUM = 1;

  DBMS_OUTPUT.PUT_LINE(vn_salary);
  
  IF vn_salary BETWEEN 1 AND 3000 THEN
     DBMS_OUTPUT.PUT_LINE('낮음');
  
  ELSIF vn_salary BETWEEN 3001 AND 6000 THEN
     DBMS_OUTPUT.PUT_LINE('중간');
  
  ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
     DBMS_OUTPUT.PUT_LINE('높음');
  
  ELSE
     DBMS_OUTPUT.PUT_LINE('최상위');
  END IF;  
   
	
END;


DECLARE
   vn_salary NUMBER := 0;
   vn_department_id NUMBER := 0;
   vn_commission NUMBER := 0;
BEGIN
	
	vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
  
   SELECT salary, commission_pct
     INTO vn_salary, vn_commission
     FROM employees
    WHERE department_id = vn_department_id
      AND ROWNUM = 1;

  DBMS_OUTPUT.PUT_LINE(vn_salary);
  
  IF vn_commission > 0 THEN
     IF vn_commission > 0.15 THEN
        DBMS_OUTPUT.PUT_LINE(vn_salary * vn_commission );
     END IF;  
  ELSE
     DBMS_OUTPUT.PUT_LINE(vn_salary);
  END IF;  
END;

-- CASE 문
DECLARE
   vn_salary NUMBER := 0;
   vn_department_id NUMBER := 0;
BEGIN
	
	vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
  
   SELECT salary
     INTO vn_salary
     FROM employees
    WHERE department_id = vn_department_id
      AND ROWNUM = 1;

  DBMS_OUTPUT.PUT_LINE(vn_salary);
  
  CASE WHEN vn_salary BETWEEN 1 AND 3000 THEN
            DBMS_OUTPUT.PUT_LINE('낮음');
       WHEN vn_salary BETWEEN 3001 AND 6000 THEN
            DBMS_OUTPUT.PUT_LINE('중간');
       WHEN vn_salary BETWEEN 6001 AND 10000 THEN
            DBMS_OUTPUT.PUT_LINE('높음');
       ELSE 
            DBMS_OUTPUT.PUT_LINE('최상위');
  END CASE;

END;

-- LOOP 문
DECLARE
   vn_base_num NUMBER := 3;
   vn_cnt      NUMBER := 1;
BEGIN
   
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
      
      vn_cnt := vn_cnt + 1; -- vn_cnt 값을 1씩 증가
      
      EXIT WHEN vn_cnt >9;  -- vn_cnt가 9보다 크면 루프 종료
   
   END LOOP;
    
END;


-- WHILE 문
DECLARE
   vn_base_num NUMBER := 3;
   vn_cnt      NUMBER := 1;
BEGIN
   
   WHILE  vn_cnt <= 9 -- vn_cnt가 9보다 작거나 같을 경우에만 반복처리 
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
      
      vn_cnt := vn_cnt + 1; -- vn_cnt 값을 1씩 증가
      
   END LOOP;
    
END;

DECLARE
   vn_base_num NUMBER := 3;
   vn_cnt      NUMBER := 1;
BEGIN
   
   WHILE  vn_cnt <= 9 -- vn_cnt가 9보다 작거나 같을 경우에만 반복처리 
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
      EXIT WHEN vn_cnt = 5;
      vn_cnt := vn_cnt + 1; -- vn_cnt 값을 1씩 증가
   END LOOP;    
END;



-- FOR 문
DECLARE
   vn_base_num NUMBER := 3;
BEGIN
   
   FOR i IN 1..9 
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
      
   END LOOP;
    
END;


DECLARE
   vn_base_num NUMBER := 3;
BEGIN
   
   FOR i IN REVERSE 9..1
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
      
   END LOOP;
    
END;

-- CONTINUE 문
DECLARE
   vn_base_num NUMBER := 3;
BEGIN
   
   FOR i IN 1..9 
   LOOP
      CONTINUE WHEN i=5;
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
   END LOOP;
    
END;

-- GOTO문
-- GOTO문을 만나면 GOTO문이 지정하는 라벨로 제어가 넘어감
-- 첫번째 FOR문에서 인덱스 값이 3이면, fourth 라벨로 이동해 3단 출력, 4단 출력

DECLARE
   vn_base_num NUMBER := 3;
BEGIN
   
   <<third>>
   FOR i IN 1..9 
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
      
      IF i = 3 THEN
         GOTO fourth;
      END IF;   
   END LOOP;
   
   <<fourth>>
   vn_base_num := 4;
   FOR i IN 1..9 
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
   END LOOP;   
    
END;


-- NULL 문
-- NULL 문은 아무것도 처리하지 않는 문장이다. 
-- NULL문은 보통 IF문이나 CASE문을 작성할 때 주로 사용함.
-- 조건에 따라 처리 로직 시, 앞에서 작성한 모든 조건에 부합되지 않을 때 사용

IF vn_variable = 'A' THEN
   처리로직1;
ELSIF vn_variable = 'B' THEN
   처리로직2;
...
ELSE NULL;
END IF;

CASE WHEN vn_variable = 'A' THEN
          처리로직1;
     WHEN vn_variable = 'B' THEN
          처리로직2;      
     ...
     ELSE NULL;
END CASE;     


