# applyKlpDockAction

React · 0.1 · 未發布 npm · 工具函式

## 主要職責

根據既有布局與面板政策套用操作，回傳結果及新布局。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { applyKlpDockAction } from '@kallopis/react';

// 產品提供參數；回傳值保留此 API 的原生型別。
const invoke = (...args: Parameters<typeof applyKlpDockAction>) => applyKlpDockAction(...args);
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function applyKlpDockAction(layout: KlpDockLayoutData, panels: readonly KlpDockPanelPolicy[], action: KlpDockAction): KlpDockActionResult
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `layout` | `KlpDockLayoutData` | 是 | — | 依公開型別提供此輸入。 |
| `panels` | `readonly KlpDockPanelPolicy[]` | 是 | — | 依公開型別提供此輸入。 |
| `action` | `KlpDockAction` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/react/08-apply-klp-dock-action.md)：跨元件使用流程。

- [KlpDockAction](../types/klp-dock-action.md)
- [KlpDockActionResult](../types/klp-dock-action-result.md)
- [KlpDockLayoutData](../types/klp-dock-layout-data.md)
- [KlpDockPanelPolicy](../types/klp-dock-panel-policy.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-layout-operations.ts)；來源位置不作為 consumer import。
