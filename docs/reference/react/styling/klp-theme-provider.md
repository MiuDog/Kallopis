# KlpThemeProvider

React · 0.1 · 未發布 npm · 語意風格

## 主要職責

建立子樹共用的 React 語意風格 scope，依 mode 與 style pack 投影 token。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { KlpThemeProvider, KlpButton } from '@kallopis/react';
import '@kallopis/react/styles.css';

export function ProductRoot() {
	return <KlpThemeProvider mode="light"><KlpButton>開始</KlpButton></KlpThemeProvider>;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpThemeProvider({ mode = 'light', stylePack, children, className = '', ...props }: KlpThemeProviderProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `mode` | `"dark" \| "light" \| "transparent" \| "ultraDark" \| undefined` | 否 | 'light' | 風格模式。 |
| `stylePack` | `KlpStylePack \| undefined` | 否 | undefined | stylePack：此 scope 的完整風格；缺省沿用正式預設。 |
| `className` | `string \| undefined` | 否 | '' | 外部宿主 class；不取代內部語意樣式。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [React Dock 元件](../../../guides/react/10-klp-dock-layout.md)：跨元件使用流程。
- [一般布局與尺寸限制](../../../guides/react/06-klp-theme-provider.md)：跨元件使用流程。
- [可替換風格](../../../guides/react/05-create-klp-style-pack.md)：跨元件使用流程。
- [第一個組合](../../../guides/react/02-klp-theme-provider.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpStylePack](klp-style-pack.md)
- [KlpThemeProviderProps](klp-theme-provider-props.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/theme.tsx)；來源位置不作為 consumer import。
