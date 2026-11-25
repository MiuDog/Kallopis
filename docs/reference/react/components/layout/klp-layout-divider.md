# KlpLayoutDivider

React · 0.1 · 未發布 npm · 布局元件

## 主要職責

呈現布局分隔，依公開參數回報尺寸調整意圖。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import type { ComponentProps } from 'react';
import { KlpLayoutDivider } from '@kallopis/react';

// 產品提供下表列出的必要 props；在 KlpThemeProvider 內呈現。
export function Example(props: ComponentProps<typeof KlpLayoutDivider>) {
	return <KlpLayoutDivider {...props} />;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpLayoutDivider({ style, ...props }: KlpLayoutDividerProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `ref` | `Ref<HTMLDivElement> \| undefined` | 否 | undefined | 存取公開的原生宿主。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [一般布局與尺寸限制](../../../../guides/react/06-klp-theme-provider.md)：跨元件使用流程。
- [語意與 API 對應](../../../../guides/react/03-klp-text.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpLayoutDividerProps](../../types/klp-layout-divider-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/workbench-layout.tsx)；來源位置不作為 consumer import。
