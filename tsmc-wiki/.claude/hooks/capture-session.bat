@echo off
REM Stop Hook (Windows) — Session 結束時自動記錄
REM
REM 觸發：Claude Code Session 結束
REM 動作：呼叫 Node.js 版本的 capture-session.js
REM
REM 學員任務：如果 Node.js 不在 PATH，改用完整路徑呼叫

setlocal
set "SCRIPT_DIR=%~dp0"

node "%SCRIPT_DIR%capture-session.js"

if %ERRORLEVEL% NEQ 0 (
  echo [WARN] capture-session 執行失敗，但不影響本次 Session
  exit /b 1
)

exit /b 0
