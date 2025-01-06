```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
    labels:
        node-type: webserver
        purpose: apache-php
- role: worker
    labels:
        node-type: database
        purpose: mysql
```

**role:worker**: 워커 노드로 역할을 지정
**labels**: 각 워커 노드에 태그를 추가하여 특정 워크노드에 연결
