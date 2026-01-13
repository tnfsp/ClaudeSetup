# ClaudeSetup - 產品需求文件 (PRD)

> 由 `/concept` 維護

---

## 專案概述

### 專案目標

建立一套可攜式的設定同步方案，讓使用者在新電腦上能夠**一鍵部署** Claude Code 與 Windows Terminal 的完整開發環境設定。

### 核心價值

- **零痛感遷移**：新電腦 clone repo → 執行腳本 → 立即擁有熟悉的開發環境
- **版本控制**：設定檔透過 Git 管理，可追蹤變更歷史
- **單一真相來源**：所有設定集中管理，避免多台電腦設定不一致

---

## 目標用戶

### 用戶畫像

- 使用 Claude Code CLI 進行開發的工程師
- 擁有多台 Windows 電腦（公司/家用/筆電）
- 希望在不同電腦間保持一致的開發體驗

### 使用場景

1. **新電腦設定**：購入新電腦後，快速部署熟悉的 Claude Code 環境
2. **重灌系統後**：系統重灌後快速恢復開發環境
3. **設定備份**：將目前的設定備份到 Git，防止遺失

---

## 功能需求

### 核心功能 (MVP)

- [x] Git 儲存庫結構設計
- [ ] **設定檔收集**：匯出目前電腦的 Claude Code / Terminal 設定
- [ ] **一鍵安裝腳本** (`install.ps1`)：
  - 複製 Claude Code 設定到 `~/.claude/`
  - 複製 Windows Terminal 設定到正確位置
  - 設定環境變數
  - 提示使用者輸入敏感資料（API Key 等）
- [ ] **MCP 設定部署**：複製 MCP server 設定檔
- [ ] **環境變數設定**：設定必要的環境變數

### 次要功能

- [ ] **匯出腳本** (`export.ps1`)：從目前電腦匯出設定到 repo
- [ ] **驗證腳本**：安裝後驗證設定是否正確
- [ ] **差異比較**：比較本機設定與 repo 設定的差異

### 未來考慮

- Linux/macOS 支援（`install.sh`）
- 選擇性安裝（只安裝部分設定）
- GUI 安裝介面

---

## 非功能需求

### 安全要求

- **敏感資料不進 Git**：API Key、Token 等敏感資訊不可存入 repo
- **範本檔案**：提供 `.env.example` 讓使用者知道需要設定哪些變數
- **安裝時提示輸入**：敏感資料在執行安裝腳本時由使用者手動輸入

### 相容性

- Windows 10/11
- PowerShell 5.1+ 或 PowerShell Core 7+
- Claude Code CLI（最新版本）

---

## 要同步的設定清單

### Claude Code 相關

| 路徑 | 說明 | 敏感 |
|------|------|------|
| `~/.claude/settings.json` | Claude Code 全域設定 | 否 |
| `~/.claude/commands/` | 使用者自訂 slash commands | 否 |
| `%APPDATA%/Claude/claude_desktop_config.json` | MCP server 設定 | 可能* |

*MCP 設定可能包含 token，需檢查

### Windows Terminal

| 路徑 | 說明 |
|------|------|
| `%LOCALAPPDATA%/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json` | Terminal 設定 |

### 環境變數

| 變數名稱 | 說明 | 敏感 |
|----------|------|------|
| `ANTHROPIC_API_KEY` | Anthropic API 金鑰 | 是 |
| （待補充） | 其他需要的環境變數 | - |

---

## Subagent 設計

此專案較為簡單，主要由 `/concept` 和 `/pm` 處理即可。

| Subagent | 職責 | 建立狀態 |
|----------|------|----------|
| `/concept` | 需求分析、文件撰寫 | ✓ 已存在 |
| `/pm` | 實作計畫、腳本開發 | ✓ 已存在 |

---

## 目錄結構設計

```
ClaudeSetup/
├── .claude/                    # Claude Code 專案設定（本 repo 用）
│   ├── commands/
│   ├── docs/
│   └── logs/
├── configs/                    # 要同步的設定檔
│   ├── claude/                 # ~/.claude/ 內容
│   │   ├── settings.json
│   │   └── commands/           # 自訂 slash commands
│   ├── mcp/                    # MCP 設定
│   │   └── claude_desktop_config.json
│   └── terminal/               # Windows Terminal 設定
│       └── settings.json
├── scripts/
│   ├── install.ps1             # 主安裝腳本
│   └── export.ps1              # 匯出目前設定
├── .env.example                # 環境變數範本
├── CLAUDE.md                   # Claude Code 說明
└── README.md                   # 人類閱讀說明
```

---

## 變更記錄

| 日期 | 版本 | 變更內容 |
|------|------|----------|
| 2026-01-13 | v0.1 | 初版建立 |
