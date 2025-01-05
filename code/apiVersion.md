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

**※ 여기서 apps/v1은 Deployment와 같은 애플리케이션 관련 리소스를 정의할 때 사용합니다.**
