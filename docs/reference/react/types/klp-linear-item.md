# KlpLinearItem

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義線性布局項目的 minimum、maximum、preferred 與 flex，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpLinearItem } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpLinearItem;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpLinearItem {
	readonly minimum?: number;
	readonly maximum?: number;
	readonly preferred?: number;
	readonly flex?: number;
}
```

## 成員與方法

### minimum

```tsx
readonly minimum?: number;
```



### maximum

```tsx
readonly maximum?: number;
```



### preferred

```tsx
readonly preferred?: number;
```



### flex

```tsx
readonly flex?: number;
```



<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/linear-layout.ts)；來源位置不作為 consumer import。
