# KlpIconButton

React · 0.1 · 未發布 npm · 操作元件

## 主要職責

呈現圖示操作入口；產品提供可讀 label 與圖示內容。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { KlpIconButton } from '@kallopis/react';

export function CloseButton() {
	return <KlpIconButton label="關閉" onClick={() => {}}>×</KlpIconButton>;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpIconButton({ label, tone = 'standalone', className = '', ...props }: KlpIconButtonProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `string` | 是 | — | 顯示標籤。 |
| `tone` | `"inline" \| "standalone" \| "window" \| undefined` | 否 | 'standalone' | 選擇語意呈現。 |
| `className` | `string \| undefined` | 否 | '' | 外部宿主 class；不取代內部語意樣式。 |
| `size` | `"lg" \| "md" \| "sm" \| "xl" \| "xs" \| undefined` | 否 | undefined | 尺寸選擇。 |
| `selected` | `boolean \| undefined` | 否 | undefined | 由產品持有的選取狀態。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [語意與 API 對應](../../../../guides/react/03-klp-text.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpIconButtonProps](../../types/klp-icon-button-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/components.tsx)；來源位置不作為 consumer import。
