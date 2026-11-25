# KlpDockDestination

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義面板移動或開啟的目標位置，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockDestination } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockDestination;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export type KlpDockDestination =
	| { readonly kind: 'tab'; readonly area: KlpDockArea; readonly groupId: string; readonly index: number }
	| { readonly kind: 'group'; readonly area: KlpDockArea; readonly groupId: string; readonly index: number; readonly extent: number };
```

## 成員與方法

### kind

```tsx
kind: "group" | "tab"
```



### area

```tsx
area: KlpDockArea
```



### groupId

```tsx
groupId: string
```



### index

```tsx
index: number
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpDockArea](klp-dock-area.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-layout-operations.ts)；來源位置不作為 consumer import。
