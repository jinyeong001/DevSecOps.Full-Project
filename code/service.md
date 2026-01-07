```yaml
apiVersion: v1
kind: Service
metadata:
  name: wargame-web-service
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
  selector:
    app: wargame-web
---
apiVersion: v1
kind: Service
metadata:
  name: wargame-db-service
spec:
  type: ClusterIP
  ports:
  - port: 3306
    targetPort: 3306
    protocol: TCP
  selector:
    app: wargame-db
```
