```
volumes:
- name: example-volume
    persistentVolumeClaim:
        claimName: example-pvc
```

**※ Persistent Volume Claim(PVC)을 참조하여 데이터를 영구 저장합니다.**