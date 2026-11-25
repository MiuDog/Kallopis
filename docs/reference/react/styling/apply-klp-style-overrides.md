# applyKlpStyleOverrides

React · 0.1 · 未發布 npm · 語意風格

## 主要職責

對既有 pack 套用合法 primitive／semantic 覆寫，回傳新 pack。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { applyKlpStyleOverrides } from '@kallopis/react';

// 產品提供參數；回傳值保留此 API 的原生型別。
const invoke = (...args: Parameters<typeof applyKlpStyleOverrides>) => applyKlpStyleOverrides(...args);
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function applyKlpStyleOverrides(pack: KlpStylePack, overrides: KlpStyleOverrides): KlpStylePack
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `pack` | `KlpStylePack` | 是 | — | 依公開型別提供此輸入。 |
| `overrides` | `KlpStyleOverrides` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [可替換風格](../../../guides/react/05-create-klp-style-pack.md)：跨元件使用流程。

- [KlpStyleOverrides](klp-style-overrides.md)
- [KlpStylePack](klp-style-pack.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/style-pack.ts)；來源位置不作為 consumer import。
