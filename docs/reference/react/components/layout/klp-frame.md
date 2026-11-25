# KlpFrame

React · 0.1 · 未發布 npm · 布局元件

## 主要職責

以 header、內容、footer 組合有語意角色的框架表面。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { KlpFrame, KlpText } from '@kallopis/react';

export function Panel() {
	return <KlpFrame header="內容"><KlpText>產品內容</KlpText></KlpFrame>;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpFrame({ role = 'content', surface = 'flat', header, footer, children, className = '', ...props }: KlpFrameProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `surface` | `"flat" \| "raised" \| undefined` | 否 | 'flat' | surface：明確選用正式微立體配方，既有 caller 預設維持平面。 |
| `role` | `"auxiliary" \| "content" \| "sidebar" \| undefined` | 否 | 'content' | 依公開型別提供此輸入。 |
| `header` | `ReactNode` | 否 | undefined | 標頭內容。 |
| `footer` | `ReactNode` | 否 | undefined | 頁尾內容。 |
| `className` | `string \| undefined` | 否 | '' | 外部宿主 class；不取代內部語意樣式。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [語意與 API 對應](../../../../guides/react/03-klp-text.md)：跨元件使用流程。
- [第一個組合](../../../../guides/react/02-klp-theme-provider.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpFrameProps](../../types/klp-frame-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/components.tsx)；來源位置不作為 consumer import。
