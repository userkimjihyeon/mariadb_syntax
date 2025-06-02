-- pk, fk, unique 제약조건 추가시에 해당컬럼에 대해 index페이지 자동생성
-- index가 만들어지면, 조회성능은 향상. 추가/수정/삭제 성능 하락.

-- index 조회
show index from author;

-- index 삭제
alter table author drop index 인덱스명;

-- index 생성
create index 인덱스명 on 테이블(컬럼명);

-- index를 통해 조회성능향상을 얻으려면, 반드시 where조건에 해당컬럼에 대한 조건이 있어야함.
select * from author where email="hongildong@naver.com";

-- 만약 where조건에서 2컬럼으로 조회시에, 1컬럼에만 index가 있다면 (-> index컬럼 먼저 조회하고 그 중에서 나머지 컬럼 조회)
select * from author where name='hong' and email='hongildong@naver.com';

-- 만약 where조건에서 2컬럼으로 조회시에, 2컬럼 모두에 index가 있다면
-- 이 경우 DB엔진에서 최적의 알고리즘 실행.
select * from author where name='hong' and email='hongildong@naver.com';

-- 복합 인덱스 : index는 1컬럼 뿐만아니라, 2컬럼을 대상으로 1개의 index를 설정하는 것도 가능.
-- 이 경우 두컬럼을 and조건으로 조회해야만 index를 사용한다. (X) -> 1컬럼으로만 조회 가능
-- 복합 인덱스 생성
create index 인덱스명 on 테이블명(컬럼1, 컬럼2);

-- 기존테이블 삭제 후 아래 테이블로 신규생성
create table author(id bigint auto_increment, email varchar(255), name varchar(255), primary key(id));

-- index테스트 시나리오
-- 아래 프로시저를 통해 수십만건의 데이터 insert후에 index생성 전후에 따라 조회성능확인
DELIMITER //
CREATE PROCEDURE insert_authors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE email VARCHAR(100);
    DECLARE batch_size INT DEFAULT 10000; -- 한 번에 삽입할 행 수
    DECLARE max_iterations INT DEFAULT 100; -- 총 반복 횟수 (1000000 / batch_size)
    DECLARE iteration INT DEFAULT 1;
    WHILE iteration <= max_iterations DO
        START TRANSACTION;
        WHILE i <= iteration * batch_size DO
            SET email = CONCAT('seonguk', i, '@naver.com');
            INSERT INTO author (email) VALUES (email);
            SET i = i + 1;
        END WHILE;
        COMMIT;         -- -> *중간중간 commit해주어야 대량의 데이터를 넣을때 에러나지 않음.
        SET iteration = iteration + 1;
        DO SLEEP(0.1); -- 각 트랜잭션 후 0.1초 지연
    END WHILE;
END //
DELIMITER ;

