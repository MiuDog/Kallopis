# resolveKlpDockGeometry

React · 0.1 · 未發布 npm · 工具函式

## 主要職責

根據有限宿主尺寸與布局限制計算 Dock 區域幾何。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { resolveKlpDockGeometry } from '@kallopis/react';

// 產品提供參數；回傳值保留此 API 的原生型別。
const invoke = (...args: Parameters<typeof resolveKlpDockGeometry>) => resolveKlpDockGeometry(...args);
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function resolveKlpDockGeometry(args: KlpDockGeometryArgs): KlpDockGeometry
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `args` | `KlpDockGeometryArgs` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 有限尺寸](../../../guides/react/09-resolve-klp-dock-geometry.md)：跨元件使用流程。

- [KlpDockGeometry](../types/klp-dock-geometry.md)
- [KlpDockGeometryArgs](../types/klp-dock-geometry-args.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-geometry.ts)；來源位置不作為 consumer import。
