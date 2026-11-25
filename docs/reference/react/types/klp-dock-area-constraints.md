# KlpDockAreaConstraints

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義停靠區域的尺寸限制，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockAreaConstraints } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockAreaConstraints;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockAreaConstraints {
	readonly minExtent: number;
	readonly maxExtent?: number;
}
```

## 成員與方法

### minExtent

```tsx
readonly minExtent: number;
```



### maxExtent

```tsx
readonly maxExtent?: number;
```



<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-geometry.ts)；來源位置不作為 consumer import。
