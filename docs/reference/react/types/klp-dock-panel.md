# KlpDockPanel

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義React Dock 面板的內容與識別，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockPanel } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockPanel;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockPanel extends KlpDockPanelPolicy {
	/** label／icon：分頁名稱與產品圖示；content：產品原生內容，不寫入保存資料。 */
	readonly label: string;
	readonly icon?: ReactNode;
	readonly content: ReactNode;
	/** draggable 是停靠操作能力；pinned／dirty 只呈現產品 metadata，不介入批准或排序。 */
	readonly draggable?: boolean;
	readonly isPinned?: boolean;
	readonly isDirty?: boolean;
	/** callback 批准後才移出布局；closeLabel 供產品本地化，callback 身分應保持穩定。 */
	readonly onCloseRequested?: () => boolean | Promise<boolean>;
	readonly closeLabel?: string;
}
```

## 成員與方法

### label

```tsx
readonly label: string;
```

label／icon：分頁名稱與產品圖示；content：產品原生內容，不寫入保存資料。

### icon

```tsx
readonly icon?: ReactNode;
```

操作或內容圖示。

### content

```tsx
readonly content: ReactNode;
```



### draggable

```tsx
readonly draggable?: boolean;
```

draggable 是停靠操作能力；pinned／dirty 只呈現產品 metadata，不介入批准或排序。

### isPinned

```tsx
readonly isPinned?: boolean;
```



### isDirty

```tsx
readonly isDirty?: boolean;
```



### onCloseRequested

```tsx
readonly onCloseRequested?: () => boolean | Promise<boolean>;
```

callback 批准後才移出布局；closeLabel 供產品本地化，callback 身分應保持穩定。

### closeLabel

```tsx
readonly closeLabel?: string;
```



### id

```tsx
id: string
```

清冊的原始 identity，不 trim。

### allowSide

```tsx
allowSide?: boolean | undefined
```

未提供表示允許左右區域。

### allowBottom

```tsx
allowBottom?: boolean | undefined
```

未提供表示允許下方區域。

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpDockPanelPolicy](klp-dock-panel-policy.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/workbench-dock.tsx)；來源位置不作為 consumer import。
