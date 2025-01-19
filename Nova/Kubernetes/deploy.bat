@echo off
echo Creating Kubernetes cluster...

REM Store the original directory
set "ORIGINAL_DIR=%CD%"
cd /d "%~dp0.."

REM Check if kind exists
if not exist "kind.exe" (
    echo kind not found. Installing...
    call Kubernetes\install-kind.bat
    if !errorlevel! neq 0 (
        echo Failed to install kind
        cd /d "%ORIGINAL_DIR%"
        exit /b !errorlevel!
    )
)

REM Check kind version
.\kind.exe --version
if %errorlevel% neq 0 (
    echo Failed to run kind.exe
    cd /d "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

REM Create Kind cluster
echo Creating cluster with config: %~dp0kind-config.yaml
.\kind.exe create cluster --config Kubernetes/kind-config.yaml --name devsecops-cluster
if %errorlevel% neq 0 (
    echo Failed to create cluster
    cd /d "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

echo.
echo Cluster created successfully!
echo Getting node information...

REM Get node information
kubectl get nodes --show-labels
if %errorlevel% neq 0 (
    echo Failed to get node information
    cd /d "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

cd /d "%ORIGINAL_DIR%"
echo Done!