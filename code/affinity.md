```
affinity:
    nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
                - key: node-type
                    operator: In
                    values:
                    - webserver
```

**※ node-type=webserver 노드에만 Pod가 배치되도록 지정합니다.**