---
name: url-validation
description: URL 驗證與正規化規範 — 觸發於任何處理使用者輸入 URL 的場景
---

# url-validation Skill

## 1. 場景

當程式碼涉及**接受、解析、儲存、重新導向使用者提供的 URL** 時自動啟用。

**觸發關鍵字**：URL、網址、redirect、shortener、link、href

---

## 2. 能力範圍

### 2.1 格式驗證

**一律使用 `URL` 建構子**，不要用 regex 自己寫：

```typescript
function isValidUrl(input: string): boolean {
  try {
    const url = new URL(input);
    return ['http:', 'https:'].includes(url.protocol);
  } catch {
    return false;
  }
}
```

**為什麼不用 regex？**
- URL 規格極度複雜（RFC 3986），regex 永遠漏掉邊界 case
- `URL` 建構子是瀏覽器 / Node.js 原生實作，已處理所有邊界

### 2.2 安全檢查

拒絕以下 URL：

| 攻擊類型 | 範例 | 處理 |
|---|---|---|
| JavaScript injection | `javascript:alert(1)` | 401 拒絕 |
| File protocol | `file:///etc/passwd` | 401 拒絕 |
| Data URL | `data:text/html,<script>` | 401 拒絕 |
| SSRF（內網）| `http://169.254.169.254/` | 401 拒絕（檢查 IP 黑名單）|
| SSRF（localhost）| `http://localhost:22` | 401 拒絕（production 環境）|
| Open redirect | `https://trusted.com@evil.com` | 401 拒絕（檢查 username 部分）|

### 2.3 正規化

儲存前先正規化，避免同一網址有多種表示：

```typescript
function normalizeUrl(input: string): string {
  const url = new URL(input);

  // 1. 小寫 protocol 和 hostname
  url.protocol = url.protocol.toLowerCase();
  url.hostname = url.hostname.toLowerCase();

  // 2. 移除 trailing slash（根路徑除外）
  if (url.pathname !== '/' && url.pathname.endsWith('/')) {
    url.pathname = url.pathname.slice(0, -1);
  }

  // 3. 移除預設 port
  if ((url.protocol === 'http:' && url.port === '80') ||
      (url.protocol === 'https:' && url.port === '443')) {
    url.port = '';
  }

  // 4. 排序 query string
  url.searchParams.sort();

  return url.toString();
}
```

### 2.4 長度限制

- 長 URL：最多 2048 字元（主流瀏覽器上限）
- 短碼：固定 7 字元（nanoid 預設）

---

## 3. 輸出標準

所有 URL 處理函式必須：

1. **驗證輸入**：不合法 URL 拋 `InvalidUrlError`
2. **處理 http / https**：明確允許這兩個 protocol
3. **回傳統一錯誤結構**：使用 `api-design` Skill 的錯誤格式
4. **正規化後儲存**：避免重複建立短碼

---

## 4. 錯誤訊息範本

```json
{
  "error": {
    "code": "INVALID_URL",
    "message": "URL 格式不符，必須以 http:// 或 https:// 開頭",
    "field": "long_url"
  }
}
```

```json
{
  "error": {
    "code": "UNSAFE_URL",
    "message": "出於安全考量，此類型的 URL 不被允許",
    "field": "long_url"
  }
}
```

---

## 5. 範例對照

| 輸入 | 驗證結果 | 備註 |
|---|---|---|
| `https://example.com/path` | ✅ | 正常 |
| `http://example.com/` | ✅ | 正常（正規化後） |
| `example.com` | ❌ INVALID_URL | 無 protocol |
| `javascript:alert(1)` | ❌ UNSAFE_URL | XSS 風險 |
| `file:///etc/passwd` | ❌ UNSAFE_URL | 本地檔案存取 |
| `http://localhost:3000` | ❌ UNSAFE_URL | （production）SSRF |
| `https://a@b.com/` | ❌ UNSAFE_URL | Open redirect 模式 |

---

## 6. 禁止事項

- ❌ 用 regex 自己寫 URL 驗證
- ❌ 接受 `javascript:`、`file:`、`data:` 等非 http(s) protocol
- ❌ 不做 SSRF 檢查直接對內網發請求
- ❌ 回應錯誤時洩漏內部細節（stack trace、IP）

---

## 7. 版本紀錄

- v1.0（2026-04-16）— Starter Kit 完整版
