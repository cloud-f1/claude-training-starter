# CLAUDE.md — ShortURL 服務

> 這是 Claude 的入職手冊。每次進入這個專案，Claude 會先讀這份檔案。
> 📝 **學員任務**：修改下方標記為 `[YOUR_*]` 的三個地方。

---

## 1. 專案背景

ShortURL 是一個縮短網址的 REST API 服務：使用者丟長 URL 進來，回傳一個短碼，訪問短碼會 302 到原始 URL，同時記錄點擊數。

- **專案擁有者**：[YOUR_NAME]             <!-- 例：Alex Hsieh -->
- **部署目標環境**：[YOUR_ENV]            <!-- 例：AWS ECS / Fly.io / 自建 Docker -->
- **預期流量**：[YOUR_SCALE]              <!-- 例：日活 1 萬，峰值 100 QPS -->

---

## 2. 技術棧

- Runtime：Node.js v20
- Language：TypeScript 5.x
- Framework：Express.js + @types/express
- Database：PostgreSQL（生產）/ SQLite（開發）
- Testing：Jest + ts-jest
- 部署：Docker + GitHub Actions

---

## 3. 目錄結構

```
shorturl/
├── CLAUDE.md             ← 本檔
├── package.json
├── tsconfig.json
├── src/
│   ├── api/              ← Express routes、controllers
│   ├── frontend/         ← 最小 React UI（表單）
│   └── __tests__/        ← Jest Unit Test
└── .claude/
    ├── commands/         ← /review、/test、/deploy
    ├── skills/           ← api-design、url-validation
    ├── agents/           ← frontend、backend、test
    ├── hooks/            ← protect-files（保護 .env）
    └── settings.json
```

---

## 4. 開發規範

### 4.1 Commit

- Conventional Commits 格式：`feat:`、`fix:`、`docs:`、`test:`、`chore:`
- 不得直接推到 `main`，全部走 PR

### 4.2 程式碼

- 所有 API 必須有對應 Unit Test（涵蓋 happy / error / edge case）
- 函式必須有 JSDoc 型別註解
- **禁止使用 `any` 型別**，使用明確的 `interface` 或 `type`
- ESLint + Prettier，不寫進 CI 會被 PR Reviewer 擋下

### 4.3 API 規範

由 `.claude/skills/api-design/SKILL.md` 定義（自動套用）：

- 名詞複數命名：`/urls`，不用 `/getUrl`
- 統一回應格式：`{ "data": {}, "meta": {} }` / `{ "error": { "code": "", "message": "" } }`
- 短碼用 nanoid(7)，避免暴力枚舉

---

## 5. 目前進度

- [x] 基礎 CRUD API 骨架
- [ ] 點擊追蹤功能（M5 Agent Team 實作）
- [ ] 自訂短碼功能
- [ ] API 文件自動生成（/project:deploy 的產物）

---

## 6. Agent 分工（平行開發黃金守則）

各 Agent 負責**不重疊的目錄**，這是 M5 的硬性規則：

| Agent | 負責目錄 | 定義檔案 |
|---|---|---|
| `frontend-agent` | `src/frontend/` | `.claude/agents/frontend-agent.md` |
| `backend-agent` | `src/api/` | `.claude/agents/backend-agent.md` |
| `test-agent` | `src/__tests__/` | `.claude/agents/test-agent.md` |

**禁止**：兩個 Agent 同時修改同一個檔案 → 結果不可預測。

---

## 7. 禁止事項

- ❌ 直接修改 `.env`（PreToolUse Hook 會擋下）
- ❌ 使用 `any` 型別
- ❌ 提交無測試的 API endpoint
- ❌ 在 production 啟用 `console.log`
- ❌ Secrets 寫進 code（用環境變數）

---

## 8. 快速檢查清單（提 PR 前）

- [ ] 所有新 API 都有 Unit Test
- [ ] `npm run lint` 沒有錯誤
- [ ] `npm test` 全過
- [ ] Commit 訊息符合 Conventional Commits
- [ ] 沒有 `any` 型別

---

> 文件版本：v1.0（Starter Kit 預填版）
> 最後更新：2026-04-16
