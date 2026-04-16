---
description: 部署前檢查清單 — 產生 API 文件、跑測試、檢查環境變數、生成部署摘要
argument-hint: "<環境：staging | production>"
---

# /deploy — 部署前檢查

你是一位 DevOps 工程師，要在部署前做完整的檢查與文件生成。

**⚠️ 這個 Command 不實際部署，只做檢查與準備工作。實際部署由 CI/CD 執行。**

---

## 流程

### Step 1 — 跑測試

```bash
npm test
```

- 若測試失敗 → **停止**，輸出失敗清單，要求修復
- 若測試通過 → 繼續

### Step 2 — Lint 與 Type Check

```bash
npm run lint
npx tsc --noEmit
```

- 任一失敗 → 停止

### Step 3 — 生成 API 文件

掃描 `src/api/` 下所有 routes，自動生成 `docs/api.md`：

```markdown
# API 文件

## POST /urls — 建立短網址

### Request
```json
{
  "long_url": "https://example.com/very/long/path"
}
```

### Response (201)
```json
{
  "data": {
    "short_code": "abc1234",
    "short_url": "https://short.io/abc1234",
    "created_at": "2026-04-16T10:00:00Z"
  }
}
```

### Errors
| Code | Meaning |
|---|---|
| 400 | Invalid URL format |
| 409 | Short code collision (retry) |
```

### Step 4 — 環境變數檢查

檢查 `.env.example` vs 目標環境的設定，確保：

- 所有 required 變數都有值
- 沒有 production 用 dev secrets
- **不要**把 `.env` 的實際內容輸出到 console

### Step 5 — 生成部署摘要

```markdown
## 🚀 部署摘要 — $ARGUMENTS 環境

### 變更摘要
- X 個 commit 自上次部署
- 主要變更：...

### 測試結果
- ✅ 單元測試：X/X 通過
- ✅ Lint：無錯誤
- ✅ Type Check：無錯誤

### 需要人工確認
- [ ] DB Migration 是否安全？
- [ ] Feature Flag 是否已開啟？
- [ ] Rollback 計畫是否完整？

### 下一步
1. 確認上述人工項目
2. 在 CI/CD 觸發部署到 $ARGUMENTS
3. 監控部署後 30 分鐘的錯誤率
```

---

## 禁止

- ❌ 實際執行 `docker push`、`kubectl apply`、`aws deploy` 等部署指令
- ❌ 修改 `.env` 檔案
- ❌ 提交未通過 lint / test 的版本

---

## 輸入

$ARGUMENTS
