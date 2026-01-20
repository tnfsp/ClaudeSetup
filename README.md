# ClaudeSetup

跨平台的開發環境遷移工具，支援 **Windows** 與 **macOS**。

## 功能

- 同步 Claude Code 設定（`~/.claude/`）
- 同步 Windows Terminal / iTerm2 設定
- 同步全域 Slash Commands 與 Skills
- 統一環境變數管理（`.env.master`）
- 批次安裝日常 APP（Homebrew / Winget）

---

## 快速開始

### macOS (Mac mini / MacBook)

```bash
# 1. Clone repo
git clone https://github.com/tnfsp/ClaudeSetup.git
cd ClaudeSetup

# 2. 執行安裝（會自動安裝 Homebrew 和所有 APP）
chmod +x scripts/install.sh
./scripts/install.sh

# 3. 設定 MCP Servers（手動）
claude mcp add --transport http heptabase-mcp https://api.heptabase.com/mcp
claude mcp add -e GITHUB_TOKEN=$GITHUB_TOKEN github -- npx -y @modelcontextprotocol/server-github
```

### Windows

```powershell
# 1. Clone repo
git clone https://github.com/tnfsp/ClaudeSetup.git
cd ClaudeSetup

# 2. 執行安裝
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\scripts\install.ps1

# 3. 設定 MCP Servers（手動）
claude mcp add --transport http heptabase-mcp https://api.heptabase.com/mcp
claude mcp add -e GITHUB_TOKEN=你的_TOKEN github -- npx -y @modelcontextprotocol/server-github
```

---

## 環境變數管理

### 統一管理方式

所有專案的環境變數統一放在 `.env.master`，透過 shell profile 自動載入。

**macOS** (`~/.zshrc`):
```bash
set -a
source ~/Project/.env.master
set +a
```

**Windows** (PowerShell Profile):
```powershell
Get-Content "$env:USERPROFILE\Project\.env.master" | ForEach-Object {
    if ($_ -match '^([^#=]+)=(.*)$') {
        [Environment]::SetEnvironmentVariable($matches[1], $matches[2], 'Process')
    }
}
```

### .env.master 結構

```env
# AI APIs
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-proj-...

# Notion
NOTION_TOKEN=ntn_...
NOTION_WEBSITE_TOKEN=ntn_...
NOTION_BRAND_TOKEN=ntn_...

# Telegram Bots
TELEGRAM_BOT_TOKEN=...           # murmur broadcast
TELEGRAM_BOT_TOKEN_ALT=...       # 資訊流
TELEGRAM_BOT_TOKEN_NOUS=...      # nous

# ... 其他服務
```

---

## APP 安裝清單

### macOS (`apps/mac.txt`)

使用 Homebrew Cask 安裝，編輯 `apps/mac.txt` 自訂：

```txt
# 瀏覽器
google-chrome

# 生產力
heptabase
notion

# 開發工具
visual-studio-code
iterm2

# 媒體
rekordbox
```

### Windows (`apps/windows.txt`)

使用 Winget 安裝，編輯 `apps/windows.txt` 自訂：

```txt
Google.Chrome
Heptabase.Heptabase
Microsoft.VisualStudioCode
```

---

## 所有專案 Git Clone 指令

### 一鍵 Clone 全部（macOS）

```bash
# 建立專案目錄
mkdir -p ~/Project && cd ~/Project

# Clone 所有專案
./scripts/clone-all.sh
```

### 研究專案 (tnfsp-research)

```bash
git clone https://github.com/tnfsp-research/research-technical-transeptal-lvad-centrimag.git
git clone https://github.com/tnfsp-research/research-bentall-pseudoaneurysm.git
git clone https://github.com/tnfsp-research/research-ecpr-pci.git
git clone https://github.com/tnfsp-research/thesis-supervisor-phd.git
git clone https://github.com/tnfsp-research/research-tavi-explant.git
git clone https://github.com/tnfsp-research/research-tavi-dapt-vs-noac.git
git clone https://github.com/tnfsp-research/research-case-lv-pseudoaneurysm.git
git clone https://github.com/tnfsp-research/research-case-mac.git
git clone https://github.com/tnfsp-research/research-case-venovo.git
git clone https://github.com/tnfsp-research/research-case-lad-fistula-pa.git
```

### 主要專案 (tnfsp)

```bash
# 核心工具
git clone https://github.com/tnfsp/ClaudeSetup.git
git clone https://github.com/tnfsp/nous-digital-twin.git
git clone https://github.com/tnfsp/tool-optimize-dev-workflow.git

# 日常工具
git clone https://github.com/tnfsp/telegram-bot.git
git clone https://github.com/tnfsp/readwise_bot.git
git clone https://github.com/tnfsp/BroadcastChannel.git
git clone https://github.com/tnfsp/screenshot-to-knowledge.git
git clone https://github.com/tnfsp/heptabase-tools.git
git clone https://github.com/tnfsp/project-github-sync.git

# 網站/品牌
git clone https://github.com/tnfsp/new_website.git
git clone https://github.com/tnfsp/brand.git

# 學習
git clone https://github.com/tnfsp/coding-learning.git
git clone https://github.com/tnfsp/learning-dj.git
git clone https://github.com/tnfsp/cardiac-surgery-learning.git

# 醫療應用
git clone https://github.com/tnfsp/cardiac-echo.git
git clone https://github.com/tnfsp/claude-icu-simulator.git
git clone https://github.com/tnfsp/ICU-stimulator.git
git clone https://github.com/tnfsp/chatgpt-export-viewer.git
git clone https://github.com/tnfsp/presentation_HM3.git
git clone https://github.com/tnfsp/wealth-coach.git

# 想法/草稿
git clone https://github.com/tnfsp/idea-archive.git
```

---

## 目錄結構

```
ClaudeSetup/
├── apps/
│   ├── mac.txt              # macOS APP 安裝清單 (Homebrew)
│   └── windows.txt          # Windows APP 安裝清單 (Winget)
├── configs/
│   ├── claude/
│   │   ├── settings.json    # Claude Code 全域設定
│   │   ├── commands/        # 全域 slash commands
│   │   └── skills/          # 全域 skills
│   └── terminal/
│       └── settings.json    # Windows Terminal 設定
├── scripts/
│   ├── install.ps1          # Windows 安裝腳本
│   ├── install.sh           # macOS 安裝腳本
│   ├── export.ps1           # Windows 匯出腳本
│   └── export.sh            # macOS 匯出腳本
├── .env.example             # 環境變數範本
└── README.md
```

---

## 手動設定項目

| 項目 | 原因 | 設定方式 |
|------|------|----------|
| Heptabase MCP | OAuth 認證 | `claude mcp add --transport http heptabase-mcp https://api.heptabase.com/mcp` |
| GitHub MCP | 需要 Token | `claude mcp add -e GITHUB_TOKEN=xxx github -- npx -y @modelcontextprotocol/server-github` |
| .env.master | 敏感資料 | 手動從安全位置複製 |

---

## 遷移檢查清單

### Mac mini 遷移

- [ ] 安裝 Xcode Command Line Tools: `xcode-select --install`
- [ ] Clone ClaudeSetup 並執行 `./scripts/install.sh`
- [ ] 複製 `.env.master` 到 `~/Project/`
- [ ] Clone 所有專案
- [ ] 設定 MCP Servers
- [ ] 複製研究專案的 `/data/` 資料夾（手動）
- [ ] 複製財務助手的資料庫備份（手動）
- [ ] 執行各專案的 `npm install` 或 `pip install`

---

## 腳本參數

### install.sh (macOS)

| 參數 | 說明 |
|------|------|
| `--skip-apps` | 跳過 APP 安裝 |
| `--skip-env` | 跳過環境變數設定 |

### install.ps1 (Windows)

| 參數 | 說明 |
|------|------|
| `-SkipBackup` | 跳過備份現有設定 |
| `-SkipEnvSetup` | 跳過環境變數設定 |

---

## License

MIT
