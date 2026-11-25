# KlpSurface

React · 0.1 · 未發布 npm · 布局元件

## 主要職責

提供具有表面語意的內容容器。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { KlpSurface, KlpText } from '@kallopis/react';

export function Content() {
	return <KlpSurface tone="inset"><KlpText>產品內容</KlpText></KlpSurface>;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpSurface({ tone = 'base', className = '', ...props }: KlpSurfaceProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `tone` | `"base" \| "component" \| "inset" \| "muted" \| "raised" \| "stage" \| undefined` | 否 | 'base' | 選擇語意呈現。 |
| `className` | `string \| undefined` | 否 | '' | 外部宿主 class；不取代內部語意樣式。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [語意與 API 對應](../../../../guides/react/03-klp-text.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpSurfaceProps](../../types/klp-surface-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/components.tsx)；來源位置不作為 consumer import。
