@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo Deploying ELK Stack to Kubernetes...

REM Store the original directory
set "ORIGINAL_DIR=%CD%"

echo.
echo Checking cluster nodes...
kubectl get nodes --show-labels | findstr "elk-stack"
if %errorlevel% neq 0 (
    echo ERROR: No node with purpose=elk-stack label found
    echo Please make sure the cluster is properly configured
    exit /b 1
)

echo.
echo Applying Kubernetes configurations...

REM Apply Elasticsearch
echo Deploying Elasticsearch...
kubectl apply -f "%~dp0k8s\elasticsearch.yaml"
if %errorlevel% neq 0 (
    echo Failed to deploy Elasticsearch
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

REM Apply Logstash
echo Deploying Logstash...
kubectl apply -f "%~dp0k8s\logstash.yaml"
if %errorlevel% neq 0 (
    echo Failed to deploy Logstash
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

REM Apply Kibana
echo Deploying Kibana...
kubectl apply -f "%~dp0k8s\kibana.yaml"
if %errorlevel% neq 0 (
    echo Failed to deploy Kibana
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

echo.
echo Waiting for pods to be ready...
timeout /t 5 /nobreak > nul

:check_pods
echo.
echo Checking ELK Stack pod status...
kubectl get pods -l "app in (elasticsearch,logstash,kibana)" -o wide
if %errorlevel% neq 0 (
    echo Failed to get pod status
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

REM Check if all pods are ready using kubectl wait
kubectl wait --for=condition=ready pod -l "app in (elasticsearch,logstash,kibana)" --timeout=30s
if %errorlevel% neq 0 (
    echo Waiting for all pods to be ready...
    timeout /t 10 /nobreak > nul
    goto :check_pods
) else (
    echo All pods are ready!
)

echo.
echo Checking ELK Stack service status...
kubectl get services -l "app in (elasticsearch,logstash,kibana)"
if %errorlevel% neq 0 (
    echo Failed to get service status
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

echo.
echo ELK Stack deployment completed successfully!
echo.
echo Services are available at:
echo - Elasticsearch: http://localhost:9200
echo - Logstash: localhost:5044
echo - Kibana: http://localhost:5601

endlocal
