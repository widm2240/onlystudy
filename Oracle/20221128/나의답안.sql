-- 문제 1
select * from tb_point;

-- 문제 2
select customer_cd, point_memo, point from tb_point;

-- 문제 3 
select customer_cd as "고객코드", point_memo as "포인트 내용", point as "포인트" from tb_point;

-- 문제 4
select customer_cd, customer_nm, email, total_point from tb_customer where total_point < 10000;

-- 문제 5
select customer_cd, seq_no, point from tb_point where customer_cd=2017053 and seq_no=2;

-- 문제 6 
select * from tb_grade;
select * from tb_grade WHERE CLASS_CD='A' OR CLASS_CD = 'B' AND KOR >=80 AND ENG >=80 AND MAT >= 80;

-- 문제 7 BETWEEN, 등록일시 2018 이 어떻게 하는지
--SELECT * FROM tb_point WHERE POINT > 10000 AND POINT < 50000;

-- 문제 8 80년대생 이상 표기 방법
SELECT MW_FLG FROM TB_CUSTOMER;
SELECT CUSTOMER_CD, CUSTOMER_NM, MW_FLG, BIRTH_DAY, TOTAL_POINT FROM TB_CUSTOMER WHERE TOTAL_POINT > 20000 AND MW_FLG = 'M' AND BIRTH_DAY > 19799999;

-- 문제 9 월이 5, 6, 7월인 고객
--SELECT CUSTOMER_CD, CUSTOMER_NM, MW_FLG, BIRTH_DAY, TOTAL_POINT FROM TB_CUSTOMER WHERE BIRTH_DAY(5,6) > 5;

-- 문제 10 ??
SELECT CUSTOMER_CD, CUSTOMER_NM, MW_FLG, BIRTH_DAY, TOTAL_POINT FROM TB_CUSTOMER WHERE TOTAL_POINT > 10000 AND TOTAL_POINT < 50000;

-- 문제 11
SELECT * FROM tb_item_info;
SELECT * FROM TB_ITEM_INFO WHERE ITEM_CD = 'S01' OR ITEM_CD = 'S04' OR ITEM_CD = 'S06' OR ITEM_CD = 'S10';

-- 문제 12  구매 단어만 도출 다른 것은 왜지
SELECT * FROM TB_POINT;
SELECT * FROM TB_POINT 
    WHERE CUSTOMER_CD = 2017042 
        OR CUSTOMER_CD = 2018087 
        OR CUSTOMER_CD = 2019095
        AND POINT_MEMO like '구매';

-- 문제 13 REG_DTTM 2019, POINT_MEMO 구매 단어
SELECT * FROM TB_POINT ;

-- 문제 14 합계표기, 높은 순 검색
SELECT * FROM TB_GRADE;
SELECT KOR, ENG, MAT, sum(length(tb_grade.class_cd) FROM TB_GRADE WHERE CLASS_CD = 'B';

-- 문제 15 
SELECT * FROM TB_SALES;
SELECT SALES_DT, PRODUCT_NM, SALES_COUNT AS "총판매수" FROM TB_SALES 
    WHERE SALES_DT = 20190802 OR SALES_DT = 20190803 
        ORDER BY SALES_DT, PRODUCT_NM;
        
-- 문제 16
SELECT PRODUCT_NM FROM TB_SALES 
    WHERE SALES_DT BETWEEN 20190801 AND 20190802
        ORDER BY PRODUCT_NM;
        
-- 문제 17 중복제외 group by 이 부분이 문제네
SELECT * FROM TB_CUSTOMER;
SELECT * FROM TB_POINT;

select tb_customer.customer_cd, customer_nm, mw_flg, seq_no, point_memo, point FROM tb_customer, tb_point 
WHERE tb_customer.customer_cd = tb_point.customer_cd;

-- 문제 18 
SELECT customer_cd, 
       customer_nm, 
       total_point, 
       case when(total_point between 1000 and 20000) then '실버'
            when(total_point between 20000 and 50000) then '골드'
            when(total_point > 50000) then 'VIP'
            ELSE '일반'
       END
FROM TB_customer;

-- 문제 19
select * from tb_grade;
select ROWNUM, tb_grade.* from tb_grade where class_cd = 'A' or class_cd = 'C';

-- 문제 20  생년월일 부분이 문제
SELECT * FROM TB_customer 
WHERE CUSTOMER_CD LIKE '2019%' 
OR CUSTOMER_CD LIKE '2018%' 
AND BIRTH_DAY > 19900000 AND BIRTH_DAY < 20100000 ;

-- 문제 21 
select 300/60 , to_char(sysdate,'yyyy-mm-dd') as "오늘날짜", to_char(sysdate+30,'yyyy-mm-dd') as "30일 후 날짜" from dual;

-- 문제 22 안되는 이유는 모르겠다.
select * from tb_customer;
select * from tb_point;

select a.customer_cd, customer_nm, mw_flg, seq_no, point_memo, point FROM tb_customer a, tb_point b
WHERE a.customer_cd = b.customer_cd
and point_memo like "이벤트";

commit;