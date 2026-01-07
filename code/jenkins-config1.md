```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
# 컨트롤 플레인
# Jenkins 웹 인터페이스 포트
   # - CI/CD 파이프라인 관리 웹 UI
   # - 빌드 및 배포 모니터링
   # - 호스트 접근: http://localhost:8080
   - containerPort: 30800
    hostPort: 8080
     listenAddress: "0.0.0.0"
     protocol: TCP

   # Jenkins JNLP 에이전트 포트
   # - Jenkins 워커 노드 연결
   # - 분산 빌드 에이전트 통신
   # - 호스트 접근: localhost:50000
   - containerPort: 30850
     hostPort: 50000
     listenAddress: "0.0.0.0"
     protocol: TCP

# 워커 노드 2: Jenkins
- role: worker
  labels:
    node-type: auto
    purpose: jenkins
```