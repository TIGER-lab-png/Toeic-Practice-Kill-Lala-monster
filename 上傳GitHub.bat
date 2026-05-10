@echo off
cd /d "%~dp0"

:: Add common Git install paths to PATH
set "PATH=%PATH%;C:\Program Files\Git\cmd;C:\Program Files\Git\bin;C:\Program Files (x86)\Git\cmd;C:\Program Files\Git\mingw64\bin"

:: Check git is available
git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git not found. Please install Git from https://git-scm.com
    pause
    exit /b 1
)

echo Git found.

:: Remove corrupt .git if config.lock exists (sign of corruption)
if exist ".git\config.lock" (
    echo Detected corrupt git repo. Cleaning up...
    rmdir /s /q .git
    echo Cleanup done.
)

:: Remove corrupt .git if config is empty/broken
if exist ".git" (
    for %%F in (".git\config") do (
        if %%~zF LSS 10 (
            echo Detected empty git config. Cleaning up...
            rmdir /s /q .git
            echo Cleanup done.
        )
    )
)

:: Init repo
if not exist ".git" (
    echo Initializing new git repo...
    git init
    git branch -M main
)

:: Set user info
git config user.email "dddsss5419@gmail.com"
git config user.name "TIGER-lab-png"

:: Set remote
git remote add origin https://github.com/TIGER-lab-png/Toeic-Practice-Kill-Lala-monster.git 2>nul
git remote set-url origin https://github.com/TIGER-lab-png/Toeic-Practice-Kill-Lala-monster.git

:: Set branch
git branch -M main 2>nul

:: Stage all changes
git add -A

:: Check if anything to commit
git diff --cached --quiet
if not errorlevel 1 (
    echo No changes to upload.
    pause
    exit /b 0
)

:: Commit
git commit -m "update game"

:: Push
echo.
echo Uploading to GitHub...
echo (First time: browser will open for GitHub login)
echo.
git push -u origin main

if not errorlevel 1 (
    echo.
    echo ========================================
    echo  Upload complete! Wait ~1 min for site
    echo  https://TIGER-lab-png.github.io/Toeic-Practice-Kill-Lala-monster/
    echo ========================================
) else (
    echo.
    echo Upload failed. Check error above.
)
echo.
pause
