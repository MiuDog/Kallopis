# KlpShortcutInput

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義原生鍵盤事件的標準化輸入，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpShortcutInput } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpShortcutInput;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpShortcutInput extends KlpShortcutStroke {

	/* stroke 欄位沿公開定義；repeat 控制重複事件，composing 保護輸入法。 */
	readonly repeat?: boolean;
	readonly composing?: boolean;
}
```

## 成員與方法

### repeat

```tsx
readonly repeat?: boolean;
```



### composing

```tsx
readonly composing?: boolean;
```



### key

```tsx
key: string
```

框架識別鍵。

### primary

```tsx
primary?: boolean | undefined
```



### ctrl

```tsx
ctrl?: boolean | undefined
```



### alt

```tsx
alt?: boolean | undefined
```



### shift

```tsx
shift?: boolean | undefined
```



### meta

```tsx
meta?: boolean | undefined
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpShortcutStroke](klp-shortcut-stroke.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-keymap.ts)；來源位置不作為 consumer import。
