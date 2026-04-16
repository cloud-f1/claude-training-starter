---
name: api-design
description: REST API 設計規範 — 觸發於任何設計或審查 API endpoint 的場景
---

# api-design Skill

## 1. 場景

當任何任務涉及**設計、新增、修改、審查 REST API endpoint** 時自動啟用。

**觸發關鍵字**：API、endpoint、route、REST、POST、GET、PUT、DELETE、OpenAPI

---

## 2. 能力範圍

### 2.1 URL 規則

- **名詞複數命名**：`/urls`、`/users`、`/clicks`
- **禁止動詞**：❌ `/getUrl`、❌ `/createUser`（改用 `GET /urls/:id`、`POST /users`）
- **版本前綴**：`/v1/urls`（不強制但推薦）
- **階層**：`/urls/:code/clicks`（子資源）

### 2.2 HTTP 動詞

| 動詞 | 用途 | 冪等 |
|---|---|---|
| GET | 讀取 | ✅ |
| POST | 建立 | ❌ |
| PUT | 完整替換 | ✅ |
| PATCH | 部分更新 | ❌ |
| DELETE | 刪除 | ✅ |

### 2.3 Status Code

| Code | 場景 |
|---|---|
| 200 | 成功（GET、PUT、PATCH） |
| 201 | Created（POST 成功建立資源） |
| 204 | No Content（DELETE 成功） |
| 400 | 請求格式錯誤 / 驗證失敗 |
| 401 | 未認證 |
| 403 | 已認證但無權限 |
| 404 | 資源不存在 |
| 409 | 衝突（例：短碼重複） |
| 429 | Rate limit |
| 500 | 伺服器錯誤 |

### 2.4 回應格式

**成功**：

```json
{
  "data": {
    "short_code": "abc1234",
    "long_url": "https://...",
    "created_at": "2026-04-16T10:00:00Z"
  },
  "meta": {
    "request_id": "req_xxx"
  }
}
```

**錯誤**：

```json
{
  "error": {
    "code": "INVALID_URL",
    "message": "URL must start with http:// or https://",
    "field": "long_url"
  },
  "meta": {
    "request_id": "req_xxx"
  }
}
```

### 2.5 分頁

**Cursor-based 優先**：

```
GET /urls?cursor=eyJpZCI6MTIzfQ&limit=20

→ {
  "data": [...],
  "meta": {
    "next_cursor": "eyJpZCI6MTQzfQ",
    "has_more": true
  }
}
```

---

## 3. ShortURL 專案特定決策

- **短碼生成**：nanoid(7) — 64^7 ≈ 4.4 兆組合，避免暴力枚舉
- **點擊追蹤**：非同步寫入 click queue，**不阻塞** 302 redirect
- **短碼唯一性**：資料庫 UNIQUE 索引 + 409 重試機制
- **URL 驗證**：使用 `url-validation` Skill 定義的規則

---

## 4. 輸出標準

設計任何 API 時必須提供：

1. **完整 endpoint**：`POST /v1/urls`
2. **Request Schema**（JSON 範例 + 欄位說明）
3. **Response Schema**（成功 + 所有錯誤 case）
4. **Status Code 對照表**
5. **範例 curl 指令**
6. **TypeScript interface**（供 frontend 引用）

---

## 5. 禁止事項

- ❌ 動詞命名 endpoint
- ❌ GET 請求帶 body
- ❌ 500 錯誤洩漏 stack trace 給使用者
- ❌ 成功回應不使用 `{ "data": {} }` 包裝
- ❌ 錯誤回應不使用 `{ "error": {} }` 結構
- ❌ 硬編碼敏感資訊到 URL（token 走 header）

---

## 6. 版本紀錄

- v1.0（2026-04-16）— Starter Kit 完整版
