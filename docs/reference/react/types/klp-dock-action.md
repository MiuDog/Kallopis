# KlpDockAction

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義停靠布局可接受的操作聯集，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockAction } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockAction;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export type KlpDockAction =
	| { readonly type: 'select'; readonly panelId: string }
	| { readonly type: 'move' | 'open'; readonly panelId: string; readonly destination: KlpDockDestination }
	| { readonly type: 'merge'; readonly sourceGroupId: string; readonly targetGroupId: string; readonly index: number }
	| { readonly type: 'close'; readonly panelId: string; readonly approved: boolean }
	| { readonly type: 'visibility'; readonly area: KlpDockArea; readonly isVisible: boolean }
	| { readonly type: 'resizeArea'; readonly area: KlpDockArea; readonly extent: number }
	| { readonly type: 'resizeGroup'; readonly groupId: string; readonly extent: number };
```

## 成員與方法

### type

```tsx
type: "close" | "merge" | "move" | "open" | "resizeArea" | "resizeGroup" | "select" | "visibility"
```

原生 HTML 元素的 type。

<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/react/08-apply-klp-dock-action.md)：跨元件使用流程。

- [KlpDockArea](klp-dock-area.md)
- [KlpDockDestination](klp-dock-destination.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-layout-operations.ts)；來源位置不作為 consumer import。
