# KlpTextField

React · 0.1 · 未發布 npm · 輸入元件

## 主要職責

組合標籤、輸入欄位、錯誤及提示內容；產品透過原生事件持有值。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { useState } from 'react';
import { KlpTextField } from '@kallopis/react';

export function TitleField() {
	const [title, setTitle] = useState('');
	return <KlpTextField label="標題" value={title} onChange={event => setTitle(event.target.value)} />;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpTextField({ label, error = false, hint, id, className = '', ...props }: KlpTextFieldProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `string` | 是 | — | 顯示標籤。 |
| `error` | `boolean \| undefined` | 否 | false | 依公開型別提供此輸入。 |
| `hint` | `string \| undefined` | 否 | undefined | 依公開型別提供此輸入。 |
| `className` | `string \| undefined` | 否 | '' | 外部宿主 class；不取代內部語意樣式。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [語意與 API 對應](../../../../guides/react/03-klp-text.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpTextFieldProps](../../types/klp-text-field-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/components.tsx)；來源位置不作為 consumer import。
