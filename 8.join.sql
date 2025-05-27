-- post테이블의 author_id값을 nullable하게 변경
alter table post modify column author_id bigint;

-- inner join
-- 두 테이블사이에 지정된 조건에 맞는 레코드만을 반환. on 조건을 통해 교집합찾기
-- 즉, post테이블에 글쓴적이 있는 author와 글쓴이가 author에 있는 post데이터를 결합하여 출력
select * from author inner join post on author.id = post.author_id;
select * from author a inner join post p on a.id = p.author_id;
-- 출력순서만 달라질뿐 위 쿼리와 아래 쿼리는 동일
select * from post p inner join author a in a.id = p.author_id;
-- 만약 위 쿼리와 같게 하고 싶다면
select a.*, p.* from post p inner join author a in a.id = p.author_id;

-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력하시오
-- post의 글쓴이가 없는 데이터는 제외. 글쓴이 중에 글쓴적없는 사람도 제외
select p.*, a.email from author a inner join post p on a.id = p.author_id;
-- 글쓴이가 있는 글의 제목, 내용, 그리고 글쓴이의 이름만 출력하시오
select p.title, p.content, a.name from author a inner join post p on a.id = p.author_id;

-- A left join B : A테이블의 데이터는 모두 조회하고, 관련있는(ON 조건) B데이터도 출력
-- 글쓴이는 모두 출력하되, 글을 쓴적있다면 관련글도 같이 출력
select * from author a left join post p on a.id = p.author_id;

-- 모든 글목록을 출력하고, 만약 저자가 있다면 이메일정보를 출력해라
select p.*, a.email from post p left join author a on a.id = p.author_id;

-- 모든 글목록을 출력하고, 관련된 저자 정보 출력.(author_id가 not null이라면 -> 익명이 없다면면)
-- 아래 두 쿼리결과가 동일(author_id가 not null이므로)
select * from post p left join author a on a.id = p.author_id;
select * from post p inner join author a on a.id = p.author_id;

-- 실습) 글쓴이가 있는 글 중에서 글의 title과 저자의 email을 출력하되, 저자의 나이가 30세 이상인글만 출력.
select p.title, a.email from post p inner join author a on a.id = p.author_id where a.age >= 30;

-- 전체 글목록을 조회하되, 글의 저자의 이름이 비어져 있지 않은 글목록만을 출력 (inner와 left결과가 같음)
select p.* from post p inner join author a on a.id = p.author_id where a.name is not null;
select p.* from post p left join author a on a.id = p.author_id where a.name is not null;

-- 조건에 맞는 도서와 저자 리스트 출력 (-> AUTHOR_ID이 Nullable FALSE이므로 left join도 가능. 순서주의.)
SELECT b.BOOK_ID, a.AUTHOR_NAME, 
DATE_FORMAT(b.PUBLISHED_DATE, '%Y-%m-%d') AS PUBLISHED_DATE
FROM BOOK b inner join AUTHOR a
ON b.AUTHOR_ID = a.AUTHOR_ID
WHERE b.category = '경제'
ORDER BY b.PUBLISHED_DATE asc;
-- 없어진 기록 찾기
-- 1) left join
SELECT o.ANIMAL_ID, o.NAME
FROM ANIMAL_OUTS o left join ANIMAL_INS i
ON o.ANIMAL_ID = i.ANIMAL_ID
WHERE i.ANIMAL_ID is null;
-- 2) not in
SELECT o.ANIMAL_ID, o.NAME
FROM ANIMAL_OUTS o
WHERE o.ANIMAL_ID NOT IN (SELECT ANIMAL_ID FROM ANIMAL_INS);