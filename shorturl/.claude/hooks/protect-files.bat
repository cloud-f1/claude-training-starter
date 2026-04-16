@echo off
REM PreToolUse Hook (Windows) — 保護重要檔案不被 Claude Code 意外覆蓋
REM
REM 觸發：Claude 即將使用 Write 或 Edit 工具
REM 動作：檢查目標檔案是否在保護清單中，是則阻擋（exit 2）

setlocal enabledelayedexpansion

REM 讀取 stdin 到暫存檔
set "TMP_INPUT=%TEMP%\claude-hook-input-%RANDOM%.json"
more > "%TMP_INPUT%"

REM 用 Node.js 或 Python 解析 JSON（擇一可用的）
set "FILE_PATH="
where python >nul 2>&1
if !ERRORLEVEL! EQU 0 (
  for /f "usebackq delims=" %%A in (`python -c "import sys, json; d = json.load(open(r'%TMP_INPUT%')); print(d.get('tool_input', {}).get('file_path', '') or d.get('tool_input', {}).get('path', ''))"`) do (
    set "FILE_PATH=%%A"
  )
) else (
  where node >nul 2>&1
  if !ERRORLEVEL! EQU 0 (
    for /f "usebackq delims=" %%A in (`node -e "const fs = require('fs'); const d = JSON.parse(fs.readFileSync('%TMP_INPUT%', 'utf8')); console.log((d.tool_input && (d.tool_input.file_path || d.tool_input.path)) || '');"`) do (
      set "FILE_PATH=%%A"
    )
  )
)

del "%TMP_INPUT%" 2>nul

REM 空路徑 → 放行
if "!FILE_PATH!" == "" exit /b 0

REM 受保護的檔案清單
set "PROTECTED=.env .env.production docker-compose.prod.yml CLAUDE.md .claude/settings.json"

for %%P in (%PROTECTED%) do (
  echo !FILE_PATH! | findstr /C:"%%P" >nul
  if !ERRORLEVEL! EQU 0 (
    echo [BLOCKED] 受保護的檔案：!FILE_PATH! >&2
    echo           理由：此檔案包含敏感資訊或治理規則，不能直接由 Agent 覆蓋。 >&2
    exit /b 2
  )
)

exit /b 0
