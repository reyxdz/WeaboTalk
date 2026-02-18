@echo off
REM Start WeaboTalk development server
REM This script sets the PostgreSQL password and starts Rails

setlocal enabledelayedexpansion

REM Set your PostgreSQL password
set POSTGRES_PASSWORD=rey1172003

REM Display startup message
echo ============================================
echo   WeaboTalk Development Server Starting
echo ============================================
echo.
echo Database: weabo_talk_development
echo URL: http://localhost:3000
echo.
echo Press Ctrl+C to stop the server
echo.
echo ============================================
echo.

REM Start the development server
call ruby -v >nul 2>&1
if errorlevel 1 (
    echo ERROR: Ruby not found in PATH
    echo Please add Ruby to your PATH or run from Git Bash
    pause
    exit /b 1
)

REM Run the dev server
ruby -S rails s
