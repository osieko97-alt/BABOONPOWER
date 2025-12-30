@echo off
echo =========================================
echo Educational Materials Portal Launcher
echo =========================================
echo.

REM Check if XAMPP is installed
if exist "C:\xampp\htdocs" (
    echo XAMPP installation found at C:\xampp
    echo.
) else (
    echo WARNING: XAMPP not found at default location C:\xampp
    echo Please install XAMPP first following the setup guide
    echo.
    pause
    exit /b 1
)

REM Check if Apache is running
echo Checking Apache status...
netstat -an | find ":80" >nul
if %errorlevel% equ 0 (
    echo Apache appears to be running on port 80
    echo.
) else (
    echo Apache may not be running on port 80
    echo Please start Apache from XAMPP Control Panel
    echo.
)

REM Copy portal files if needed
echo Checking portal files...
if not exist "C:\xampp\htdocs\index.html" (
    echo Copying portal files to XAMPP directory...
    xcopy "*" "C:\xampp\htdocs\" /Y /I /E >nul
    echo Portal files copied successfully
    echo.
) else (
    echo Portal files already present in XAMPP directory
    echo.
)

REM Launch browser
echo Launching Educational Materials Portal...
echo.
echo The portal will open in your default browser
echo URL: http://localhost/
echo.
echo Press Ctrl+C to stop the server if needed
echo.

REM Try to open the portal
start "" "http://localhost/"

REM Wait a moment and show instructions
timeout /t 3 >nul

echo =========================================
echo Portal Access Instructions:
echo =========================================
echo.
echo 1. The portal should now be open in your browser
echo 2. If not, manually navigate to: http://localhost/
echo 3. Click on "index.html" to access the main portal
echo 4. Use the "CV System" button to access the spreadsheet view
echo.
echo For XAMPP control, use: C:\xampp\xampp-control.exe
echo.
echo Press any key to exit this launcher...
pause >nul