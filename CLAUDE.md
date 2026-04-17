# CLAUDE.md — Claude Training Starter Kit（維護者手冊）

> **這份檔案是給 Kit 維護者看的，不是給學員看的。**
> 學員請讀 [`README.md`](./README.md)。
>
> 任何 Agent 進入本 repo 請先讀完本檔再動任何檔案。

---

## 1. 專案身份

| 欄位 | 內容 |
|---|---|
| **專案名稱** | Claude Training Starter Kit |
| **專案類型** | 教學基礎設施（teaching infrastructure）— 不是 production code |
| **配套課程** | Claude AI Agent Team 工程師培訓 **v4.0** |
| **課綱來源** | `course-outline-two-level.md`（位於 content-asset-system 的 course-claude-ai-agent-system/ 父層）|
| **預期使用者** | 6 小時培訓的學員（一次性執行，完成後可 fork 做自己的專案）|
| **維護者** | Alex Hsieh｜Cloud Formula Digital Technology |
| **語言** | 繁體中文教材 + 英文程式碼 |

---

## 2. 本 Kit 的設計哲學

### 2.1 70/30 原則（硬性規則）

**70% 預填、30% 學員修改**。不可違反。

- **預填**：所有讓學員「能跑起來」的基礎設施（Commands、Skills、Agents、Hooks、settings.json）
- **修改**：學員的個人資訊、研究焦點、team 風格（目前每份 CLAUDE.md 內 ≤3 處 `[YOUR_*]` placeholder）

**為什麼不是 100% 預填？** 因為「完全空白」會卡住沒經驗的學員，「完全預填」則剝奪了第一次修改 CLAUDE.md 的肌肉記憶。3 個 placeholder 是 30 分鐘內可完成、又有實質學習意義的平衡點。

### 2.2 Asymmetric Projects

兩個專案**不是平行對照組**，而是教學側重不同：

| 專案 | 教學焦點 | 設計思維 |
|---|---|---|
| `tsmc-wiki/` | **Memory + Hook**（持久化、自動化）| 文件即系統，強調 Agent 的記憶與事件觸發 |
| `shorturl/` | **Command + MCP + Skill + Agent**（開發工作流）| 程式碼即產品，強調 Agent 分工與規範套用 |

不要在兩個專案之間複製貼上 Skill / Command / Agent — 它們是為不同教學目標設計的。

### 2.3 Skeleton 設計

`shorturl/.claude/agents/backend-agent.md` 與 `test-agent.md` **刻意不完整**，留給學員在 M5 模組完成。這是教學契約的一部分 — 修改 Kit 時不要擅自把它們補完。

---

## 3. Monorepo 結構

```
claude-training-starter/
├── CLAUDE.md             ← 本檔（維護者手冊）
├── README.md             ← 學員操作指引（使用者入口）
├── .gitignore
│
├── tsmc-wiki/            ← 專案 A
│   ├── CLAUDE.md         ← 子專案手冊（學員修改 2 處 placeholder）
│   ├── INDEX.md
│   ├── notes/ concepts/ decisions/ daily/
│   └── .claude/
│       ├── commands/ skills/ agents/ hooks/
│       └── settings.json
│
└── shorturl/             ← 專案 B
    ├── CLAUDE.md         ← 子專案手冊（學員修改 3 處 placeholder）
    ├── package.json tsconfig.json .env.example
    ├── src/api/ src/frontend/ src/__tests__/
    └── .claude/
        ├── commands/ skills/ agents/ hooks/
        └── settings.json
```

> ⚠️ **Skeleton 檔案（刻意不完整，見 §2.3）**：
> - `shorturl/.claude/agents/backend-agent.md`
> - `shorturl/.claude/agents/test-agent.md`
>
> 這兩個檔案是 M5 的學員產出，**Kit 維護者不得補完**。

### 3.1 三層 CLAUDE.md 各自的職責

| 位置 | 讀者 | 職責 |
|---|---|---|
| `course-claude-ai-agent-system/CLAUDE.md`（上游）| 課程教材庫的維護者 | 課綱版本治理、教材文件分工 |
| **本檔**（Kit 根）| Kit 維護者與貢獻者 | Kit 結構規範、版本同步、測試策略 |
| `*/CLAUDE.md`（子專案）| 學員 + 學員的 Agent | 子專案的規範、placeholder 位置 |

**不要跨層寫內容**。課綱細節寫在上游；Kit 維護規則寫這裡；學員規範寫子專案。

---

## 4. 版本同步策略（最重要的規則）

Kit 的版本號必須**追隨 `course-outline-two-level.md` 的版本**。

| 情境 | Kit 要做什麼 |
|---|---|
| 課綱 Patch（v4.0 → v4.1，小修）| Kit 同步小修，不一定發 tag |
| 課綱 Minor（v4.0 → v4.1 增加新模組）| Kit 新增對應檔案，tag `v4.1` |
| 課綱 Major（v4 → v5，重構）| Kit 必須同步重構，tag `v5.0`。**舊學員可留在 v4.x branch** |

### 4.1 新增子專案時必做檢查清單

- [ ] 設計 70/30 預填 / 修改點
- [ ] 子專案 CLAUDE.md 只含 ≤3 個 `[YOUR_*]` placeholder
- [ ] `.claude/` 結構完整：commands / skills / agents / hooks / settings.json
- [ ] Hooks 跨平台：採 `.js`（Node 自身跨平台，settings.json 直呼 `node`）**或** `.sh` + `.bat`（純 shell 腳本時才需雙版本）
- [ ] `README.md` 的「專案結構」與「模組對應」表格同步更新
- [ ] 本 CLAUDE.md §3 的結構圖同步更新

---

## 5. 測試策略

這是教學基礎設施，**不是跑單元測試就算完成**。真正的驗收是：「一位工程師能否在 6 小時內靠這份 Kit 完成課程」。

### 5.1 常用開發指令

`shorturl/` 是 Kit 內唯一有 build system 的子專案（tsmc-wiki 是純 Markdown，無 build / test）。

```bash
cd shorturl
npm install                           # 首次執行必跑

npm test                              # 全部測試（Jest）
npm test -- urls.test.ts              # 單一檔案
npm test -- --testNamePattern="POST"  # 依測試名稱過濾

npm run dev                           # ts-node-dev 開發伺服器（熱重載）
npm run build                         # tsc 輸出到 dist/
npm run lint                          # ESLint 檢查 src/**/*.ts
npm run format                        # Prettier 寫回
```

### 5.2 Maintainer Smoke Test（每次改動後必跑）

**靜態檢查（快、每次都跑）**：

```bash
./scripts/smoke-test.sh              # A 模式，~10 秒
./scripts/smoke-test.sh --full       # A + B：加 claude -p 行為驗證，~3-5 分鐘 + 耗 API
```

A 模式涵蓋：檔案結構、JSON parse、Hook 語法、Hook 單元測試（mock payload）、Skeleton 契約（§2.3）、70/30 placeholder 數量、frontmatter 齊全。B 模式加上 `npm test` 與 `claude -p "/project:wiki-add"` 的實際行為驗證。

**手動行為驗證（release 前跑一次）**：

```bash
# 1. Clone 乾淨環境
git clone . /tmp/kit-smoke && cd /tmp/kit-smoke

# 2. tsmc-wiki 側（無需 npm install — 純 Markdown 專案）
cd tsmc-wiki
claude
# 輸入：/project:wiki-add 測試一則筆記
# 預期：notes/ 新增一份檔案、INDEX.md 更新、Stop Hook 觸發 daily/*-session.md

# 3. shorturl 側（必須先 npm install）
cd ../shorturl
npm install                           # ← 缺這步下方指令會失敗
npm test                              # 確認骨架測試可跑
claude
# 輸入：幫我寫 POST /v1/urls 的骨架
# 預期：套用 api-design + url-validation Skill 的規範

# 4. 驗證 Hook 阻擋
# 在 shorturl 內輸入：請修改 .env 的 DATABASE_URL
# 預期：PreToolUse Hook 以 exit 2 阻擋
```

### 5.3 半年一次的 Learner Replay

找一位沒碰過 Claude Code 的工程師（或課程學員），讓他實際跑一次 M0–M6。卡住的點就是 Kit 的下一版 backlog。

---

## 6. 風格規範（維護者寫文件時）

### 6.1 CLAUDE.md（子專案）

- **字數上限**：≤ 150 行（超過表示規則太多，學員會跳過）
- **段落長度**：≤ 3 行
- **Placeholder**：≤ 3 個，且每個都要附 `<!-- 例：... -->` 註解
- **禁止**：寫 how-to 教學（那是 README.md 的事）

### 6.2 SKILL.md

- **單一職責**：一個 Skill 只處理一個能力範圍
- **場景觸發段**：必須列 3–5 個觸發關鍵字
- **禁止事項**：至少 3 條（負面列舉比正面描述更有效）
- **版本紀錄**：檔尾固定格式

### 6.3 Command（`.claude/commands/*.md`）

- Frontmatter 必備 `description` + `argument-hint`
- 指令主體採 Step 1..N 結構
- 輸出格式必須具體示範（不要只寫「用適當格式」）
- 末尾用 `$ARGUMENTS` 接收使用者輸入

### 6.4 Agent（`.claude/agents/*.md`）

- Frontmatter 必備 `name` + `description` + `tools`
- 必有「工作範圍（可動 / 可讀 / 不能動）」段落
- 必有「禁止事項」段落
- 多個並行 Agent 的檔案權限範圍**不能重疊**

---

## 7. 貢獻流程

### 7.1 修改流程

```
1. Fork / Branch (branch name: kit-{topic})
2. 修改前先跑 Smoke Test（§5.1）
3. 修改後再跑 Smoke Test
4. 更新下列檔案的版本紀錄：
   - 改動的 *.md 檔尾版本
   - 必要時 README.md 的結構圖
   - 必要時本 CLAUDE.md 的 §3
5. Commit：遵循 Conventional Commits（feat/fix/docs/refactor）
6. PR：描述「改了什麼」+「為什麼」+「Smoke Test 結果」
```

### 7.2 禁止事項

- ❌ 在 commit 納入 `.env`（即使是 example；`.env.example` 才是正確名稱）
- ❌ 修改 `daily/` 或 `notes/` 內的內容（那是學員的產出空間，`.gitignore` 已排除）
- ❌ 擅自把 `backend-agent.md` / `test-agent.md` 的 skeleton 補完（§2.3 教學契約）
- ❌ 把本 repo 當 production 專案開發（它是教學用）
- ❌ 不做 Smoke Test 就 merge

---

## 8. Agent 行為準則

進入本 repo 的 Claude Agent：

1. **先讀本檔，再讀對應子專案 CLAUDE.md**
2. **判斷任務歸屬**：是 Kit 維護（動 `.claude/`、README、本檔）還是學員任務（動 `notes/`、`src/`）？兩者行為準則不同
3. **任何改動前**：先檢查 §4 的版本同步策略
4. **結束前**：更新相關版本紀錄，提醒 Alex 是否需要跑 Smoke Test

---

## 9. 已知限制與 TODO

| 項目 | 狀態 | 備註 |
|---|---|---|
| Smoke Test 自動化腳本 | ✅ v1.3 | `scripts/smoke-test.sh`（A 靜態 + B `--full` 行為驗證）|
| Windows PowerShell Profile 範本 | ⏳ TODO | 課綱 Phase 2 提到 UTF-8 設定，目前靠講師現場協助 |
| Starter Kit 影片教學 | ⏳ TODO | 配合課程 M0 使用 |
| Remote repo | ⏳ 未建立 | 建議路徑 `cloud-f1/claude-training-starter` |

---

## 10. 相關資源

- **課程教材庫**：`../content-asset-system/assets/course-claude-ai-agent-system/`
  - `course-outline-two-level.md` v4.0 — 課綱唯一真相
  - `claude-code-deep-dive-teaching.md` v2.0 — 七層功能深度教材
  - `tsmc-research/` — 完整跑完的活教材（不是本 Kit 內的 tsmc-wiki）
- **Alex 的 ai-coding-template** — 進階延伸
- **Claude Code 官方文件**：<https://docs.claude.com/claude-code>

---

> **維護守則**：這份手冊是活的。發現規範與現實衝突時，用 `[LEARN]` 標註讓 Alex 決定是否更新。
>
> 文件版本：v1.3
> 對應課綱：course-outline-two-level.md v4.0
> 最後更新：2026-04-18
> 維護者：Alex Hsieh｜Cloud Formula Digital Technology
>
> **變更紀錄**
> - v1.3 (2026-04-18)：新增 `scripts/smoke-test.sh`（A 靜態 50 項檢查 + B `--full` 行為驗證）；§5.2 改為先跑腳本、再手動驗證的雙層策略；§9 移除對應 backlog
> - v1.2 (2026-04-18)：§4.1 修正 Hook 跨平台檢查規則（`.js` 或 `.sh`+`.bat` 二擇一）；刪除冗餘的 `tsmc-wiki/.claude/hooks/capture-session.bat`
> - v1.1 (2026-04-17)：§3 加入 skeleton 警告區、新增 §5.1 常用開發指令、§5.2 Smoke Test 明確化 `npm install` 步驟
> - v1.0 (2026-04-17)：初版
