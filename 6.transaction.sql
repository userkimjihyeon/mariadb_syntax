-- 트랜잭션 테스트
alter table author add column post_count int default 0;

-- post에 글쓴후에, author테이블의 post_count 컬럼에 +1을 시키는 트랜잭션 테스트
start transaction;
update author set post_count=post_count+1 where id = 2;
insert into post(title, content, author_id) values("hello", "hello worlllld", 100);         -- -> 중간에 에러나면 위의 명령문까지 임시저장 (commit, rollback 가지도 않음)
commit; --또는 rollback;

-- 위 트랜잭션은 실패시 자동으로 rollback이 어려움
-- stored 프로시저를 활용하여 성공시 commit 실패시 rollback 등 다이나믹한 프로그래밍
DELIMITER //
create procedure transaction_test()
begin 
    declare exit handler for SQLEXCEPTION       -- -> 예외처리 구문 (SQLEXCEPTION : 모든 에러의 최상위 에러)
    begin
        rollback;
    end;
    start transaction;
    update author set post_count = post_count + 1 where id = 2;
    insert into post(title, content, author_id) values("hello", "hello worlllld", 2);         
    -- -> author_id가 2이면 모두 실행O / 100이면 모두 실행X -> author_id가 fk인데 참조테이블에 존재하지 않는 값이므로
    commit;
end //
DELIMITER ;

-- 프로시저 호출  -- -> CALL해야 임시저장상태에서 프로시저 실행됨
CALL transaction_test();

-- 사용자에게 입력받는 프로시저 생성 -> CALL명령어 대신 UI로 입력받기 가능
DELIMITER //
create procedure transaction_test2(in titleInput varchar(255), in contentInput varchar(255), in idInput bigint)
begin 
    declare exit handler for SQLEXCEPTION       -- -> 예외처리 구문 (SQLEXCEPTION : 모든 에러의 최상위 에러)
    begin
        rollback;
    end;
    start transaction;
    update author set post_count = post_count + 1 where id = idInput;
    insert into post(title, content, author_id) values(titleInput, contentInput, idInput);         
    -- -> author_id가 2이면 모두 실행O / 100이면 모두 실행X -> author_id가 fk인데 참조테이블에 존재하지 않는 값이므로
    commit;
end //
DELIMITER ;