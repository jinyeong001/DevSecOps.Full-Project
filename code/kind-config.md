```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
# 컨트롤 플레인
- role: control-plane
    extraPortMappings:
    - containerPort: 30080 #DevSecOps Web
        hostPort: 30080
        listenAddress: "0.0.0.0"
        protocol: TCP
# 워커 노드 1: 테스트 웹서버
- role: worker
  labels:
    node-type: webserver
    purpose: apache-php
```