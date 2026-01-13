# ClaudeSetup - Install Script
# 在新電腦上部署 Claude Code 與 Windows Terminal 設定

param(
    [switch]$SkipBackup,      # 跳過備份現有設定
    [switch]$SkipEnvSetup     # 跳過環境變數設定
)

$ErrorActionPreference = "Stop"

# 取得腳本所在目錄的父目錄（repo 根目錄）
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ConfigsDir = Join-Path $RepoRoot "configs"
$BackupDir = Join-Path $RepoRoot "backups\$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ClaudeSetup - Install Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 定義來源與目標路徑
$Mappings = @(
    @{
        Name = "Claude Code settings.json"
        Source = Join-Path $ConfigsDir "claude\settings.json"
        Target = Join-Path $env:USERPROFILE ".claude\settings.json"
    },
    @{
        Name = "Windows Terminal settings.json"
        Source = Join-Path $ConfigsDir "terminal\settings.json"
        Target = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    }
)

# 部署每個設定檔
foreach ($mapping in $Mappings) {
    Write-Host "Processing: $($mapping.Name)" -ForegroundColor Yellow

    if (-not (Test-Path $mapping.Source)) {
        Write-Host "  Source not found: $($mapping.Source)" -ForegroundColor Red
        Write-Host "  Skipped." -ForegroundColor Red
        Write-Host ""
        continue
    }

    # 確保目標目錄存在
    $targetDir = Split-Path -Parent $mapping.Target
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "  Created directory: $targetDir" -ForegroundColor Gray
    }

    # 備份現有設定（如果存在）
    if ((Test-Path $mapping.Target) -and -not $SkipBackup) {
        if (-not (Test-Path $BackupDir)) {
            New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
        }
        $backupPath = Join-Path $BackupDir (Split-Path -Leaf $mapping.Target)
        Copy-Item -Path $mapping.Target -Destination $backupPath -Force
        Write-Host "  Backed up to: $backupPath" -ForegroundColor DarkGray
    }

    # 複製設定檔
    Copy-Item -Path $mapping.Source -Destination $mapping.Target -Force
    Write-Host "  Installed to: $($mapping.Target)" -ForegroundColor Green
    Write-Host ""
}

# 部署 Claude Code custom commands（如果存在）
$claudeCommandsSource = Join-Path $ConfigsDir "claude\commands"
$claudeCommandsTarget = Join-Path $env:USERPROFILE ".claude\commands"

Write-Host "Processing: Claude Code custom commands" -ForegroundColor Yellow
if (Test-Path $claudeCommandsSource) {
    if (-not (Test-Path $claudeCommandsTarget)) {
        New-Item -ItemType Directory -Path $claudeCommandsTarget -Force | Out-Null
    }
    Copy-Item -Path "$claudeCommandsSource\*" -Destination $claudeCommandsTarget -Recurse -Force
    Write-Host "  Installed to: $claudeCommandsTarget" -ForegroundColor Green
} else {
    Write-Host "  No custom commands to install." -ForegroundColor DarkGray
}
Write-Host ""

# 環境變數設定
if (-not $SkipEnvSetup) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Environment Variables Setup" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    # 檢查 ANTHROPIC_API_KEY
    $existingKey = [Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY", "User")
    if ($existingKey) {
        Write-Host "ANTHROPIC_API_KEY is already set." -ForegroundColor Green
        $updateKey = Read-Host "Do you want to update it? (y/N)"
        if ($updateKey -ne 'y' -and $updateKey -ne 'Y') {
            Write-Host "Keeping existing API key." -ForegroundColor Gray
        } else {
            $newKey = Read-Host "Enter your ANTHROPIC_API_KEY"
            if ($newKey) {
                [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $newKey, "User")
                Write-Host "ANTHROPIC_API_KEY updated." -ForegroundColor Green
            }
        }
    } else {
        Write-Host "ANTHROPIC_API_KEY is not set." -ForegroundColor Yellow
        $newKey = Read-Host "Enter your ANTHROPIC_API_KEY (or press Enter to skip)"
        if ($newKey) {
            [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $newKey, "User")
            Write-Host "ANTHROPIC_API_KEY set successfully." -ForegroundColor Green
        } else {
            Write-Host "Skipped ANTHROPIC_API_KEY setup." -ForegroundColor DarkGray
        }
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Notes:" -ForegroundColor White
Write-Host "  - You may need to restart Windows Terminal for changes to take effect." -ForegroundColor Gray
Write-Host "  - Claude Code settings.json may contain paths that need adjustment." -ForegroundColor Gray
Write-Host "    Check mcpServers paths in ~/.claude/settings.json" -ForegroundColor Gray
if (-not $SkipBackup -and (Test-Path $BackupDir)) {
    Write-Host "  - Original settings backed up to: $BackupDir" -ForegroundColor Gray
}
Write-Host ""
