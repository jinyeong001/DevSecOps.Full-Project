# ELK 컨테이너 실행
```bash
docker compose up -d
```

# 접속 테스트
- Elasticsearch: 브라우저에서 http://localhost:9200
- Kibana: 브라우저에서 http://localhost:5601

# Elasticsearch 비밀번호 재설정
```bash
docker exec -it [elasticsearch 컨테이너 ID] /bin/bash
bin/elasticsearch-reset-password -u elastic
```
- y을 눌러 생성된 비밀번호 복사

# Elasticsearch 브라우저 접속
- 사용자 계정 : elastic
- 비밀번호 : 복사한 비밀번호
- 접속하면 json 데이터 출력됨(정상)

# Kibana 브라우저 접속
- elasticsearch 컨테이너 내부 IP주소
```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' elasticsearch
```
- https://172.18.0.4:9200
- kibana_system 비밀번호 확인
```bash
docker exec -it [elasticsearch 컨테이너 ID] /bin/bash
bin/elasticsearch-reset-password --username kibana_system #K_eMd9m1*aQwVxlKtA9h
```
- kibana_system:[확인한 비밀번호] 로 접속

# Kibana 서버 인증
```bash
docker exec -it [kibana 컨테이너 ID] /bin/bash
bin/kibana-verification-code
```
- 인증 코드 입력
