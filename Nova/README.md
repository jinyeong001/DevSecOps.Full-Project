 # DevSecOps 프로젝트

## 프로젝트 개요
DevSecOps 방법론을 적용한 웹 애플리케이션 개발 및 운영 환경 구축 프로젝트입니다. 
보안을 고려한 CI/CD 파이프라인과 모니터링 시스템을 구축하여 안전하고 효율적인 개발 환경을 제공합니다.

## 기술 스택
- **컨테이너 오케스트레이션**: Kubernetes (Kind)
- **CI/CD**: Jenkins
- **로깅 & 모니터링**: ELK Stack (Elasticsearch, Logstash, Kibana)
- **웹 서비스**: Apache, PHP
- **버전 관리**: Git, GitHub

## 프로젝트 구조
```
.
├── docs/                    # 문서화 자료
├── ELK/                    # Elasticsearch, Logstash, Kibana 스택
│   └── k8s/                # ELK 스택 Kubernetes 매니페스트
├── Jenkins/                # Jenkins CI/CD 서버
│   └── k8s/                # Jenkins Kubernetes 매니페스트
├── Kubernetes/             # Kubernetes 클러스터 설정
│   ├── deploy.bat          # 클러스터 생성 스크립트
│   ├── kind-config.yaml    # Kind 클러스터 설정
│   └── reset-cluster.bat   # 클러스터 초기화 스크립트
└── Web/                    # 웹 애플리케이션
    ├── src/                # 소스 코드
    └── k8s/                # 웹 서비스 Kubernetes 매니페스트
```

## 컴포넌트 설명

### 1. Kubernetes 클러스터 (/Kubernetes)
- Kind를 사용한 로컬 Kubernetes 클러스터 구성
- 워커 노드별 역할 분리 (웹서버, Jenkins, ELK 스택 등)
- 자동화된 클러스터 생성 및 초기화 스크립트 제공

### 2. Jenkins CI/CD (/Jenkins)
- 자동화된 빌드 및 배포 파이프라인
- GitHub 웹훅을 통한 자동 빌드 트리거
- Kubernetes 매니페스트를 통한 컨테이너화된 Jenkins 배포
- 보안 취약점 스캔 및 코드 품질 검사 통합

### 3. ELK 스택 (/ELK)
- 중앙 집중식 로깅 시스템
- 실시간 로그 수집 및 분석
- 시각화된 모니터링 대시보드
- 보안 이벤트 감지 및 알림

### 4. 웹 애플리케이션 (/Web)
- Apache와 PHP 기반의 웹 서비스
- Kubernetes에 최적화된 컨테이너 구성
- 보안 강화를 위한 설정 적용
- 자동 스케일링 지원

## 시작하기

### 사전 요구사항
- Docker Desktop
- Git
- Windows 운영체제

### 설치 및 실행
1. 클러스터 초기화:
```bash
cd Kubernetes
.\reset-cluster.bat
```

2. 클러스터 생성:
```bash
.\deploy.bat
```

3. Jenkins 배포:
```bash
cd ..\Jenkins
.\jenkins-service.bat
```

4. ELK 스택 배포:
```bash
cd ..\ELK
.\ELK.bat
```

5. 웹 서비스 배포:
```bash
cd ..\Web
.\web-service.bat
```

## 접속 정보
- Jenkins: http://localhost:8080
- Kibana: http://localhost:5601
- Elasticsearch: http://localhost:9200
- 웹 서비스: http://localhost:30080

## 참고 자료
- https://github.com/GH6679/web_wargamer.git (웹 서비스 소스 코드)