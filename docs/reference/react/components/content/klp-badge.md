# KlpBadge

React · 0.1 · 未發布 npm · 內容元件

## 主要職責

呈現短文字標記與狀態語意，不承擔操作按鈕職責。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { KlpBadge } from '@kallopis/react';

export function Status() {
	return <KlpBadge tone="success">已儲存</KlpBadge>;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpBadge({ tone = 'neutral', className = '', ...props }: KlpBadgeProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `tone` | `"danger" \| "info" \| "neutral" \| "success" \| "warning" \| undefined` | 否 | 'neutral' | 選擇語意呈現。 |
| `className` | `string \| undefined` | 否 | '' | 外部宿主 class；不取代內部語意樣式。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [語意與 API 對應](../../../../guides/react/03-klp-text.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpBadgeProps](../../types/klp-badge-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/components.tsx)；來源位置不作為 consumer import。
