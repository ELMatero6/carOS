@echo off
echo === CarOS Installer ===
echo.

:: Fix Python _pth file if needed
set "PTHFILE=python\python*.pth"
for %%f in (%PTHFILE%) do (
    findstr /C:"import site" "%%f" >nul || (
        echo import site>>"%%f"
        echo [INFO] Enabled site-packages in %%f
    )
)

:: Ensure pip is present
python\python.exe -m ensurepip || (
    echo [INFO] Bootstrapping pip...
    python\python.exe get-pip.py
)

:: Upgrade pip
python\python.exe -m pip install --upgrade pip

:: Install project dependencies
python\python.exe -m pip install -r requirements.txt
echo.
echo [SUCCESS] All dependencies installed.
echo.

:: Ask if user wants to start the server
set /p STARTNOW=Do you want to start CarOS now? (Y/N): 
if /I "%STARTNOW%"=="Y" (
    echo Starting CarOS...
    python\python.exe app\main.py
) else (
    echo You can start CarOS later by running run.bat
)
pause
