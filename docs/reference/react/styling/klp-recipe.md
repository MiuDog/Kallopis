# KlpRecipe

React · 0.1 · 未發布 npm · 語意風格

## 主要職責

定義正式元件配方的合法 ID，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpRecipe } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpRecipe;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export type KlpRecipe = keyof typeof klpRecipes;
```

<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/theme.tsx)；來源位置不作為 consumer import。
