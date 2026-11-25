# KlpTextRole

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義文字角色的合法選項，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpTextRole } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpTextRole;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export type KlpTextRole = 'body' | 'body-strong' | 'caption' | 'label' | 'lead' | 'h1' | 'h2' | 'h3' | 'h4' | 'code';
```

<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/components.tsx)；來源位置不作為 consumer import。
