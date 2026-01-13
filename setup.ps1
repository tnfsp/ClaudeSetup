# Windows Development Environment Auto-Install Script
# Purpose: Quickly set up Claude Code CLI development environment on a clean Windows PC

param(
    [switch]$SkipGit,
    [switch]$SkipVSCode,
    [switch]$SkipNodeJS
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Windows Dev Environment Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[Warning] Recommend running as Administrator for best results" -ForegroundColor Yellow
    Write-Host ""
}

# Check if winget is available
function Test-Winget {
    try {
        $null = Get-Command winget -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Install software using winget
function Install-WithWinget {
    param(
        [string]$PackageId,
        [string]$Name
    )

    Write-Host "[Installing] $Name..." -ForegroundColor Yellow

    # Check if already installed
    $installed = winget list --id $PackageId 2>$null | Select-String $PackageId
    if ($installed) {
        Write-Host "[Installed] $Name already exists, skipping" -ForegroundColor Green
        return $true
    }

    try {
        winget install --id $PackageId --accept-package-agreements --accept-source-agreements --silent
        Write-Host "[Done] $Name installed successfully" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "[Error] $Name installation failed: $_" -ForegroundColor Red
        return $false
    }
}

# Main installation process
Write-Host "[Step 1/4] Checking winget package manager..." -ForegroundColor Cyan

if (-not (Test-Winget)) {
    Write-Host "[Error] winget not available. Please ensure you are using Windows 10 (1809+) or Windows 11" -ForegroundColor Red
    Write-Host "        You can install 'App Installer' from Microsoft Store to get winget" -ForegroundColor Red
    exit 1
}
Write-Host "[Done] winget is available" -ForegroundColor Green
Write-Host ""

# Install Git
Write-Host "[Step 2/4] Git version control..." -ForegroundColor Cyan
if (-not $SkipGit) {
    Install-WithWinget -PackageId "Git.Git" -Name "Git"
} else {
    Write-Host "[Skipped] Git installation skipped" -ForegroundColor Yellow
}
Write-Host ""

# Install VS Code
Write-Host "[Step 3/4] Visual Studio Code..." -ForegroundColor Cyan
if (-not $SkipVSCode) {
    Install-WithWinget -PackageId "Microsoft.VisualStudioCode" -Name "Visual Studio Code"
} else {
    Write-Host "[Skipped] VS Code installation skipped" -ForegroundColor Yellow
}
Write-Host ""

# Install Node.js (required for Claude Code CLI)
Write-Host "[Step 4/4] Node.js (required for Claude Code CLI)..." -ForegroundColor Cyan
if (-not $SkipNodeJS) {
    Install-WithWinget -PackageId "OpenJS.NodeJS.LTS" -Name "Node.js LTS"
} else {
    Write-Host "[Skipped] Node.js installation skipped" -ForegroundColor Yellow
}
Write-Host ""

# Refresh environment variables
Write-Host "[Setup] Refreshing environment variables..." -ForegroundColor Cyan
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
Write-Host "[Done] Environment variables updated" -ForegroundColor Green
Write-Host ""

# Install Claude Code CLI
Write-Host "[Step 5/4] Installing Claude Code CLI..." -ForegroundColor Cyan
try {
    # Check if npm is available
    $npmVersion = npm --version 2>$null
    if ($npmVersion) {
        Write-Host "[Info] npm version: $npmVersion" -ForegroundColor Gray

        # Check if Claude Code is already installed
        $claudeInstalled = npm list -g @anthropic-ai/claude-code 2>$null | Select-String "claude-code"
        if ($claudeInstalled) {
            Write-Host "[Installed] Claude Code CLI already exists" -ForegroundColor Green
        } else {
            Write-Host "[Installing] Claude Code CLI..." -ForegroundColor Yellow
            npm install -g @anthropic-ai/claude-code
            Write-Host "[Done] Claude Code CLI installed successfully" -ForegroundColor Green
        }
    } else {
        Write-Host "[Warning] npm not yet available, please reopen terminal and run:" -ForegroundColor Yellow
        Write-Host "          npm install -g @anthropic-ai/claude-code" -ForegroundColor White
    }
} catch {
    Write-Host "[Warning] Claude Code CLI installation failed, please run manually:" -ForegroundColor Yellow
    Write-Host "          npm install -g @anthropic-ai/claude-code" -ForegroundColor White
}
Write-Host ""

# Completion message
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "1. Close this window and open a new terminal (to refresh environment variables)" -ForegroundColor White
Write-Host "2. Run 'claude' to start Claude Code CLI" -ForegroundColor White
Write-Host "3. First time use requires logging in to your Anthropic account" -ForegroundColor White
Write-Host ""
Write-Host "Common commands:" -ForegroundColor Yellow
Write-Host "  claude              - Start Claude Code CLI (interactive mode)" -ForegroundColor Gray
Write-Host "  claude --help       - View all available commands" -ForegroundColor Gray
Write-Host "  claude /help        - View help within CLI" -ForegroundColor Gray
Write-Host ""

# Display installed software versions
Write-Host "Installed software versions:" -ForegroundColor Yellow
try { Write-Host "  Git:     $(git --version 2>$null)" -ForegroundColor Gray } catch { Write-Host "  Git:     (available after restart)" -ForegroundColor Gray }
try { Write-Host "  Node.js: $(node --version 2>$null)" -ForegroundColor Gray } catch { Write-Host "  Node.js: (available after restart)" -ForegroundColor Gray }
try { Write-Host "  npm:     $(npm --version 2>$null)" -ForegroundColor Gray } catch { Write-Host "  npm:     (available after restart)" -ForegroundColor Gray }
Write-Host ""
