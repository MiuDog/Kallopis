# KlpFileExplorerProps

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義 KlpFileExplorer 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpFileExplorerProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpFileExplorerProps;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpFileExplorerProps extends Omit<HTMLAttributes<HTMLElement>, 'onSelect' | 'onToggle'> {
	sections: readonly KlpExplorerSection[];
	expandedIds: readonly string[];
	selectedId?: string;
	onToggle: (id: string) => void;
	onSelect: (id: string) => void;
	label?: string;
}
```

## 成員與方法

### sections

```tsx
sections: readonly KlpExplorerSection[];
```

產品投影的區段資料。

### expandedIds

```tsx
expandedIds: readonly string[];
```

目前展開的識別集合。

### selectedId

```tsx
selectedId?: string;
```

產品持有的選取識別。

### onToggle

```tsx
onToggle: (id: string) => void;
```

將展開或切換意圖交回產品。

### onSelect

```tsx
onSelect: (id: string) => void;
```

將選取意圖交回產品。

### label

```tsx
label?: string;
```

顯示標籤。

<!-- reference-api:end -->

## 使用限制與關聯

- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpExplorerSection](klp-explorer-section.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/components.tsx)；來源位置不作為 consumer import。
