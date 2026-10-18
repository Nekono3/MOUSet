@echo off
title MOUSet Presentation Remote & Trackpad
echo ==================================================
echo   🚀 Starting MOUSet for Windows...
echo ==================================================

where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed.
    echo Please install Node.js from https://nodejs.org
    pause
    exit /b
)

if not exist node_modules (
    echo Installing dependencies...
    call npm install
)

echo Launching server...
node server.js
pause
