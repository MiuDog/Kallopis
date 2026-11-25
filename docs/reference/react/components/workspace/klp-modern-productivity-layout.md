# KlpModernProductivityLayout

React · 0.1 · 未發布 npm · 工作區元件

## 主要職責

組合唯一左側功能欄與右側 Header／Stage，產品持有面板清單與受控選取。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import type { ComponentProps } from 'react';
import { KlpModernProductivityLayout } from '@kallopis/react';

// 產品提供下表列出的必要 props；在 KlpThemeProvider 內呈現。
export function Example(props: ComponentProps<typeof KlpModernProductivityLayout>) {
	return <KlpModernProductivityLayout {...props} />;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpModernProductivityLayout(props: KlpModernProductivityLayoutProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `panels` | `readonly KlpModernProductivityPanel[]` | 是 | — | 依公開型別提供此輸入。 |
| `selectedId` | `string` | 是 | — | 產品持有的選取識別。 |
| `onSelected` | `((id: string) => void) \| null \| undefined` | 否 | undefined | 將選取意圖交回產品。 |
| `header` | `ReactNode` | 是 | — | 標頭內容。 |
| `stage` | `ReactNode` | 是 | — | 依公開型別提供此輸入。 |
| `sidebarWidth` | `number \| undefined` | 否 | undefined | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpModernProductivityLayoutProps](../../types/klp-modern-productivity-layout-props.md)
- [KlpModernProductivityPanel](../../types/klp-modern-productivity-panel.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/modern-productivity-layout.tsx)；來源位置不作為 consumer import。
