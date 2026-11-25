# KlpRegisteredCommandMenuProps

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義 KlpRegisteredCommandMenu 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpRegisteredCommandMenuProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpRegisteredCommandMenuProps<unknown>;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpRegisteredCommandMenuProps<C = unknown> extends KlpRegisteredCommandToolbarProps<C> {
	/* emptyLabel 為產品空清冊文案；autoFocus 可明確取得初始焦點；onDismiss 交彈出宿主管理關閉。 */
	emptyLabel: string;
	autoFocus?: boolean;
	onDismiss?: () => void;
}
```

## 成員與方法

### emptyLabel

```tsx
emptyLabel: string;
```



### autoFocus

```tsx
autoFocus?: boolean;
```



### onDismiss

```tsx
onDismiss?: () => void;
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

### style

```tsx
style?: CSSProperties | undefined
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpCommandExecutionResult](klp-command-execution-result.md)
- [KlpCommandReference](klp-command-reference.md)
- [KlpCommandRegistry](../controllers/klp-command-registry.md)
- [KlpRegisteredCommandToolbarProps](klp-registered-command-toolbar-props.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-entries.tsx)；來源位置不作為 consumer import。
