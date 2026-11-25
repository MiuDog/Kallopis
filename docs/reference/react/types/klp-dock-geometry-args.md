# KlpDockGeometryArgs

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義計算 Dock 幾何所需的宿主及布局輸入，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockGeometryArgs } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockGeometryArgs;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockGeometryArgs {
	readonly width: number;
	readonly height: number;
	readonly layout: KlpDockLayoutData;
	readonly leftConstraints: KlpDockAreaConstraints;
	readonly rightConstraints: KlpDockAreaConstraints;
	readonly bottomConstraints?: KlpDockAreaConstraints;
	readonly handleExtent: number;
	/** 省略沒有 header；0 保留零高 header 槽。 */
	readonly headerExtent?: number;
}
```

## 成員與方法

### width

```tsx
readonly width: number;
```



### height

```tsx
readonly height: number;
```



### layout

```tsx
readonly layout: KlpDockLayoutData;
```



### leftConstraints

```tsx
readonly leftConstraints: KlpDockAreaConstraints;
```



### rightConstraints

```tsx
readonly rightConstraints: KlpDockAreaConstraints;
```



### bottomConstraints

```tsx
readonly bottomConstraints?: KlpDockAreaConstraints;
```



### handleExtent

```tsx
readonly handleExtent: number;
```



### headerExtent

```tsx
readonly headerExtent?: number;
```

省略沒有 header；0 保留零高 header 槽。

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpDockAreaConstraints](klp-dock-area-constraints.md)
- [KlpDockLayoutData](klp-dock-layout-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-geometry.ts)；來源位置不作為 consumer import。
