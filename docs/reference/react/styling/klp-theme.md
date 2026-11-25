# KlpTheme

React · 0.1 · 未發布 npm · 語意風格

## 主要職責

定義目前模式、語意 token 與查詢方法，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpTheme } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpTheme;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpTheme {
	mode: KlpMode;
	tokens: Readonly<Record<KlpSemantic, KlpTokenValue>>;
	semantic: (id: string) => KlpTokenValue;
}
```

## 成員與方法

### mode

```tsx
mode: KlpMode;
```

風格模式。

### tokens

```tsx
tokens: Readonly<Record<KlpSemantic, KlpTokenValue>>;
```



### semantic

```tsx
semantic: (id: string) => KlpTokenValue;
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpMode](klp-mode.md)
- [KlpSemantic](klp-semantic.md)
- [KlpTokenValue](klp-token-value.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/theme.tsx)；來源位置不作為 consumer import。
