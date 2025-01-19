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
echo Checking for ngrok auth token...
kubectl get secret ngrok-credentials > nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: ngrok-credentials secret not found
    echo Please create the secret with your ngrok auth token:
    echo kubectl create secret generic ngrok-credentials --from-literal=auth-token=your-token
    exit /b 1
)

echo.
echo Cleaning up existing resources...
kubectl delete deployment,service -l app=jenkins --ignore-not-found=true
ping -n 6 127.0.0.1 > nul

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
:wait_pod
for /f "tokens=1,2,3 delims= " %%a in ('kubectl get pods -l app^=jenkins ^| findstr "jenkins"') do (
    set "POD_NAME=%%a"
    set "READY=%%b"
    set "STATUS=%%c"
)
if "%READY%"=="2/2" (
    if "%STATUS%"=="Running" (
        goto :pod_ready
    )
)
echo Current status: %READY% containers ready ^| Pod status: %STATUS%
echo Waiting for both Jenkins and Ngrok containers to be ready...
ping -n 6 127.0.0.1 > nul
goto :wait_pod

:pod_ready
echo.
echo Jenkins pod is ready!

REM Wait a bit for Jenkins to initialize
ping -n 11 127.0.0.1 > nul

echo.
echo Getting Jenkins initial admin password...
for /f "tokens=1" %%i in ('kubectl get pods -l app^=jenkins -o jsonpath^="{.items[0].metadata.name}"') do (
    echo Initial admin password:
    kubectl exec %%i -c jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword
)

echo.
echo Jenkins is available at:
echo - Web UI: http://localhost:8080
echo - JNLP : localhost:50000

echo.
echo Waiting for Ngrok tunnel to be established...
ping -n 11 127.0.0.1 > nul

echo.
echo Ngrok tunnel information:
for /f "tokens=1" %%i in ('kubectl get pods -l app^=jenkins -o jsonpath^="{.items[0].metadata.name}"') do (
    echo Ngrok logs:
    kubectl logs %%i -c ngrok | findstr "url="
)

echo.
echo Setup completed successfully!
echo.
echo Jenkins URLs:
echo - Local  : http://localhost:8080
for /f "tokens=1" %%i in ('kubectl get pods -l app^=jenkins -o jsonpath^="{.items[0].metadata.name}"') do (
    for /f "tokens=2 delims==" %%u in ('kubectl logs %%i -c ngrok ^| findstr "url="') do (
        echo - Public : %%u
    )
)

cd "%ORIGINAL_DIR%"
endlocal
