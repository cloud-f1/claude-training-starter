#!/bin/bash
# PreToolUse Hook — 保護重要檔案不被 Claude Code 意外覆蓋
#
# 觸發：Claude 即將使用 Write 或 Edit 工具
# 動作：檢查目標檔案是否在保護清單中，是則阻擋（exit 2）
#
# 適用：macOS / Linux

set -euo pipefail

INPUT=$(cat)

# 依賴檢查：node 已是 Kit 必備（shorturl 用 Node v20+、tsmc-wiki Hook 也用 node）
if ! command -v node >/dev/null 2>&1; then
  echo "⚠️  protect-files Hook 需要 node，但 PATH 中找不到；放行。" >&2
  exit 0
fi

# 從 stdin JSON 抓出檔案路徑（改用 node 取代 python3，與 Kit 其他 Hook 一致）
# PreToolUse payload: { "tool_name": "Write", "tool_input": { "file_path": "..." } }
FILE_PATH=$(echo "$INPUT" | node -e '
let s = ""; process.stdin.on("data", c => s += c); process.stdin.on("end", () => {
  try {
    const d = JSON.parse(s);
    const ti = d.tool_input || {};
    process.stdout.write(ti.file_path || ti.path || "");
  } catch { process.stdout.write(""); }
});
')

# 空路徑 → 放行（可能是其他工具）
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# 受保護的檔案清單
PROTECTED=(
  ".env"
  ".env.production"
  "docker-compose.prod.yml"
  "CLAUDE.md"
  ".claude/settings.json"
)

for protected in "${PROTECTED[@]}"; do
  if [[ "$FILE_PATH" == *"$protected"* ]]; then
    echo "⛔ 受保護的檔案：$FILE_PATH" >&2
    echo "   理由：此檔案包含敏感資訊或治理規則，不能直接由 Agent 覆蓋。" >&2
    echo "   若真的需要修改，請手動編輯或在 CLAUDE.md 明確許可。" >&2
    exit 2
  fi
done

exit 0
