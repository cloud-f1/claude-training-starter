#!/usr/bin/env node
/**
 * Stop Hook — Session 結束時自動記錄
 *
 * 觸發：Claude Code Session 結束
 * 動作：在 daily/ 寫入今日 Session 元資料
 *
 * Stop Hook stdin payload:
 *   { "session_id": "xxx", "transcript_path": "/path/to/transcript.json", "hook_event_name": "Stop" }
 *
 * 學員任務：修改第 17 行的 WIKI_FOLDER 為你實際的資料夾名稱
 */

'use strict';

const readline = require('readline');
const fs = require('fs');
const path = require('path');

// 👇 學員修改這一行
const WIKI_FOLDER = 'tsmc-wiki';

const rl = readline.createInterface({ input: process.stdin });
let input = '';
rl.on('line', (line) => { input += line + '\n'; });
rl.on('close', () => {
  try {
    const session = input.trim() ? JSON.parse(input) : {};
    const today = new Date().toISOString().split('T')[0];
    const logPath = path.join(process.cwd(), WIKI_FOLDER, 'daily', `${today}-session.md`);

    const content = [
      '---',
      `title: "${today} Session 記錄"`,
      `created_at: "${today}"`,
      `tags: ["#session"]`,
      `status: "draft"`,
      'source: "auto-generated"',
      '---',
      '',
      `# ${today} Session 記錄`,
      '',
      `- Session ID：${session.session_id || '未知'}`,
      `- 對話記錄：\`${session.transcript_path || '無'}\``,
      `- Hook 事件：${session.hook_event_name || 'Stop'}`,
      '',
      '## 行動項目',
      '',
      '- [ ] 回顧本次 Session，把有價值的內容用 `/project:wiki-add` 正式加入知識庫',
      '- [ ] 若有新的決策 → 寫進 `decisions/` 形成 ADR',
      '',
      '---',
      '',
      '> 這份檔案由 `capture-session.js` Stop Hook 自動產生。',
      '> 不要直接編輯此檔，整理後的內容請寫到 `notes/` 或 `concepts/`。',
      ''
    ].join('\n');

    fs.mkdirSync(path.dirname(logPath), { recursive: true });
    fs.writeFileSync(logPath, content);
    console.error(`✅ Session 記錄已儲存到 ${logPath}`);
    process.exit(0);
  } catch (err) {
    console.error(`⚠️  Stop Hook 執行失敗：${err.message}`);
    // exit 1 = 告知錯誤但繼續，不要因為記錄失敗就中斷使用者
    process.exit(1);
  }
});
