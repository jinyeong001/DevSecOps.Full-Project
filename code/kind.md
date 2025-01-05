```
apiVersion: apps/v1
kind: Deployment
metadata:
    name: my-app
spec:
    replicas: 3
    selector:
        matchLabels:
            app: my-app
    template:
        metadata:
            labels:
                app: my-app
```

**※ 여기서 Deployment는 애플리케이션 배포를 정의함을 의미합니다.**
