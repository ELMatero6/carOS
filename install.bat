@echo off
setlocal enabledelayedexpansion

:: ==============================
:: CarOS Portable Python Installer
:: ==============================

set PY_VERSION=3.12.6
set PY_URL=https://www.python.org/ftp/python/%PY_VERSION%/python-%PY_VERSION%-embed-amd64.zip
set PY_DIR=python
set PY_ZIP=python.zip
set GET_PIP=tools\get-pip.py

echo [INFO] Checking for portable Python...

if exist "%PY_DIR%\python.exe" (
    echo [OK] Python already exists in "%PY_DIR%"
) else (
    echo [INFO] Downloading portable Python %PY_VERSION%...
    powershell -Command "Invoke-WebRequest -Uri %PY_URL% -OutFile %PY_ZIP%"
    echo [INFO] Extracting Python...
    powershell -Command "Expand-Archive -Path %PY_ZIP% -DestinationPath %PY_DIR%"
    del %PY_ZIP%
    echo [OK] Python extracted to "%PY_DIR%"

    echo [INFO] Configuring site-packages...
    if not exist "%PY_DIR%\python312._pth" (
        echo python312.zip> "%PY_DIR%\python312._pth"
        echo .>> "%PY_DIR%\python312._pth"
        echo import site>> "%PY_DIR%\python312._pth"
        echo [OK] Created python312._pth with import site enabled.
    ) else (
        powershell -Command "(Get-Content '%PY_DIR%\python312._pth') -replace '#import site','import site' | Set-Content '%PY_DIR%\python312._pth'"
        echo [OK] Patched python312._pth to enable site-packages.
    )
)

echo [INFO] Installing pip...
"%PY_DIR%\python.exe" "%GET_PIP%"

echo [INFO] Upgrading pip...
"%PY_DIR%\python.exe" -m pip install --upgrade pip

echo [INFO] Installing project requirements...
"%PY_DIR%\python.exe" -m pip install -r requirements.txt --no-cache-dir

echo.
echo [OK] Setup complete.
choice /m "Do you want to run CarOS now?"
if errorlevel 1 (
    if %errorlevel%==1 (
        call run.bat
    )
)

pause
