# Jenkins 설정 가이드

## 사전 준비사항

- Kubernetes 클러스터 구성
- kubectl 설정 완료
- Ngrok 계정 및 인증 토큰 ([Ngrok Dashboard](https://dashboard.ngrok.com/)에서 발급)

## 디렉토리 구조

```
Jenkins/
├── k8s/
│   ├── jenkins-deployment.yaml  # Jenkins 배포 설정
│   ├── jenkins-service.yaml     # Jenkins 서비스 설정
│   ├── jenkins-pv.yaml         # 영구 스토리지 설정
│   └── ngrok-secret.yaml       # Ngrok 인증 정보
└── jenkins-service.bat         # Jenkins 서비스 실행 스크립트
```

## 설치 및 실행

### 1. Ngrok 설정

1. [Ngrok Dashboard](https://dashboard.ngrok.com/)에서 인증 토큰 발급
2. 토큰 base64 인코딩:
   ```bash
   echo -n "발급받은-토큰" | base64
   ```
3. `k8s/ngrok-secret.yaml` 파일에 인코딩된 토큰 입력
4. ngrok-credentials Secret 생성
   ```bash
   kubectl create secret generic ngrok-credentials --from-literal=auth-token="발급받은-토큰"
   ```
### 2. Jenkins 배포

#### 자동 배포 (권장)

```bash
jenkins-service.bat
```

#### 수동 배포

```bash
kubectl apply -f k8s/jenkins-pv.yaml
kubectl apply -f k8s/ngrok-secret.yaml
kubectl apply -f k8s/jenkins-deployment.yaml
kubectl apply -f k8s/jenkins-service.yaml
```

## Jenkins 접속

### 로컬 접속
- 웹 UI: http://localhost:8080
- JNLP: localhost:50000

### 외부 접속 (Ngrok)
Ngrok URL 확인:
```bash
kubectl logs -l app=jenkins -c ngrok | findstr "url="
```

## 초기 설정

1. 관리자 비밀번호 확인:
   ```bash
   kubectl exec -it $(kubectl get pods -l app=jenkins -o jsonpath="{.items[0].metadata.name}") -c jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword
   ```

2. 웹 UI 접속 후 초기 설정 진행

## 문제 해결

### Ngrok 연결 오류

"too many connections" 오류 발생 시:
1. [Ngrok Agents Dashboard](https://dashboard.ngrok.com/tunnels/agents)에서 기존 세션 확인
2. 기존 세션 종료
3. Jenkins pod 재시작:
   ```bash
   kubectl delete pod -l app=jenkins
   ```

## 주의사항

1. Ngrok 무료 계정은 동시에 하나의 터널만 사용 가능
2. Jenkins 데이터는 PersistentVolume에 저장됨
3. Pod 재시작 시 Ngrok URL이 변경됨
