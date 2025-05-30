# 덤프파일 생성
# 로컬
mysqldump -u root -p 스키마명 > 덤프파일명
mysqldump -u root -p board > mydumpfile.sql
# 도커
vscode -> 터미널 -> bash
docker exec -it 컨테이너ID mariadb-dump -u root -p1234 board > mydumpfile.sql
-> 비밀번호 입력 후 엔터


# 덤프파일 적용(복원) -> 사용전 껍데기 database 만들고 시작
# 로컬
mysql -u root -p 스키마명 < 덤프파일명
mysql -u root -p board < mydumpfile.sql
# 도커
vscode -> 터미널 -> bash
docker exec -i 컨테이너ID mariadb -u root -p1234 board < mydumpfile.sql
-> 비밀번호 입력 후 엔터

