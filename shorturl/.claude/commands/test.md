---
description: 為指定檔案生成 Jest Unit Test，涵蓋 happy / error / edge case
argument-hint: "<要測試的檔案路徑>"
---

# /test — 生成單元測試

你是一位測試工程師，為以下程式碼生成完整的 Jest Unit Test。

---

## 規範

### 1. 測試範圍

每個函式至少涵蓋：

- **Happy path**：正常輸入 → 預期輸出
- **Error case**：無效輸入、非預期狀態 → 預期拋錯
- **Edge case**：邊界值（空字串、0、最大長度、Unicode）

### 2. 外部依賴處理

- 資料庫 → 使用 Jest mock 或 in-memory SQLite
- HTTP 請求 → 使用 `jest.mock` 或 `nock`
- 時間 → 使用 `jest.useFakeTimers()`

### 3. 測試結構（AAA 模式）

```typescript
describe('functionName', () => {
  it('should [expected behavior] when [condition]', () => {
    // Arrange
    const input = ...;
    const expected = ...;

    // Act
    const actual = functionName(input);

    // Assert
    expect(actual).toEqual(expected);
  });
});
```

### 4. 命名

- `describe(...)`：被測試的函式名或類別名
- `it('should ... when ...')`：清楚描述測試目的
- **禁止**：`it('test 1')`、`it('works')` 這類無意義描述

---

## 輸出檔案位置

- 測試檔案寫入 `src/__tests__/` 目錄
- 命名：`<被測檔案名>.test.ts`
- 範例：`src/api/shortener.ts` → `src/__tests__/shortener.test.ts`

---

## 輸出格式

```markdown
✅ 已生成測試檔案：`src/__tests__/shortener.test.ts`

### 測試涵蓋
- Happy path: X 個
- Error case: X 個
- Edge case: X 個
- 總計：X 個測試

### 執行方式
```bash
npm test -- shortener
```

### 尚未涵蓋（建議補充）
- ...
- ...
```

---

## 禁止

- ❌ 測試 `any` 型別、未斷言的 side effect
- ❌ 測試私有函式（測公開介面）
- ❌ 寫「看似通過但沒真的斷言」的測試
- ❌ 複製貼上同樣的 test case 只改輸入（善用 `it.each`）

---

## 輸入

$ARGUMENTS
