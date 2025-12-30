@echo off
echo =========================================
echo GitHub Push Script for Educational Materials Portal
echo =========================================
echo.

REM Check if we're in a git repository
if not exist ".git" (
    echo ERROR: This is not a Git repository.
    echo Please initialize Git first with: git init
    echo.
    pause
    exit /b 1
)

REM Check git status
echo Checking repository status...
git status --porcelain >nul
if %errorlevel% neq 0 (
    echo ERROR: Git status check failed.
    echo.
    pause
    exit /b 1
)

echo.
echo Current repository status:
git status --short
echo.

REM Add all changes
echo Adding all changes to staging area...
git add .
if %errorlevel% neq 0 (
    echo ERROR: Failed to add files to staging area.
    echo.
    pause
    exit /b 1
)

echo Files added successfully.
echo.

REM Check if there are changes to commit
git diff --cached --quiet
if %errorlevel% equ 0 (
    echo No changes to commit. Repository is up to date.
    echo.
    pause
    exit /b 0
)

REM Get commit message from user or use default
set "commit_msg="
set /p commit_msg="Enter commit message (or press Enter for default): "
if "%commit_msg%"=="" (
    set commit_msg=Update Educational Materials Portal
)

REM Commit changes
echo Committing changes with message: "%commit_msg%"
git commit -m "%commit_msg%"
if %errorlevel% neq 0 (
    echo ERROR: Failed to commit changes.
    echo.
    pause
    exit /b 1
)

echo Changes committed successfully.
echo.

REM Check if remote origin exists
git remote get-url origin >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: No remote 'origin' configured.
    echo Please set up your GitHub repository first:
    echo git remote add origin https://github.com/yourusername/yourrepo.git
    echo.
    pause
    exit /b 1
)

REM Push to GitHub
echo Pushing to GitHub...
git push origin main
if %errorlevel% neq 0 (
    REM Try pushing to master branch if main fails
    echo Trying to push to 'master' branch...
    git push origin master
    if %errorlevel% neq 0 (
        echo ERROR: Failed to push to GitHub.
        echo Please check your remote configuration and try manually.
        echo.
        pause
        exit /b 1
    )
)

echo.
echo =========================================
echo SUCCESS: All changes pushed to GitHub!
echo =========================================
echo.
echo Repository URL:
git remote get-url origin
echo.
echo Latest commit:
git log --oneline -1
echo.
echo Press any key to exit...
pause >nul