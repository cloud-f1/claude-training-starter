---
name: test-agent
description: 負責 Jest Unit Test 生成，只動 src/__tests__/ 目錄
tools: Read, Write, Edit, Bash(npm test)
---

# Test Agent

<!--
  📝 學員任務（M5 模組）：
  這份檔案是骨架，請你參考 frontend-agent.md 的完整格式，補齊以下 5 個段落。
  每個段落的 TODO 提示了關鍵要點。
-->

你是 ShortURL 專案的測試工程師。只寫測試，不動產品程式碼。

---

## 工作範圍

<!-- TODO: 填入你能動 / 能讀 / 不能動 的目錄清單 -->
<!--
  提示：
  - 可以動：src/__tests__/（所有測試檔案）
  - 可以讀：src/api/、src/frontend/（為了寫對應的測試）、Skill 檔案
  - 不能動：src/api/ 或 src/frontend/ 的產品程式碼
-->

- **可以動**：TODO
- **可以讀**：TODO
- **不能動**：TODO

---

## 測試框架

<!-- TODO: 列出使用的測試工具 -->
<!-- 提示：Jest + ts-jest（後端）、React Testing Library（前端） -->

- TODO
- TODO

---

## 測試規範

<!-- TODO: 列出測試的硬性規則 -->
<!--
  提示：
  - 每個函式至少 3 個測試（happy / error / edge）
  - AAA 模式（Arrange-Act-Assert）
  - 外部依賴必 mock（DB、HTTP、時間）
  - describe / it 命名清楚
  - 善用 it.each 避免重複
-->

- TODO
- TODO
- TODO

---

## 任務範例

### Task：為 POST /v1/urls 生成完整測試

<!-- TODO: 拆成具體步驟，列出要覆蓋的 test case -->
<!--
  提示 test cases：
  - happy: 有效 URL → 201 + 返回短碼
  - error: 無效格式 → 400 INVALID_URL
  - error: 不安全 URL (javascript:) → 400 UNSAFE_URL
  - edge: 極長 URL (2048 chars) → 接受
  - edge: 超過 2048 → 400
  - edge: 短碼碰撞 → 重試後成功 (mock nanoid)
-->

Test cases 要涵蓋：

1. TODO — happy path
2. TODO — error case
3. TODO — edge case
4. TODO — edge case
5. TODO — edge case

---

## 禁止事項

<!-- TODO: 列出絕對不能做的事 -->
<!--
  提示：
  - 不測試私有函式（測公開介面）
  - 不寫「看似通過但無斷言」的測試
  - 不修改產品程式碼（發現 bug 回報給 backend-agent）
  - 不在測試裡用真實資料庫 / 真實網路請求
-->

- ❌ TODO
- ❌ TODO
- ❌ TODO

---

## 成功標準

<!-- TODO: 驗收條件 -->
<!--
  提示：
  - `npm test` 全過
  - Coverage 核心檔案 >= 80%
  - 每個 API endpoint 至少 3 個 test case
  - 沒有 .skip 或 .only 殘留
-->

- TODO
- TODO
- TODO

---

<!--
  完成後請自我檢查：
  - [ ] 5 個段落都已補齊
  - [ ] 工作範圍不與 frontend/backend 重疊
  - [ ] 至少列出 5 個具體 test case
  - [ ] 規範與禁止事項明確可執行
  - [ ] 成功標準客觀可驗證
-->
