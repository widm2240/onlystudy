-- PL/SQL day02_morning.sql
-- 익명블록
SET SERVEROUTPUT ON

DECLARE
    vi_num NUMBER;
    
BEGIN
    vi_num := 100;
    DBMS_OUTPUT.PUT_LINE('vi_num = ' || TO_CHAR(vi_num));
END;
/



-- 38라인
-- DML
-- 사원 ID가 100인 사원의 이름명, 부서명을 조회해라
SET SERVEROUTPUT ON
DECLARE

    vs_emp_name VARCHAR2(80); -- 사원명 변수
    vs_dep_name VARCHAR2(80); -- 부서명 변수

BEGIN

    SELECT a.emp_name, b.department_name
        INTO vs_emp_name, vs_dep_name
    FROM employees a, departments b
    WHERE a.department_id = b.department_id
        AND a.employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ' - ' || vs_dep_name);
    
END;
/

-- 숫자를 입력받아서 출력하는 예제
SET SERVEROUTPUT ON
ACCEPT p_num1 prompt '첫번째 숫자를 입력하세요 ~'
ACCEPT p_num2 prompt '두번째 숫자를 입력하세요 ~'

DECLARE
    v_sum number(10);
BEGIN
    v_sum := &p_num1 + &p_num2;
        DBMS_OUTPUT.PUT_LINE('총합은 : ' || TO_CHAR(v_sum));

END;
/


-- 문제 : 임의의 사원번호를 입력하면 employees 테이블에서 해당 사원번호의 급여를 출력해라  81줄
select * from employees;

SET SERVEROUTPUT ON
ACCEPT p_empno prompt '사원번호를 입력하세요 ~'

DECLARE
    v_salary NUMBER;
    v_name VARCHAR2(80);
BEGIN
    SELECT salary, emp_name INTO v_salary, v_name FROM employees WHERE employee_id= &p_empno;
            DBMS_OUTPUT.PUT_LINE(v_name ||' - ' || TO_CHAR(v_salary));

END;
/

ACCEPT p_num prompt '숫자를 입력하세요 ~'

BEGIN
    IF mod(&p_num, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('짝수입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('홀수입니다.');
    END IF;
END;
/

-- 고소득자, 중간 소득자, 저 소득자 구분하는 익명블록 만들기
-- 임의의 사원번호 / 교재에는 사원명 입력
select * from employees where salary >= 5000;

ACCEPT p_empno prompt '사원번호를 입력하세요 ~'

DECLARE
    --v_salary NUMBER;
    v_salary        employees.salary%TYPE;
BEGIN
    SELECT salary INTO v_salary FROM employees WHERE employee_id= &p_empno;
    -- DBMS_OUTPUT.PUT_LINE(v_salary);
    
    IF v_salary >= 5000 THEN
        DBMS_OUTPUT.PUT_LINE('고소득자');

    ELSIF v_salary >= 3000 THEN
        DBMS_OUTPUT.PUT_LINE('중간 소득자');
    ELSE
        DBMS_OUTPUT.PUT_LINE('저소득자');
    END IF;
END;
/

-- 문제
-- 사원 테이블에서 사원번호가 제일 큰 사원을 찾아낸 뒤, 
-- 이 번호 +1번으로 아래의 사원을 사원테이블에 신규 입력하는 익명 블록을 만들어 보자.
SELECT * FROM employees;
/*
<사원명>   : Harrison Ford
<이메일>   : HARRIS
<입사일자> : 현재일자
<부서번호> : 50
*/

DECLARE
    vn_max_empno employees.employee_id%TYPE;
BEGIN

    SELECT MAX(employee_id) INTO vn_max_empno FROM employees;

    INSERT INTO employees ( employee_id, emp_name, email, hire_date, department_id )
        VALUES ( vn_max_empno + 1, 'Harrison Ford', 'HARRIS', SYSDATE, 50);
        
    COMMIT;
END;

SELECT * FROM employees ORDER BY employee_id DESC;


-- 반복문
-- 303번째 라인부터 시작
-- LOOP문 3단 곱하기 작성

DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt NUMBER := 1;
BEGIN
    LOOP
    
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || vn_cnt || '=' || vn_base_num * vn_cnt);
        vn_cnt := vn_cnt + 1; -- vn_cnt 값이 계속 1씩 증가
        
        EXIT WHEN vn_cnt >9;
    
    END LOOP;
END;
/

-- WHILE 문 (LOOP ~ END LOOP가 들어가야함.)
DECLARE
    vn_base_num NUMBER := 4;
    vn_cnt NUMBER := 1;
BEGIN

    WHILE vn_cnt <= 9 -- vn_cnt가 9보다 작거나 같을 경우 처리
    LOOP
    
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || vn_cnt || '=' || vn_base_num * vn_cnt);
        vn_cnt := vn_cnt + 1; -- vn_cnt 값이 계속 1씩 증가
--        EXIT WHEN vn_cnt = 5; 조건식을 넣어서 멈추는 break문 과 같다.
    END LOOP;

END;
/

-- FOR LOOP 문

DECLARE
    vn_base_num NUMBER := 5;
BEGIN

    FOR i IN 1..9 -- 1부터 9까지 반복문 수행
    LOOP
    
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '=' || vn_base_num * i);
            
    END LOOP;

END;
/

-- 나머지와 몫, 나머지를 반환하는 함수 day02_after
CREATE OR REPLACE FUNCTION my_mod(num1 NUMBER, num2 NUMBER)
    RETURN NUMBER -- 반환 데이터타입 지정
IS
    -- 변수 선언
    vn_remainder NUMBER := 0; --반환할 나머지
    vn_quotient NUMBER := 0; -- 몫
    
BEGIN

    -- 수식 작성
    vn_quotient := FLOOR(num1 / num2); -- 피제수 / 제수 정수 부분 걸러내기
    vn_remainder := num1 - (num2 * vn_quotient); -- 나머지 = 피제수 - (제수 * 몫)
    
    RETURN vn_remainder; -- 나머지 반환

END;
/

SELECT my_mod(14, 3) remainder FROM DUAL;

-- 국가명을 반환하는 함수 작성
-- 52790 미국, 52784 네덜란드
SELECT * FROM countries;

CREATE OR REPLACE FUNCTION fn_get_country_name(p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name countries.country_name%TYPE;
    
BEGIN

    SELECT country_name INTO vs_country_name
    FROM countries
    WHERE country_id = p_country_id;
    
    RETURN vs_country_name; -- 국가명 반환

END;

-- 활용
-- 52790 미국, 52784 네덜란드
SELECT 
    fn_get_country_name(52790) country1
    ,   fn_get_country_name(52784) country2
FROM 
    DUAL;
    
SELECT 
    fn_get_country_name(111111) country1
    ,   fn_get_country_name(52784) country2
FROM 
    DUAL;
    
CREATE OR REPLACE FUNCTION fn_get_country_name(p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name countries.country_name%TYPE;
    vn_count NUMBER := 0;
BEGIN
    
    SELECT count(*) INTO vn_count
    FROM countries
    WHERE country_id = p_country_id;
    
    IF vn_count = 0 THEN
        vs_country_name := '국가 없음';
    ELSE
        SELECT country_name INTO vs_country_name
        FROM countries
        WHERE country_id = p_country_id;
    
    END IF;
    
    RETURN vs_country_name; -- 국가명 반환
    
    

END;

SELECT 
    fn_get_country_name(111111) country1
    ,   fn_get_country_name(52784) country2
FROM 
    DUAL;