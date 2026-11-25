# createKlpStylePack

React · 0.1 · 未發布 npm · 語意風格

## 主要職責

解析及驗證完整風格資料，建立不可變的 style pack。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { createKlpStylePack } from '@kallopis/react';

const pack = createKlpStylePack();
// 將 pack 傳給 KlpThemeProvider 的 stylePack。
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function createKlpStylePack(input: unknown = defaultStylePack): KlpStylePack
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `input` | `unknown` | 否 | defaultStylePack | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [可替換風格](../../../guides/react/05-create-klp-style-pack.md)：跨元件使用流程。

- [KlpStylePack](klp-style-pack.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/style-pack.ts)；來源位置不作為 consumer import。
