-- SQL 서브쿼리 연습문제
-- 문제 1. 2015년 평균 기대수명보다 높은 모든 정보를 조회하세요.
-- 테이블명 : populations

-- 나의 답
select 
    * 
from populations
where year = 2015 
    and life_expectancy >= (select avg(life_expectancy) from populations);

-- 강사님 답
SELECT
    *
FROM populations
WHERE life_expectancy > (SELECT AVG(life_expectancy) FROM populations WHERE year = 2015)
	  AND year = 2015;
      
-- 문제풀이 : 차이점은 순서인가?

-- 문제 2. countries2 테이블에 있는 capital과 
-- 매칭되는 cities 테이블의 정보를 조회하세요. 
-- 조회할 컬럼명은 name, country_code, urbanarea_pop

-- 내가 쓴 답
select name, country_code, urbanarea_pop 
from countries2 
join cities
on (code = country_code)
order by urbanarea_pop desc;
-- 필터링 잘못

-- 강사님 쓴 답
SELECT name, country_code, urbanarea_pop
  FROM cities
WHERE name IN
  (SELECT capital
   FROM countries2)
ORDER BY urbanarea_pop DESC;

-- 문제풀이 : 왜 차이가 나는 것인지 확인이 필요하다


-- 문제 3. 
-- 조건 1. economies 테이블에서 country code, inflation rate, unemployment rate를 조회한다.
-- 조건 2. inflation rate 오름차순으로 정렬한다.
-- 조건 3. countries2 테이블내 gov_form 컬럼에서 Constitutional Monarchy 또는 `Republic`이 들어간 국가는 제외한다.
-- Select fields
-- 데이터셋

-- 내가쓴 답
select * from economies; 

select a.code, a.inflation_rate, a.unemployment_rate 
from economies a, countries2 b
where year = 2015 and not (b.gov_form = 'Constitutional Monarchy' and b.gov_form = 'Republic')  -- and b.gov_form = 'Republic' and(x), = 대신 like '%republic%' 하는 이유는 republic들어간 단어가 많아서
order by inflation_rate;

-- 강사님 답
SELECT code, inflation_rate, unemployment_rate
FROM economies
  WHERE year = 2015 AND code NOT IN
  	(SELECT code
  	 FROM countries2
  	 WHERE (GOV_FORM = 'Constitutional Monarchy' OR GOV_FORM LIKE '%Republic%'))
ORDER BY inflation_rate;

-- 정답 결과가 완전히 다른걸...?


-- 문제 4. 2015년 각 대륙별 inflation_rate가 가장 심한 국가와 inflation_rate를 구하세요. 
-- 힌트 1. 아래 쿼리 실행
-- group by 이부분에 대해서 잘 모르겠다


SELECT country_name, continent, inflation_rate
  FROM countries2
  	INNER JOIN economies
    USING (code)
WHERE year = 2015
order by inflation_rate desc;

-- 각 대륙별 inflation_rate가 가장 높은 나라를 추출하는 코드를 작성한다. 

-- 내가쓴 정답 답이 아니다 절대
SELECT country_name, count(continent) as countinent, inflation_rate
  FROM countries2
  	INNER JOIN economies
    USING (code)
WHERE year = 2015
group by countries2.country_name ha;

SELECT country_name, continent, inflation_rate
  FROM (
        select countries2.continent, economies.inflation_rate
                , row_number() over(PARTITION by countries2.continent order by economies.inflation_rate desc) as Rowldx
        from countries2)
where Rowldx = 1;


-- 강사님이 적어주신 답
SELECT sc.country_name, sc.continent, ec.inflation_rate
  FROM countries2 sc
	INNER JOIN economies ec
	ON sc.code = ec.code
  WHERE year = 2015
    AND inflation_rate IN (
        SELECT MAX(inflation_rate) AS max_inf
        FROM (
             SELECT sc.country_name, sc.continent, ec.inflation_rate
             FROM countries2 sc
             INNER JOIN economies ec
             -- Using(code) 대신 ON 쿼리를 작성합니다.
             ON sc.code = ec.code
             WHERE year = 2015)
        GROUP BY continent);

-- SQL 윈도우 함수 연습문제
-- 문제 1. 각 행에 숫자를 1, 2, 3, ..., 형태로 추가한다. (row_n 으로 표시)
-- row_n 기준으로 오름차순으로 출력
-- 테이블명에 alias를 적용한다. 
-- 테이블에 alias 적용을 어떻게?

-- 내가쓴 정답 맞음
select rownum as row_n, summer_medals.* from summer_medals;

-- 강사님 쓰신 정답
SELECT 
    ROWNUM as row_n
    , sm.*
FROM summer_medals sm;


-- 문제 2. 올림픽 년도를 오름차순 순번대로 작성을 한다. 
-- 힌트 : 서브쿼리와 윈도우 함수를 이용한다. 
-- 내가 쓴 정답
select * from summer_medals order by year;
select summer_medals.*, row_number() over(order by year) as row_n from summer_medals;

-- 강사님 쓴 정답
SELECT 
    Year, 
    ROW_NUMBER() OVER(ORDER BY Year) AS Row_N
FROM (
    SELECT DISTINCT Year
    FROM summer_medals
) Years;

-- 문제 3. 
-- (1) WITH 절 사용하여 각 운동선수들이 획득한 메달 갯수를 내림차순으로 정렬하도록 합니다. 
-- (2) (1) 쿼리를 활용하여 그리고 선수들의 랭킹을 추가한다. 
-- 상위 5개만 추출 : OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
-- WITH AS (1번 쿼리)
-- 2번 쿼리

-- 강사님 정답
WITH medals AS (
  SELECT
    Athlete,
    COUNT(*) AS Medals
  FROM summer_medals
  GROUP BY Athlete)

SELECT
  Medals, 
  Athlete,
  ROW_NUMBER() OVER (ORDER BY Medals DESC) AS Row_N
FROM medals
ORDER BY Medals DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


-- 문제 4
-- 다음쿼리를 실행한다. 
-- 남자 69KG 역도 경기에서 매년 금메달리스트 조회하도록 합니다. 
SELECT
    Year,
    Country AS champion
  FROM summer_medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold';
    
-- 기존 쿼리에서 매년 전년도 챔피언도 같이 조회하도록 합니다.
-- 강사님 정답
-- LAG & WITH 절 사용
WITH Weightlifting_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Country AS champion
  FROM summer_medals
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
