@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo Deploying Jenkins to Kubernetes...

REM Store the original directory
set "ORIGINAL_DIR=%CD%"

echo.
echo Checking cluster nodes...
kubectl get nodes --show-labels | findstr "jenkins"
if %errorlevel% neq 0 (
    echo ERROR: No node with purpose=jenkins label found
    echo Please make sure the cluster is properly configured
    exit /b 1
)

echo.
echo Applying Kubernetes configurations...

REM Apply PV and PVC
echo Creating persistent volume and claim...
kubectl apply -f "%~dp0k8s\jenkins-pv.yaml"
if %errorlevel% neq 0 (
    echo Failed to create persistent volume
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

REM Apply Deployment
echo Deploying Jenkins...
kubectl apply -f "%~dp0k8s\jenkins-deployment.yaml"
if %errorlevel% neq 0 (
    echo Failed to deploy Jenkins
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

REM Apply Service
echo Creating Jenkins service...
kubectl apply -f "%~dp0k8s\jenkins-service.yaml"
if %errorlevel% neq 0 (
    echo Failed to create service
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

echo.
echo Waiting for Jenkins pod to be ready...
kubectl wait --for=condition=ready pod -l app=jenkins --timeout=300s
if %errorlevel% neq 0 (
    echo Timeout waiting for Jenkins pod
    goto :show_status
)

:show_status
echo.
echo Jenkins deployment status:
kubectl get pods,svc -l app=jenkins

echo.
echo Jenkins is available at:
echo - Web UI: http://localhost:8080
echo - JNLP : localhost:50000

echo.
echo Waiting for Jenkins to initialize...
timeout /t 10 /nobreak > nul

echo.
echo Initial admin password:
for /f "tokens=1" %%i in ('kubectl get pod -l app^=jenkins -o jsonpath^="{.items[0].metadata.name}"') do (
    kubectl exec %%i -- cat /var/jenkins_home/secrets/initialAdminPassword
)

cd "%ORIGINAL_DIR%"
endlocal
