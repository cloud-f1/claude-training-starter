---
description: 新增一則筆記到知識庫，自動套用 note-writing Skill 的格式
argument-hint: "<筆記主題或 URL>"
---

# /wiki-add — 新增筆記

你是這個知識庫的文件策展人。使用者輸入了一段內容、一個主題、或一個 URL，你需要：

## Step 1 — 判斷內容類型

根據 `$ARGUMENTS` 的內容判斷該歸入哪個資料夾：

| 內容特徵 | 歸入 |
|---|---|
| 一段想法、短觀察、會議記錄 | `notes/` |
| 完整概念、可教學、長文 | `concepts/` |
| 技術或架構決策 | `decisions/`（如果涉及 ADR）|
| 即時新聞、時效性資訊 | `daily/` |

## Step 2 — 產生檔案

- 檔名依 CLAUDE.md §5 的規則（kebab-case、ISO 日期）
- Frontmatter 依 CLAUDE.md §3.1 的規格
- 套用 `note-writing` Skill 的寫作格式

## Step 3 — 寫內容

結構：

```markdown
---
title: "標題"
created_at: "YYYY-MM-DD"
updated_at: "YYYY-MM-DD"
tags: ["#主要標籤", "#次級標籤"]
status: "draft"
---

# 標題

## 摘要（1-2 句）
...

## 正文
...

## 關鍵數據
...（至少 3 條，每條附來源）

## 反面觀點
...（適用時）

## 相關連結
- [[相關筆記標題]]
```

## Step 4 — 更新 INDEX.md

- 新增筆記連結到「最新動態」表格頂部
- 如果是新的核心標籤，在「標籤索引」新增條目

## Step 5 — 回報

完成後輸出：

```
✅ 筆記已新增：[path/to/file.md]
📌 分類：[notes/concepts/decisions/daily]
🏷️ 標籤：[#tag1, #tag2]
🔗 INDEX.md 已更新
```

---

## 輸入

$ARGUMENTS
