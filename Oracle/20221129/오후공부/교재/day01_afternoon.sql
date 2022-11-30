-- Q1. 서브 쿼리 사용하기
-- JONES보다 더 많은 월급을 받는 사원들의 이름과 월급을 출력한다. 
-- 서브쿼리: JONES의 급여
-- 메인쿼리: JONES보다 더 많은 월급을 받는 사원들의 이름과 월급을 출력한다. 
SELECT sal FROM emp WHERE ename='JONES';
-- 2975

SELECT 
    ename
    , sal
FROM emp
WHERE sal > (SELECT sal FROM emp WHERE ename='JONES');

-- SCOTT과 같은 월급을 받는 사원들의 이름과 월급을 출력하는 쿼리
-- 서브쿼리: SCOTT의 급여
SELECT sal FROM emp WHERE ename = 'SCOTT';

-- 메인쿼리 SCOTT과 같은 월급을 받는 사원들의 이름과 월급 출력
SELECT
    ename
    , sal
FROM emp
WHERE sal = (SELECT sal FROM emp WHERE ename = 'SCOTT');

-- 그런데, SCOTT을 제외하고 싶다면, 위 쿼리에서 SCOTT을 제외하는 쿼리를 작성한다. 
SELECT
    ename
    , sal
FROM emp
WHERE sal = (SELECT sal FROM emp WHERE ename = 'SCOTT')
      AND ename !='SCOTT';

-- Q2. 서브 쿼리 사용하기 (다중 행 서브쿼리)
-- 직업이 SALESMAN인 사원들과 같은 월급을 받는 사원들의 이름과 월급 출력
SELECT 
    ename
    , sal
FROM emp
WHERE sal in (SELECT sal FROM emp WHERE job='SALESMAN');

-- IN이 아니라 = 대입 시, 에러 발생
-- SALESMAN인 사원들이 한 명이 아니라 여러 명이기 때문

-- Q3. 서브 쿼리 사용하기 (NOT IN)
-- 관리자가 아닌 사원들의 이름과 월급과 직업을 출력함. 
SELECT 
    ename
    , sal
    , job
FROM emp
WHERE empno not in (SELECT mgr 
                    FROM emp 
                    WHERE mgr is not null);
                    
-- 만약 mgr is not null을 사용하지 않고 실행하면 아무것도 출력되지 않음
-- 선택된 레코드가 없다고 나오는 이유는 mgr 컬럼에 NULL값이 있기 때문
SELECT 
    ename
    , sal
    , job
FROM emp
WHERE empno not in (SELECT mgr from emp);

-- Q4. 서브 쿼리 사용하기 (EXISTS와 NOT EXISTS)
-- 부서 테이블에 있는 부서 번호 중, 사원 테이블에도 존재하는 부서 번호, 부서명 부서 위치 출력
SELECT 
    *
FROM dept d
WHERE EXISTS (SELECT * FROM emp e WHERE e.deptno = d.deptno);

-- DEPT 테이블에는 존재하는 부서 번호
-- 그러나, EMP 테이블에 존재하지 않는 데이터 검색 시, NOT EXISTS 사용
SELECT 
    * 
FROM dept d 
WHERE NOT EXISTS (SELECT * FROM emp e WHERE e.deptno = d.deptno);

-- Q5. 서브 쿼리 사용하기 (HAVING절의 서브 쿼리)
SELECT
    job
    , sum(sal)
FROM emp
GROUP BY job
HAVING sum(sal) > (SELECT sum(sal) FROM emp WHERE job='SALESMAN');

--
SELECT
    job
    , sum(sal)
FROM emp
WHERE JOB != 'SALESMAN'
GROUP BY job
HAVING sum(sal) >= (SELECT sum(sal) FROM emp WHERE job='SALESMAN')
ORDER BY sum(sal) DESC;

-- 그룹 함수 이용한 데이터 검색은 WHERE이 아닌 HAVING절 작성

-- Q6. 서브 쿼리 사용하기 (FROM절의 서브 쿼리)
SELECT 
    v.ename
    , v.sal
    , v.순위
FROM (SELECT ename, sal, rank() OVER(order by sal desc) 순위 FROM emp) v
WHERE v.순위 = 1;

-- Q7. 서브 쿼리 사용하기 (SELECT절의 서브 쿼리)
SELECT 
    ename
    , sal
    , (SELECT max(sal) from emp where job='SALESMAN') as 최대월급
    , (SELECT min(sal) from emp where job='SALESMAN') as 최소월급
FROM emp
WHERE job='SALESMAN';

-----------------------------------------------------------
-- 데이터 불러오기 populations, cities, countries2, economies
-----------------------------------------------------------
-- Q8. 
-- 서브쿼리 기본문제
-- 데이터 populations 데이터 가져오기
-- 질문 1. 먼저 2015년 전체 국가의 평균 수명을 계산하십시오.
SELECT 
    AVG(life_expectancy)
FROM populations
WHERE year = 2015;

-- Q9. 
-- 조건 1. 모든 데이터를 조회한다. 
-- 조건 2. 2015년 평균 기대수명의 1.15배보다 높도록 설정한다. (life_expectancy > 1.15 * )
SELECT 
    *
FROM populations
WHERE life_expectancy > 1.15 * (SELECT AVG(life_expectancy) FROM populations WHERE year = 2015) 
	  AND year = 2015
FETCH FIRST 5 ROWS ONLY;

-- Q10.
-- 조건 1. 서브 쿼리의 국가 테이블에 있는 capital 필드를 사용합니다.
-- 조건 2. cities 테이블에서 name, country code, urban area population 필드를 조회한다.
SELECT name, country_code, urbanarea_pop
  FROM cities
WHERE name IN
  (SELECT capital
   FROM countries2)
ORDER BY urbanarea_pop DESC;

-- Q11. 
-- economies 데이터셋 불러오기
-- 조건 1. economies data에서 country code, inflation rate, unemployment rate를 조회한다. 
-- 조건 2. inflation rate 오름차순으로 정렬한다. 
-- 조건 3. Alias 사용하지 않는다. 
-- 조건 4. countries2 테이블내 gov_form 컬럼에서 Constitutional Monarchy 또는 `Republic`이 들어간 국가는 제외한다. 
-- Select fields
SELECT code, inflation_rate, unemployment_rate
  FROM economies
  WHERE year = 2015 AND code NOT IN
  	(SELECT code
  	 FROM countries2
  	 WHERE (gov_form = 'Constitutional Monarchy' OR gov_form LIKE '%Republic%'))
ORDER BY inflation_rate;

-- Q12. 
-- 조건 1. 첫번째 주석을 풀고 실행합니다. 
SELECT * FROM countries2;
SELECT countries2.country_name as country, COUNT(*) as cities_num
  FROM cities
	  INNER JOIN countries2
	  ON countries2.code = cities.country_code
GROUP BY countries2.country_name
ORDER BY cities_num DESC, country;

/* 
SELECT ___ AS ___,
  (SELECT ___
   FROM ___
   WHERE countries2.code = cities.country_code) AS cities_num
FROM ___
ORDER BY ___ ___, ___
LIMIT 9;
*/
SELECT countries2.country_name AS country, COUNT(*) AS cities_num
  FROM cities
	  INNER JOIN countries2
	  ON countries2.code = cities.country_code
GROUP BY countries2.country_name
ORDER BY cities_num DESC, country;

-- 조건 2. GROUP BY 코드를 변환하여 SELECT 내부의 하위 쿼리를 사용하도록 한다. 
-- 즉, 첫 번째 쿼리에서 GROUP BY 코드를 사용하여 주어진 결과와 일치하는 결과를 얻으려면 빈칸을 채운다.
-- 조건 3. 다시 city_num 내림차순으로 결과를 정렬한 다음 국가 오름차순으로 정렬합니다.

SELECT countries2.country_name AS country,
  (SELECT COUNT(*)
   FROM cities
   WHERE countries2.code = cities.country_code) AS cities_num
FROM countries2
ORDER BY cities_num DESC, country;

-- Q13. 
-- 조건 1. 아래 쿼리 실행
SELECT country_name, continent, inflation_rate
  FROM countries2
  	INNER JOIN economies
    USING (code)
WHERE year = 2015;

-- 조건 2. 위 쿼리를 FROM 이내의 서브쿼리를 활용한다. 
-- 조건 3. 2015년의 continent 그룹별로 하여 continent, inflation_rate의 최댓값을 조회한다.
-- Select the maximum inflation rate as max_inf
SELECT 
    continent
    , MAX(inflation_rate) AS max_inf
  FROM (
      SELECT 
        country_name
        , continent
        , inflation_rate
      FROM countries2
      INNER JOIN economies
      USING (code)
      WHERE year = 2015)
GROUP BY continent
ORDER BY MAX_INF;

-- 조건 4. 각 대륙별 inflation_rate가 가장 높은 나라를 추출하는 코드를 작성하도록 합니다. 
-- 조건 5. 위 쿼리에서 continent 필드 조회하는 것만 제외합니다. 그리고, 해당 쿼리를 다음 쿼리에서 IN 이하절로 활용합니다.
SELECT country_name, continent, inflation_rate
  FROM countries2
	INNER JOIN economies
	ON countries2.code = economies.code
  WHERE year = 2015
    AND inflation_rate IN (
        SELECT MAX(inflation_rate) AS max_inf
        FROM (
             SELECT country_name, continent, inflation_rate
             FROM countries2
             INNER JOIN economies
             -- Using(code) 대신 ON 쿼리를 작성합니다. 
             ON countries2.code = economies.code
             WHERE year = 2015)
        GROUP BY continent);

-----------------------------------------------------
-- 데이터 가져오기, summer_medals
-----------------------------------------------------

-- Question 1.
-- ROW Number()
-- 각 행에 숫자를 1, 2, 3, ..., N 형태로 추가하도록 한다.
-- Row_N 기준으로 오름차순으로 진행한다.

SELECT
    ROWNUM as ROW_N
    ,sm.*
FROM summer_medals sm;

-- 이번에는 올림픽 연도를 오름차순 순번대로 작성을 하도록 합니다.
-- 이 때, 서브쿼리로 연도만을 추출한 뒤, 윈도우 함수를 이용한다.
SELECT
    year
    , ROWNUM as ROW_N
FROM
    (SELECT DISTINCT Year
    FROM summer_medals
    ORDER BY Year ASC) Years
ORDER BY Year ASC;

-- ORDER BY
-- 하계 올림픽이 열린 각 연도에 번호를 할당합니다.
-- 가장 최근 연도를 가진 행이 더 낮은 행 수를 갖도록 합니다.
SELECT
    YEAR
    , ROW_NUMBER() OVER(ORDER BY YEAR ASC) ROW_N
FROM (SELECT DISTINCT YEAR FROM summer_medals) Years
ORDER BY Year;

-- Question 3.
-- 각 운동선수들이 획득한 메달 갯수를 내림차순으로 정렬하도록 한다.
SELECT
    Athlete
    , COUNT(*) as Medals
FROM summer_medals
GROUP BY Athlete
ORDER BY Medals DESC;

-- 이전 쿼리에서, 각 선수들의 랭킹을 추가한다.
WITH Athlete_Medals AS (
    SELECT
        Athlete
        , COUNT(*) as Medals
    FROM summer_medals
    GROUP BY Athlete)

SELECT
  Medals
    , Athlete
    , ROW_NUMBER() OVER (ORDER BY Medals DESC) AS Row_N
FROM Athlete_Medals
ORDER BY Medals DESC;

-- 이번에는 남자 69KG 역도 경기에서 매년 금메달리스트 조회하도록 한다.
-- Discipline: Weightlifting
-- Event: 69KG
-- Gender: Men
-- Medal Gold
SELECT
    Year
    , Country as champion
FROM summer_medals
WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold';

-- 기존 쿼리에서 매년 전년도 챔피언도 같이 조회하도록 한다.
-- 이 때, LAG() 함수를 사용한다.
WITH Weightlifting_Gold AS (
  SELECT
    Year,
    Country AS champion
  FROM Summer_Medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')

SELECT
  Year, Champion,
  LAG(Champion) OVER
    (ORDER BY Year ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;

-- LAG() 함수의 활용
-- LAG() 함수는 이전 행의 컬럼 값과 비교를 하거나 또는 값을 가져올 때 사용한다.
-- 이 때 사용하는 문법이 LAG() OVER() 구문이다.
-- 우선, 200M 달리기 금메달을 확인해보도록 한다.
-- Discipline: 'Athletics'
-- Event: '200M'
-- Gender: 'Men'
-- Medal: 'Gold'
SELECT
    YEAR
    , Athlete
    , Country AS champion
FROM summer_medals
WHERE
	Discipline = 'Athletics' AND
	Event = '200M' AND
	Gender = 'Men' AND
	Medal = 'Gold';

-- 2연패를 달성한 선수가 있는지 확인을 해보도록 한다.
WITH Gold AS (
SELECT
	Year,
	Athlete AS Champion
FROM summer_medals
WHERE
	Discipline = 'Athletics' AND
	Event = '200M' AND
	Gender = 'Men' AND
	Medal = 'Gold')

SELECT
	Year, Champion,
	LAG(Champion) OVER (ORDER BY YEAR ASC) AS Last_Champion
FROM Gold;

-- 데이터 불러오기
-- 올림픽 관련 데이터를 업로드 한다.  summer.csv
-- 테이블명은 summer_medals로 하였다.

-- Window Functions
-- 테이블에서 행집합을 대상으로 하는 함수
-- 집합 단위로 계산하기 때문에, 집계 함수와 비슷
-- 단, 집계 함수는 한 행으로 결괏값을 보여주는 반면, 윈도우 암수는 각 행마다 처리 결과를 출력함
-- 윈도우 함수를 사용하려면 집약함수 뒤에 OVER를 붙이고 윈도 함수를 지정한다.

-- ROW Number()
-- 각 행에 숫자를 1, 2, 3, ..., N 형태로 추가하도록 한다.
-- Row_N 기준으로 오름차순으로 진행한다.

SELECT
    ROWNUM as ROW_N
    ,sm.*
FROM summer_medals sm;

-- 이번에는 올림픽 연도를 오름차순 순번대로 작성을 하도록 합니다.
-- 이 때, 서브쿼리로 연도만을 추출한 뒤, 윈도우 함수를 이용한다.
SELECT
    year
    , ROWNUM as ROW_N
FROM
    (SELECT DISTINCT Year
    FROM summer_medals
    ORDER BY Year ASC) Years
ORDER BY Year ASC;

-- 2연패를 달성한 선수가 있는지 확인을 해보도록 한다.
WITH Gold AS (
SELECT
	Year,
	Athlete AS Champion
FROM summer_medals
WHERE
	Discipline = 'Athletics' AND
	Event = '200M' AND
	Gender = 'Men' AND
	Medal = 'Gold')

SELECT
	Year, Champion,
	LAG(Champion) OVER (ORDER BY YEAR ASC) AS Last_Champion
FROM Gold
ORDER BY Year ASC;

-- PARTITION BY
-- Partition BY는 열의 고유 값을 기준으로 테이블을 파티션으로 분할함
-- 결과가 한 열로 롤업되지 않음
-- 창 기능에 따라 별도로 작동됨
-- ROW_NUMBER가 각 파티션에 대해 재설정됩니다.
-- LAG는 이전 행이 동일한 파티션에 있는 경우에만 이전 값을 가져온다.
WITH Discus_Gold_Medal AS (
    SELECT
        Year, Event, Country AS Champion
    FROM summer_medals
    WHERE
        Year IN (2004, 2008, 2012)
        AND Gender = 'Men' AND Medal = 'Gold'
        AND Event IN ('Discus Throw', 'Triple Jump')
        AND Gender = 'Men')

SELECT
    YEAR, Event, Champion,
    LAG(Champion) OVER
    (ORDER BY Event ASC, Year ASC) AS Last_Champion
FROM Discus_Gold_Medal
ORDER BY Event ASC, Year ASC;

-- Triple Jump의 GER가 나타나는 것은 어색하다.
-- 이 때, Partition By 문법을 적용한다.
WITH Discus_Gold_Medal AS (
    SELECT
        Year, Event, Country AS Champion
    FROM summer_medals
    WHERE
        Year IN (2004, 2008, 2012)
        AND Gender = 'Men' AND Medal = 'Gold'
        AND Event IN ('Discus Throw', 'Triple Jump')
        AND Gender = 'Men')

SELECT
        YEAR, Event, Champion,
        LAG(Champion) OVER
        (PARTITION BY Event ORDER BY Event ASC, Year ASC) AS Last_Champion
FROM Discus_Gold_Medal
ORDER BY Event ASC, Year ASC;

-- 성별에 따른 현재 챔피언과 이전 챔피언을 반환한다. 
-- 이번에는 경기종목을 2개 추가한다.
-- ('100M', '10000M')
-- 이 때에는 IN() 함수를 사용한다.

WITH athletics_gold as (
    SELECT DISTINCT
        GENDER, Year, Event, Country
    FROM summer_medals
    WHERE
        Year >= 2000 AND
        Discipline = 'Athletics' AND
        Event IN ('100M', '10000M') AND
        Medal = 'Gold')

SELECT
    Gender
    , Year
    , Event
    , Country AS Champion
    , LAG(Country) OVER (PARTITION BY Gender
                                      , Event
                         ORDER BY Year ASC) AS Last_Champion
FROM athletics_gold
ORDER BY Event ASC, Gender ASC, Year ASC;

-- Relative
-- LAG(column, n) LAG()는 현재 행 앞의 행에 있는 열의 값을 반환합니다.
-- Lead(column, n) 현재 행 뒤의 행에 있는 열의 값을 반환합니다.
-- Absolute
-- FIRST_VALUE(column) 테이블 또는 파티션의 첫번째 값을 반환합니다.
-- LAST_VALUE(column) 테이블 또는 파티션의 마지막 값을 반환합니다.
-- 각 연도마다 현재 금메달리스트와 3개 대회 이후의 메달리스트를 같이 조회한다.
WITH Discus_Medalists AS (
  SELECT DISTINCT
    Year,
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Event = 'Discus Throw'
    AND Gender = 'Women'
    AND Year >= 1992)

SELECT
  -- 각 행에는, 현재와 3개 대회 이후의 메달리스트까지 같이 출력할 수 있다.
  Year,
  Athlete,
  LEAD(Athlete, 3) OVER (ORDER BY Year ASC) AS Future_Champion
FROM Discus_Medalists
ORDER BY Year ASC;

-- 이번에는 FIRST_VALUE를 활용하여 모든 선수를 조회한다. 
-- 동시에 첫번째 선수를 조회하도록 합니다.
-- 모든 선수 조회 시, 알파벳 순으로 정렬합니다.
-- Medal = 'Gold'
-- Gender = 'Men'
WITH All_Male_Medalists AS (
  SELECT DISTINCT
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Gender = 'Men')

SELECT
  Athlete,
  FIRST_VALUE(Athlete) OVER (
    ORDER BY Athlete ASC
  ) AS First_Athlete
FROM All_Male_Medalists;

-- 각 올림픽 경기가 열렸던 해외 도시를 조회합니다.
-- 본 데이터에서 올림픽 경기가 열렸던 마지막 도시를 조회합니다.
-- LAST_VALUE()

WITH Hosts AS (
  SELECT DISTINCT Year, City
    FROM Summer_Medals)

SELECT
  Year,
  City,
  LAST_VALUE(City) OVER (
   ORDER BY Year ASC
   RANGE BETWEEN
     UNBOUNDED PRECEDING AND
     UNBOUNDED FOLLOWING
  ) AS Last_City
FROM Hosts
ORDER BY Year ASC;

-- 각 나라별 올림픽 출전 횟수 비교
SELECT 
	Country, COUNT(DISTINCT Year) AS Games
FROM summer_medals
Where 
	Country IN ('GBR', 'DEN', 'FRA',
                'ITA', 'AUT', 'BEL', 
	            'NOR', 'JPN', 'KOR')
GROUP BY Country
ORDER BY GAMES DESC;

-- 순위 관련 함수 비교
WITH Country_Games AS (
   SELECT 
       Country, COUNT(DISTINCT Year) AS Games
       FROM summer_medals
       Where 
          Country IN ('GBR', 'DEN', 'FRA', 
                      'ITA', 'AUT', 'BEL', 
                      'NOR', 'JPN', 'KOR')
        GROUP BY Country
        ORDER BY GAMES DESC)

SELECT 
     Country, Games, 
         ROW_NUMBER()
	OVER (ORDER BY Games DESC) AS Row_N,
         RANK()
	OVER (ORDER BY Games DESC) AS Rank_N, 
         DENSE_RANK()
	OVER (ORDER BY Games DESC) AS Dense_Rank_N
FROM Country_Games
ORDER BY Games DESC, Country ASC;


-- 먼저 2000년대 이후의 전체 매달 갯수를 구한다.
WITH Athlete_Medals AS (SELECT
    Country, COUNT(*) AS Medals
FROM Summer_Medals
WHERE Medal = 'Gold' AND Year >= 2000
GROUP BY Country)

SELECT SUM(medals) FROM Athlete_Medals;

-- 이번에는 국가별 Gold 메달 갯수를 알파벳 순서대로 작업을 하도록 합니다.
WITH Athlete_Medals AS (SELECT
    Country, COUNT(*) AS Medals
FROM Summer_Medals
WHERE Medal = 'Gold' AND Year >= 2000
GROUP BY Country)

SELECT
	Country,
	Medals,
	SUM(Medals) OVER (ORDER BY Country ASC) AS Cum_Medals
FROM Athlete_Medals
ORDER BY Country ASC;

-- 이번에는 한국과 일본 국가만 조회될 수 있도록 쿼리를 작성한다.
-- 조회된 기록 중, 가장 많은 메달을 기록 갯수가 나타나도록 한다. 
WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('KOR', 'JPN')
    AND Medal = 'Gold' AND Year >= 2000
  GROUP BY Year, Country)

SELECT
  Country,
  Year,
  Medals,
  MAX(Medals) OVER (PARTITION BY Country ORDER BY Year ASC) AS Max_Medals
FROM Country_Medals
ORDER BY Country ASC, Year ASC;

-- 국가별 금메달을 기준으로 랭킹을 구하는 쿼리를 작성했다.
WITH Country_Awards AS (
    SELECT
      Country,
      Year,
      COUNT(*) AS Medal_CNT
    FROM Summer_Medals
    WHERE
      Country IN ('FRA', 'GBR', 'GER')
      AND Year IN (2004, 2008, 2012)
      AND Medal = 'Gold'
    GROUP BY Country, Year)

SELECT
    Country,
    Year,
    Medal_CNT,
    RANK() OVER
      (PARTITION BY Year
       ORDER BY Medal_CNT DESC) Rank
  FROM Country_Awards
  ORDER BY Country ASC, Year ASC;