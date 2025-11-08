@echo off
setlocal enabledelayedexpansion
title Auto Setup Utility

:: === 1. Paths and variables ===
set "BASE_DIR=%~dp0"
set "RESOURCES=%BASE_DIR%resources"
set "CHANGES=%BASE_DIR%changes"
set "OUTPUT=%BASE_DIR%output"
set "DOWNLOAD_URL=https://drive.usercontent.google.com/download?id=1-ADI7WIICvtbHOKYEIEjb4RrgyVBJn_E&export=download&authuser=0"
set "ZIP_FILE=%RESOURCES%\optimized.zip"

echo ===========================================
echo         Automatic Setup Utility
echo ===========================================
echo.

:: === 2. Create required folders ===
if not exist "%RESOURCES%" mkdir "%RESOURCES%"
if not exist "%CHANGES%" mkdir "%CHANGES%"
if not exist "%OUTPUT%" mkdir "%OUTPUT%"

:: === 3. Download optimized.zip (reliable method with size check) ===
echo [1/6] Downloading optimized.zip...
if exist "%ZIP_FILE%" del "%ZIP_FILE%" >nul

set "MAX_RETRIES=10"
set "WAIT_SEC=5"
set "RETRY_COUNT=0"

:download_loop
powershell -Command ^
  "$ProgressPreference='SilentlyContinue';" ^
  "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%ZIP_FILE%' -UseBasicParsing" ^
  "; if ((Get-Item '%ZIP_FILE%').Length -lt 5000000) { exit 1 }"

if errorlevel 1 (
    set /a RETRY_COUNT+=1
    echo Attempt %RETRY_COUNT% failed or file too small. Retrying in %WAIT_SEC%s...
    if %RETRY_COUNT% GEQ %MAX_RETRIES% (
        echo Error: Failed to download optimized.zip after %MAX_RETRIES% attempts.
        pause
        exit /b
    )
    timeout /t %WAIT_SEC% /nobreak >nul
    goto download_loop
)

echo Download complete.


:: === 4. Extract archive ===
echo [2/6] Extracting optimized.zip...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%OUTPUT%' -Force"

:: === 5. Mode selection menu ===
echo.
echo Select a mode:
echo 1 - Blox Fruits
echo 2 - Adopt Me
echo 3 - Plants vs Brainrot
echo 4 - Steal a Brainrot
echo 5 - Fish It
echo 6 - Grow a Garden
echo 7 - 99 Nights
echo 8 - Murder Mystery 2
set /p MODE=Enter mode number: 

:: === 9. Finish ===
echo.
echo ===========================================
echo           Everything was done!
echo ===========================================
pause
exit /b
