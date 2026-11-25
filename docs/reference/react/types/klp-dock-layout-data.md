# KlpDockLayoutData

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義可保存的 Dock 布局資料，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockLayoutData } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockLayoutData;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockLayoutData {
	/** Stage 周圍的三個受控區域；Stage 內容不保存。 */
	readonly left: KlpDockAreaData;
	readonly right: KlpDockAreaData;
	readonly bottom: KlpDockAreaData;
}
```

## 成員與方法

### left

```tsx
readonly left: KlpDockAreaData;
```

Stage 周圍的三個受控區域；Stage 內容不保存。

### right

```tsx
readonly right: KlpDockAreaData;
```



### bottom

```tsx
readonly bottom: KlpDockAreaData;
```



<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 布局資料保存](../../../guides/react/07-klp-dock-layout-data.md)：跨元件使用流程。

- [KlpDockAreaData](klp-dock-area-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-layout-state.ts)；來源位置不作為 consumer import。
