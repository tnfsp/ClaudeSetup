@echo off
title Claude Code Dev Environment Setup

echo.
echo ========================================
echo   Claude Code Dev Environment Installer
echo ========================================
echo.
echo This script will install:
echo   - Git (version control)
echo   - Visual Studio Code (code editor)
echo   - Node.js (required for Claude Code CLI)
echo   - Claude Code CLI (claude command)
echo.
echo Press any key to start installation, or Ctrl+C to cancel...
pause >nul

echo.
echo [Starting] Running installation script...
echo.

:: Get script directory
set "SCRIPT_DIR=%~dp0"

:: Run PowerShell script
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%setup.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [Tip] If you need Administrator privileges:
    echo   1. Right-click this file
    echo   2. Select "Run as administrator"
    echo.
)

echo.
echo ========================================
echo   Installation process completed!
echo ========================================
echo.
echo Please close this window, open a new terminal, then run 'claude' to start
echo.
pause
