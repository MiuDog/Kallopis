# KlpWorkspace

React · 0.1 · 未發布 npm · 工作區元件

## 主要職責

提供產品工作區的共用容器，內容與流程由產品組合。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import type { ComponentProps } from 'react';
import { KlpWorkspace } from '@kallopis/react';

// 產品提供下表列出的必要 props；在 KlpThemeProvider 內呈現。
export function Example(props: ComponentProps<typeof KlpWorkspace>) {
	return <KlpWorkspace {...props} />;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpWorkspace({ children, className = '', ...props }: KlpWorkspaceProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `children` | `ReactNode` | 是 | — | 產品提供的子內容。 |
| `className` | `string \| undefined` | 否 | '' | 外部宿主 class；不取代內部語意樣式。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [語意與 API 對應](../../../../guides/react/03-klp-text.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpWorkspaceProps](../../types/klp-workspace-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/components.tsx)；來源位置不作為 consumer import。
