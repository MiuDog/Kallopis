# KlpShortcutBinding

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義快捷鍵序列、命令 ID 與作用域綁定，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpShortcutBinding } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpShortcutBinding<unknown>;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpShortcutBinding<C = unknown> {

	/* id 是 binding owner，commandId 引用唯一 registry；sequence 保留產品預設組合。 */
	readonly id: string;
	readonly commandId: string;
	readonly sequence: readonly KlpShortcutStroke[];
	/* scope／scopeId 限定有效焦點；priority 決定同層排序；兩個 allow 明示輸入例外；when 讀產品當次條件。 */
	readonly scope: KlpShortcutScope;
	readonly scopeId?: string;
	readonly priority?: number;
	readonly allowRepeat?: boolean;
	readonly allowInEditable?: boolean;
	readonly when?: (context: C) => boolean;
}
```

## 成員與方法

### id

```tsx
readonly id: string;
```

穩定識別，用於查詢或回報。

### commandId

```tsx
readonly commandId: string;
```



### sequence

```tsx
readonly sequence: readonly KlpShortcutStroke[];
```



### scope

```tsx
readonly scope: KlpShortcutScope;
```



### scopeId

```tsx
readonly scopeId?: string;
```



### priority

```tsx
readonly priority?: number;
```



### allowRepeat

```tsx
readonly allowRepeat?: boolean;
```



### allowInEditable

```tsx
readonly allowInEditable?: boolean;
```



### when

```tsx
readonly when?: (context: C) => boolean;
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpShortcutScope](klp-shortcut-scope.md)
- [KlpShortcutStroke](klp-shortcut-stroke.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-keymap.ts)；來源位置不作為 consumer import。
