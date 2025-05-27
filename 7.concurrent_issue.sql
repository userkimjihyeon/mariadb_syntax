-- read uncommited : 커밋되지 않은 데이터 read 가능 -> dirty read 문제 발생
-- 실습절차
-- 1)워크벤치에서 auto_commit해제. update후. commit하지 않음.(transaction1)
-- 2)터미널을 열어 select했을때 위 변경사항이 읽히는지 확인(transaction2)
-- 결론 : mariadb는 기본 격리수준이 repeatable read이므로 dirty read 발생하지 않음.

-- read commited : 커밋한 데이터만 read 가능 -> phantom read 발생(또는 non-repeatable read)     -- -> ex.A트랜잭션 select하면 10인데 중간에 다른 B트랜잭션 "insert"되면 11로 읽힘
-- 워크벤치에서 실행
start transaction;
select count(*) from author;
do sleep(15);
select count(*) from author;
commit;                             -- -> start transaction; + commit;
-- 터미널에서 실행
insert into author(email) values("xxx@naver.com");
-- -> 결론: 현재워크벤치는 격리수준(repeatable read)이 높아서 phantom read 이슈가 발생되지 않음을 확인. -> 15초 sleep 전에 14-> 후에 14조회됨! (phantom read는 14->15가 조회됨)

-- *이게뭔지, 어떻게 해결할지 (serializable이랑 다른점:선택한 특정 행만 잠금!) -> 동시성이슈 해결에 대한 프로젝트 및 면접준비
-- *repeatable read : 읽기의 일관성 보장 ->  *lost update 문제 발생 -> *배타적 잠금(select for "update") (-> ex.A트랜잭션의 select(update(X))부터 lock걸기)으로 해결)
(?)select는 select고 update는 update아님? 왜 연동되는것임? -> 그게 아니구 주문할때 재고1인데 둘다 update(재고-1)하면 총재고현황이 -1이 되기 때문임. 재고0이 되고 B트랜잭션은 실행안되어야함!
-- lost update 문제 발생
DELIMITER //
create procedure concurrent_test1()
begin 
    -- 프로시저는 변수생성가능
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 1);
    select post_count into count from author where id = 1;
    do sleep(15);
    update author set post_count = count + 1 where id = 1;
    commit;
end //
DELIMITER ;
-- 터미널에서는 아래코드 실행
select post_count from author where id = 1;  -- ->lost update 문제가 되면:0

-- lost update 문제 해결 : select for update시에 트랜잭션이 종료후에 특정 행에 대한 lock이 풀림
DELIMITER //
create procedure concurrent_test2()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 1);
    select post_count into count from author where id = 1 for update;       -- -> 특정 행에 LOCK 걸기 -> rDB(멀.스)로 할수있는 최선의방법 -> 성능저하 -> redis(싱.스)쓰샘
    do sleep(15);
    update author set post_count = count + 1 where id = 1;
    commit;
end //
DELIMITER ;
-- 터미널에서는 아래코드 실행
select post_count from author where id = 1 for update;         -- -> 특정 행에 LOCK 걸기 -- ->문제해결:1

-- serializable : 모든 트랜잭션 순차적 실행 -> 동시성 문제없으나 성능저하



