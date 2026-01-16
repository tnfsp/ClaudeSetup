# Screenshot to Knowledge Skill

將截圖自動轉化為知識卡片的 Claude Code Skill。

## 安裝位置

```
~/.claude/skills/screenshot-to-knowledge/
├── skill.md              # Skill 主檔案
├── config.example.json   # 設定範例
└── README.md             # 本文件
```

## 快速開始

### 1. 在專案中建立設定檔

```bash
cp ~/.claude/skills/screenshot-to-knowledge/config.example.json ./screenshot-config.json
```

### 2. 修改設定

```json
{
  "input_path": "你的截圖資料夾路徑",
  "output_target": "heptabase",
  "tracking_file": "./processed.json"
}
```

### 3. 執行

```bash
/screenshot-to-knowledge
```

## 輸出目標

| 目標 | 說明 |
|------|------|
| `heptabase` | 使用 Heptabase MCP 寫入卡片和 Journal |
| `local` | 輸出為本地 Markdown 檔案 |

## 需求

- Claude Code CLI
- Heptabase MCP（如果輸出到 Heptabase）

## 版本

- v1.0 - 2026-01-15
