# Session Log

> 每次 CLI 啟動時必讀此檔案，了解專案進度與待辦事項

---

## Session: 2025-12-14 初始化

### 變更摘要
- 建立專案模板框架
- 建立 CLAUDE.md 主要說明文件
- 建立 `/concept` subagent (概念設計師)
- 建立 `/pm` subagent (專案經理)
- 建立文件模板：PRD.md, TECHSTACK.md, IMPLEMENTATION-PLAN.md
- 建立 log 系統

### 決策記錄
- 採用 `.claude/` 目錄結構管理所有 Claude Code 相關檔案
- Subagent 使用 slash command 方式實作，放在 `.claude/commands/`
- Log 使用累積式 Markdown 格式，每次 session 新增一個區塊
- 工作流程：Concept 先行 → PM 接手規劃 → 動態建立其他 Subagent

### 待辦事項
- [ ] 使用此模板開始新專案時，執行 `/concept` 討論專案概念
- [ ] 更新 CLAUDE.md 中的 `[PROJECT_NAME]`
- [ ] 填寫 PRD.md
- [ ] 填寫 TECHSTACK.md
- [ ] 執行 `/pm` 建立實作計畫

---

## Session: 2026-01-13 21:45

### 變更摘要
- 完成 PRD.md 初版撰寫
- 完成 TECHSTACK.md 初版撰寫
- 更新 CLAUDE.md 專案名稱為 ClaudeSetup

### 決策記錄
- **專案定位**：單向部署工具，專注於新電腦設定，非雙向同步
- **同步方式**：Git + PowerShell 安裝腳本（簡單、無額外依賴）
- **敏感資料處理**：安裝時手動輸入，不存入 Git
- **技術選擇**：純 PowerShell，不引入 Python/Node.js 等額外依賴
- **目標平台**：Windows 優先，未來可擴展至 macOS/Linux

### 待辦事項
- [x] 討論專案概念
- [x] 撰寫 PRD.md
- [x] 撰寫 TECHSTACK.md
- [x] 更新 CLAUDE.md 專案名稱
- [ ] 執行 `/pm` 建立實作計畫
- [ ] 建立目錄結構（configs/, scripts/）
- [ ] 收集目前電腦的設定檔
- [ ] 撰寫 install.ps1 安裝腳本
- [ ] 撰寫 export.ps1 匯出腳本
- [ ] 初始化 Git repo 並推送

---

## Session: 2026-01-13 22:15 (PM 執行)

### 變更摘要
- 完成 IMPLEMENTATION-PLAN.md 撰寫
- 建立目錄結構：`configs/`, `scripts/`
- 收集並匯出設定檔：
  - Claude Code settings.json
  - Windows Terminal settings.json
- 撰寫 `scripts/export.ps1`（匯出腳本）
- 撰寫 `scripts/install.ps1`（安裝腳本）
- 建立 `.env.example`（環境變數範本）
- 更新 `README.md`（使用說明）
- 建立 `/update` subagent（更新設定用）

### 決策記錄
- MCP 設定直接存在 `settings.json` 內，不需要額外的 MCP 設定檔
- 路徑硬編碼問題：在 README 中說明需手動調整
- 新增 `/update` subagent 方便日後更新設定

### 待辦事項
- [x] 建立 IMPLEMENTATION-PLAN
- [x] 建立目錄結構
- [x] 收集設定檔
- [x] 撰寫 export.ps1
- [x] 撰寫 install.ps1
- [x] 建立 .env.example
- [x] 更新 README.md
- [x] 建立 /update subagent
- [x] 初始化 Git repo（已完成 commit）
- [x] 推送到 GitHub
- [ ] 在新電腦上測試完整流程

---

## Session: 2026-01-16 16:00

### 變更摘要
- 完善全域設定同步功能
- 新增 Skills 目錄同步（`~/.claude/skills/`）
- 匯出 6 個全域 Commands 到 `configs/claude/commands/`
- 匯出 1 個全域 Skill（screenshot-to-knowledge）到 `configs/claude/skills/`
- 更新 `export.ps1` 支援 skills 匯出
- 更新 `install.ps1` 支援 skills 安裝，並在結尾顯示 MCP 設定指引
- 更新 `README.md`：
  - 加入完整的新電腦部署流程
  - 加入所有專案 git clone 指令（25 個 repos）
  - 說明 MCP servers 的兩種類型（stdio vs HTTP OAuth）
  - 加入同步內容說明表格

### 決策記錄
- **MCP 設定無法自動化**：Heptabase MCP 使用 HTTP + OAuth 認證，憑證存在 `~/.claude/.credentials.json`，包含敏感 tokens，不應同步到 Git。需在新電腦手動執行 `claude mcp add` 重新認證。
- **全域設定分類**：
  - 自動同步：settings.json、commands/、skills/、Windows Terminal
  - 手動設定：MCP servers（OAuth）、ANTHROPIC_API_KEY、路徑調整
- **專案列表維護**：將所有 25 個專案的 git clone 指令列入 README，方便新電腦快速 clone

### 待辦事項
- [x] 匯出全域 commands
- [x] 匯出全域 skills
- [x] 更新 export.ps1 支援 skills
- [x] 更新 install.ps1 支援 skills
- [x] 更新 README 加入所有專案 git clone 指令
- [x] 說明 MCP 設定流程
- [x] 推送到 GitHub
- [ ] 在新電腦上測試完整流程

---

## Session: 2026-01-20 (Mac mini 遷移規劃)

### 變更摘要

#### ClaudeSetup 跨平台擴展
- 新增 `scripts/install.sh` - macOS 安裝腳本
- 新增 `scripts/export.sh` - macOS 匯出腳本
- 新增 `apps/mac.txt` - Homebrew APP 安裝清單
- 新增 `apps/windows.txt` - Winget APP 安裝清單
- 更新 `README.md` - 跨平台使用說明

#### APP 安裝清單（Homebrew）
- AI 工具：Claude Desktop, Claude Code CLI
- 開發工具：VS Code, iTerm2, Node.js, Python, Git, GitHub CLI
- 生產力：Heptabase, Notion, Anki, Quarto
- 通訊：Telegram, Discord
- 媒體：Rekordbox
- 系統：Raycast, Rectangle
- 遠端：VMware Horizon Client
- 手動下載：Typeless, Ivanti Secure Access

#### 專案盤點與整理
- 盤點 Project 資料夾：共 28 個專案（原以為 25 個）
- 清理 `0. Template` 暫存資料夾（56 個 tmpclaude-*）
- 清理 ClaudeSetup 暫存資料夾

#### 新建 GitHub Repo
| 專案 | Repo | 權限 |
|------|------|------|
| 研究_謝老闆 LV pseudoaneurysm | tnfsp-research/research-case-lv-pseudoaneurysm | Private |
| 研究_謝老闆 MAC | tnfsp-research/research-case-mac | Private |
| 研究_謝老闆 Venovo | tnfsp-research/research-case-venovo | Private |
| 研究_謝醫師 LAD fistula to PA | tnfsp-research/research-case-lad-fistula-pa | Private |
| idea-archive（7 個想法專案）| tnfsp/idea-archive | Private |
| 研究_Metaanalysis_refractory | tnfsp-research/research-metaanalysis-refractory | Private |
| 年度OP統計 | tnfsp/annual-op-statistics | Private |
| DATABASE | tnfsp/database-archive | Private |

#### 其他處理
- 刪除 tnfsp 下 4 個重複的舊 repo
- 研究專案 /data/ 資料夾確認已追蹤
- 財務助手更新 .gitignore 排除敏感資料

### 決策記錄

1. **跨平台支援**：擴展 ClaudeSetup 支援 macOS，使用 Homebrew 批次安裝
2. **環境變數統一管理**：
   - 所有專案共用 `~/Project/.env.master`
   - 透過 `~/.zshrc` 的 `source` 載入
   - 敏感資料不進 Git，需手動複製到新電腦（USB）
3. **研究專案分類**：
   - 研究相關 → tnfsp-research（Private）
   - 其他專案 → tnfsp
4. **敏感資料處理**：
   - 財務助手：.xlsx, .back, .sqlite 等檔案加入 .gitignore
   - 研究 /data/：確認為文獻篩選資料，可傳上 Private repo

### Mac mini 遷移清單

```bash
# 1. 準備（Windows）
# - 複製 .env.master 到 USB
# - 複製研究 /data/ 和財務備份到 USB（如需要）

# 2. Mac mini 到手後
xcode-select --install
git clone https://github.com/tnfsp/ClaudeSetup.git
cd ClaudeSetup
cp /Volumes/USB/.env.master ~/Project/
chmod +x scripts/install.sh
./scripts/install.sh
source ~/.zshrc

# 3. 設定 MCP
claude mcp add --transport http heptabase-mcp https://api.heptabase.com/mcp
claude mcp add -e GITHUB_TOKEN=$GITHUB_TOKEN github -- npx -y @modelcontextprotocol/server-github

# 4. Clone 所有專案（見 README）
```

### 待辦事項
- [ ] Mac mini 到手後測試完整遷移流程
- [ ] 確認所有專案在 Mac 上正常運作
- [ ] 測試 .env.master 環境變數載入

---

## Session: 2026-01-20 14:30 (Code Audit & Mac 模擬)

### 變更摘要

#### Code Audit 修復
- **Critical**: 修復 settings.json 硬編碼路徑 → 使用 `~/Project/nous` + 動態替換
- **Warning**: install.sh `set -a` → 明確 export 個別變數（避免洩漏）
- **Warning**: install.sh Homebrew 安裝加入網路錯誤處理
- **Warning**: setup.ps1 步驟編號修正 [Step 5/4] → [Step 5/5]
- **Warning**: export.ps1 -Force 一致性檢查
- **Warning**: .env.example API key 格式調整

#### Mac 模擬測試修復
- mac.txt 格式清理（移除 inline comments）
- 加入 Step 0 Pre-flight checks（.env.master、gh auth）
- 加入 `touch "$ZSHRC"` 確保新 Mac 可用
- 加入 Claude Code CLI npm 安裝
- 加入 nous 自動 clone + 依賴安裝
- 加入互動式 `gh auth login` 提示（clone 前檢查）
- 加入 Step 6 安裝驗證

#### .env.master 位置決策
- 統一使用 `~/Project/.env.master`（跟 Windows 一致）

### 決策記錄
- **nous MCP 路徑**: 使用 `~/Project/nous`，install.sh 動態替換為實際 `$HOME/Project/nous`
- **環境變數載入**: 只 export 特定變數（ANTHROPIC_API_KEY, GITHUB_TOKEN, OPENAI_API_KEY, SUPABASE_URL, SUPABASE_KEY），不用 `set -a` 全載入
- **.env.master 位置**: 統一放 `~/Project/.env.master`，新 Mac 需從 USB 複製到此位置

### 待辦事項
- [ ] Mac mini 到手後測試完整遷移流程
- [ ] Git commit 今日變更
- [ ] 執行 `/daily-summary` 日結

---

<!-- 新的 session 記錄請加在這裡 -->
