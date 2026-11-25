# KlpDockPanelPolicy

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義產品允許的面板能力與限制，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockPanelPolicy } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockPanelPolicy;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockPanelPolicy {
	/** 清冊的原始 identity，不 trim。 */
	readonly id: string;
	/** 未提供表示允許左右區域。 */
	readonly allowSide?: boolean;
	/** 未提供表示允許下方區域。 */
	readonly allowBottom?: boolean;
}
```

## 成員與方法

### id

```tsx
readonly id: string;
```

清冊的原始 identity，不 trim。

### allowSide

```tsx
readonly allowSide?: boolean;
```

未提供表示允許左右區域。

### allowBottom

```tsx
readonly allowBottom?: boolean;
```

未提供表示允許下方區域。

<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 布局資料保存](../../../guides/react/07-klp-dock-layout-data.md)：跨元件使用流程。


- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-layout-state.ts)；來源位置不作為 consumer import。
