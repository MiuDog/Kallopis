# KlpCard

React · 0.1 · 未發布 npm · 布局元件

## 主要職責

組合 header、內容與 footer 的卡片表面。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { KlpCard, KlpText } from '@kallopis/react';

export function Summary() {
	return <KlpCard header="摘要"><KlpText>產品內容</KlpText></KlpCard>;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpCard({ header, footer, children, tone = 'component', className = '', ...props }: KlpCardProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `header` | `ReactNode` | 否 | undefined | 標頭內容。 |
| `footer` | `ReactNode` | 否 | undefined | 頁尾內容。 |
| `className` | `string \| undefined` | 否 | '' | 外部宿主 class；不取代內部語意樣式。 |
| `tone` | `"base" \| "component" \| "inset" \| "muted" \| "raised" \| "stage" \| undefined` | 否 | 'component' | 選擇語意呈現。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [語意與 API 對應](../../../../guides/react/03-klp-text.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpCardProps](../../types/klp-card-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/components.tsx)；來源位置不作為 consumer import。
