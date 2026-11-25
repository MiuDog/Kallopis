# KlpCommandState

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義命令目前的 visible、enabled、checked 與 running 狀態，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpCommandState } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpCommandState;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpCommandState {
	/* metadata 為本次唯讀快照；keywords 複製凍結，icon 不凍結產品物件。 */
	readonly id: string;
	readonly label: string;
	readonly description?: string;
	readonly category?: string;
	readonly keywords: readonly string[];
	readonly icon?: ReactNode;
	/* visible/enabled/checked 是最新條件；running 屬於註冊 token；conditionError 保留失敗。 */
	readonly visible: boolean;
	readonly enabled: boolean;
	readonly checked: boolean;
	readonly running: boolean;
	readonly conditionError: KlpCommandConditionError | null;
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
readonly keywords: readonly string[];
```

搜尋關鍵字。

### icon

```tsx
readonly icon?: ReactNode;
```

操作或內容圖示。

### visible

```tsx
readonly visible: boolean;
```



### enabled

```tsx
readonly enabled: boolean;
```



### checked

```tsx
readonly checked: boolean;
```



### running

```tsx
readonly running: boolean;
```



### conditionError

```tsx
readonly conditionError: KlpCommandConditionError | null;
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpCommandConditionError](klp-command-condition-error.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-registry.ts)；來源位置不作為 consumer import。
