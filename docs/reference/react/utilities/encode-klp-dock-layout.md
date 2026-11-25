# encodeKlpDockLayout

React · 0.1 · 未發布 npm · 工具函式

## 主要職責

把布局資料編碼為保存用 JSON 字串，不保存正文或業務資料。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { encodeKlpDockLayout } from '@kallopis/react';

// 產品提供參數；回傳值保留此 API 的原生型別。
const invoke = (...args: Parameters<typeof encodeKlpDockLayout>) => encodeKlpDockLayout(...args);
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function encodeKlpDockLayout(layout: KlpDockLayoutData): string
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `layout` | `KlpDockLayoutData` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯


- [KlpDockLayoutData](../types/klp-dock-layout-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-layout-state.ts)；來源位置不作為 consumer import。
