# Screenshot to Knowledge

將截圖轉化為知識卡片的通用 Skill。

## 調用方式

```
/screenshot-to-knowledge [選項]
```

## 選項

| 選項 | 說明 | 預設值 |
|------|------|--------|
| `--path <路徑>` | 輸入資料夾 | 需指定或使用設定檔 |
| `--output <目標>` | 輸出目標（heptabase/local） | heptabase |
| `--limit <數量>` | 限制處理數量 | 無限制 |
| `--dry-run` | 只預覽不執行 | false |
| `--tracking <檔案>` | 追蹤檔位置 | ./processed.json |

## 使用範例

```bash
# 處理 iCloud 照片，輸出到 Heptabase
/screenshot-to-knowledge --path "D:/iCloud Photos/Photos" --output heptabase

# 只處理 5 張測試
/screenshot-to-knowledge --path "./screenshots" --limit 5

# 預覽會處理哪些檔案
/screenshot-to-knowledge --path "./screenshots" --dry-run
```

---

## 工作流程

### 1. 掃描照片
- 讀取指定資料夾中的 PNG/JPG/JPEG 檔案
- 比對追蹤檔，過濾已處理的照片

### 2. 逐張處理

#### a. 辨識類型
使用 Claude Vision 判斷：
- **知識截圖**：Threads、X、文章、書籍、YouTube、對話等 → 繼續處理
- **手術/醫學圖片**：詢問用戶是否處理
- **日常照片**：食物、風景、自拍等 → 略過

#### b. 擷取內容（知識截圖）
辨識：
- **來源**：作者帳號、書名、網站、頻道等
- **核心概念**：這張圖在講什麼
- **價值**：為什麼值得收藏
- **行動建議**：如果要實踐，可以怎麼做

#### c. 生成卡片

**Heptabase 輸出**：
```markdown
# [標題]

**來源**：[作者/平台/書名]
**類型**：[category]（如果專案有定義 categories）
**截圖**：[檔名]（[日期]）

[核心內容]

**可以試試**：[行動建議]
```

**本地 MD 輸出**：
存到 `./notes/[標題].md`

#### d. 收集行動建議
收集所有「可以試試」項目。

### 3. 彙整行動指南

**Heptabase**：呼叫 `append_to_journal()`
```markdown
## 截圖整理 - 行動指南

- [ ] [行動 1]（來源：[卡片標題]）
- [ ] [行動 2]（來源：[卡片標題]）
```

**本地**：存到 `./action-items.md`

### 4. 更新追蹤檔
將已處理的檔案路徑寫入追蹤檔。

### 5. 輸出摘要
回報：處理數量、卡片數量、略過數量。

---

## 來源辨識規則

| 截圖類型 | 辨識的來源 |
|----------|-----------|
| Threads/X | 作者帳號（@xxx）、發文日期 |
| 書籍 | 書名、作者、頁碼 |
| 網頁文章 | 網站名稱、作者、標題 |
| YouTube | 頻道名稱、影片標題 |
| 聊天記錄 | 平台、對話對象 |
| 無法辨識 | 標註「來源不明」 |

---

## 寫作原則

- **簡潔直接**：不廢話，重點先行
- **繁體中文**
- **避免 AI 感用語**
- **來源優先**：一定要標註原始作者/出處

---

## 設定檔（選用）

在專案根目錄建立 `screenshot-config.json`：

```json
{
  "input_path": "D:/iCloud Photos/Photos",
  "output_target": "heptabase",
  "tracking_file": "./processed.json",
  "skip_types": ["food", "selfie", "meme"]
}
```

有設定檔時，可以直接執行 `/screenshot-to-knowledge` 不帶參數。

### 進階：自定義分類（categories）

如果專案需要更細緻的分類，可以使用 `categories` 參數覆蓋預設的三分法：

```json
{
  "input_path": "D:/iCloud Photos",
  "output_target": "heptabase",
  "categories": {
    "article": { "action": "create_card", "description": "文章截圖" },
    "video": { "action": "create_card", "description": "YouTube/影片" },
    "tool": { "action": "create_card", "description": "工具/App" },
    "social": { "action": "create_card", "description": "Threads/X/社群" },
    "book": { "action": "create_card", "description": "書籍/閱讀" },
    "daily": { "action": "mark_only", "description": "日常照片，標記但不建卡" },
    "medical": { "action": "skip", "description": "醫學照片，直接略過" }
  }
}
```

**action 類型**：
| action | 說明 |
|--------|------|
| `create_card` | 建立 Heptabase 卡片 |
| `mark_only` | 只標記到追蹤檔，不建卡（可供其他流程使用）|
| `skip` | 直接略過，不處理也不標記 |

**當有 categories 時**：
1. 使用專案定義的分類規則（覆蓋預設三分法）
2. Claude Vision 判斷每張圖片屬於哪個 category
3. 根據該 category 的 action 決定處理方式
4. 卡片格式會加入 `**類型**：[category]` 欄位

---

## 注意事項

1. **不處理敏感圖片**：手術圖、醫療影像先詢問用戶
2. **相關截圖可合併**：同一篇文章的多張截圖合併成一張卡片
3. **保持彈性**：卡片格式根據內容調整
4. **錯誤處理**：MCP 失敗時告知用戶並繼續處理下一張
