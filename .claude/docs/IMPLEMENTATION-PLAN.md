# 實作計畫 (Implementation Plan)

> 由 `/pm` 維護

---

## 專案資訊

- **專案名稱**: ClaudeSetup
- **PRD 版本**: v0.1
- **計畫建立日期**: 2026-01-13
- **最後更新**: 2026-01-13

---

## 階段規劃

### Phase 1: 專案結構建立
- [x] PRD 與 TECHSTACK 撰寫（由 /concept 完成）
- [ ] 建立 `configs/` 目錄結構
- [ ] 建立 `scripts/` 目錄
- [ ] 建立 `.env.example` 環境變數範本

### Phase 2: 設定檔收集
- [ ] 匯出 Claude Code 設定 (`~/.claude/`)
- [ ] 匯出 Windows Terminal 設定
- [ ] 匯出 MCP 設定（如有）
- [ ] 檢查並移除敏感資料

### Phase 3: 腳本開發
- [ ] 撰寫 `export.ps1`（從本機匯出設定到 repo）
- [ ] 撰寫 `install.ps1`（從 repo 部署設定到新電腦）
  - [ ] Claude Code 設定複製
  - [ ] Windows Terminal 設定複製
  - [ ] MCP 設定複製
  - [ ] 環境變數設定（提示輸入敏感資料）
- [ ] 腳本測試

### Phase 4: 文件與發布
- [ ] 撰寫 README.md（使用說明）
- [ ] 初始化 Git repository
- [ ] 推送到 GitHub
- [ ] 測試完整流程

---

## 任務詳情

### Task 2.1: 匯出 Claude Code 設定

**來源路徑**:
```
~/.claude/settings.json
~/.claude/commands/
```

**目標位置**:
```
configs/claude/settings.json
configs/claude/commands/
```

**注意事項**:
- 排除 `~/.claude/statsig/` 等快取目錄
- 排除任何包含敏感資料的檔案

### Task 2.2: 匯出 Windows Terminal 設定

**來源路徑**:
```
%LOCALAPPDATA%/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
```

**目標位置**:
```
configs/terminal/settings.json
```

### Task 2.3: 匯出 MCP 設定

**來源路徑**:
```
%APPDATA%/Claude/claude_desktop_config.json
```

**目標位置**:
```
configs/mcp/claude_desktop_config.json
```

**注意事項**:
- 檢查是否包含 API token
- 如有敏感資料，需要遮蔽或建立範本

### Task 3.1: export.ps1 功能

```powershell
# 主要功能
1. 檢查來源檔案是否存在
2. 建立目標目錄（如不存在）
3. 複製設定檔到 configs/
4. 顯示完成訊息
```

### Task 3.2: install.ps1 功能

```powershell
# 主要功能
1. 檢查必要檔案是否存在於 configs/
2. 備份現有設定（如有）
3. 複製設定檔到目標位置
4. 提示使用者輸入環境變數（ANTHROPIC_API_KEY 等）
5. 設定使用者層級環境變數
6. 顯示完成訊息與後續步驟
```

---

## Subagent 分配

此專案由 PM 直接執行，不需要額外 subagent。

| 角色 | 負責任務 | 狀態 |
|------|----------|------|
| `/pm` | 全部階段 | 執行中 |

---

## 進度追蹤

| 階段 | 狀態 | 完成度 |
|------|------|--------|
| Phase 1 | 完成 | 100% |
| Phase 2 | 完成 | 100% |
| Phase 3 | 完成 | 100% |
| Phase 4 | 進行中 | 50% |

---

## 風險與注意事項

| 風險 | 影響程度 | 對應策略 |
|------|----------|----------|
| MCP 設定含敏感資料 | 中 | 檢查並建立 sanitized 版本 |
| 路徑在不同 Windows 版本可能不同 | 低 | 在腳本中檢查多個可能路徑 |
| PowerShell 執行權限問題 | 低 | 在 README 說明如何調整執行原則 |

---

## 變更記錄

| 日期 | 變更內容 |
|------|----------|
| 2026-01-13 | 初版建立 |
