```
spec:
    replicas: 3
    selector:
        matchLabels:
            app: example
    template:
        metadata:
            labels:
                app: example
        spec:
            containers:
            - name: nginx
                image: nginx:1.21.6
                ports:
                - containerPort: 80
```

**필드1. replicas: Pod 복제본 수**
**필드2. containers: 실행할 컨테이너 이미지와 설정**

