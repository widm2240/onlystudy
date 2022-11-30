-- PROCEDUTRE 작성
-- 94p부터

-- day02_afternoon.sql
-- 92 line

CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_job_id    IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal   IN jobs.min_salary%TYPE,
    p_max_sal   IN jobs.max_salary%TYPE

)


IS
BEGIN
        INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
        COMMIT;
END;

-- 프로시저 실행
SELECT * FROM jobs;
EXEC my_new_job_proc('SM_JOB1', 'Sample JOB1', 1000, 5000);

SELECT * FROM jobs;

EXEC my_new_job_proc('SM_JOB1', 'Sample JOB1', 1000, 5000);


-- 회원가입 페이지
-- 중복 ID가 있음 안됨(X)
-- 일반적으로 스프링쪽에서 개발 vs DB쪽에서 개발

CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_job_id    IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal   IN jobs.min_salary%TYPE,
    p_max_sal   IN jobs.max_salary%TYPE
)
IS
    vn_cnt NUMBER := 0;
BEGIN
    
    -- 동일한 job_id가 있는지 체크
    SELECT count(*) INTO vn_cnt
    FROM jobs
    WHERE job_id = p_job_id;
    
    -- 0이면, 없다. 그럼 INSERT
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
    ELSE -- 있으면 update
        UPDATE jobs
            SET job_title = p_job_title,
                min_salary = p_min_sal,
                max_salary = p_max_sal,
                update_date = SYSDATE
        WHERE job_id = p_job_id;
    END IF;    
        COMMIT;
END;

EXEC my_new_job_proc('SM_JOB1', 'Sample JOB1', 1000, 5000);

SELECT * FROM jobs;

-- 매개변수 디폴트 값 설정
CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_job_id    IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal   IN jobs.min_salary%TYPE := 10,
    p_max_sal   IN jobs.max_salary%TYPE := 100
)
IS
    vn_cnt NUMBER := 0;
BEGIN
    
    -- 동일한 job_id가 있는지 체크
    SELECT count(*) INTO vn_cnt
    FROM jobs
    WHERE job_id = p_job_id;
    
    -- 0이면, 없다. 그럼 INSERT
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
    ELSE -- 있으면 update
        UPDATE jobs
            SET job_title = p_job_title,
                min_salary = p_min_sal,
                max_salary = p_max_sal,
                update_date = SYSDATE
        WHERE job_id = p_job_id;
    END IF;    
        COMMIT;
END;
EXEC my_new_job_proc('SM_JOB1', 'Sample JOB1');
SELECT * FROM jobs;

-- IN / OUT / IN OUT 매개변수 이해
-- 270라인
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE my_parameter_test_proc(
    p_var1          VARCHAR2,
    p_var2 OUT      VARCHAR2,
    p_var3 IN OUT   VARCHAR2

)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('p_var1 value = ' || p_var1);
    DBMS_OUTPUT.PUT_LINE('p_var2 value = ' || p_var2); -- p_var2의 값은 왜 안뜰까? 바로 매개변수에 out을 넣었기 때문
    DBMS_OUTPUT.PUT_LINE('p_var3 value = ' || p_var3);
    
    p_var2 := 'B2';
    p_var3 := 'C2';
END;

-- 익명블록 테스트
DECLARE

    v_var1 VARCHAR2(10) := 'A';
    v_var2 VARCHAR2(10) := 'B';
    v_var3 VARCHAR2(10) := 'C';

BEGIN

    my_parameter_test_proc(v_var1, v_var2, v_var3);
    DBMS_OUTPUT.PUT_LINE('v_var2 value = ' || v_var2);
    DBMS_OUTPUT.PUT_LINE('v_var3 value = ' || v_var3);
END;

-- RETURN문
-- PROCEDURE에서의 RETURN문은 코드를 종료하는 의미

CREATE OR REPLACE PROCEDURE my_new_job_proc(
    p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE := 10,
    p_max_sal IN jobs.max_salary%TYPE := 100

)

IS
    vn_cnt NUMBER := 0;
    vn_cur_date jobs.update_date%TYPE := SYSDATE;
BEGIN

    -- 1000보다 작으면 메시지 출력 후 빠져나간다
    IF p_min_sal < 1000 THEN
        DBMS_OUTPUT.PUT_LINE('최소 급여값은 1000 이상이어야 합니다');
        RETURN;
    END IF;
        
        
        -- 동일한 job_id가 있는지 체크
    SELECT count(*) INTO vn_cnt
    FROM jobs
    WHERE job_id = p_job_id;
    
    -- 0이면, 없다. 그럼 INSERT
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
    ELSE -- 있으면 update
        UPDATE jobs
            SET job_title = p_job_title,
                min_salary = p_min_sal,
                max_salary = p_max_sal,
                update_date = SYSDATE
        WHERE job_id = p_job_id;
    END IF;    
        COMMIT;

END;


EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1',999, 50000);
SELECT * FROM jobs;

-- 예외처리
-- 374라인
CREATE OR REPLACE PROCEDURE no_exception_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('Success!');
END;

CREATE OR REPLACE PROCEDURE exception_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('Success!');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.!');
END;

-- 예외 처리가 없는 프로시저 실행
DECLARE
BEGIN
    --no_exception_proc;
    exception_proc;
    DBMS_OUTPUT.PUT_LINE('실행!');
    
END;

-- 예외처리 업그레이드
CREATE OR REPLACE PROCEDURE exception_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('Success!');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.!');
    DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE:' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE:' || SQLERRM);

END;

EXEC exception_proc;

-- 예외처리 업그레이드
CREATE OR REPLACE PROCEDURE exception_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('Success!');
-- EXCEPTION WHEN OTHERS THEN
EXCEPTION WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE('ZERO_DIVIDDE 발생!');
    DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE:' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE:' || SQLERRM);

END;

EXEC exception_proc;

-- 예외처리 업그레이드
CREATE OR REPLACE PROCEDURE exception_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('Success!');
-- EXCEPTION WHEN OTHERS THEN
EXCEPTION WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('ZERO_DIVIDDE 발생!');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE:' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE:' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('다른 에러 발생!');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE:' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE:' || SQLERRM);
END;
EXEC exception_proc;

-- 727라인
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

-- 부서번호 잘못 입력
EXEC ins_emp2_proc('HONG', 1000, '201401');

-- 잘못된 월
EXEC ins_emp2_proc('EVAN', 100, '202213');

SELECT * FROM error_log_tb;

-- 트리거
CREATE TABLE exam1(
    id NUMBER PRIMARY KEY
    , name VARCHAR2(20)
);

CREATE TABLE exam2(
    log VARCHAR2(100)
    , regdate DATE Default SYSDATE
);


-- 상황1. exam1 테이블에 간단하게 insert문 추가 874 라인
-- exam2에 해당 로그 기록을 남김

CREATE OR REPLACE TRIGGER triger_insert_exam2
AFTER
    INSERT ON exam1
BEGIN
    INSERT INTO exam2(log) VALUES('추가작업 - 로그');
END;

SELECT * FROM exam2; -- 현재는 아무것도 없음 
INSERT INTO exam1 VALUES(100, '홍길동');
SELECT * FROM exam2; -- INSERT INTO 가 exam1에 들어가면서 exam2에 로그가 남는 다는 것을 확인해볼 수 있다. 

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
SELECT * FROM exam1;
commit;
-- 