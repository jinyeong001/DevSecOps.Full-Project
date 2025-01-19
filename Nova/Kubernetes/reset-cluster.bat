@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

REM Store the original directory
set "ORIGINAL_DIR=%CD%"
cd /d "%~dp0.."

echo.
echo Deleting existing cluster...
.\kind.exe delete cluster --name devsecops-cluster
if %errorlevel% neq 0 (
    echo WARNING: No existing cluster found or failed to delete
) else (
    echo Successfully deleted existing cluster
)

echo.
echo Cluster has been reset. You can now run deploy.bat to create a new cluster.

cd /d "%ORIGINAL_DIR%"
endlocal
