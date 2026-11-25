# KlpFileExplorer

React · 0.1 · 未發布 npm · 工作區元件

## 主要職責

呈現產品投影的 section／item 與選取狀態，透過回呼交回選取及展開意圖。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import type { ComponentProps } from 'react';
import { KlpFileExplorer } from '@kallopis/react';

// 產品提供下表列出的必要 props；在 KlpThemeProvider 內呈現。
export function Example(props: ComponentProps<typeof KlpFileExplorer>) {
	return <KlpFileExplorer {...props} />;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpFileExplorer({ sections, expandedIds, selectedId, onToggle, onSelect, label = 'Explorer', className = '', ...props }: KlpFileExplorerProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `sections` | `readonly KlpExplorerSection[]` | 是 | — | 產品投影的區段資料。 |
| `expandedIds` | `readonly string[]` | 是 | — | 目前展開的識別集合。 |
| `selectedId` | `string \| undefined` | 否 | undefined | 產品持有的選取識別。 |
| `onToggle` | `(id: string) => void` | 是 | — | 將展開或切換意圖交回產品。 |
| `onSelect` | `(id: string) => void` | 是 | — | 將選取意圖交回產品。 |
| `label` | `string \| undefined` | 否 | 'Explorer' | 顯示標籤。 |
| `className` | `string \| undefined` | 否 | '' | 外部宿主 class；不取代內部語意樣式。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [React 專屬元件展示](../../../../guides/react/17-klp-button.md)：跨元件使用流程。
- [語意與 API 對應](../../../../guides/react/03-klp-text.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpExplorerSection](../../types/klp-explorer-section.md)
- [KlpFileExplorerProps](../../types/klp-file-explorer-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/components.tsx)；來源位置不作為 consumer import。
