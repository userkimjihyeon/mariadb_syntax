-- mariadb서버에 접속 (-> workbench(GUI툴) 사용시 불필요)
mariadb -u root -p --입력 후 비밀번호 별도 입력


-- 스키마(database) 생성
CREATE DATABASE board; --(-> 명령어: 대소문자구분X, 이름: 대소문자구분O)

-- 스키마 삭제
DROP DATABASE board;

-- 스키마 목록 조회 (-> USE한 상태에서도 사용가능)
show databases;

-- *스키마 선택 (MariaDB [(none)]> -> MariaDB [board]> 이렇게 바뀜. workbench는 볼드체로 변경됨)
USE board;

-- ->실습1
board2 데이터베이스 생성 -> show databases; -> board2 삭제 -> show databases;

-- 문자인코딩 변경
ALTER DATABASE board default character set = utf8mb4;

-- 문자인코딩 조회
show variables like 'character_set_server';


-- 테이블 생성
create table author(id int primary key, name varchar(255), email varchar(255), password varchar(255));
->varchar와 달리 int는 1과 300000이 같은 byte 할당. 글자크기 제한없음.

-- 테이블 목록 조회
show tables;

-- *테이블 컬럼 조회
describe author;

-- 테이블 생성명령문 조회
show create table author;

-- posts테이블 신규 생성(id, title, contents, author_id)    
create table posts(id int primary key, title varchar(255), contents varchar(255), author_id int); 
-> author_id가  nullable
create table posts(id int, title varchar(255), contents varchar(255), author_id int not null, primary key(id), foreign key(author_id) references author(id));
-> not null, 복잡한 조건: 맨뒤에 넣기(pk,fk)

-- 테이블 제약조건 조회
select * from information_schema.key_column_usage where table_name='posts';

-- 테이블 index 조회
show index from author;
->index란? pk,fk대상을 생성(빈번하므로)

-- alter : 테이블의 구조를 변경
-- 테이블 이름 변경
alter table posts rename post;
-- 테이블에 컬럼 추가
alter table author add column age int;
-- 테이블 컬럼 삭제 (삭제는 타입 불필요)
alter table author drop column age;
-- 테이블 컬럼명 변경
alter table post change column contents content varchar(255);
-- 테이블 컬럼의 타입과 제약조건 변경 => 덮어쓰기
alter table author modify column email varchar(100) not null;
alter table author modify column email varchar(100) not null unique; (->덮어쓰기: unique만 추가하는게 아니라 기존 제약조건도 재입력)

-- 실습 : author테이블에 address컬럼을 추가(varchar255)
alter table author add column address varchar(255);
-- 실습 : post테이블에 title은 not null로 변경, content는 길이 3000자로 변경
1.따로
alter table post modify column title varchar(255) not null;
alter table post modify column content varchar(3000);
2.같이
alter table post modify column title varchar(255) not null, modify column content varchar(3000);

-- drop : 테이블을 삭제하는 명령어
drop table abc;
-- 일련의 쿼리를 실행시킬때 특정 쿼리에서 에러가 나지 않도록 if exists를 많이 사용
drop table if exists abc;