-- 컬럼 차원의 제약조건(unique, not null) 추가/제거 -> modify
-- not null 제약조건 추가
alter table author modify column name varchar(255) not null;
alter table post modify column title varchar(255) not null;
-- not null 제약조건 제거 -> 덮어쓰기 모드이므로 not null만 빼면됨 -> unique는 어떻게 뺌...ㅠㅠ? -> 인덱스명을 사용해서 제거한다는데 일단 나중에..
alter table author modify column name varchar(255);
alter table post modify column title varchar(255);
-- not null, unique 제약조건 동시추가
alter table author modify column email varchar(255) not null unique;

-- 테이블차원의 제약조건(pf, fk) 추가/제거  -> add/drop
-- 제약조건 조회
select * from information_schema.key_column_usage where table_name='post';
-- 제약조건 삭제(pk)
alter table post drop primary key;
-- 제약조건 삭제(fk) -> fk는 여러개일 수 있으므로 제약조건명 추가
alter table post drop foreign key 제약조건명; -> 제약조건명은 마음대로 ex)post_fk
alter table post drop constraint 제약조건명;
-- 제약조건 추가
alter table post add constraint primary key(id);
alter table post add constraint 제약조건명 foreign key(author_id) references author(id);  ---> fk와 참조 필드는 타입이 일치해야함
-> 제약조건 걸면 인덱스가 자동생성됨(그 컬럼이 빈번하게 조회되기 때문) -> 제약조건 삭제해도 인덱스는 유지되므로 따로 삭제해주어야함.

-- on delete/update 제약조건 테스트
-- 부모테이블 데이터 delete시에 자식 fk컬럼 set null, update시에 자식 fk컬럼 cascade
alter table post add constraint 제약조건명 foreign key(author_id) references author(id) on delete set null on update cascade;   -> 이때, delete는 delete row해야 적용됨(id가 pk여서 데이터만 삭제하면 null이 되므로 불가)

-- default옵션
-- enum타입 및 현재시간(current_timestamp)에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';     -> 수정시 varchar(255)이런 데이터타입은 입력해줘야하고 pk,fk는 생략가능
-- auto_increment : 입력을 안했을때 마지막에 입력된 가장 큰 값에서 +1만큼 자동으로 증가된 숫자값을 적용
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

-- uuid 타입
alter table post add column user_id char(36) default (uuid());
