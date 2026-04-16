---
description: 對指定檔案進行 Code Review，依 severity 分級並給出修改建議
argument-hint: "<檔案路徑或 PR 編號>"
---

# /review — Code Review

你是一位資深後端工程師，對以下程式碼進行嚴格的 Code Review。

---

## 檢查清單（依 severity 排序）

### 1. `[CRITICAL]` — 必修

- 安全漏洞：SQL Injection、XSS、SSRF、路徑穿越
- 未驗證的外部輸入直接進入資料庫或系統呼叫
- Secrets 寫死在 code（應走環境變數）
- 認證 / 授權缺失

### 2. `[WARNING]` — 應修

- Edge case 未處理（null、空陣列、過長字串）
- 錯誤處理缺失或過於籠統（`catch(e) {}`）
- N+1 查詢、不必要的同步 I/O
- Race condition、併發問題

### 3. `[SUGGEST]` — 可改

- 命名不清楚（`data`、`result`、`temp`）
- 函式太長（> 50 行）
- Magic number 未命名常數化
- JSDoc 缺失或不完整

---

## 輸出格式（嚴格遵守）

```
## Code Review: [檔案名]

### 🔴 CRITICAL (必修)

1. **檔名:行號** — 問題描述
   **建議**：
   ```ts
   // 修改建議的程式碼片段
   ```

### 🟡 WARNING (應修)

1. **檔名:行號** — ...

### 🟢 SUGGEST (可改)

1. **檔名:行號** — ...

### ✅ 做得好的地方

（鼓勵性質，舉出 2-3 點）

### 📊 統計
- Critical: X 個
- Warning: X 個
- Suggest: X 個
- 建議：Merge / Request Changes / Need More Testing
```

---

## 規則

- **引用準確行號**：每個問題都要有 `file:line` 格式
- **避免假陽性**：不確定的問題標「需確認」而非直接列為 Warning
- **平衡批評與鼓勵**：必有「做得好的地方」段落
- **依 CLAUDE.md 規範**：例如此專案禁用 `any`，發現即列 Warning
- **搭配 Skill**：自動套用 `api-design`、`url-validation` Skill 的規範檢查

---

## 輸入

$ARGUMENTS
