# KlpShortcutHandling

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義快捷鍵處理狀態與命令執行結果，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpShortcutHandling } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpShortcutHandling;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpShortcutHandling {

	/* handled 僅在實際消費鍵時成立；state 描述解析結果；兩 ID 與 execution 只在適用狀態存在。 */
	readonly handled: boolean;
	readonly state: KlpShortcutHandlingState;
	readonly bindingId?: string;
	readonly commandId?: string;
	readonly execution?: Promise<KlpCommandExecutionResult>;
}
```

## 成員與方法

### handled

```tsx
readonly handled: boolean;
```



### state

```tsx
readonly state: KlpShortcutHandlingState;
```



### bindingId

```tsx
readonly bindingId?: string;
```



### commandId

```tsx
readonly commandId?: string;
```



### execution

```tsx
readonly execution?: Promise<KlpCommandExecutionResult>;
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpCommandExecutionResult](klp-command-execution-result.md)
- [KlpShortcutHandlingState](klp-shortcut-handling-state.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-keymap.ts)；來源位置不作為 consumer import。
