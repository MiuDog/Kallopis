# KlpShortcutStroke

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義單次快捷鍵輸入的按鍵及修飾鍵，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpShortcutStroke } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpShortcutStroke;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpShortcutStroke {

	/* key 是 canonical logical key；primary 隨平台投影；其餘 modifier 必須精確匹配。 */
	readonly key: string;
	readonly primary?: boolean;
	readonly ctrl?: boolean;
	readonly alt?: boolean;
	readonly shift?: boolean;
	readonly meta?: boolean;
}
```

## 成員與方法

### key

```tsx
readonly key: string;
```

框架識別鍵。

### primary

```tsx
readonly primary?: boolean;
```



### ctrl

```tsx
readonly ctrl?: boolean;
```



### alt

```tsx
readonly alt?: boolean;
```



### shift

```tsx
readonly shift?: boolean;
```



### meta

```tsx
readonly meta?: boolean;
```



<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-keymap.ts)；來源位置不作為 consumer import。
