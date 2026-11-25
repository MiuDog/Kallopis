# KlpCommandDefinition

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義命令識別、標籤、條件與執行 handler，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpCommandDefinition } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpCommandDefinition<unknown>;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpCommandDefinition<C = unknown> {
	/* id 保留產品識別；label 為呈現名稱；description/category/keywords 供入口搜尋；icon 保持原生呈現引用。 */
	readonly id: string;
	readonly label: string;
	readonly description?: string;
	readonly category?: string;
	readonly keywords?: readonly string[];
	readonly icon?: ReactNode;
	/* handler 擁有業務；三個 predicate 每次讀 caller context，不建立狀態鏡像。 */
	readonly handler: (context: C) => unknown | PromiseLike<unknown>;
	readonly isVisible?: (context: C) => boolean;
	readonly isEnabled?: (context: C) => boolean;
	readonly isChecked?: (context: C) => boolean;
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

### description

```tsx
readonly description?: string;
```

補充描述。

### category

```tsx
readonly category?: string;
```

分類資訊。

### keywords

```tsx
readonly keywords?: readonly string[];
```

搜尋關鍵字。

### icon

```tsx
readonly icon?: ReactNode;
```

操作或內容圖示。

### handler

```tsx
readonly handler: (context: C) => unknown | PromiseLike<unknown>;
```

由產品提供的執行處理。

### isVisible

```tsx
readonly isVisible?: (context: C) => boolean;
```

依目前上下文判定是否可見。

### isEnabled

```tsx
readonly isEnabled?: (context: C) => boolean;
```

依目前上下文判定是否可啟動。

### isChecked

```tsx
readonly isChecked?: (context: C) => boolean;
```

依目前上下文判定勾選狀態。

<!-- reference-api:end -->

## 使用限制與關聯

- [React 命令核心](../../../guides/react/11-klp-command-registry.md)：跨元件使用流程。


- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-registry.ts)；來源位置不作為 consumer import。
