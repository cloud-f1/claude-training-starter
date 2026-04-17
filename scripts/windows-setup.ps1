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
# 防禦性設計：
#   - Idempotent：重覆執行不會重覆寫入 PROFILE（用 Select-String 檢查 marker，BOM-safe）
#   - 不在 git repo 時跳過 git 設定（僅警告，不中斷）
#   - 兼容 Windows PowerShell 5.1 + PowerShell 7+（分別處理 BOM 差異）

$ErrorActionPreference = 'Stop'

Write-Host ''
Write-Host '▸ Claude Training Starter Kit — Windows 環境設定' -ForegroundColor Cyan
Write-Host "  PowerShell $($PSVersionTable.PSVersion)" -ForegroundColor DarkGray
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

# 用 single-quoted here-string + -f 插值，避免 $OutputEncoding 被 PS parser 展開
$blockTemplate = @'

{0}
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
$OutputEncoding            = [System.Text.Encoding]::UTF8
'@
$block = $blockTemplate -f $marker

# 確保 PROFILE 檔案（含父目錄）存在
if (-not (Test-Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File -Force | Out-Null
    Write-Host "      建立 $profilePath" -ForegroundColor DarkGray
}

# Idempotent 檢查：用 Select-String -SimpleMatch -Quiet，BOM 不會影響比對
$alreadyInstalled = Select-String -Path $profilePath -SimpleMatch -Pattern $marker -Quiet -ErrorAction SilentlyContinue

if ($alreadyInstalled) {
    Write-Host '      ✓ PROFILE 已含 UTF-8 block，跳過' -ForegroundColor Green
} else {
    # PS 5.1 的 utf8 = with BOM；PS 7+ 的 utf8 = without BOM（語意不同但檔案都可讀）
    # 優先用 utf8NoBOM 拿一致結果；5.1 不支援就 fallback
    $encoding = if ($PSVersionTable.PSVersion.Major -ge 6) { 'utf8NoBOM' } else { 'utf8' }
    Add-Content -Path $profilePath -Value $block -Encoding $encoding
    Write-Host "      ✓ 已追加到 $profilePath (encoding: $encoding)" -ForegroundColor Green
}

# ── 3. Git 設定（僅此 repo）───────────────────────────────────────────
Write-Host ''
Write-Host '[3/3] 設定 git（repo 層級，不影響其他專案）' -ForegroundColor Gray

# 防禦：不在 git repo 時跳過（例如學員從別的目錄跑此腳本）
$inRepo = $false
try {
    $null = git rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -eq 0) { $inRepo = $true }
} catch {
    # git 未安裝或其他錯誤，當作不在 repo
}

if (-not $inRepo) {
    Write-Host '      ⚠ 當前目錄不是 git repo — 跳過 git 設定' -ForegroundColor Yellow
    Write-Host '        請 cd 到 claude-training-starter/ 再重跑，或手動設定：' -ForegroundColor DarkGray
    Write-Host '          git config core.autocrlf input' -ForegroundColor DarkGray
    Write-Host '          git config core.quotepath false' -ForegroundColor DarkGray
} else {
    # core.autocrlf=input：Windows 寫進 repo 時轉 CRLF→LF，避免污染 Hook 腳本
    # core.quotepath=false：讓中文檔名正常顯示，不會變成 \xxx\xxx\xxx 跳脫碼
    $gitSettings = @(
        @{ Key = 'core.autocrlf';  Value = 'input' }
        @{ Key = 'core.quotepath'; Value = 'false' }
    )
    foreach ($s in $gitSettings) {
        git config $s.Key $s.Value
        if ($LASTEXITCODE -eq 0) {
            Write-Host "      ✓ git config $($s.Key) = $($s.Value)" -ForegroundColor Green
        } else {
            Write-Host "      ✗ git config $($s.Key) 失敗" -ForegroundColor Red
        }
    }
}

# ── 結語 ──────────────────────────────────────────────────────────────
Write-Host ''
Write-Host '完成。注意事項：' -ForegroundColor Cyan
Write-Host '  • 重開 PowerShell 讓 PROFILE 生效，或執行：. $PROFILE' -ForegroundColor Gray
Write-Host '  • 若仍見中文亂碼，檢查終端機字型（建議 Cascadia Code / JetBrains Mono）' -ForegroundColor Gray
Write-Host "  • Hook 腳本請改用 .bat 版本：見 README.md 的「Windows 特別說明」" -ForegroundColor Gray
Write-Host ''
