```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wargame-db
spec:
  selector:
    matchLabels:
      app: wargame-db
  template:
    metadata:
      labels:
        app: wargame-db
        node-type: web-db
    spec:
      nodeSelector:
        node-type: web-db
      containers:
      - name: mariadb
        image: mariadb:latest
        resources:
          limits:
            memory: "512Mi"
            cpu: "500m"
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "1234"
        - name: MYSQL_DATABASE
          value: "LED_WG"
        - name: MYSQL_ALLOW_EMPTY_PASSWORD
          value: "no"
        - name: MYSQL_ROOT_HOST
          value: "%"
        - name: MARIADB_MYSQL_LOCALHOST_USER
          value: "1"
        - name: MARIADB_MYSQL_LOCALHOST_GRANTS
          value: "ALL"
        volumeMounts:
        - name: mariadb-storage
          mountPath: /var/lib/mysql
        - name: mariadb-backup
          mountPath: /backup
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: mariadb-pvc
      - name: mariadb-backup
        persistentVolumeClaim:
          claimName: mariadb-backup-pvc
```
