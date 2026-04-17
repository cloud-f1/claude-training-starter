#!/usr/bin/env bash
# scripts/smoke-test.sh — Kit 維護者 Smoke Test
#
# 用法：
#   ./scripts/smoke-test.sh            # A 模式（預設）：純靜態 + Hook 單元測試，~15 秒
#   ./scripts/smoke-test.sh --full     # A + B：加上 claude -p 行為驗證，~3-5 分鐘（耗 API 配額）
#   ./scripts/smoke-test.sh --help
#
# A 模式涵蓋：
#   1. 必要檔案存在
#   2. JSON 檔 parse 成功
#   3. Hook 腳本語法正確
#   4. Hook 單元測試（mock JSON → exit 2）
#   5. §2.3 Skeleton 契約未被違反
#   6. 70/30 Placeholder 數量正確
#   7. .claude/* Markdown frontmatter 基本欄位齊全
#
# B 模式（--full）額外涵蓋：
#   8. claude CLI 存在
#   9. shorturl npm install + test 通過
#  10. tsmc-wiki /project:wiki-add 真的產生 notes/*.md

set -u

MODE="static"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --full) MODE="full"; shift ;;
    --help|-h)
      sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) echo "未知參數：$1"; exit 2 ;;
  esac
done

cd "$(dirname "$0")/.."

PASS=0; FAIL=0; SKIP=0
FAILED_ITEMS=()

check() {
  local label="$1"; local rc="$2"; local detail="${3:-}"
  if [[ "$rc" -eq 0 ]]; then
    printf '  \033[32m✓\033[0m %s\n' "$label"; PASS=$((PASS + 1))
  else
    printf '  \033[31m✗\033[0m %s' "$label"
    [[ -n "$detail" ]] && printf ' \033[90m— %s\033[0m' "$detail"
    printf '\n'
    FAIL=$((FAIL + 1)); FAILED_ITEMS+=("$label")
  fi
}
skip() { printf '  \033[33m~\033[0m %s \033[90m— %s\033[0m\n' "$1" "$2"; SKIP=$((SKIP + 1)); }

json_valid() { node -e "JSON.parse(require('fs').readFileSync('$1','utf8'))" 2>/dev/null; }
file_contains() { grep -qF "$2" "$1" 2>/dev/null; }
file_lacks() { ! grep -qF "$2" "$1" 2>/dev/null; }
count_matches() { grep -oE "$2" "$1" 2>/dev/null | wc -l | tr -d ' '; }

# ── A1: 必要檔案 ─────────────────────────────────────
echo "▸ 檔案結構"
for f in \
  CLAUDE.md README.md .gitignore \
  tsmc-wiki/CLAUDE.md tsmc-wiki/INDEX.md \
  tsmc-wiki/.claude/settings.json \
  tsmc-wiki/.claude/commands/wiki-add.md \
  tsmc-wiki/.claude/commands/wiki-search.md \
  tsmc-wiki/.claude/skills/note-writing/SKILL.md \
  tsmc-wiki/.claude/agents/research-agent.md \
  tsmc-wiki/.claude/agents/writer-agent.md \
  tsmc-wiki/.claude/hooks/capture-session.js \
  shorturl/CLAUDE.md shorturl/package.json shorturl/tsconfig.json shorturl/.env.example \
  shorturl/.claude/settings.json \
  shorturl/.claude/commands/review.md \
  shorturl/.claude/commands/test.md \
  shorturl/.claude/commands/deploy.md \
  shorturl/.claude/skills/api-design/SKILL.md \
  shorturl/.claude/skills/url-validation/SKILL.md \
  shorturl/.claude/agents/frontend-agent.md \
  shorturl/.claude/agents/backend-agent.md \
  shorturl/.claude/agents/test-agent.md \
  shorturl/.claude/hooks/protect-files.sh \
  shorturl/.claude/hooks/protect-files.bat \
; do
  [[ -f "$f" ]]; check "$f" $?
done

# 已刪除的冗餘檔案不得復現
if [[ -e tsmc-wiki/.claude/hooks/capture-session.bat ]]; then
  check "orphan removed: capture-session.bat" 1 "v1.2 已刪；不應重現"
else
  check "orphan removed: capture-session.bat" 0
fi

# ── A2: JSON parse ──────────────────────────────────
echo
echo "▸ JSON parse"
for f in tsmc-wiki/.claude/settings.json shorturl/.claude/settings.json shorturl/package.json; do
  json_valid "$f"; check "$f" $?
done

# ── A3: Hook 腳本語法 ───────────────────────────────
echo
echo "▸ Hook 腳本語法"
node --check tsmc-wiki/.claude/hooks/capture-session.js 2>/dev/null
check "node --check capture-session.js" $?
bash -n shorturl/.claude/hooks/protect-files.sh 2>/dev/null
check "bash -n protect-files.sh" $?

# ── A4: Hook 單元測試（mock payload）─────────────────
echo
echo "▸ Hook 單元測試"
# protect-files 應該對 .env 回 exit 2
set +e
echo '{"tool_name":"Write","tool_input":{"file_path":"shorturl/.env"}}' \
  | bash shorturl/.claude/hooks/protect-files.sh 2>/dev/null
[[ $? -eq 2 ]]; check "protect-files 擋下 .env (exit 2)" $?
# 對無關檔案應 exit 0
echo '{"tool_name":"Write","tool_input":{"file_path":"shorturl/src/api/server.ts"}}' \
  | bash shorturl/.claude/hooks/protect-files.sh 2>/dev/null
[[ $? -eq 0 ]]; check "protect-files 放行一般檔案 (exit 0)" $?
set -e 2>/dev/null || true
set -u

# ── A5: Skeleton 契約（§2.3）────────────────────────
echo
echo "▸ Skeleton 契約（§2.3 — 兩檔必須保持未完成）"
for f in shorturl/.claude/agents/backend-agent.md shorturl/.claude/agents/test-agent.md; do
  file_contains "$f" "📝 學員任務"; check "$f 保留 skeleton 標記" $? "Kit 維護者不得補完"
done
file_lacks shorturl/.claude/agents/frontend-agent.md "📝 學員任務"
check "frontend-agent.md 非 skeleton" $?

# ── A6: 70/30 Placeholder ───────────────────────────
echo
echo "▸ 70/30 契約（placeholder 數量）"
tsmc_n=$(count_matches tsmc-wiki/CLAUDE.md '\[YOUR_[A-Z_]+\]')
[[ "$tsmc_n" -eq 2 ]]; check "tsmc-wiki/CLAUDE.md: [YOUR_*] × 2" $? "偵測到 $tsmc_n 個"
short_n=$(count_matches shorturl/CLAUDE.md '\[YOUR_[A-Z_]+\]')
[[ "$short_n" -eq 3 ]]; check "shorturl/CLAUDE.md: [YOUR_*] × 3" $? "偵測到 $short_n 個"

# ── A7: Frontmatter ─────────────────────────────────
echo
echo "▸ Frontmatter 基本欄位"
for f in \
  tsmc-wiki/.claude/commands/wiki-add.md \
  tsmc-wiki/.claude/commands/wiki-search.md \
  shorturl/.claude/commands/review.md \
  shorturl/.claude/commands/test.md \
  shorturl/.claude/commands/deploy.md \
; do
  file_contains "$f" "description:"; check "$f 有 description" $?
done
for f in \
  tsmc-wiki/.claude/agents/research-agent.md \
  tsmc-wiki/.claude/agents/writer-agent.md \
  shorturl/.claude/agents/frontend-agent.md \
  shorturl/.claude/agents/backend-agent.md \
  shorturl/.claude/agents/test-agent.md \
; do
  file_contains "$f" "name:" && file_contains "$f" "description:" && file_contains "$f" "tools:"
  check "$f 有 name/description/tools" $?
done

# ── B 模式：行為驗證 ────────────────────────────────
if [[ "$MODE" == "full" ]]; then
  echo
  echo "▸ B 模式：行為驗證（耗時 + 耗 API 配額）"

  # B1: claude CLI
  if command -v claude >/dev/null 2>&1; then
    check "claude CLI 可用" 0
    CLAUDE_OK=1
  else
    check "claude CLI 可用" 1 "未安裝或不在 PATH"
    CLAUDE_OK=0
  fi

  # B2: shorturl npm test
  pushd shorturl >/dev/null
  if [[ ! -d node_modules ]]; then
    echo "  (首次安裝 npm deps — 約 30 秒)"
    npm install --silent --no-audit --no-fund >/dev/null 2>&1 || true
  fi
  if [[ -d node_modules ]]; then
    npm test --silent >/dev/null 2>&1
    check "shorturl npm test" $?
  else
    skip "shorturl npm test" "node_modules 安裝失敗"
  fi
  popd >/dev/null

  # B3: tsmc-wiki /wiki-add 行為測試
  if [[ "$CLAUDE_OK" -eq 1 ]]; then
    echo "  (執行 claude -p — 約 15-30 秒)"
    before=$(find tsmc-wiki/notes -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    pushd tsmc-wiki >/dev/null
    claude -p "/project:wiki-add smoke-test 自動化測試筆記" >/dev/null 2>&1 || true
    popd >/dev/null
    after=$(find tsmc-wiki/notes -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    [[ "$after" -gt "$before" ]]; check "tsmc-wiki /wiki-add 產生新 note ($before → $after)" $?
  else
    skip "tsmc-wiki /wiki-add 行為測試" "claude CLI 不可用"
    skip "tsmc-wiki Stop Hook 產生 daily/*-session.md" "claude CLI 不可用"
  fi
fi

# ── 結果 ─────────────────────────────────────────────
echo
echo "────────────────────────────────────"
TOTAL=$((PASS + FAIL))
if [[ "$FAIL" -eq 0 ]]; then
  printf '\033[32m全過 %d/%d\033[0m' "$PASS" "$TOTAL"
  [[ "$SKIP" -gt 0 ]] && printf '  \033[33m(skipped %d)\033[0m' "$SKIP"
  printf '\n'
  exit 0
else
  printf '\033[31m失敗 %d/%d\033[0m  (pass %d)\n' "$FAIL" "$TOTAL" "$PASS"
  echo; echo "失敗清單："
  for item in "${FAILED_ITEMS[@]}"; do echo "  - $item"; done
  exit 1
fi
