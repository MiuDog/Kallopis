# KlpShortcutOverrides

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義產品或使用者提供的快捷鍵覆寫，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpShortcutOverrides } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpShortcutOverrides;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpShortcutOverrides {

	/* schemaVersion 擁有 wire 版本；bindings 動態 ID 對應覆寫序列，null 為停用，無產品 callback。 */
	readonly schemaVersion: 1;
	readonly bindings: Readonly<Record<string, readonly KlpShortcutStroke[] | null>>;
}
```

## 成員與方法

### schemaVersion

```tsx
readonly schemaVersion: 1;
```



### bindings

```tsx
readonly bindings: Readonly<Record<string, readonly KlpShortcutStroke[] | null>>;
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpShortcutStroke](klp-shortcut-stroke.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-keymap.ts)；來源位置不作為 consumer import。
