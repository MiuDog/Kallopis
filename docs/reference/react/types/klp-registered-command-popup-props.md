# KlpRegisteredCommandPopupProps

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義 KlpRegisteredCommandPopup 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpRegisteredCommandPopupProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpRegisteredCommandPopupProps<unknown>;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpRegisteredCommandPopupProps<C = unknown> extends Pick<KlpRegisteredCommandMenuProps<C>, 'registry' | 'getContext' | 'items' | 'label' | 'emptyLabel' | 'onResult' | 'className' | 'id'> {

	/* menu 欄位沿公開契約；open 保留產品開關權威；anchor 由產品更新；onDismiss 僅回傳意圖。 */
	open: boolean;
	anchor: KlpCommandPopupAnchor;
	onDismiss: (reason: KlpCommandPopupDismissReason) => void;
}
```

## 成員與方法

### open

```tsx
open: boolean;
```

產品持有的開啟狀態。

### anchor

```tsx
anchor: KlpCommandPopupAnchor;
```



### onDismiss

```tsx
onDismiss: (reason: KlpCommandPopupDismissReason) => void;
```

向產品提出關閉意圖。

### registry

```tsx
registry: KlpCommandRegistry<C>
```

借用共用命令登錄表。

### getContext

```tsx
getContext: () => C
```

取得當次產品執行上下文。

### items

```tsx
items: readonly KlpCommandReference[]
```

由產品提供的項目。

### label

```tsx
label: string
```

顯示標籤。

### onResult

```tsx
onResult: (result: KlpCommandExecutionResult) => void
```

接收執行結果。

### className

```tsx
className?: string | undefined
```

外部宿主 class；不取代內部語意樣式。

### id

```tsx
id?: string | undefined
```

穩定識別，用於查詢或回報。

### emptyLabel

```tsx
emptyLabel: string
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpCommandExecutionResult](klp-command-execution-result.md)
- [KlpCommandPopupAnchor](klp-command-popup-anchor.md)
- [KlpCommandPopupDismissReason](klp-command-popup-dismiss-reason.md)
- [KlpCommandReference](klp-command-reference.md)
- [KlpCommandRegistry](../controllers/klp-command-registry.md)
- [KlpRegisteredCommandMenuProps](klp-registered-command-menu-props.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-popup.tsx)；來源位置不作為 consumer import。
