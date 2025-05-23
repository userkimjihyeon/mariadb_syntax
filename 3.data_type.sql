-- tinyint : -128~127까지 표현(unsigned시에 양수만 0~255까지)
-- author테이블에 age컬럼 변경
alter table author modify column age tinyint unsigned;
insert into author(id, email, age) values(6, 'abc@naver.com', 300); --255까지이므로 에러

-- int : 4바이트(대략 40억 숫자범위)

-- bigint : 8바이트
-- author, post테이블의 id값 bigint로 변경
alter table author modify column id bigint; -- -> post테이블에서 fk이므로 에러 -> fk를 해제해야함
alter table author modify column id bigint primary key; -- -> multiple 에러 -> 이미 적용되어 있어서.. 그냥 빼고 하면 됨
-- -> 흐름
select 제약조건조회 -> fk설정(나중에 제약조건파트에서 다시배움. 그래서 실무에서 fk안씀.)
author테이블의 id -> bigint 변경
post테이블의 id, author_id -> bigint 변경

-- decimal(총자릿수, 소수부자리수)
alter table post add column price decimal(10, 3);
-- decimal 소수점 초과시 짤림현상 발생
insert into post(id, title, price, author_id) values(6, "hello python", 10.33412, 3);

-- 문자타입 : 고정길이(char), 가변길이(varchar, text)
alter table author add column gender char(10);  -- -> 남,여 등 글자수가 정해진 경우에 사용
alter table author add column self_introduction text;  -- -> 범위설정안함: 최대 65535 글자수 사용가능

-- BLOB(바이너리데이터) 타입 실습 -> 잘 안씀
-- 일반적으로 blob으로 저장하기 보다, varchar로 설계하고 이미지경로만을 저장함.
alter table author add column profile_image longblob;
insert into author(id, email, profile_image) values(8, 'aaa@naver.com', LOAD_FILE('C:\\test.jpg'));

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role컬럼 추가
alter table author add column role enum('admin', 'user') not null default 'user'; -- -> null을 넣으면 기본값 'user'가 적용됨.
-- enum에 지정된 값이 아닌 경우 -> 에러
insert into author(id, email, role) values(10, 'sss10@naver.com', 'admin2');
-- role을 지정 안한경우 -> 기본값
insert into author(id, email) values(10, 'sss10@naver.com');
-- enum에 지정된 값인 경우
insert into author(id, email, role) values(11, 'sss11@naver.com', 'admin');

-- date과 datetime
-- 날짜타입의 입력, 수정, 조회시에 문자열 형식을 사용한다
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id, title, author_id, created_time) values(7, 'hello', 3, '2025-05-23 14:36:30');
alter table post modify column created_time datetime default current_timestamp();
insert into post(id, title, author_id, created_time) values(8, 'hello', 3, '2025-05-23 14:36:30');

-- 비교연산자 ->셋다 같은 구문임
select * from author where id >= 2 and id <= 4;
select * from author where id between 2 and 4;
select * from author where id in(2,3,4);    -- -> not in은 반대

-- LIKE : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'h%';       -- -> not like도 가능
select * from post where title like '%h';
select * from post where title like '%h%';      -- -> 양쪽 끝이 빈값이어도 조회됨

-- regexp : 정규표현식을 활용한 조회
select * from post where title regexp '[a-z]'; -- 하나라도 알파벳 소문자가 들어있으면
select * from post where title regexp '[가-힣]'; -- 하나라도 한글이 들어있으면

-- 날짜변환 cast
-- 숫자 -> 날짜
select cast(20250523 as date); -- 2025-05-23
-- 문자 -> 날짜
select cast('20250523' as date); -- 2025-05-23
-- 문자 -> 숫자
select cast('12' as unsigned);

-- 날짜조회 방법 : 2025-05-23 14:30:25
-- like패턴, 부등호 활용, date_format
select * from post where created_time like '2025-05%'; -- 문자열처럼 조회
-- 5월1일부터 5월20일까지, 날짜만 입력시 시간부분은 00:00:00이 자동으로 붙음
select * from post where created_time >= '2025-05-01' and created_time < '2025-05-21';


select date_format(created_time, '%Y-%m-%d') from post; -- 날짜
select date_format(created_time, '%H:%i:%s') from post;  -- 시간
select * from post where date_format(created_time, '%m') = '05';

-- sql문제풀이용 (월을 문자 '05'에서 숫자 5로 조회하려면, cast로 문자->숫자)
select * from post where cast(date_format(created_time, '%m') as unsigned) = 5;

