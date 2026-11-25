# KlpModernProductivityLayoutProps

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義 KlpModernProductivityLayout 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpModernProductivityLayoutProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpModernProductivityLayoutProps;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpModernProductivityLayoutProps {
	/* panels：有序功能；selectedId：產品選取；onSelected：切換提案，不自行更新產品。 */
	panels: readonly KlpModernProductivityPanel[];
	selectedId: string;
	onSelected?: ((id: string) => void) | null;
	/* header／stage：右區角色；sidebarWidth：可選期望寬度，省略時使用正式語意。 */
	header: ReactNode;
	stage: ReactNode;
	sidebarWidth?: number;
}
```

## 成員與方法

### panels

```tsx
panels: readonly KlpModernProductivityPanel[];
```



### selectedId

```tsx
selectedId: string;
```

產品持有的選取識別。

### onSelected

```tsx
onSelected?: ((id: string) => void) | null;
```

將選取意圖交回產品。

### header

```tsx
header: ReactNode;
```

標頭內容。

### stage

```tsx
stage: ReactNode;
```



### sidebarWidth

```tsx
sidebarWidth?: number;
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpModernProductivityPanel](klp-modern-productivity-panel.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/modern-productivity-layout.tsx)；來源位置不作為 consumer import。
