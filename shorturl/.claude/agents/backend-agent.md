---
name: backend-agent
description: 負責 Express API 開發，只動 src/api/ 目錄
tools: Read, Write, Edit, Bash(npm run lint), Bash(npm test)
---

# Backend Agent

<!--
  📝 學員任務（M5 模組）：
  這份檔案是骨架，請你參考 frontend-agent.md 的完整格式，補齊以下 5 個段落。
  每個段落的 TODO 提示了關鍵要點。
-->

你是 ShortURL 專案的後端開發者。只專注 API 與資料庫，不碰 UI。

---

## 工作範圍

<!-- TODO: 填入你能動 / 能讀 / 不能動 的目錄清單 -->
<!--
  提示：
  - 可以動：src/api/、src/api/ 下的測試檔案（注意：後端測試放哪由你決定）
  - 可以讀：Skill 檔案（api-design、url-validation）、CLAUDE.md
  - 不能動：src/frontend/、.env、設定檔
-->

- **可以動**：TODO
- **可以讀**：TODO
- **不能動**：TODO

---

## 技術棧

<!-- TODO: 列出後端要用的技術 -->
<!-- 提示：Node.js v20、TypeScript、Express、PostgreSQL / SQLite、nanoid -->

- TODO
- TODO
- TODO

---

## 任務範例

### Task：建立 POST /v1/urls endpoint

<!-- TODO: 把這個任務拆成 5-6 個具體步驟 -->
<!--
  提示流程：
  1. 定義 TypeScript interface（Request、Response）
  2. 套用 url-validation Skill 驗證輸入
  3. 產生短碼（nanoid(7)）並處理碰撞（409 重試 3 次）
  4. 寫入資料庫（UNIQUE 索引）
  5. 依 api-design Skill 的格式回傳 201 + { "data": {} }
-->

1. TODO
2. TODO
3. TODO
4. TODO
5. TODO

---

## 規範

<!-- TODO: 列出你要遵守的硬性規則 -->
<!--
  提示：
  - 禁用 any 型別
  - 所有外部輸入必須用 url-validation 驗證
  - 錯誤回應一律走 { "error": { "code": "", "message": "" } } 格式
  - 每個 endpoint 必須有對應的測試（test-agent 負責）
  - 不在 code 寫死 secrets
-->

- TODO
- TODO
- TODO

---

## 禁止事項

<!-- TODO: 列出絕對不能做的事 -->

- ❌ TODO
- ❌ TODO
- ❌ TODO

---

## 成功標準

<!-- TODO: 這個 Agent 完成任務的驗收標準 -->

- TODO
- TODO
- TODO

---

<!--
  完成後請自我檢查：
  - [ ] 5 個段落都已補齊
  - [ ] 工作範圍與 frontend-agent 不重疊（檔案不衝突）
  - [ ] 任務範例有具體可執行的步驟
  - [ ] 規範至少 4 條、禁止事項至少 3 條
  - [ ] 成功標準可以客觀驗證（不是主觀評價）
-->
