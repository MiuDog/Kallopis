# KlpShortcutFocus

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義快捷鍵求值時的產品焦點資訊，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpShortcutFocus } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpShortcutFocus;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpShortcutFocus {

	/* focusId 是原生焦點 owner；三個 scope ID 投影有效鏈；editable 避免接管正文輸入。 */
	readonly focusId: string;
	readonly pageId?: string;
	readonly regionId?: string;
	readonly componentId?: string;
	readonly editable?: boolean;
}
```

## 成員與方法

### focusId

```tsx
readonly focusId: string;
```



### pageId

```tsx
readonly pageId?: string;
```



### regionId

```tsx
readonly regionId?: string;
```



### componentId

```tsx
readonly componentId?: string;
```



### editable

```tsx
readonly editable?: boolean;
```



<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-keymap.ts)；來源位置不作為 consumer import。
