# KlpDockGroupData

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義停靠群組的面板排列與目前選取，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockGroupData } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockGroupData;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockGroupData {
	/** 全部區域共用的群組 identity。 */
	readonly id: string;
	/** 保存的分頁順序，panel identity 全域唯一。 */
	readonly panelIds: readonly string[];
	/** 必須屬於自己的 panelIds。 */
	readonly activePanelId: string;
	/** 區域主軸的有限正數偏好尺寸。 */
	readonly mainAxisExtent: number;
}
```

## 成員與方法

### id

```tsx
readonly id: string;
```

全部區域共用的群組 identity。

### panelIds

```tsx
readonly panelIds: readonly string[];
```

保存的分頁順序，panel identity 全域唯一。

### activePanelId

```tsx
readonly activePanelId: string;
```

必須屬於自己的 panelIds。

### mainAxisExtent

```tsx
readonly mainAxisExtent: number;
```

區域主軸的有限正數偏好尺寸。

<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-layout-state.ts)；來源位置不作為 consumer import。
