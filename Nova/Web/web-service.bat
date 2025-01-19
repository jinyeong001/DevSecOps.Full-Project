@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

REM Find kind executable
set "KIND_EXE="
for %%p in (
    "%USERPROFILE%\go\bin\kind.exe"
    "C:\Program Files\kind\kind.exe"
    "C:\ProgramData\chocolatey\bin\kind.exe"
    "%LOCALAPPDATA%\Programs\kind\kind.exe"
) do (
    if exist %%p (
        set "KIND_EXE=%%p"
        goto :found_kind
    )
)
echo ERROR: Could not find kind.exe in common locations
echo Please make sure kind is installed correctly
exit /b 1

:found_kind
echo Found kind at: !KIND_EXE!

echo Checking for web_wargamer repository...

REM Store the original directory
set "ORIGINAL_DIR=%CD%"
cd ..
set "PROJECT_ROOT=%CD%"
cd "%ORIGINAL_DIR%"

set "IMAGE_NAME=wargame-web:latest"
set "TEMP_TAR=%ORIGINAL_DIR%\temp-image.tar"

REM Check if web_wargamer directory exists
if exist "%PROJECT_ROOT%\web_wargamer" (
    echo Repository exists, updating...
    cd "%PROJECT_ROOT%\web_wargamer"
    git pull
    if %errorlevel% neq 0 (
        echo Failed to update repository
        cd "%ORIGINAL_DIR%"
        exit /b %errorlevel%
    )
) else (
    echo Cloning repository...
    cd "%PROJECT_ROOT%"
    git clone https://github.com/GH6679/web_wargamer.git
    if %errorlevel% neq 0 (
        echo Failed to clone repository
        cd "%ORIGINAL_DIR%"
        exit /b %errorlevel%
    )
    cd web_wargamer
)

echo.
echo Building Docker image...
docker build -t !IMAGE_NAME! .
if %errorlevel% neq 0 (
    echo Failed to build Docker image
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

cd "%ORIGINAL_DIR%"

echo.
echo Verifying Docker image...
docker image inspect !IMAGE_NAME! > nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker image !IMAGE_NAME! not found
    exit /b %errorlevel%
)

echo.
echo Loading image to Kind cluster...
echo Debug: Current directory is: !CD!
echo Debug: Image name is: !IMAGE_NAME!
echo Debug: Kind executable is: !KIND_EXE!

echo Debug: Saving Docker image to tar...
docker save !IMAGE_NAME! -o "!TEMP_TAR!"
if %errorlevel% neq 0 (
    echo Failed to save Docker image to tar
    exit /b %errorlevel%
)

echo Debug: Loading image archive to Kind cluster...
!KIND_EXE! load image-archive "!TEMP_TAR!" --name devsecops-cluster
if %errorlevel% neq 0 (
    echo Failed to load image to cluster
    del "!TEMP_TAR!" 2>nul
    exit /b %errorlevel%
)

del "!TEMP_TAR!" 2>nul

echo.
echo Applying Kubernetes configurations...
cd "%PROJECT_ROOT%"
kubectl apply -f web_wargamer/k8s/db-init-configmap.yaml
if %errorlevel% neq 0 (
    echo Failed to apply database configmap
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

kubectl apply -f web_wargamer/k8s/db-deployment.yaml
if %errorlevel% neq 0 (
    echo Failed to apply database deployment
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

kubectl apply -f web_wargamer/k8s/web-deployment.yaml
if %errorlevel% neq 0 (
    echo Failed to apply web deployment
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

kubectl apply -f web_wargamer/k8s/services.yaml
if %errorlevel% neq 0 (
    echo Failed to apply services
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

cd "%ORIGINAL_DIR%"

echo.
echo All deployments completed successfully!
echo.
echo Checking pod status...
kubectl get pods
echo.
echo Checking service status...
kubectl get services

endlocal