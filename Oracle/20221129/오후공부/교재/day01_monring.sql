--------------------------------------------------
-- 사원 테이블, 부서 테이블, 급여 테이블 생성 및 추가
--------------------------------------------------

alter session set nls_date_format='YYYY-MM-DD';

DROP TABLE DEPT;

CREATE TABLE DEPT
(
  DEPTNO        number(10),
  DNAME         VARCHAR2(14),
  LOC           VARCHAR2(13)
);

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

commit;

DROP TABLE EMP;

CREATE TABLE EMP
(
 EMPNO          NUMBER(4) NOT NULL,
 ENAME          VARCHAR2(10),
 JOB            VARCHAR2(9),
 MGR            NUMBER(4) ,
 HIREDATE       DATE,
 SAL            NUMBER(7,2),
 COMM           NUMBER(7,2),
 DEPTNO         NUMBER(2)
);

INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,'81-11-17',5000,NULL,10);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,'81-05-01',2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,'81-05-09',2450,NULL,10);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,'81-04-01',2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,'81-09-10',1250,1400,30);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,'81-02-11',1600,300,30);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,'81-08-21',1500,0,30);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,'81-12-11',950,NULL,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,'81-02-23',1250,500,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,'81-12-11',3000,NULL,20);
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,'80-12-11',800,NULL,20);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,'82-12-22',3000,NULL,20);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,'83-01-15',1100,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,'82-01-11',1300,NULL,10);

commit;

DROP  TABLE  SALGRADE;

CREATE TABLE SALGRADE
(
  grade       number(10),
  losal       number(10),
  hisal       number(10)
);

INSERT INTO SALGRADE VALUES(1,700,1200);
INSERT INTO SALGRADE VALUES(2,1201,1400);
INSERT INTO SALGRADE VALUES(3,1401,2000);
INSERT INTO SALGRADE VALUES(4,2001,3000);
INSERT INTO SALGRADE VALUES(5,3001,9999);

commit;

----------------------------------------------------
-- 사원 테이블, 부서 테이블, 급여 테이블 생성 및 추가완료
----------------------------------------------------

-- 날짜 확인
SELECT SYSDATE FROM DUAL;

-- Q1. 테이블에서 특정 열 선택
-- 가독성 위해 SQL은 대문자, 컬럼명과 테이블명은 소문자로 작성 권장. 
-- 실행은 ctrl+Enter
SELECT empno, ename, sal FROM emp;

-- Q2. 테이블에서 모든 열 출력
SELECT * FROM emp;
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno FROM emp;

-- Q3. 컬럼명 변경 (한글 보다는 영어로) 
SELECT empno as 사원번호 FROM emp;
SELECT empno as employee_number FROM emp;

-- Q4. 연결 연산자 사용
-- 두개의 Column 값이 서로 붙어서 출력됨. 
SELECT ename || sal FROM emp;
SELECT ename || '의 직업은 ' || job || '입니다' as 직업정보 FROM emp;

-- Q5. 중복된 데이터 제거 후 출력
-- DISTINCT 대신 UNIQUE 사용 가능
SELECT DISTINCT job FROM emp;
SELECT UNIQUE job FROM emp;

-- Q6. 데이터 정렬해서 출력하기
SELECT ename, sal FROM emp ORDER BY sal asc; -- 오름차순
SELECT ename, sal FROM emp ORDER BY sal DESC; -- 내림차순
SELECT ename as name, sal FROM emp ORDER BY name DESC;
SELECT ename, deptno, sal FROM emp ORDER BY 2 ASC, 3 DESC; -- 숫자는 컬럼 순서
SELECT ename, deptno, sal FROM emp ORDER BY deptno ASC, sal DESC; -- 

-- Q7. WHERE절 배우기
SELECT ename, sal, job FROM emp WHERE sal = 3000;
SELECT ename as 이름, sal as 월급 FROM emp WHERE sal >= 3000;
-- SELECT ename as 이름, sal as 월급 FROM emp WHERE 월급 >= 3000; 에러 발생

-- Q8. 문자와 날짜 검색
SELECT ename, sal, job, hiredate, deptno FROM emp WHERE ename='SCOTT';

-- Q9. 날짜 형식 변경
-- RR/MM/DD
SELECT * FROM NLS_SESSION_PARAMETERS WHERE PARAMETER = 'NLS_DATE_FORMAT';
ALTER SESSION SET NLS_DATE_FORMAT='YY/MM/DD';

SELECT ename, sal FROM emp WHERE hiredate='81/11/17';
-- 선택한 레코드 없음 

ALTER SESSION SET NLS_DATE_FORMAT='RR/MM/DD';
SELECT ename, sal FROM emp WHERE hiredate='81/11/17';

-- Q10. 산술 연산자 배우기 (*, /, +, -)
SELECT ename, sal, comm, sal + comm FROM emp WHERE deptno = 10;

-- 커미션이 NULL 값이면 같이 연산된 결괏값도 NULL값으로 확인됨. 
-- 이럴경우 NVL() 함수를 사용함. 
-- 참고: https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Functions.html#GUID-D079EFD3-C683-441F-977E-2C9503089982
SELECT ename, sal, NVL(comm, 0), sal + NVL(comm, 0) FROM emp WHERE deptno = 10;
-- NVL 함수는 NULL 데이터 처리. 

-- Q11. 비교 연산자 배우기
-- (>, <, >=, <=, =, !=, <>, ^=)
SELECT ename, sal, job, deptno FROM emp WHERE sal <= 1200;

-- 부등호를 바꿔서 진행한다. 

-- Q12. 비교 연산자 배우기
-- (BETWEEN AND)
-- 아래 두개의 쿼리는 동일함. 
SELECT ename, sal FROM emp WHERE sal BETWEEN 1000 AND 3000;
SELECT ename, sal FROM emp WHERE (sal >= 1000 AND sal <= 3000);


-- NOT을 추가하는 쿼리
-- 아래 두개의 쿼리는 동일함. 
SELECT ename, sal FROM emp WHERE sal NOT BETWEEN 1000 AND 3000;
SELECT ename, sal FROM emp WHERE (sal < 1000 OR sal > 3000);

-- 날짜 조회 쿼리
SELECT ename, hiredate FROM emp WHERE hiredate BETWEEN '1982/01/01' AND '1982/12/31';
SELECT ename, hiredate FROM emp WHERE hiredate NOT BETWEEN '1982/01/01' AND '1982/12/31';

-- Q13. 와일드카드
-- %는 Wild Card라고 부른다. 
-- 'S%'는 첫번째 철자가 S이고 두번째 철자가 %인 데이터를 검색하겠다는 뜻. 
SELECT ename, sal FROM emp WHERE ename LIKE 'S%';

-- '_'는 어떠한 철자가 와도 관계 없으나, 자리수는 한 자리여야 된다는 의미. (하나의 문자와 일치)
SELECT ename FROM emp WHERE ename LIKE '%M_';
SELECT ename FROM emp WHERE ename LIKE '_M%';
SELECT ename FROM emp WHERE ename LIKE '__M%';
SELECT ename FROM emp WHERE ename LIKE '%A%';

-- Q14. 비교 연산자 배우기 IS NULL
-- NULL 값을 검색하기 위해서는 is null 명령어 사용. 
SELECT ename, comm FROM emp WHERE comm is null;

-- Q15. 비교 연산자 배우기 IN
-- IN 연산자를 사용하면 여러 리스트의 값을 조회할 수 있다. 
-- 아래 두개의 쿼리는 동일하다. 
SELECT ename, sal, job FROM emp WHERE job in ('SALESMAN', 'ANALYST');
SELECT ename, sal, job FROM emp WHERE (job = 'SALESMAN' or job = 'ANALYST');

-- NOT을 추가한다. 
SELECT ename, sal, job FROM emp WHERE job NOT in ('SALESMAN', 'ANALYST');
SELECT ename, sal, job FROM emp WHERE (job != 'SALESMAN' AND job != 'ANALYST');

-- Q16. 논리 연산자 배우기 (AND, OR, NOT)
-- 직업이 salesman 월급이 1200 이상, 이름, 월급, 직업 출력
SELECT ename, sal, job FROM emp WHERE job='SALESMAN' AND sal >= 1200;

-- Q17. 대소문자 변환 함수 (UPPER, LOWER, INTCAP)
-- Upper 함수는 대문자로 출력
-- lower 함수는 소문자로 출력
-- initcap 함수는 첫번째 철자만 대문자로 출력

SELECT ename, UPPER(ename), LOWER(ename), INITCAP(ename) FROM emp;

-- 이름이 Scott인 사원의 이름과 월급을 조회하는 쿼리
SELECT ename, sal FROM emp WHERE LOWER(ename)='scott';

-- Q18.문자에서 특정 철자 추출하기 (SUBSTR)
-- 영어 단어 SMITH에서 SMI만 잘라내서 출력한다. 
SELECT SUBSTR('SMITH', 1, 3) FROM DUAL;
SELECT SUBSTR('SMITH', -2, 2) FROM DUAL;
SELECT SUBSTR('SMITH', 2) FROM DUAL;

-- Q19. 문자열의 길이를 출력하기
-- 이름 출력후, 문자열의 길이를 출력한다. 
SELECT ename, LENGTH(ename) FROM emp;

-- Q19. 문자에서 특정 철자의 위치 출력하기
-- gmail.com만 추출한다. 
-- 이 때, SUBSTR 함수를 이용한다. 
SELECT INSTR('SMITH', 'M') FROM DUAL;
SELECT INSTR('abd@gmail.com', '@') FROM DUAL;
SELECT SUBSTR('abd@gmail.com', INSTR('abd@gmail.com', '@')+1) FROM DUAL;

-- Q20. 특정 철자를 다른 철자로 변경하기 (REPLACE)
SELECT ename, sal FROM emp;
SELECT ename, REPLACE(sal, 0, '*') FROM emp;
SELECT ename, REGEXP_REPLACE(sal, '[0-3]', '*') as SALARY FROM emp;

-- Q21. 두 번째 자리의 한글을 *로 출력하기. 
CREATE TABLE TEST_ENAME
(ENAME VARCHAR2(10));

INSERT INTO TEST_ENAME VALUES('김태희');
commit; 

SELECT REPLACE(ename, SUBSTR(ename, 2, 1), '*') as "전광판_이름" FROM TEST_ENAME;
SELECT REPLACE(ename, SUBSTR(ename, 2, 1), '*') as "전광판_이름" FROM emp;

-- Q21. 특정 철자를 N개 만큼 채우기 (LPAD, RPAD)
SELECT ename, LPAD(sal, 10, '*') as salary1, RPAD(sal, 10, '*') as salary2 FROM EMP;
SELECT ename, sal, LPAD('■', round(sal/100), '■') as bar_chart FROM emp;

-- Q22. 특정 철자 잘라내기 (TRIM, RTRIM, LTRIM)
SELECT 'smith', LTRIM('smith', 's'), RTRIM('smith', 'h'), TRIM('s' FROM 'smiths') FROM dual;

-- RTRIM 적용을 위해 공백이 있는 이름 추가
INSERT INTO emp(empno, ename, sal, job, deptno) VALUES(8291, 'JACK   ', 3000, 'SALESMAN', 30);
COMMIT;

-- 이름이 JACK인 사원의 이름과 월급 조회
SELECT ename, sal FROM emp WHERE ename='JACK'; 
-- 조회되지 않음

SELECT ename, sal FROM emp WHERE RTRIM(ename)='JACK'; 
-- 조회됨

-- 다음 실습 위해 입력한 데이터 삭제
DELETE FROM EMP WHERE TRIM(ENAME)='JACK';
COMMIT;

-- Q23. 반올림해서 출력하기 ROUND
SELECT '876.567' AS 숫자, ROUND(876.567, 1) FROM DUAL;
SELECT '876.567' AS 숫자, ROUND(876.567, -1) FROM DUAL;

-- Q24. 숫자를 버리고 출력하기 TRUNC
SELECT '876.567' AS 숫자, TRUNC(876.567, 1) FROM DUAL;
SELECT '876.567' AS 숫자, TRUNC(876.567, -1) FROM DUAL;

-- Q25. 나눈 나머지 값 출력하기
SELECT MOD(10, 3) FROM DUAL;

-- Q26. 날짜 간 개월 수 출력하기
-- SQL> SELECT * FROM NLS_SESSION_PARAMETERS WHERE PARAMETER='NLS_DATE_FORMAT';
-- SQL> ALTER SESSION SET NLS_DATE_FORMAT='RR/MM/DD';
-- MONTHS_BETWEEN(최신 날짜, 예전 날짜)
SELECT ename, MONTHS_BETWEEN(sysdate, hiredate) FROM emp;
SELECT TO_DATE('2021-06-20', 'RRRR-MM-DD') - TO_DATE('2010-05-29', 'RRRR-MM-DD') FROM DUAL;
SELECT ROUND((TO_DATE('2021-06-20', 'RRRR-MM-DD') - TO_DATE('2010-05-29', 'RRRR-MM-DD')) / 7) AS "총 주수" FROM DUAL;

-- Q27. 개월 수 더한 날짜 출력하기 (ADD_MONTHS)
-- 100개월 더하기
SELECT ADD_MONTHS(TO_DATE('2019-05-01', 'RRRR-MM-DD'), 100) FROM DUAL;

-- 100일 더하기
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + 100 FROM DUAL;

-- INTERVAL 활용 
-- 1년 3개월 후의 날짜 출력 쿼리
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '1-3' year(1) to month FROM DUAL;
-- INTERVAL 표현식은 PPT 참조. 

-- Q28. 특정 날짜 뒤에 오는 요일 날짜 출력하기(NEXT_DAY) 
SELECT '2019/05/22' as 날짜, NEXT_DAY('2019/05/22', '월요일') FROM DUAL;

-- Q29. 특정 날짜가 있는 달의 마지막 날짜 출력하기(LAST_DAY)
-- 만약 오늘 날짜가 2021년 7월 20일이라면 2021년7월 31일에서 2021년 7월 20일을 뺀 숫자인 11가 출력됨. 
SELECT LAST_DAY(SYSDATE) - SYSDATE FROM DUAL;
SELECT ename, hiredate, LAST_DAY(hiredate) FROM emp WHERE ename='KING';

-- Q30. 문자형으로 데이터 유형 변환하기 (TO_CHAR)
-- SCOTT 사원의 이름과 입사한 요일 출력, SCOTT의 월급에 천 단위 구분할 수 있는 콤마(,)를 붙여 출력함.
SELECT ename, TO_CHAR(hiredate, 'DAY'), TO_CHAR(sal, '999,999') FROM emp WHERE ename='SCOTT';
SELECT ename
                , TO_CHAR(hiredate, 'RRRR')
                , TO_CHAR(hiredate, 'MM')
                , TO_CHAR(hiredate, 'DD')
                , TO_CHAR(hiredate, 'DAY')
                , TO_CHAR(sal, '999,999')
FROM emp
WHERE ename='SCOTT';

-- 1981년도에 입사한 사원의 이름과 입사일 출력
SELECT ename, hiredate FROM emp WHERE TO_CHAR(hiredate,'RRRR')='1981';
SELECT ename as 이름
       , EXTRACT(year from hiredate) as 연도
       , EXTRACT(MONTH from hiredate) as 달
       , EXTRACT(day from hiredate) as 요일
FROM emp;

-- 이름과 월급 출력 
SELECT ename as 이름, TO_CHAR(sal, '999,999') as 월급 FROM emp;

-- 천 단위와 백만 단위 표시
SELECT ename as 이름, TO_CHAR(sal*200, '999,999,999') as 월급 FROM emp;

-- 원화 단위 붙여 사용
SELECT ename as 이름, TO_CHAR(sal * 200, 'L999,999,999') as 월급 FROM emp;

-- Q31. 날짜형으로 데이터 유형 변환하기 (TO_DATE)
SELECT ename, hiredate FROM emp WHERE hiredate = TO_DATE('81/11/17', 'RR/MM/DD');

-- Q32. 암시적 형 변환 이해하기
SELECT ename, sal FROM emp WHERE sal = '3000';
-- 숫자형 = 문자형 / 숫자형 = 숫자형

-- 임시 테이블 생성
CREATE TABLE EMP32
(ENAME VARCHAR2(10), SAL VARCHAR2(10)); 

INSERT INTO EMP32 VALUES('SCOTT', '3000');
INSERT INTO EMP32 VALUES('SMITH', '1200');

COMMIT;

-- 숫자를 WHERE 조건을 추가하여 조회
-- cmd 창에서 실행
-- 아래 모두 실행 됨. 
SELECT ename, sal FROM EMP32 WHERE sal = '3000'; 
SELECT ename, sal FROM EMP32 WHERE sal = 3000; 
SELECT ename, sal FROM EMP32 WHERE TO_NUMBER(SAL) = 3000;

/*
SET AUTOT ON
SELECT ename, sal FROM EMP32 WHERE SAL = 3000;
*/

-- 오라클이 임시적으로 문자형을 숫자형으로 형변환 한 것으로 확인. 

-- Q33. NULL 값 대신 다른 데이터 출력하기(NVL, NVL2)
-- 커미션이 NULL값인 데이터는 0으로 출력하기
SELECT ename, comm, NVL(comm, 0) FROM emp;

-- NULL 값은 알 수 없기에 커미션이 NULL인 사원들은 월급 + 커미션도 NULL로 출력됨. 
SELECT ename, sal, comm, sal+comm FROM emp WHERE JOB IN('SALESMAN', 'ANALYST');
SELECT ename, sal, comm, NVL(comm, 0), sal+NVL(comm, 0) FROM emp WHERE JOB IN('SALESMAN', 'ANALYST');

-- Q34. IF문을 SQL로 구현하기
-- 부서 번호가 10이면 300, 부서 번호가 20이면, 400, 둘다 아니면 0
SELECT ename, deptno, DECODE(deptno, 10, 300, 20, 400, 0) AS 보너스 FROM emp;

-- 사원 번호와 사원 번호가 짝수인지 홀수 인지 출력하는 쿼리
SELECT empno, mod(empno, 2), DECODE(mod(empno, 2), 0, '짝수', 1, '홀수') as 보너스 FROM emp;

-- 이름과 직업 보너스 출력 시, SALESMAN 보너스 5000 출력, 나머지는 2000 출력
SELECT ename, job, DECODE(job, 'SALESMAN', 5000, 2000) as 보너스 FROM emp;

-- Q35. IF문을 SQL로 구현하기
-- 보너스 월급이 3000 이상이면 500, 2000 <= sal < 3000 이면 300, sal >= 1000 100, 나머지 0
SELECT ename, job, sal, CASE WHEN sal >= 3000 THEN 500
                             WHEN sal >= 2000 THEN 300
                             WHEN sal >= 1000 THEN 200
                             ELSE 0 END as bonus
FROM emp
WHERE job IN('SALESMAN', 'ANALYST');

-- CASE와 DECODE가 다른 점은 DECODE는 등호(=) 비교만 가능, 
-- CASE는 등호(=) 비교 / 부등호 비교 가능
-- 다음의 예제는 이름, 직업, 커미션, 보너스 출력

-- 커미션이 NULL이면 500 출력, NULL이 아니면 0을 출력. 
SELECT ename, job, comm, CASE WHEN comm is null THEN 500 ELSE 0 END bonus
FROM emp 
WHERE job IN ('SALESMAN', 'ANALYST');

-- 이번에는 SALESMAN, ANALYST 이면 500 출력
-- 직업이 CLERK, MANAGER이면 400 출력, 나머지 직업은 0 출력
SELECT ename, job, 
        CASE WHEN job in ('SALESMAN', 'ANALYST') THEN 500
             WHEN job in ('CLERK', 'MANAGER') THEN 300
        ELSE 0 END as bonus
FROM emp;

-- Q36. 최댓값 출력하기(MAX)
SELECT MAX(sal) FROM emp;

-- MAX 함수 이용 시 최댓값 출력 
-- 아래 코드 에러
-- SELECT ename, MAX(SAL) FROM emp WHERE job='SALESMAN';
SELECT job, MAX(SAL)FROM emp WHERE job='SALESMAN' GROUP BY job;

-- 부서 번호와 부서 번호별 최대 월급 출력
SELECT deptno, MAX(sal) FROM emp GROUP BY deptno;

-- Q37. 최솟값 출력하기 (MIN)
-- 기본적인 것은 MAX와 동일하다. 
SELECT MIN(sal) FROM emp WHERE job='SALESMAN';

-- 직업, 직업별 최소 월급 출력, 직업에서 SALESMAN 제외 후 출력, 직업별 최소 월급이 높은 것부터 출력
SELECT job, MIN(sal)
FROM emp 
WHERE job != 'SALESMAN'
GROUP BY job
ORDER BY MIN(sal) DESC;

-- Q38. 평균값 출력하기(AVG)
-- 아래 결과는 커미션을 다 더한 후에 4로 나눈 값임 (NULL 값 제외)
SELECT COUNT(*) FROM emp;
SELECT AVG(comm) FROM emp;
SELECT ROUND(AVG(NVL(comm, 0))) FROM emp;

-- Q39. 토탈값 출력하기(SUM)
SELECT deptno, SUM(sal) FROM emp GROUP BY deptno;

-- 직업과 직업별 토탈 월급을 출력
SELECT job, SUM(sal) 
FROM emp 
GROUP BY job 
ORDER BY sum(sal) DESC;

-- 토탈 월급이 4000 이상인 조건만 허용
SELECT job, SUM(sal) 
FROM emp 
GROUP BY job 
HAVING sum(sal) >= 4000;

-- 직업에서 SALESMAN 제외 직업별 토탈 월급이 4000 이상인 사원들만 출력
SELECT job, SUM(sal) 
FROM emp 
WHERE job != 'SALESMAN'
GROUP BY job
HAVING sum(sal) >= 4000;

-- Q40. 건수 출력하기(COUNT)
-- 사원 테이블 전체 사원수를 출력하는 쿼리
SELECT COUNT(empno) FROM emp;
SELECT COUNT(*) FROM emp;

-- NULL 값 존재 시
SELECT COUNT(COMM) FROM emp;

-- Q41. 데이터 분석 함수로 순위 출력하기 (RANK)
SELECT ename, job, sal, RANK() OVER (ORDER BY sal DESC) 순위
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

-- Q42. 데이터 분석 함수로 순위 출력하기 (DENSE_RANK)
SELECT ename, job, sal
    , RANK() OVER (ORDER BY sal DESC) as RANK
    , DENSE_RANK() OVER (ORDER BY sal DESC) AS DENSE_RANK
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

-- 월급이 2975인 사원의 월급의 순위 출력
SELECT DENSE_RANK(2975) within group (ORDER BY sal DESC) 순위 FROM emp;

-- 입사일이 1981년 11월 18일, 전체 사원들 중 몇 번째로 입사한 것인지 출력하는 쿼리
SELECT DENSE_RANK('81/11/17') within group (ORDER BY hiredate ASC) 순위 
FROM emp;

-- Q43. 데이터 분석 함수로 등급 출력하기 (NTILE)
-- NTILE 등급을 출력하는 기본 함수. 
-- NTILE(숫자) 숫자만큼 등급을 분할 한다는 의미 
-- DESC NULLS LAST는 월급을 높은 것부터 출력하지만, NULL을 맨 아래에 출력하는 것. 
SELECT 
    ename
    , job
    , sal
    , NTILE(4) OVER (ORDER BY sal DESC NULLS LAST) 등급
FROM emp
WHERE job in ('ANALYST', 'MANAGER', 'CLERK');

-- Q44. 데이터 분석 함수로 순위의 비율 출력하기(CUME_DIST)
-- 이름과, 월급, 월급의 순위, 월급의 순위 비율 출력
SELECT 
    ename
    , sal
    , RANK() OVER (ORDER BY sal DESC) as RANK
    , DENSE_RANK() OVER (ORDER BY sal DESC) as DENSE_RANK
    , CUME_DIST() over (ORDER BY sal DESC) as CUM_DIST
FROM emp;

-- ORDER BY 대신 PARTITION BY를 출력합니다. 
SELECT job
    , ename
    , sal
    , RANK() OVER (PARTITION BY job ORDER BY sal DESC) as RANK
    , CUME_DIST() OVER (PARTITION BY job ORDER BY sal DESC) as CUM_DIST
FROM emp;

-- Q45. 데이터 분석 함수로 데이터를 가로로 출력하기
-- WITHIN GROUP은 '~이내의'라는 뜻임
SELECT 
    deptno
    , LISTAGG(ename, ',') WITHIN GROUP (ORDER BY ename) AS EMPLOYEE
FROM emp
GROUP BY deptno;

-- 직업과 그 직업에 속한 사원들의 이름을 가로로 출력하는 예제
SELECT 
    job
    , LISTAGG(ename, ', ') within group (ORDER BY ename ASC) as employee 
FROM emp 
GROUP BY job;

-- 이름 옆에 월급도 같이 출력
SELECT 
    job
    , LISTAGG(ename||'('||sal||')', ', ') within group (ORDER BY ename ASC) as employee 
FROM emp 
GROUP BY job;

-- Q46. 데이터 분석 함수로 바로 전 행과 다음 행 출력하기 (LAG, LEAD)
SELECT
    empno
    , ename
    , sal
    , LAG(sal, 1) OVER (ORDER BY sal asc) "전 행"
    , LEAD(sal, 1) OVER (ORDER BY sal asc) "다음 행"
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

-- 부서 번호, 사원 번호, 이름, 입사일, 바로 전에 입사한 사원의 입사일 출력
-- 바로 다음에 입사한 사원의 입사일 출력, 부서 번호별로 구분
SELECT 
    deptno
    , empno
    , ename
    , hiredate
    , LAG(hiredate, 1) OVER (PARTITION BY deptno ORDER BY hiredate ASC) "전 행"
    , LEAD(hiredate, 1) OVER (PARTITION BY deptno ORDER BY hiredate ASC) "다음 행"
FROM emp;

-- Q47. COLUMNS을 ROW로 출력하기 (SUM + DECODE)
SELECT 
    SUM(DECODE(deptno, 10, sal)) as "10"
    , SUM(DECODE(deptno, 20, sal)) as "20"
    , SUM(DECODE(deptno, 30, sal)) as "30"
FROM emp;

-- 직업, 직업별 토탈 월급 출력
SELECT 
    deptno
    , SUM(DECODE(job, 'ANALYST', sal)) as "ANALYST"
    , SUM(DECODE(job, 'CLERK', sal)) as "CLERK"
    , SUM(DECODE(job, 'MANAGER', sal)) as "MANAGER"
    , SUM(DECODE(job, 'SALESMAN', sal)) as "SALESMAN"
FROM emp
GROUP BY deptno;

-- Q48. COLUMN을 ROW로 출력하기
-- 예제 47에서 SUM과 DECODE를 이용해 출력한 결과를 PIVOT을 활용하면 쉽게 쿼리 작성 가능
SELECT 
    * 
FROM (select deptno, sal from emp)
PIVOT (sum(sal) for deptno in (10, 20, 30));

-- 문자형 데이터 활용한 PIVOT
SELECT 
    * 
FROM (select job, sal from emp)
PIVOT (sum(sal) for job in ('ANALYST', 'CLERK', 'MANAGER', 'SALESMAN'));

-- PIVOT 문을 이용한 토탈 월급 출력
-- 싱글 쿼테이션 마크가 출력되지 않게 하려면 AS 더블 쿼테이션 마크 출력한다. 
SELECT 
    * 
FROM (select job, sal from emp)
PIVOT (sum(sal) for job in ('ANALYST' AS "ANALYST" , 'CLERK', 'MANAGER', 'SALESMAN'));

-- Q49. ROW를 COLUMN으로 출력하기 (UNPIVOT)
-- order2 테이블 생성하기
drop  table order2;

create table order2
( ename  varchar2(10),
  bicycle  number(10),
  camera   number(10),
  notebook  number(10) );

insert  into  order2  values('SMITH', 2,3,1);
insert  into  order2  values('ALLEN',1,2,3 );
insert  into  order2  values('KING',3,2,2 );

commit;

-- UNPIVOT을 사용하여 컬럼 로우 출력
SELECT * FROM order2;

SELECT *
FROM order2
UNPIVOT (건수 for 아이템 in (BICYCLE, CAMERA, NOTEBOOK));

SELECT *
FROM order2
UNPIVOT (건수 for 아이템 in (BICYCLE as 'B', CAMERA, NOTEBOOK));
 
-- NULL 포함 시킨 후 UNPIVOT 문 재실행
UPDATE ORDER2 SET NOTEBOOK=NULL WHERE ENAME='SMITH';
SELECT * FROM order2;

-- SMITH의 NOTEBOOK 정보가 출력되지 않음
-- 이럴 때 NULL 값인 행도 결과에 포함시킬 것
-- INCLUDE NULLS 사용
SELECT * 
FROM ORDER2
UNPIVOT INCLUDE NULLS (건수 for 아이템 in (BICYCLE as 'B', CAMERA, NOTEBOOK));
 
 
-- Q50. 데이터 분석 함수로 누적 데이터 출력하기(SUM OVER)
-- UNBOUNDED PRECEDING: 맨 첫 번째 행을 가리킵니다. 
-- UNBOUNDED FOLLOWING: 맨 마지막 행을 가리킵니다. 
-- CURRENT ROW: 현재 행을 가리킵니다. 
-- 사원 번호, 이름, 월급, 월급의 누적치를 출력하는 쿼리
SELECT 
    empno
    , ename
    , sal
    , SUM(sal) OVER (ORDER BY empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 누적치
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

-- Q51. 데이터 분석 함수로 비율 출력하기 (RATIO_TO_REPORT)
-- 부서 번호가 20번인 사원들의 사원 번호, 이름, 월급 출력
SELECT 
    empno
    , ename
    , sal
    , RATIO_TO_REPORT(sal) OVER() as 비율
FROM emp
WHERE deptno = 20;

-- 이번에는 비율을 직접 구하도록 한다. 
SELECT 
    empno
    , ename
    , sal
    , RATIO_TO_REPORT(sal) OVER() as 비율
    , SAL/SUM(sal) OVER() as "비교 비율"
FROM emp
WHERE deptno = 20;

-- Q52. 데이터 분석 함수로 집계 결과 출력하기 (ROLLUP)
-- ROLLUP을 이용하여 직업과 직업별 토탈 월급 출력 후, 전체 토탈 월급 추가적으로 출력하는 쿼리
SELECT 
    job
    , sum(sal)
FROM emp
GROUP BY ROLLUP(job);

-- 각 부서별 컬럼별로 토탈 월급 출력
SELECT 
    deptno
    , job
    , sum(sal)
FROM emp
GROUP BY ROLLUP(deptno, job);

-- Q53. 데이터 분석 함수로 집계 결과 출력하기 (CUBE)
-- 첫 번째 행에 토탈 월급을 출력해 본다. 
SELECT 
    job
    , sum(sal)
FROM emp
GROUP BY CUBE(job);

-- 이번에는 컬럼 2개를 사용한다.
-- 토탈 월급, 직업별 토탈 월급, 부서번호별 토탈 월급
SELECT 
    deptno
    , job
    , sum(sal)
FROM emp
GROUP BY CUBE(deptno, job);

-- Q54. 데이터 분석 함수로 집계 결과 출력하기
-- GROUPINNG SETS
SELECT 
    deptno
    , job
    , sum(sal)
FROM emp
GROUP BY GROUPING SETS((deptno), (job), ());

-- Q55. 데이터 분석 함수로 출력 결과 넘버링 하기
-- RANK(), DENSE_RANK(), ROW_NUMBER()
-- 3가지 비교 한다. 
SELECT 
    empno
    , ename
    , sal
    , RANK() OVER (ORDER BY sal DESC) RANK
    , DENSE_RANK() OVER (ORDER BY sal DESC) DENSE_RANK
    , ROW_NUMBER() OVER (ORDER BY sal DESC) 번호
FROM emp
WHERE deptno = 20;

-- PARTITION BY
SELECT 
    empno
    , ename
    , sal
    , ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) 번호
FROM emp
WHERE deptno in (10, 20);

-- 데이터 가공 실습
DROP TABLE access_log;
CREATE TABLE access_log (
    stamp    varchar2(255)
  , referrer varchar2(255)
  , url      varchar2(255)
);

INSERT INTO access_log VALUES ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video/detail?id=001');
INSERT INTO access_log VALUES ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video#ref'          );
INSERT INTO access_log VALUES ('2016-08-26 12:02:01', 'https://www.other.com/'                               , 'http://www.example.com/book/detail?id=002' );

COMMIT;

-- URL에서 요소 추가하기
-- 래퍼러 도메인만 추출하는 쿼리
SELECT 
    stamp
    , regexp_substr(referrer, 'https?://[^/]*') AS referrer_host
FROM access_log;

-- URL 경로와 GET 매개변수에 있는 특정 키 값 추출
SELECT 
    stamp
    , url
    , regexp_replace(regexp_substr(url, '//[^/]+[^?#]+'), '//[^/]+','') AS path
    , regexp_replace(regexp_substr(url, 'id=[^&]*'), 'id=','') AS id
FROM access_log;

-- 결측치 값을 디폴트 값으로 대치
DROP TABLE purchase_log_with_coupon;
CREATE TABLE purchase_log_with_coupon (
    purchase_id varchar2(10)
  , amount      integer
  , coupon      integer
);

INSERT INTO purchase_log_with_coupon VALUES ('10001', 3280, NULL);
INSERT INTO purchase_log_with_coupon VALUES ('10002', 4650,  500);
INSERT INTO purchase_log_with_coupon VALUES ('10003', 3870, NULL);

COMMIT;

-- 구매액에서 할인 쿠폰 값을 제외한 메출 금액을 구한다. 
SELECT
    purchase_id
    , amount
    , coupon
    , amount - coupon AS discount_amount1
    , amount - COALESCE(coupon, 0) AS discount_amount2
FROM purchase_log_with_coupon;

-- 날짜 데이터
DROP TABLE mst_users_with_dates;
CREATE TABLE mst_users_with_dates (
    user_id        varchar2(255)
  , register_stamp varchar2(255)
  , birth_date     varchar2(255)
);

INSERT INTO mst_users_with_dates VALUES ('U001', '2019-03-28 10:00:00', '1998-02-28');
INSERT INTO mst_users_with_dates VALUES ('U002', '2019-03-29 10:00:00', '1999-03-29');
INSERT INTO mst_users_with_dates VALUES ('U003', '2019-04-01 10:00:00', '2001-02-28');

COMMIT;

-- 두 날짜의 차이 계산
SELECT 
    user_id
    , SYSDATE AS today
    , CAST(TO_TIMESTAMP(register_stamp) AS DATE) AS register_date
    , TO_DATE(SYSDATE, 'YYYY-MM-DD') - TO_DATE(CAST(TO_TIMESTAMP(register_stamp) AS DATE), 'YYYY-MM-DD') AS diff_days
FROM mst_users_with_dates;

-- 사용자의 생년월일로 나이 계산하기

SELECT 
    user_id
    , SYSDATE AS today
    , CAST(TO_TIMESTAMP(register_stamp) AS DATE) AS register_date
    , TO_DATE(birth_date, 'YYYY-MM-DD') AS birth_date
    -- 만 나이
    , TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), TO_DATE(birth_date,'YYYY-MM-DD')) / 12) AS age
    -- 한국 나이 계산 = 현재년도 - 출생년도 + 1
    , MONTHS_BETWEEN(TRUNC(SYSDATE, 'YEAR'), TRUNC(TO_DATE(birth_date,'YYYY-MM-DD'),'YEAR')) / 12 +1 AS kor_age
FROM mst_users_with_dates;