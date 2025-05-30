-- 사용자관리
-- 사용자목록
select * from mysql.user;

-- 사용자생성
create user 'jihyeon92'@'%' identified by '4321';       --> 도커db는 '%'써야함(원격접속)

-- 사용자에게 권한부여
grant select on board.author to 'jihyeon92'@'%';
grant select, insert on board.* to 'jihyeon92'@'%';
grant all privileges on board.* to 'jihyeon92'@'%';

-- 사용자권한 회수
revoke select on board.author from 'jihyeon92'@'%';

-- 사용자권한 조회
show grants for 'jihyeon92'@'%';

-- 사용자 계정삭제
drop user 'jihyeon92'@'%';


