# ClaudeSetup

一鍵部署 Claude Code 與 Windows Terminal 設定的同步工具。

## 功能

- 同步 Claude Code 設定（`~/.claude/settings.json`）
- 同步 Windows Terminal 設定
- 同步自訂 Slash Commands
- 設定環境變數（ANTHROPIC_API_KEY）

## 快速開始

### 在新電腦上安裝

1. Clone 這個 repo：
   ```powershell
   git clone https://github.com/YOUR_USERNAME/ClaudeSetup.git
   cd ClaudeSetup
   ```

2. 執行安裝腳本：
   ```powershell
   # 允許執行腳本（如果尚未設定）
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

   # 執行安裝
   .\scripts\install.ps1
   ```

3. 依提示輸入 API Key

4. 重新啟動 Windows Terminal

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

### 路徑調整

`settings.json` 中的 MCP server 路徑是硬編碼的，安裝後可能需要手動調整：

```json
{
  "mcpServers": {
    "example": {
      "cwd": "C:\\Users\\YOUR_USERNAME\\..."  // 需要改成你的路徑
    }
  }
}
```

### 安全性

- API Key 等敏感資料不會存入 Git
- 安裝時會提示輸入
- 請勿將 `.env` 檔案 commit 到 repo

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
