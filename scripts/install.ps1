# ClaudeSetup - Install Script
param([switch]$SkipBackup, [switch]$SkipEnvSetup)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ConfigsDir = Join-Path $RepoRoot "configs"
$BackupDir = Join-Path $RepoRoot "backups\$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ClaudeSetup - Install Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Claude Code settings
$src1 = Join-Path $ConfigsDir "claude\settings.json"
$dst1 = Join-Path $env:USERPROFILE ".claude\settings.json"

# Windows Terminal settings
$src2 = Join-Path $ConfigsDir "terminal\settings.json"
$dst2 = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Install Claude Code settings
Write-Host "Processing: Claude Code settings.json" -ForegroundColor Yellow
if (Test-Path $src1) {
    $dir1 = Split-Path -Parent $dst1
    if (-not (Test-Path $dir1)) { New-Item -ItemType Directory -Path $dir1 -Force | Out-Null }
    if ((Test-Path $dst1) -and (-not $SkipBackup)) {
        if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }
        Copy-Item -Path $dst1 -Destination (Join-Path $BackupDir "settings.json") -Force
        Write-Host "  Backed up existing file" -ForegroundColor DarkGray
    }
    Copy-Item -Path $src1 -Destination $dst1 -Force
    Write-Host "  Installed to: $dst1" -ForegroundColor Green
} else {
    Write-Host "  Source not found, skipped." -ForegroundColor Red
}
Write-Host ""

# Install Windows Terminal settings
Write-Host "Processing: Windows Terminal settings.json" -ForegroundColor Yellow
if (Test-Path $src2) {
    $dir2 = Split-Path -Parent $dst2
    if (-not (Test-Path $dir2)) {
        Write-Host "  Windows Terminal not installed, skipped." -ForegroundColor DarkYellow
    } else {
        if ((Test-Path $dst2) -and (-not $SkipBackup)) {
            if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }
            Copy-Item -Path $dst2 -Destination (Join-Path $BackupDir "terminal-settings.json") -Force
            Write-Host "  Backed up existing file" -ForegroundColor DarkGray
        }
        Copy-Item -Path $src2 -Destination $dst2 -Force
        Write-Host "  Installed to: $dst2" -ForegroundColor Green
    }
} else {
    Write-Host "  Source not found, skipped." -ForegroundColor Red
}
Write-Host ""

# Custom commands
$cmdSrc = Join-Path $ConfigsDir "claude\commands"
$cmdDst = Join-Path $env:USERPROFILE ".claude\commands"
Write-Host "Processing: Claude Code custom commands" -ForegroundColor Yellow
if (Test-Path $cmdSrc) {
    if (-not (Test-Path $cmdDst)) { New-Item -ItemType Directory -Path $cmdDst -Force | Out-Null }
    Copy-Item -Path "$cmdSrc\*" -Destination $cmdDst -Recurse -Force
    Write-Host "  Installed to: $cmdDst" -ForegroundColor Green
} else {
    Write-Host "  No custom commands found." -ForegroundColor DarkGray
}
Write-Host ""

# Custom skills
$skillSrc = Join-Path $ConfigsDir "claude\skills"
$skillDst = Join-Path $env:USERPROFILE ".claude\skills"
Write-Host "Processing: Claude Code custom skills" -ForegroundColor Yellow
if (Test-Path $skillSrc) {
    if (-not (Test-Path $skillDst)) { New-Item -ItemType Directory -Path $skillDst -Force | Out-Null }
    Copy-Item -Path "$skillSrc\*" -Destination $skillDst -Recurse -Force
    Write-Host "  Installed to: $skillDst" -ForegroundColor Green
} else {
    Write-Host "  No custom skills found." -ForegroundColor DarkGray
}
Write-Host ""

# Environment variables
if (-not $SkipEnvSetup) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Environment Variables Setup" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    $key = [Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY", "User")
    if ($key) {
        Write-Host "ANTHROPIC_API_KEY is already set." -ForegroundColor Green
    } else {
        Write-Host "ANTHROPIC_API_KEY is not set." -ForegroundColor Yellow
        $newKey = Read-Host "Enter your ANTHROPIC_API_KEY (or press Enter to skip)"
        if ($newKey) {
            [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $newKey, "User")
            Write-Host "ANTHROPIC_API_KEY set successfully." -ForegroundColor Green
        }
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor White
Write-Host "  1. Restart Windows Terminal" -ForegroundColor Gray
Write-Host "  2. Check mcpServers paths in ~/.claude/settings.json" -ForegroundColor Gray
Write-Host "  3. Setup MCP Servers (requires manual auth):" -ForegroundColor Gray
Write-Host ""
Write-Host "     # Heptabase MCP" -ForegroundColor DarkCyan
Write-Host "     claude mcp add --transport http heptabase-mcp https://api.heptabase.com/mcp" -ForegroundColor White
Write-Host ""
Write-Host "     # GitHub MCP" -ForegroundColor DarkCyan
Write-Host "     claude mcp add -e GITHUB_TOKEN=YOUR_TOKEN github -- npx -y @modelcontextprotocol/server-github" -ForegroundColor White
Write-Host ""
Write-Host "  4. Verify: claude mcp list" -ForegroundColor Gray
Write-Host ""
