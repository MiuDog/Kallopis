# KlpDockRestoreResult

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義布局還原結果與診斷，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockRestoreResult } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockRestoreResult;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockRestoreResult {
	/** 與 caller 隔離的深層 frozen 布局。 */
	readonly layout: KlpDockLayoutData;
	/** 按保存區域、群組、分頁順序列出缺少面板。 */
	readonly missingPanelIds: readonly string[];
	/** 按清冊順序列出未放置面板。 */
	readonly availablePanelIds: readonly string[];
}
```

## 成員與方法

### layout

```tsx
readonly layout: KlpDockLayoutData;
```

與 caller 隔離的深層 frozen 布局。

### missingPanelIds

```tsx
readonly missingPanelIds: readonly string[];
```

按保存區域、群組、分頁順序列出缺少面板。

### availablePanelIds

```tsx
readonly availablePanelIds: readonly string[];
```

按清冊順序列出未放置面板。

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpDockLayoutData](klp-dock-layout-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-layout-state.ts)；來源位置不作為 consumer import。
