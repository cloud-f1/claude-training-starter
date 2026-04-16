#!/bin/bash
# PreToolUse Hook — 保護重要檔案不被 Claude Code 意外覆蓋
#
# 觸發：Claude 即將使用 Write 或 Edit 工具
# 動作：檢查目標檔案是否在保護清單中，是則阻擋（exit 2）
#
# 適用：macOS / Linux

set -euo pipefail

INPUT=$(cat)

# 從 stdin JSON 抓出檔案路徑
# PreToolUse payload: { "tool_name": "Write", "tool_input": { "file_path": "..." } }
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('file_path', '') or d.get('tool_input', {}).get('path', ''))
except Exception:
    print('')
")

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
