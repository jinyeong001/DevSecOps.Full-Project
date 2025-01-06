```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wargame-web
spec:
  selector:
    matchLabels:
      app: wargame-web
  template:
    metadata:
      labels:
        app: wargame-web
        node-type: webserver
    spec:
      nodeSelector:
        node-type: webserver
      containers:
      - name: wargame-web
        image: wargame-web:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 80
        env:
        - name: DB_HOST
          value: "wargame-db-service"
        - name: DB_PORT
          value: "3307"
        - name: DB_DATABASE
          value: "LED_WG"
        - name: DB_USERNAME
          value: "root"
        - name: DB_PASSWORD
          value: "1234"
        volumeMounts:
        - name: web-storage
          mountPath: /var/www/html
        resources:
          limits:
            memory: "512Mi"
            cpu: "500m"
          requests:
            memory: "256Mi"
            cpu: "250m"
      volumes:
      - name: web-storage
        persistentVolumeClaim:
          claimName: web-pvc
```
