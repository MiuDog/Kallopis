# KlpDockAreaData

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義單一停靠區域的群組與可見狀態，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockAreaData } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockAreaData;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockAreaData {
	/** 群組排列方向，不從區域名稱推定。 */
	readonly axis: 'horizontal' | 'vertical';
	/** 收合仍保留原群組與尺寸。 */
	readonly isVisible: boolean;
	/** 左右寬度或下方高度的有限非負偏好尺寸。 */
	readonly extent: number;
	readonly groups: readonly KlpDockGroupData[];
}
```

## 成員與方法

### axis

```tsx
readonly axis: 'horizontal' | 'vertical';
```

群組排列方向，不從區域名稱推定。

### isVisible

```tsx
readonly isVisible: boolean;
```

收合仍保留原群組與尺寸。

### extent

```tsx
readonly extent: number;
```

左右寬度或下方高度的有限非負偏好尺寸。

### groups

```tsx
readonly groups: readonly KlpDockGroupData[];
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpDockGroupData](klp-dock-group-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-layout-state.ts)；來源位置不作為 consumer import。
