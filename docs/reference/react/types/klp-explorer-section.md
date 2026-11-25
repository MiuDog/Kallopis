# KlpExplorerSection

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義Explorer section 與所含項目，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpExplorerSection } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpExplorerSection;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpExplorerSection extends KlpExplorerItem {
	items: readonly KlpExplorerItem[];
}
```

## 成員與方法

### items

```tsx
items: readonly KlpExplorerItem[];
```

由產品提供的項目。

### id

```tsx
id: string
```

穩定識別，用於查詢或回報。

### label

```tsx
label: string
```

顯示標籤。

### icon

```tsx
icon?: ReactNode
```

操作或內容圖示。

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpExplorerItem](klp-explorer-item.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/components.tsx)；來源位置不作為 consumer import。
