# KlpShortcutConflict

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義快捷鍵綁定衝突診斷，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpShortcutConflict } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpShortcutConflict;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpShortcutConflict {

	/* kind 區分完整及前綴衝突；bindingIds 用 UTF-16 排序；winnerId 由固定順位決定。 */
	readonly kind: KlpShortcutConflictKind;
	readonly bindingIds: readonly string[];
	readonly winnerId: string;
}
```

## 成員與方法

### kind

```tsx
readonly kind: KlpShortcutConflictKind;
```



### bindingIds

```tsx
readonly bindingIds: readonly string[];
```



### winnerId

```tsx
readonly winnerId: string;
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpShortcutConflictKind](klp-shortcut-conflict-kind.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-keymap.ts)；來源位置不作為 consumer import。
