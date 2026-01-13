# ClaudeSetup - Export Script
# 從本機匯出 Claude Code 與 Windows Terminal 設定到 repo

param(
    [switch]$Force  # 強制覆蓋現有檔案
)

$ErrorActionPreference = "Stop"

# 取得腳本所在目錄的父目錄（repo 根目錄）
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ConfigsDir = Join-Path $RepoRoot "configs"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ClaudeSetup - Export Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 定義來源與目標路徑
$Mappings = @(
    @{
        Name = "Claude Code settings.json"
        Source = Join-Path $env:USERPROFILE ".claude\settings.json"
        Target = Join-Path $ConfigsDir "claude\settings.json"
    },
    @{
        Name = "Windows Terminal settings.json"
        Source = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        Target = Join-Path $ConfigsDir "terminal\settings.json"
    }
)

# 匯出每個設定檔
foreach ($mapping in $Mappings) {
    Write-Host "Processing: $($mapping.Name)" -ForegroundColor Yellow

    if (Test-Path $mapping.Source) {
        # 確保目標目錄存在
        $targetDir = Split-Path -Parent $mapping.Target
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            Write-Host "  Created directory: $targetDir" -ForegroundColor Gray
        }

        # 檢查目標檔案是否已存在
        if ((Test-Path $mapping.Target) -and -not $Force) {
            Write-Host "  Target already exists. Use -Force to overwrite." -ForegroundColor DarkYellow
            Write-Host "  Skipped: $($mapping.Target)" -ForegroundColor DarkYellow
        } else {
            Copy-Item -Path $mapping.Source -Destination $mapping.Target -Force
            Write-Host "  Exported to: $($mapping.Target)" -ForegroundColor Green
        }
    } else {
        Write-Host "  Source not found: $($mapping.Source)" -ForegroundColor DarkGray
        Write-Host "  Skipped." -ForegroundColor DarkGray
    }
    Write-Host ""
}

# 匯出 Claude Code commands（如果存在）
$claudeCommandsSource = Join-Path $env:USERPROFILE ".claude\commands"
$claudeCommandsTarget = Join-Path $ConfigsDir "claude\commands"

Write-Host "Processing: Claude Code custom commands" -ForegroundColor Yellow
if (Test-Path $claudeCommandsSource) {
    if (-not (Test-Path $claudeCommandsTarget)) {
        New-Item -ItemType Directory -Path $claudeCommandsTarget -Force | Out-Null
    }
    Copy-Item -Path "$claudeCommandsSource\*" -Destination $claudeCommandsTarget -Recurse -Force
    Write-Host "  Exported to: $claudeCommandsTarget" -ForegroundColor Green
} else {
    Write-Host "  No custom commands found." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Export Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Review exported files in configs/" -ForegroundColor Gray
Write-Host "  2. Remove any sensitive data (API keys, tokens)" -ForegroundColor Gray
Write-Host "  3. Commit and push to Git" -ForegroundColor Gray
Write-Host ""
