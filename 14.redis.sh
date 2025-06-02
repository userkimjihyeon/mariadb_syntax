# window에서는 기본설치 안됨 -> 도커를 통한 redis 설치
docker run --name redis-container -d -p 6379:6379 redis

# redis 접속명령어
redis-cli
# docker redis 접속명령어
docker exec -it 컨테이너ID redis-cli        # 컨테이너ID조회 : docker ps

# redis는 0~15번까지의 db로 구성(default는 0번 db)
# db번호 선택
select db번호

# db내 모든 키 조회
keys *

# 가장 일반적인 String 자료구조

# set을 통해 key:value 세팅
set user1 hong1@naver.com
set user:email:1 hong1@naver.com
set user:email:2 hong2@naver.com
# 기존에 key:value가 존재할경우 덮어쓰기
set user:email:1 hong3@naver.com
# key값이 이미 존재하면 pass, 없으면 set : nx
set user:email:1 hong4@naver.com nx
# 만료시간(ttl) 설정(초단위) : ex
set user:email:5 hong5@naver.com ex 10
# *redis실전활용 : token등 사용자 인증정보 저장 -> 빠른성능 활용
set user:1:refresh_token abcdefg1234 ex 1800
# key를 통해 value get
get user1
get user:email:1
# 특정 key삭제
del user1
# 현재 DB내 모든 key값 삭제
flushdb

#redis실전활용 : 좋아요기능 구현 -> 동시성이슈 해결
set likes:posting:1 0 #redis는 기본적으로 모든 key:value가 문자열. 내부적으로는 "0"으로 저장.
incr likes:posting:1 #특정 key값의 value를 1만큼 증가
decr likes:posting:1 #특정 key값의 value를 1만큼 감소
#redis실전활용 : 재고관리 -> 동시성이슈 - 해결
set stocks:product:1 100
decr stocks:product:1
incr stocks:product:1

# redis실전활용 : 캐싱기능구현 (->조회는빠르지만업데이트는느림. rdb redis모두 수정해야해서)
# 1번 회원 정보 조회 : select name, email, age from member where id=1;
# 위 데이터의 결과값을 spring서버를 통해 json으로 변형하여, redis에 캐싱
# 최종적인 데이터 형식 : {"name":"hong", "email":"hong@daum.net", "age":30}
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000

# list자료구조
# redis의 list는 deque와 같은 자료구조. 즉 double-ended queue 구조
# lpush : 데이터를 list자료구조에 왼쪽부터 삽입
# rpush : 데이터를 list자료구조에 오른쪽부터 삽입
lpush hongs hong1
lpush hongs hong2
rpush hongs hong3
# list조회 : 0은 리스트의 시작인덱스를 의미. -1은 리스트의 마지막인덱스를 의미
lrange hongs 0 -1 #전체조회
lrange hongs 0 0 #0번째값조회
lrange hongs -1 -1 #마지막값조회
lrange hongs -2 -1 #마지막2번째부터 마지막까지
lrange hongs 0 2 #0번째부터 2번째까지 
# list값 꺼내기. 꺼내면서 삭제.
rpop hongs
lpop hongs
# A리스트에서 rpop하여 B리스트에서 lpush
rpoplpush A리스트 B리스트
rpush abc a1
rpush abc a2
rpush bcd b1
rpush bcd b2
rpoplpush abc bcd
# list의 데이터 개수 조회
llen hongs
# ttl적용
expire hongs 20
# ttl조회
ttl hongs
# redis실전활용 : 최근조회한상품목록
rpush user:1:recent:product apple
rpush user:1:recent:product banana
rpush user:1:recent:product orange
rpush user:1:recent:product melon
rpush user:1:recent:product mango
# 최근본상품3개조회
lrange user:1:recent:product -3 -1

# set자료구조 : 중복없음, 순서없음.
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3
sadd memberlist m3      #알아서 중복제거 됨
# set조회
smembers memberlist
# set멤버 개수 조회
scard memberlist
# 특정멤버가 set안에 있는지 존재여부 확인
sismember memberlist m2     #1은긍정 0은부정

# redis실전활용 : 좋아요 구현
# 게시글상세보기에 들어가면
scard posting:likes:1       #좋아요개수조회
sismember posting:likes:1 a1@naver.com      #a1@naver.com가 좋아요한 set멤버에 존재여부
# 게시글에 좋아요를 하면
sadd posting:likes:1 a1@naver.com       #a1@naver.com이 좋아요set에 추가
# 좋아요한사람을 클릭하면
smembers posting:likes:1        #좋아요한 set조회

# zset : sorted set
