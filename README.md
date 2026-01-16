# ClaudeSetup

一鍵部署 Claude Code 與 Windows Terminal 設定的同步工具。

## 功能

- 同步 Claude Code 設定（`~/.claude/settings.json`）
- 同步 Windows Terminal 設定
- 同步全域 Slash Commands（`~/.claude/commands/`）
- 設定環境變數（ANTHROPIC_API_KEY）

## 快速開始

### 在新電腦上安裝

**Step 1**: Clone 並執行安裝腳本
```powershell
git clone https://github.com/tnfsp/ClaudeSetup.git
cd ClaudeSetup

# 允許執行腳本（如果尚未設定）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 執行安裝
.\scripts\install.ps1
```

**Step 2**: 設定 MCP Servers（需手動執行）

MCP servers 使用 OAuth 認證，無法自動化，需要手動添加：

```powershell
# Heptabase MCP（會彈出瀏覽器進行 OAuth 認證）
claude mcp add --transport http heptabase-mcp https://api.heptabase.com/mcp

# GitHub MCP（需要你的 GitHub Personal Access Token）
# 到 https://github.com/settings/tokens 建立 token
claude mcp add -e GITHUB_TOKEN=你的_TOKEN github -- npx -y @modelcontextprotocol/server-github
```

**Step 3**: 驗證設定
```powershell
claude mcp list
```

**Step 4**: 重新啟動 Windows Terminal

### 從現有電腦匯出設定

```powershell
.\scripts\export.ps1
```

使用 `-Force` 覆蓋現有檔案：
```powershell
.\scripts\export.ps1 -Force
```

## 目錄結構

```
ClaudeSetup/
├── configs/                    # 設定檔
│   ├── claude/                 # Claude Code 設定
│   │   ├── settings.json
│   │   └── commands/           # 自訂 slash commands
│   └── terminal/               # Windows Terminal 設定
│       └── settings.json
├── scripts/
│   ├── install.ps1             # 安裝腳本
│   └── export.ps1              # 匯出腳本
├── .env.example                # 環境變數範本
└── README.md
```

## 注意事項

### MCP Servers 說明

Claude Code 的 MCP servers 分為兩種：

1. **在 `settings.json` 裡的 stdio MCP**：會被 install.ps1 自動安裝
2. **用 `claude mcp add` 添加的 HTTP MCP**：需要手動設定（如 Heptabase）

HTTP MCP 使用 OAuth 認證，憑證存在 `~/.claude/.credentials.json`，這個檔案**不會**也**不應該**被同步（包含敏感 tokens）。

### 路徑調整

`settings.json` 中的 MCP server 路徑是硬編碼的，安裝後需要手動調整：

```json
{
  "mcpServers": {
    "example": {
      "cwd": "C:\\Users\\YOUR_USERNAME\\..."  // 改成你的路徑
    }
  }
}
```

### 安全性

- API Key、OAuth tokens 等敏感資料不會存入 Git
- 安裝時會提示輸入 ANTHROPIC_API_KEY
- MCP OAuth 認證需要在新電腦上重新進行
- 請勿將 `.env` 或 `.credentials.json` commit 到 repo

## 腳本參數

### install.ps1

| 參數 | 說明 |
|------|------|
| `-SkipBackup` | 跳過備份現有設定 |
| `-SkipEnvSetup` | 跳過環境變數設定 |

### export.ps1

| 參數 | 說明 |
|------|------|
| `-Force` | 強制覆蓋現有檔案 |

## 維護指令

### /update - 更新設定

執行 `/update` 可以重新收集目前電腦的設定，更新到 repo。

## 開發

此專案使用 Claude Code 的 Subagent 架構開發。

- `/concept` - 概念設計師
- `/pm` - 專案經理
- `/update` - 更新設定

## License

MIT
