# createKlpTheme

React · 0.1 · 未發布 npm · 語意風格

## 主要職責

依模式與可選 style pack 取得語意 token；未知模式會拒絕。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { createKlpTheme } from '@kallopis/react';

const tokens = createKlpTheme('light');
const surface = tokens['theme.colors.surface'];
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function createKlpTheme(mode: KlpMode = 'light', stylePack?: KlpStylePack): KlpTheme['tokens']
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `mode` | `KlpMode` | 否 | 'light' | 風格模式。 |
| `stylePack` | `KlpStylePack` | 否 | undefined | 此 scope 使用的合法風格包。 |


<!-- reference-api:end -->

## 使用限制與關聯


- [KlpMode](klp-mode.md)
- [KlpStylePack](klp-style-pack.md)
- [KlpTheme](klp-theme.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/theme.tsx)；來源位置不作為 consumer import。
