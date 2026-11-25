# KlpModernProductivityPanel

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義現代生產力布局的功能面板，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpModernProductivityPanel } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpModernProductivityPanel;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpModernProductivityPanel {
	/* id：重排及切換的穩定身分；label：按鈕的文字與可存取名稱；content：原生產品內容。 */
	readonly id: string;
	readonly label: string;
	readonly content: ReactNode;
}
```

## 成員與方法

### id

```tsx
readonly id: string;
```

穩定識別，用於查詢或回報。

### label

```tsx
readonly label: string;
```

顯示標籤。

### content

```tsx
readonly content: ReactNode;
```



<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/modern-productivity-layout.tsx)；來源位置不作為 consumer import。
