# KlpRegisteredCommandPaletteProps

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義 KlpRegisteredCommandPalette 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpRegisteredCommandPaletteProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpRegisteredCommandPaletteProps<unknown>;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpRegisteredCommandPaletteProps<C = unknown> {
	/* registry/context 是產品權威；open 為產品受控的 modal 生命週期。 */
	registry: KlpCommandRegistry<C>;
	getContext: () => C;
	open: boolean;
	/* 三個名稱由產品本地化；callback 保留原結果與明確關閉理由。 */
	label: string;
	searchLabel: string;
	emptyLabel: string;
	onResult: (result: KlpCommandExecutionResult) => void;
	onDismiss: (reason: KlpCommandDismissReason) => void;
	/* id/className 只標識原生宿主，不建立第二份內部風格。 */
	id?: string;
	className?: string;
}
```

## 成員與方法

### registry

```tsx
registry: KlpCommandRegistry<C>;
```

借用共用命令登錄表。

### getContext

```tsx
getContext: () => C;
```

取得當次產品執行上下文。

### open

```tsx
open: boolean;
```

產品持有的開啟狀態。

### label

```tsx
label: string;
```

顯示標籤。

### searchLabel

```tsx
searchLabel: string;
```



### emptyLabel

```tsx
emptyLabel: string;
```



### onResult

```tsx
onResult: (result: KlpCommandExecutionResult) => void;
```

接收執行結果。

### onDismiss

```tsx
onDismiss: (reason: KlpCommandDismissReason) => void;
```

向產品提出關閉意圖。

### id

```tsx
id?: string;
```

穩定識別，用於查詢或回報。

### className

```tsx
className?: string;
```

外部宿主 class；不取代內部語意樣式。

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpCommandDismissReason](klp-command-dismiss-reason.md)
- [KlpCommandExecutionResult](klp-command-execution-result.md)
- [KlpCommandRegistry](../controllers/klp-command-registry.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-palette.tsx)；來源位置不作為 consumer import。
