-- 사용자 정의 함수
-- 익명 블록은 한번 사용하고 나면 없어져 버리는 휘발성 블록 
-- 실무에서는 PL/SQL 작성 시, 종종 사용함 
SET SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION my_mod ( num1 NUMBER, num2 NUMBER )
   RETURN NUMBER  -- 반환 데이터타입은 NUMBER
IS
   vn_remainder NUMBER := 0; -- 반환할 나머지
   vn_quotient  NUMBER := 0; -- 몫 
BEGIN
	 
	 vn_quotient  := FLOOR(num1 / num2); -- 피제수/제수 결과에서 정수 부분을 걸러낸다
	 vn_remainder := num1 - ( num2 * vn_quotient); --나머지 = 피제수 - ( 제수 * 몫)
	 
	 RETURN vn_remainder;  -- 나머지를 반환
	
END;	
  
  
SELECT my_mod(14, 3) reminder
  FROM DUAL;  
  

CREATE OR REPLACE FUNCTION fn_get_country_name ( p_country_id NUMBER )
   RETURN VARCHAR2  -- 국가명을 반환하므로 반환 데이터타입은 VARCHAR2
IS
   vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
	 
	 SELECT country_name
	   INTO vs_country_name
	   FROM countries
	  WHERE country_id = p_country_id;
	 
	 RETURN vs_country_name;  -- 국가명 반환
	
END;	


SELECT fn_get_country_name (52777) COUN1, fn_get_country_name(10000) COUN2
  FROM DUAL;
  
CREATE OR REPLACE FUNCTION fn_get_country_name ( p_country_id NUMBER )
   RETURN VARCHAR2  -- 국가명을 반환하므로 반환 데이터타입은 VARCHAR2
IS
   vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
   vn_count NUMBER := 0;
BEGIN
	
	
	SELECT COUNT(*)
	  INTO vn_count
	  FROM countries
	 WHERE country_id = p_country_id;
	 
  IF vn_count = 0 THEN
     vs_country_name := '해당국가 없음';
  ELSE
	
	  SELECT country_name
	    INTO vs_country_name
	    FROM countries
	   WHERE country_id = p_country_id;
	      
  END IF;
	 
 RETURN vs_country_name;  -- 국가명 반환
	
END;	  
  
SELECT fn_get_country_name (52777) COUN1, fn_get_country_name(10000) COUN2
  FROM DUAL;
  

CREATE OR REPLACE FUNCTION fn_get_user
   RETURN VARCHAR2  -- 반환 데이터타입은 VARCHAR2
IS
   vs_user_name VARCHAR2(80);
BEGIN
	SELECT USER
    INTO vs_user_name
    FROM DUAL;
		 
  RETURN vs_user_name;  -- 사용자이름 반환
	
END;	 	

SELECT fn_get_user(),fn_get_user
  FROM DUAL;


-- 프로시저 생성

CREATE OR REPLACE PROCEDURE my_new_job_proc 
          ( p_job_id    IN JOBS.JOB_ID%TYPE,
            p_job_title IN JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN JOBS.MIN_SALARY%TYPE,
            p_max_sal   IN JOBS.MAX_SALARY%TYPE )
IS

BEGIN
	
	INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
	          VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
	          
	COMMIT;
	
	
END ;            

-- 프로시저 실행

EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000);

SELECT *
  FROM jobs
 WHERE job_id = 'SM_JOB1';
 
EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000); 
 
 
CREATE OR REPLACE PROCEDURE my_new_job_proc 
          ( p_job_id    IN JOBS.JOB_ID%TYPE,
            p_job_title IN JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN JOBS.MIN_SALARY%TYPE,
            p_max_sal   IN JOBS.MAX_SALARY%TYPE )
IS
  vn_cnt NUMBER := 0;
BEGIN
	
	-- 동일한 job_id가 있는지 체크
	SELECT COUNT(*)
	  INTO vn_cnt
	  FROM JOBS
	 WHERE job_id = p_job_id;
	 
	-- 없으면 INSERT 
	IF vn_cnt = 0 THEN 
	
	   INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
	             VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
	             
	ELSE -- 있으면 UPDATE
	
	   UPDATE JOBS
	      SET job_title   = p_job_title,
	          min_salary  = p_min_sal,
	          max_salary  = p_max_sal,
	          update_date = SYSDATE
	    WHERE job_id = p_job_id;
	
  END IF;
	          
	COMMIT;
	
	
END ;   

EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 2000, 6000);


SELECT *
  FROM jobs
 WHERE job_id = 'SM_JOB1';
 
 
-- 매개변수 디폴트 값 설정 
 
EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1'); 
 
 
CREATE OR REPLACE PROCEDURE my_new_job_proc 
          ( p_job_id    IN JOBS.JOB_ID%TYPE,
            p_job_title IN JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN JOBS.MIN_SALARY%TYPE := 10,
            p_max_sal   IN JOBS.MAX_SALARY%TYPE := 100 )
IS
  vn_cnt NUMBER := 0;
BEGIN
	
	-- 동일한 job_id가 있는지 체크
	SELECT COUNT(*)
	  INTO vn_cnt
	  FROM JOBS
	 WHERE job_id = p_job_id;
	 
	-- 없으면 INSERT 
	IF vn_cnt = 0 THEN 
	
	   INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
	             VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
	             
	ELSE -- 있으면 UPDATE
	
	   UPDATE JOBS
	      SET job_title   = p_job_title,
	          min_salary  = p_min_sal,
	          max_salary  = p_max_sal,
	          update_date = SYSDATE
	    WHERE job_id = p_job_id;
	
  END IF;
	          
	COMMIT;
	
	
END ;    


EXECUTE my_new_job_proc ('SM_JOB1', 'Sample JOB1');

SELECT *
  FROM jobs
 WHERE job_id = 'SM_JOB1';
 
-- OUT, IN OUT 매개변수 사용

CREATE OR REPLACE PROCEDURE my_new_job_proc 
          ( p_job_id    IN  JOBS.JOB_ID%TYPE,
            p_job_title IN  JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN  JOBS.MIN_SALARY%TYPE := 10,
            p_max_sal   IN  JOBS.MAX_SALARY%TYPE := 100,
            p_upd_date  OUT JOBS.UPDATE_DATE%TYPE  )
IS
  vn_cnt NUMBER := 0;
  vn_cur_date JOBS.UPDATE_DATE%TYPE := SYSDATE;
BEGIN
	
	-- 동일한 job_id가 있는지 체크
	SELECT COUNT(*)
	  INTO vn_cnt
	  FROM JOBS
	 WHERE job_id = p_job_id;
	 
	-- 없으면 INSERT 
	IF vn_cnt = 0 THEN 
	
	   INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
	             VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, vn_cur_date, vn_cur_date);
	             
	ELSE -- 있으면 UPDATE
	
	   UPDATE JOBS
	      SET job_title   = p_job_title,
	          min_salary  = p_min_sal,
	          max_salary  = p_max_sal,
	          update_date = vn_cur_date
	    WHERE job_id = p_job_id;
	
  END IF;
  
	-- OUT 매개변수에 일자 할당
	p_upd_date := vn_cur_date;
	          
	COMMIT;
	
	
END ;   


DECLARE
   vd_cur_date JOBS.UPDATE_DATE%TYPE;
BEGIN
	 my_new_job_proc ('SM_JOB1', 'Sample JOB1', 2000, 6000, vd_cur_date);
	 
	 DBMS_OUTPUT.PUT_LINE(vd_cur_date);
END;


CREATE OR REPLACE PROCEDURE my_parameter_test_proc (
               p_var1        VARCHAR2,
               p_var2 OUT    VARCHAR2,
               p_var3 IN OUT VARCHAR2 )
IS

BEGIN
	 DBMS_OUTPUT.PUT_LINE('p_var1 value = ' || p_var1);
	 DBMS_OUTPUT.PUT_LINE('p_var2 value = ' || p_var2);
	 DBMS_OUTPUT.PUT_LINE('p_var3 value = ' || p_var3);
	 
	 p_var2 := 'B2';
	 p_var3 := 'C2';
	
END;               


DECLARE 
   v_var1 VARCHAR2(10) := 'A';
   v_var2 VARCHAR2(10) := 'B';
   v_var3 VARCHAR2(10) := 'C';
BEGIN
	 my_parameter_test_proc (v_var1, v_var2, v_var3);
	 
	 DBMS_OUTPUT.PUT_LINE('v_var2 value = ' || v_var2);
	 DBMS_OUTPUT.PUT_LINE('v_var3 value = ' || v_var3);
END;


-- RETURN 문
CREATE OR REPLACE PROCEDURE my_new_job_proc 
          ( p_job_id    IN  JOBS.JOB_ID%TYPE,
            p_job_title IN  JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN  JOBS.MIN_SALARY%TYPE := 10,
            p_max_sal   IN  JOBS.MAX_SALARY%TYPE := 100
            --p_upd_date  OUT JOBS.UPDATE_DATE%TYPE  
            )
IS
  vn_cnt NUMBER := 0;
  vn_cur_date JOBS.UPDATE_DATE%TYPE := SYSDATE;
BEGIN
	-- 1000 보다 작으면 메시지 출력 후 빠져나간다
	IF p_min_sal < 1000 THEN
	   DBMS_OUTPUT.PUT_LINE('최소 급여값은 1000 이상이어야 합니다');
	   RETURN;
  END IF;
	
	-- 동일한 job_id가 있는지 체크
	SELECT COUNT(*)
	  INTO vn_cnt
	  FROM JOBS
	 WHERE job_id = p_job_id;
	 
	-- 없으면 INSERT 
	IF vn_cnt = 0 THEN 
	
	   INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
	             VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, vn_cur_date, vn_cur_date);
	             
	ELSE -- 있으면 UPDATE
	
	   UPDATE JOBS
	      SET job_title   = p_job_title,
	          min_salary  = p_min_sal,
	          max_salary  = p_max_sal,
	          update_date = vn_cur_date
	    WHERE job_id = p_job_id;
	
  END IF;
  
	          
	COMMIT;
	
	
END ;   


EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 999, 6000);




-- 예외처리와 트랜잭션
-- 예외처리구문
DECLARE 
   vi_num NUMBER := 0;
BEGIN
	 vi_num := 10 / 0;
	 DBMS_OUTPUT.PUT_LINE('Success!'); 
END;

-- 10을 0으로 나눌 때의 예외처리를 추가한다. 
DECLARE 
   vi_num NUMBER := 0;
BEGIN
	
	 vi_num := 10 / 0;
	 
	 DBMS_OUTPUT.PUT_LINE('Success!');
	 
EXCEPTION WHEN OTHERS THEN
	 DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다');	
END;

-- 예외처리 부분이 있는 것과 없는 것으로 나누어 2개의 프로시저로 만들어 본다. 
CREATE OR REPLACE PROCEDURE no_exception_proc 
IS
  vi_num NUMBER := 0;
BEGIN
	vi_num := 10 / 0;
	 
	DBMS_OUTPUT.PUT_LINE('Success!');
	
END;	

-- 프로시저 생성
CREATE OR REPLACE PROCEDURE exception_proc 
IS
  vi_num NUMBER := 0;
BEGIN
	vi_num := 10 / 0;
	 
	DBMS_OUTPUT.PUT_LINE('Success!');
EXCEPTION WHEN OTHERS THEN	 
	 DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다');		
	
END;	

-- 예외처리가 없는 프로시저를 실행하는 익명 블록을 만들어 실행한다. 
DECLARE 
   vi_num NUMBER := 0;
BEGIN
	
	 no_exception_proc; 
	 DBMS_OUTPUT.PUT_LINE('Success!');

END;

-- 예외처리가 있는 프로시저를 실행하느 익명 블록을 만들고 실행한다. 
DECLARE 
   vi_num NUMBER := 0;
BEGIN
	
	 exception_proc;
	 DBMS_OUTPUT.PUT_LINE('Success!');

END;


-- SQLCODE, SQLERRM을 이용한 예외정보 참조
CREATE OR REPLACE PROCEDURE exception_proc 
IS
  vi_num NUMBER := 0;
BEGIN
	vi_num := 10 / 0;
	 
	DBMS_OUTPUT.PUT_LINE('Success!');
	
EXCEPTION WHEN OTHERS THEN
	 
 DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다');		
 DBMS_OUTPUT.PUT_LINE( 'SQL ERROR CODE: ' || SQLCODE);
 DBMS_OUTPUT.PUT_LINE( 'SQL ERROR MESSAGE: ' || SQLERRM); -- 매개변수 없는 SQLERRM
 DBMS_OUTPUT.PUT_LINE( SQLERRM(SQLCODE)); -- 매개변수 있는 SQLERRM

	
END;	

EXEC exception_proc;


CREATE OR REPLACE PROCEDURE exception_proc 
IS
  vi_num NUMBER := 0;
BEGIN
	vi_num := 10 / 0;
	 
	DBMS_OUTPUT.PUT_LINE('Success!');
	
EXCEPTION WHEN OTHERS THEN
	 
 DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다');		
 DBMS_OUTPUT.PUT_LINE( 'SQL ERROR CODE: ' || SQLCODE);
 DBMS_OUTPUT.PUT_LINE( 'SQL ERROR MESSAGE: ' || SQLERRM); 
 
 DBMS_OUTPUT.PUT_LINE( DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
	
END;	


-- 시스템 예외 
CREATE OR REPLACE PROCEDURE exception_proc 
IS
  vi_num NUMBER := 0;
BEGIN
	vi_num := 10 / 0;
	 
	DBMS_OUTPUT.PUT_LINE('Success!');
	
EXCEPTION WHEN ZERO_DIVIDE THEN
	 
	 DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다');		
	 DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: ' || SQLCODE);
	 DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: ' || SQLERRM);
	
END;	

EXEC exception_proc;



CREATE OR REPLACE PROCEDURE exception_proc 
IS
  vi_num NUMBER := 0;
BEGIN
	vi_num := 10 / 0;
	 
	DBMS_OUTPUT.PUT_LINE('Success!');
	
EXCEPTION WHEN ZERO_DIVIDE THEN
	          	 DBMS_OUTPUT.PUT_LINE('오류1');		
	             DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE1: ' || SQLERRM);
	        WHEN OTHERS THEN
	          	 DBMS_OUTPUT.PUT_LINE('오류2');		
	             DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE2: ' || SQLERRM);	
END;	

EXEC exception_proc;


CREATE OR REPLACE PROCEDURE upd_jobid_proc 
                  ( p_employee_id employees.employee_id%TYPE,
                    p_job_id      jobs.job_id%TYPE )
IS
  vn_cnt NUMBER := 0;
BEGIN
	
	SELECT COUNT(*)
	  INTO vn_cnt
	  FROM JOBS
	 WHERE JOB_ID = p_job_id;
	 
	IF vn_cnt = 0 THEN
	   DBMS_OUTPUT.PUT_LINE('job_id가 없습니다');
	   RETURN;
	ELSE
	   UPDATE employees
	      SET job_id = p_job_id
	    WHERE employee_id = p_employee_id;
	
  END IF;
  
  COMMIT;
	
END;

EXEC upd_jobid_proc (200, 'SM_JOB2');



CREATE OR REPLACE PROCEDURE upd_jobid_proc 
                  ( p_employee_id employees.employee_id%TYPE,
                    p_job_id      jobs.job_id%TYPE )
IS
  vn_cnt NUMBER := 0;
BEGIN
	
	SELECT 1
	  INTO vn_cnt
	  FROM JOBS
	 WHERE JOB_ID = p_job_id;
	 
   UPDATE employees
      SET job_id = p_job_id
    WHERE employee_id = p_employee_id;
	
  COMMIT;
  
  EXCEPTION WHEN NO_DATA_FOUND THEN
                 DBMS_OUTPUT.PUT_LINE(SQLERRM);
                 DBMS_OUTPUT.PUT_LINE(p_job_id ||'에 해당하는 job_id가 없습니다');
            WHEN OTHERS THEN
                 DBMS_OUTPUT.PUT_LINE('기타 에러: ' || SQLERRM);
END;
                   

EXEC upd_jobid_proc (200, 'SM_JOB2');


CREATE OR REPLACE PROCEDURE upd_jobid_proc 
                  ( p_employee_id employees.employee_id%TYPE,
                    p_job_id      jobs.job_id%TYPE)
IS
  vn_cnt NUMBER := 0;
BEGIN
	
	SELECT 1
	  INTO vn_cnt
	  FROM JOBS
	 WHERE JOB_ID = p_job_id;
	 
   UPDATE employees
      SET job_id = p_job_id
    WHERE employee_id = p_employee_id;
	
  COMMIT;
  
  EXCEPTION WHEN NO_DATA_FOUND THEN
                 DBMS_OUTPUT.PUT_LINE(SQLERRM);
                 DBMS_OUTPUT.PUT_LINE(p_job_id ||'에 해당하는 job_id가 없습니다');
            WHEN OTHERS THEN
                 DBMS_OUTPUT.PUT_LINE('기타 에러: ' || SQLERRM);
END;

-- 사용자 정의 예외

CREATE OR REPLACE PROCEDURE ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   
   ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 정의
BEGIN
	
	 -- 부서테이블에서 해당 부서번호 존재유무 체크
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	  WHERE department_id = p_department_id;
	  
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- 사용자 정의 예외 발생
	 END IF;
	 
	 -- employee_id의 max 값에 +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 
	 -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
              
   COMMIT;              
              
EXCEPTION WHEN ex_invalid_depid THEN -- 사용자 정의 예외 처리
               DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              
	
END;                	


EXEC ins_emp_proc ('홍길동', 999);


CREATE OR REPLACE PROCEDURE ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month  VARCHAR2  )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   
   ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 정의
   
   ex_invalid_month EXCEPTION; -- 잘못된 입사월인 경우 예외 정의
   PRAGMA EXCEPTION_INIT ( ex_invalid_month, -1843); -- 예외명과 예외코드 연결
BEGIN
	
	 -- 부서테이블에서 해당 부서번호 존재유무 체크
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	  WHERE department_id = p_department_id;
	  
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- 사용자 정의 예외 발생
	 END IF;
	 
	 -- 입사월 체크 (1~12월 범위를 벗어났는지 체크)
	 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
	    RAISE ex_invalid_month; -- 사용자 정의 예외 발생
	 
	 END IF;
	 
	 
	 -- employee_id의 max 값에 +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 
	 -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
              
   COMMIT;              
              
EXCEPTION WHEN ex_invalid_depid THEN -- 사용자 정의 예외 처리
               DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
          WHEN ex_invalid_month THEN -- 입사월 사용자 정의 예외 처리
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               DBMS_OUTPUT.PUT_LINE('1~12월 범위를 벗어난 월입니다');               
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              
	
END;    

EXEC ins_emp_proc ('홍길동', 110, '201314');


-- RAISE와 RAISE_APPLICATOIN_ERROR
CREATE OR REPLACE PROCEDURE raise_test_proc ( p_num NUMBER)
IS

BEGIN
	IF p_num <= 0 THEN
	   RAISE INVALID_NUMBER;
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(p_num);
  
EXCEPTION WHEN INVALID_NUMBER THEN
               DBMS_OUTPUT.PUT_LINE('양수만 입력받을 수 있습니다');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
	
END;

EXEC raise_test_proc (-10);               



CREATE OR REPLACE PROCEDURE raise_test_proc (p_num NUMBER)
IS

BEGIN
	IF p_num <= 0 THEN
	   --RAISE INVALID_NUMBER;
	   RAISE_APPLICATION_ERROR (-20000, '양수만 입력받을 수 있단 말입니다!');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(p_num);
  
EXCEPTION WHEN INVALID_NUMBER THEN
               DBMS_OUTPUT.PUT_LINE('양수만 입력받을 수 있습니다');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
	
END;

EXEC raise_test_proc (-10);               

-- 효율적인 예외 처리 방법
-- 첫번째, 에러로그 테이블 생성
CREATE TABLE error_log_tb (
                 error_seq     NUMBER,              -- 에러 시퀀스
                 prog_name     VARCHAR2(80),        -- 프로그램명
                 error_code    NUMBER,              -- 에러코드
                 error_message VARCHAR2(300),       -- 에러 메시지
                 error_line    VARCHAR2(100),       -- 에러 라인
                 error_date    DATE DEFAULT SYSDATE -- 에러발생일자
);

-- 더 필요한 정보가 있느면 해당 컬럼을 추가한다. 
-- CREATE SEQUENCE를 사용한다. (자동증가, 일련번호)
CREATE SEQUENCE error_seq
           INCREMENT BY 1
           START WITH 1
           MINVALUE 1
           MAXVALUE 999999
           NOCYCLE
           NOCACHE;

-- 예외가 발생할 때, 예외 로그 테이블에 에러 정보를 입력하는 프로시저를 생성한다. 
CREATE OR REPLACE PROCEDURE error_log_proc (
      p_prog_name error_log_tb.prog_name%TYPE,
      p_error_code error_log_tb.error_code%TYPE,
      p_error_messgge error_log_tb.error_message%TYPE,
      p_error_line error_log_tb.error_line%TYPE)
    IS

    BEGIN
      INSERT INTO error_log_tb (error_seq, prog_name, error_code, error_message, error_line)
           VALUES (error_seq.NEXTVAL, p_prog_name, p_error_code, p_error_messgge, p_error_line );

      COMMIT;
END;

-- 이제 익명 블록이나 다른 프로시저에서 예외가 발생했을 때, 예외처리 부분에서 위 프로시저를 호출한다. 
CREATE OR REPLACE PROCEDURE ins_emp2_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month  VARCHAR2  )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   
   ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 정의
   PRAGMA EXCEPTION_INIT(ex_invalid_depid, -20000); -- 예외명과 예외코드 연결
   
   ex_invalid_month EXCEPTION; -- 잘못된 입사월인 경우 예외 정의
   PRAGMA EXCEPTION_INIT (ex_invalid_month, -1843); -- 예외명과 예외코드 연결
   
   -- 예외 관련 변수 선언
   v_err_code error_log_tb.error_code%TYPE;
   v_err_msg error_log_tb.error_message%TYPE;
   v_err_line error_log_tb.error_line%TYPE;
   
BEGIN
	
	 -- 부서테이블에서 해당 부서번호 존재유무 체크
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	  WHERE department_id = p_department_id;
	  
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- 사용자 정의 예외 발생
	 END IF;
	 
	 -- 입사월 체크 (1~12월 범위를 벗어났는지 체크)
	 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
	    RAISE ex_invalid_month; -- 사용자 정의 예외 발생
	 
	 END IF;
	 
	 -- employee_id의 max 값에 +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 
	 -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES (vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
              
     COMMIT;              
              
EXCEPTION WHEN ex_invalid_depid THEN -- 사용자 정의 예외 처리
    v_err_code := SQLCODE;
    v_err_msg  := '해당 부서가 없습니다';
    v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    ROLLBACK;
    error_log_proc('ins_emp2_proc', v_err_code, v_err_msg, v_err_line);
WHEN ex_invalid_month THEN -- 입사월 사용자 정의 예외 처리
    v_err_code := SQLCODE;
    v_err_msg  := SQLERRM;
    v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    ROLLBACK;
    error_log_proc('ins_emp2_proc', v_err_code, v_err_msg, v_err_line);
WHEN OTHERS THEN
    v_err_code := SQLCODE;
    v_err_msg  := SQLERRM;
    v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    ROLLBACK;
    error_log_proc('ins_emp2_proc', v_err_code, v_err_msg, v_err_line);
END;    


EXEC ins_emp2_proc('HONG', 1000, '201401');

-- 잘못된 월
EXEC ins_emp2_proc('EVAN', 100, '202213');

-- 에러 로그 테이블 확인
SELECT * FROM error_log_tb;

-- 트리거 
-- 특정 이벤트가 발생하면, DB에 의해 자동으로 수행되는 블록 
-- 트리거 크게 2가지 종류
-- DML 트리거 / 시스템 트리거 (DB, 스키마, 등)
-- INSERT, UPDATE, DELETE (문장 단위, 행 단위) 


-- 트리거 동작 하는 시기 : before, after 
-- 특정한 조건을 만족 시, 트리거 작동
-- 사용자가 트리거 이벤트를 언제 실행할 것인지 

-- 실행 시점 / 실행 범위 / 내용
-- Before / 문장 단위 / SQL문이 실행되기 전에 특정 문장 한번 실행
-- Before / 행 단위 / DML 작업하기 전에 각 행에 대해 한번 실행
-- After / 문장 단위 / SQL문이 실행한 후에 특정 문장 한번 실행
-- After / 행 단위 / DML 작업한 후 에 각 행에 대해 한번 실행

DROP TABLE exam2;
CREATE TABLE exam1(
    id NUMBER PRIMARY KEY
    , name VARCHAR2(20)
);

CREATE TABLE exam2(
    log VARCHAR2(100)
    , regdate date Default sysdate
);

-- 상황 1. exam1 테이블에 간단하게 insert문을 추가 한 후
-- 확인하고 싶은 exam2에 로그 기록을 남기고 싶다. 

CREATE OR REPLACE TRIGGER trig_insert_exam2
AFTER 
    INSERT ON exam1 
BEGIN 
    INSERT INTO exam2(log) VALUES('추가작업 - 로그');
END;

INSERT INTO exam1 VALUES (100, '홍길동');

SELECT * FROM exam1;
SELECT * FROM exam2;


CREATE OR REPLACE TRIGGER trig_insert_exam2
AFTER 
    INSERT OR UPDATE OR DELETE ON exam1
DECLARE 
    v_msg VARCHAR2(100);
BEGIN
    -- 조건 술어 (conditional predicate) 
    IF INSERTING THEN 
        v_msg := '> 추가 작업 - 로그';
    ELSIF UPDATING THEN 
        v_msg := '> 수정 작업 - 로그';
    ELSIF DELETING THEN 
        v_msg := '> 삭제 작업 - 로그';
    END IF;
    INSERT INTO exam2(log) VALUES (v_msg);
END;

INSERT INTO exam1 VALUES (101, '김길동');
UPDATE exam1 SET name='김길동' WHERE id = 100;
DELETE FROM exam1 WHERE id = 100;

SELECT * FROM exam2;

-- 개발된 좋아요 버튼 클릭 시 --> 좋아요 갯수가 늘어나는 트리거
-- 근무시간 외에는 작업을 못하도록 시스템에 메시지를 띄움

-- 예) 데이터를 추가한 후, 근무시간이 아닙니다! 
-- 데이터를 추가하기 전에 근무시간이 아닙니다! 
SELECT * FROM exam1;

CREATE OR REPLACE TRIGGER trig_stopexec
BEFORE 
    INSERT OR UPDATE OR DELETE ON exam1 
BEGIN 
    IF SYSDATE = SYSDATE THEN 
        raise_application_error(-20001, '지금은 근무시간이 아닙니다.');
    END IF;
END;

INSERT INTO exam1 VALUES(1004, '지금은');

SELECT * FROM exam1;