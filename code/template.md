```
template:
    metadata:
        labels:
            app: example
    spec:
    containers:
        - name: nginx
            image: nginx:1.21.6
```

**※ app: example 레이블을 가진 Pod를 생성하며, nginx 컨테이너를 실행합니다.**