# Claude Training Starter Kit

> 6 小時從零建立 AI Agent Team — 官方 Starter Kit
> 維護者：Alex Hsieh｜Cloud Formula Digital Technology
> 配套課程：Claude AI Agent Team 工程師培訓（v4.0）

---

## 這份 Kit 是什麼？

這是配合 6 小時培訓課程的「預填 70%」骨架。你不會從空白開始 — 大部分的檔案已經寫好，你只要**修改 3 個地方**就能跑起來。

整套 Kit 包含兩個專案：

| 專案 | 類型 | 你會學到 |
|---|---|---|
| `tsmc-wiki/` | 知識管理系統 | Memory + Hook（持久化、自動化） |
| `shorturl/` | REST API 服務 | Command + MCP + Skill + Agent（開發工作流） |

---

## 前置條件

### 必備

- [ ] Node.js v18 以上（`node --version` 確認）
- [ ] Git
- [ ] Claude 帳號（Pro 或 Max plan 建議）
- [ ] Claude Desktop 已安裝並登入（claude.ai/download）

### 建議

- [ ] Windows 用戶：Windows Terminal（Microsoft Store）或 WSL
- [ ] macOS / Linux 用戶：終端機能正常顯示繁體中文
- [ ] Claude Code CLI（Phase 2 才需要）：
  ```bash
  npm install -g @anthropic-ai/claude-code
  claude login
  claude --version
  ```

---

## 快速開始

### Step 1 — 取得 Starter Kit

```bash
git clone https://github.com/cloud-f1/claude-training-starter
cd claude-training-starter
```

### Step 2 — 選一個專案進入

```bash
# 專案 A：知識庫
cd tsmc-wiki

# 或 專案 B：API 服務
cd shorturl
```

### Step 3 — 修改 CLAUDE.md 的 placeholder

打開 `CLAUDE.md`，尋找 `[YOUR_*]` 標記，填入你自己的資訊：

- **`tsmc-wiki/CLAUDE.md`**：2 處（研究焦點、維護者）
- **`shorturl/CLAUDE.md`**：3 處（擁有者、部署環境、預期流量）

例（tsmc-wiki）：

```markdown
## 1. 專案背景
研究焦點：[YOUR_FOCUS_AREA]        ← 改這裡
維護者：[YOUR_NAME]                 ← 改這裡
```

### Step 4 — 啟動 Claude Code

```bash
claude
```

然後試試：

```
/project:wiki-add 今天讀了一篇臺積電技術白皮書
```

---

## 專案結構

```
claude-training-starter/
├── README.md                 ← 本檔
│
├── tsmc-wiki/                ← 專案 A：知識庫
│   ├── CLAUDE.md             ← 70% 填好，改 3 個 placeholder
│   ├── INDEX.md              ← 空白模板
│   ├── notes/                ← 日常筆記
│   ├── concepts/             ← 概念整理
│   ├── decisions/            ← 決策記錄（ADR）
│   ├── daily/                ← 每日情報
│   └── .claude/
│       ├── commands/         ← /wiki-add、/wiki-search
│       ├── skills/           ← note-writing
│       ├── agents/           ← research-agent、writer-agent
│       ├── hooks/            ← capture-session
│       └── settings.json
│
└── shorturl/                 ← 專案 B：API 服務
    ├── CLAUDE.md             ← 70% 填好
    ├── package.json
    ├── src/
    │   ├── api/              ← 後端（你會寫）
    │   ├── frontend/         ← 前端（你會寫）
    │   └── __tests__/        ← 測試（Agent 會寫）
    └── .claude/
        ├── commands/         ← /review、/test、/deploy
        ├── skills/           ← api-design、url-validation
        ├── agents/           ← frontend、backend(骨架)、test(骨架)
        ├── hooks/            ← protect-files
        └── settings.json
```

---

## 課程模組對應

| 模組 | 時長 | 你會動到的檔案 |
|---|---|---|
| **M3** Memory + Command | 50 min | `*/CLAUDE.md`、`*/.claude/commands/*` |
| **M4** MCP + Skill | 40 min | `*/.claude/skills/*/SKILL.md` |
| **M5** Agent + Hook | 50 min | `*/.claude/agents/*`、`*/.claude/hooks/*` |
| **M6** 整合收尾 | 40 min | 整合所有設定，跑完整流程 |

---

## Windows 特別說明

### 一鍵環境設定

Windows 學員第一次打開專案前，先跑：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\windows-setup.ps1
```

會處理：PowerShell 永久設為 UTF-8（避免繁中亂碼）、Git CRLF 與中文檔名設定（僅影響此 repo）。Idempotent — 重跑不會重覆寫入。

### Hook 腳本

本 Kit 同時提供兩版 Hook 腳本：

- `*.sh`（macOS / Linux）
- `*.bat`（Windows）

`.claude/settings.json` 預設使用 `.sh`，Windows 用戶請改成 `.bat`：

```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "capture-session.bat"   // Windows 改這行
      }]
    }]
  }
}
```

### 路徑分隔符號

所有設定檔路徑一律使用 `/`（正斜線），不要用 `\`。Windows Node.js 會自動處理。

### 常見卡點

詳見 `course-outline-two-level.md` 的「Windows 環境注意事項」段落。

---

## 學員帶走清單

完成 6 小時課程後，你會有：

- [x] 兩個專案各自一份修改完畢的 `CLAUDE.md`
- [x] 5 個以上可用的 Command（`/wiki-add`、`/wiki-search`、`/review`、`/test`、`/deploy`）
- [x] 2 個 Skill（`note-writing`、`api-design`）
- [x] 5 個 Agent 定義（research、writer、frontend、backend、test）
- [x] 2 個 Hook 實際運作（Stop Hook + PreToolUse Hook）
- [x] 完整跑過 7 層功能的肌肉記憶

---

## 課後延伸

- Alex 的 [`ai-coding-template`](https://github.com/cloud-f1/ai-coding-template) — Team 層級的標準化模板
- Claude Code 官方文件：<https://docs.claude.com/claude-code>
- `awesome-claude-code-toolkit`（社群資源彙整）

---

## License

MIT — 你可以自由 fork、修改、用在你自己的專案或 team。

---

> 文件版本：v1.0
> 最後更新：2026-04-16
> 維護者：Alex Hsieh｜Cloud Formula Digital Technology
