# ClaudeSetup - Export Script
param([switch]$Force)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ConfigsDir = Join-Path $RepoRoot "configs"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ClaudeSetup - Export Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Claude Code settings
$src1 = Join-Path $env:USERPROFILE ".claude\settings.json"
$dst1 = Join-Path $ConfigsDir "claude\settings.json"

# Windows Terminal settings
$src2 = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$dst2 = Join-Path $ConfigsDir "terminal\settings.json"

# Export Claude Code settings
Write-Host "Processing: Claude Code settings.json" -ForegroundColor Yellow
if (Test-Path $src1) {
    $dir1 = Split-Path -Parent $dst1
    if (-not (Test-Path $dir1)) { New-Item -ItemType Directory -Path $dir1 -Force | Out-Null }
    if ((Test-Path $dst1) -and (-not $Force)) {
        Write-Host "  Target exists. Use -Force to overwrite." -ForegroundColor DarkYellow
    } else {
        Copy-Item -Path $src1 -Destination $dst1 -Force
        Write-Host "  Exported to: $dst1" -ForegroundColor Green
    }
} else {
    Write-Host "  Source not found, skipped." -ForegroundColor DarkGray
}
Write-Host ""

# Export Windows Terminal settings
Write-Host "Processing: Windows Terminal settings.json" -ForegroundColor Yellow
if (Test-Path $src2) {
    $dir2 = Split-Path -Parent $dst2
    if (-not (Test-Path $dir2)) { New-Item -ItemType Directory -Path $dir2 -Force | Out-Null }
    if ((Test-Path $dst2) -and (-not $Force)) {
        Write-Host "  Target exists. Use -Force to overwrite." -ForegroundColor DarkYellow
    } else {
        Copy-Item -Path $src2 -Destination $dst2 -Force
        Write-Host "  Exported to: $dst2" -ForegroundColor Green
    }
} else {
    Write-Host "  Source not found, skipped." -ForegroundColor DarkGray
}
Write-Host ""

# Export custom commands
$cmdSrc = Join-Path $env:USERPROFILE ".claude\commands"
$cmdDst = Join-Path $ConfigsDir "claude\commands"
Write-Host "Processing: Claude Code custom commands" -ForegroundColor Yellow
if (Test-Path $cmdSrc) {
    if (-not (Test-Path $cmdDst)) { New-Item -ItemType Directory -Path $cmdDst -Force | Out-Null }
    if ((Test-Path $cmdDst) -and (Get-ChildItem $cmdDst -ErrorAction SilentlyContinue) -and (-not $Force)) {
        Write-Host "  Target exists. Use -Force to overwrite." -ForegroundColor DarkYellow
    } else {
        Copy-Item -Path "$cmdSrc\*" -Destination $cmdDst -Recurse -Force
        Write-Host "  Exported to: $cmdDst" -ForegroundColor Green
    }
} else {
    Write-Host "  No custom commands found." -ForegroundColor DarkGray
}
Write-Host ""

# Export custom skills
$skillSrc = Join-Path $env:USERPROFILE ".claude\skills"
$skillDst = Join-Path $ConfigsDir "claude\skills"
Write-Host "Processing: Claude Code custom skills" -ForegroundColor Yellow
if (Test-Path $skillSrc) {
    if (-not (Test-Path $skillDst)) { New-Item -ItemType Directory -Path $skillDst -Force | Out-Null }
    if ((Test-Path $skillDst) -and (Get-ChildItem $skillDst -ErrorAction SilentlyContinue) -and (-not $Force)) {
        Write-Host "  Target exists. Use -Force to overwrite." -ForegroundColor DarkYellow
    } else {
        Copy-Item -Path "$skillSrc\*" -Destination $skillDst -Recurse -Force
        Write-Host "  Exported to: $skillDst" -ForegroundColor Green
    }
} else {
    Write-Host "  No custom skills found." -ForegroundColor DarkGray
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
