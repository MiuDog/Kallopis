# KlpButton

React · 0.1 · 未發布 npm · 操作元件

## 主要職責

呈現文字操作按鈕，產品持有事件與選取狀態；語意、尺寸與互動外觀由目前 theme 解析。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { KlpButton } from '@kallopis/react';

export function SaveButton() {
	return <KlpButton onClick={() => {
		// 接入產品的儲存流程。
	}}>儲存</KlpButton>;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpButton({ tone = 'secondary', size = 'md', selected, type = 'button', className = '', ...props }: KlpButtonProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `tone` | `"ghost" \| "primary" \| "secondary" \| undefined` | 否 | 'secondary' | 選擇語意呈現。 |
| `size` | `"lg" \| "md" \| "sm" \| "xl" \| "xs" \| undefined` | 否 | 'md' | 尺寸選擇。 |
| `selected` | `boolean \| undefined` | 否 | undefined | 由產品持有的選取狀態。 |
| `className` | `string \| undefined` | 否 | '' | 外部宿主 class；不取代內部語意樣式。 |
| `type` | `"button" \| "reset" \| "submit" \| undefined` | 否 | 'button' | 原生 HTML 元素的 type。 |


<!-- reference-api:end -->

## 使用限制與關聯

- `disabled`、`onClick`、`children` 沿原生 button 契約；停用時不啟動點擊。
- 本平台預設 tone 是 secondary、size 是 md，與 Flutter 預設不同。
- `selected` 由產品持有，映射至 aria-pressed。
- [React 專屬元件展示](../../../../guides/react/17-klp-button.md)：跨元件使用流程。
- [語意與 API 對應](../../../../guides/react/03-klp-text.md)：跨元件使用流程。
- [第一個組合](../../../../guides/react/02-klp-theme-provider.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpButtonProps](../../types/klp-button-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/components.tsx)；來源位置不作為 consumer import。
