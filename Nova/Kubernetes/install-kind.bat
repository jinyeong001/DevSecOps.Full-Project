@echo off
setlocal enabledelayedexpansion

echo Checking for kind installation...

REM Store the original directory
set "ORIGINAL_DIR=%CD%"
cd /d "%~dp0.."

REM Check if kind.exe already exists in project root
if exist "kind.exe" (
    echo kind.exe already exists in project root
    echo Checking version:
    .\kind.exe --version
    choice /C YN /M "Do you want to reinstall kind?"
    if !errorlevel! equ 2 (
        echo Keeping existing kind installation
        cd /d "%ORIGINAL_DIR%"
        exit /b 0
    )
    del /f kind.exe
)

echo Downloading kind...
REM Using PowerShell to download kind
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://kind.sigs.k8s.io/dl/v0.20.0/kind-windows-amd64' -OutFile 'kind.exe'}"
if %errorlevel% neq 0 (
    echo Failed to download kind
    cd /d "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

echo.
echo Testing kind installation...
.\kind.exe --version
if %errorlevel% neq 0 (
    echo Failed to run kind
    cd /d "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

echo.
echo kind has been successfully installed to: %CD%\kind.exe

cd /d "%ORIGINAL_DIR%"
endlocal
