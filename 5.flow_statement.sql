-- 흐름제어 : case when(분기처리 3개이상), if, ifnull
-- if(a, b, c) : a조건이 참이면 b반환, 그렇지 않으면 c반환
select id, if(name is null, '익명사용자', name) from author;    --> 안됨 ㅠㅠ name에 'anonymous' 적용해서그런듯,, -> 아니었음 NULL이 아니라 공백이어서 그랬음!!!

-- ifnull(a, b) : a가 null이면 b반환, null이 아니면 a를 그대로 반환
select id, ifnull(name, '익명사용자') from author;

select id,
case
    when name is null then '익명사용자' 
    when name='hong7' then '홍길동'
    else name                               -> else 생략가능
end AS NAME
from author;

-- 실습
-- 경기도에 위치한 식품창고 목록 출력하기
SELECT WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS,
CASE
 WHEN FREEZER_YN is null then 'N'
 ELSE FREEZER_YN
END AS FREEZER_YN
FROM FOOD_WAREHOUSE
WHERE ADDRESS LIKE '경기도%'
ORDER BY WAREHOUSE_ID;
-- 조건에 부합하는 중고거래 상태 조회하기
SELECT BOARD_ID, WRITER_ID, TITLE, PRICE,
CASE
  WHEN STATUS="SALE" THEN "판매중"
  WHEN STATUS="RESERVED" THEN "예약중"
  WHEN STATUS="DONE" THEN "거래완료"
END AS STATUS
FROM USED_GOODS_BOARD
WHERE CREATED_DATE = "2022-10-05"
ORDER BY BOARD_ID DESC;
-- 12세 이하인 여자 환자 목록 출력하기
SELECT PT_NAME, PT_NO, GEND_CD, AGE, IFNULL(TLNO, 'NONE') AS TLNO
FROM PATIENT
WHERE AGE <= 12 AND GEND_CD = 'W'
ORDER BY AGE DESC, PT_NAME;