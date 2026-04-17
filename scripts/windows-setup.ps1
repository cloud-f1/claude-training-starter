# scripts/windows-setup.ps1
#
# Claude Training Starter Kit — Windows 環境一次性設定
#
# 解決 Windows 學員最常卡住的兩個問題：
#   1. PowerShell 預設編碼不是 UTF-8 → 中文筆記、繁中 prompt 顯示亂碼
#   2. Git 預設 core.autocrlf=true → Hook 腳本 (.sh) 換行變 CRLF 在 WSL / macOS 側執行失敗
#
# 用法（專案根目錄下執行）：
#   powershell -ExecutionPolicy Bypass -File scripts\windows-setup.ps1
#
# 這個腳本是 idempotent 的：重覆執行不會重覆寫入 PROFILE。

$ErrorActionPreference = 'Stop'

Write-Host ''
Write-Host '▸ Claude Training Starter Kit — Windows 環境設定' -ForegroundColor Cyan
Write-Host ''

# ── 1. 當前 session 立即切到 UTF-8 ────────────────────────────────────
Write-Host '[1/3] 當前 session 套用 UTF-8' -ForegroundColor Gray
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
$OutputEncoding            = [System.Text.Encoding]::UTF8
Write-Host '      ✓ Console/Input/OutputEncoding = UTF-8' -ForegroundColor Green

# ── 2. 寫進 $PROFILE 永久生效 ─────────────────────────────────────────
Write-Host ''
Write-Host '[2/3] 寫入 PowerShell PROFILE' -ForegroundColor Gray

$profilePath = $PROFILE
$marker      = '# Claude Training Starter Kit — UTF-8 encoding'
$block = @"

$marker
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
`$OutputEncoding            = [System.Text.Encoding]::UTF8
"@

if (-not (Test-Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File -Force | Out-Null
    Write-Host "      建立 $profilePath" -ForegroundColor Gray
}

$existing = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
if ($existing -and $existing.Contains($marker)) {
    Write-Host '      ✓ PROFILE 已含 UTF-8 block，跳過' -ForegroundColor Green
} else {
    Add-Content -Path $profilePath -Value $block -Encoding UTF8
    Write-Host "      ✓ 已追加到 $profilePath" -ForegroundColor Green
}

# ── 3. Git 設定（僅此 repo）───────────────────────────────────────────
Write-Host ''
Write-Host '[3/3] 設定 git（repo 層級，不影響其他專案）' -ForegroundColor Gray

# core.autocrlf=input：Windows 只把 CRLF 轉成 LF 進 repo，checkout 不改
#   原因：Hook 腳本 (.sh) 要在 WSL/macOS 跑，若被轉 CRLF 會執行失敗
# core.quotepath=false：讓中文檔名正常顯示，不會變成 \xxx\xxx\xxx 跳脫碼
$gitSettings = @(
    @{ Key = 'core.autocrlf';  Value = 'input' }
    @{ Key = 'core.quotepath'; Value = 'false' }
)

foreach ($s in $gitSettings) {
    git config $s.Key $s.Value
    Write-Host "      ✓ git config $($s.Key) = $($s.Value)" -ForegroundColor Green
}

# ── 結語 ──────────────────────────────────────────────────────────────
Write-Host ''
Write-Host '完成。注意事項：' -ForegroundColor Cyan
Write-Host '  • 重開 PowerShell 讓 PROFILE 生效，或執行：. $PROFILE' -ForegroundColor Gray
Write-Host '  • 若仍見中文亂碼，檢查終端機字型（建議 Cascadia Code / JetBrains Mono）' -ForegroundColor Gray
Write-Host "  • Hook 腳本請改用 .bat 版本：見 README.md 的「Windows 特別說明」" -ForegroundColor Gray
Write-Host ''
