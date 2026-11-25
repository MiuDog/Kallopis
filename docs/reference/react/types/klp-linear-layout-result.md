# KlpLinearLayoutResult

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義線性分配後的尺寸、間距、剩餘空間與壓縮狀態，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpLinearLayoutResult } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpLinearLayoutResult;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpLinearLayoutResult {
	readonly extents: readonly number[];
	readonly gutter: number;
	readonly unused: number;
	readonly compressed: boolean;
}
```

## 成員與方法

### extents

```tsx
readonly extents: readonly number[];
```



### gutter

```tsx
readonly gutter: number;
```



### unused

```tsx
readonly unused: number;
```



### compressed

```tsx
readonly compressed: boolean;
```



<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/linear-layout.ts)；來源位置不作為 consumer import。
