# KlpDockGeometry

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義解析後的 Dock 區域幾何，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockGeometry } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockGeometry;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockGeometry {
	readonly stage: KlpDockRect;
	readonly left: KlpDockRect | null;
	readonly right: KlpDockRect | null;
	readonly bottom: KlpDockRect | null;
	readonly header: KlpDockRect | null;
	/** 隱藏區仍保留有限邊緣 reopen handle，不保留正文配額。 */
	readonly leftHandle: KlpDockRect;
	readonly rightHandle: KlpDockRect;
	readonly bottomHandle: KlpDockRect;
	/** 實際 viewport 預算；UI 提交仍須與邏輯 min/max 求交集。 */
	readonly maximumLeft: number;
	readonly maximumRight: number;
	readonly maximumBottom: number;
}
```

## 成員與方法

### stage

```tsx
readonly stage: KlpDockRect;
```



### left

```tsx
readonly left: KlpDockRect | null;
```



### right

```tsx
readonly right: KlpDockRect | null;
```



### bottom

```tsx
readonly bottom: KlpDockRect | null;
```



### header

```tsx
readonly header: KlpDockRect | null;
```

標頭內容。

### leftHandle

```tsx
readonly leftHandle: KlpDockRect;
```

隱藏區仍保留有限邊緣 reopen handle，不保留正文配額。

### rightHandle

```tsx
readonly rightHandle: KlpDockRect;
```



### bottomHandle

```tsx
readonly bottomHandle: KlpDockRect;
```



### maximumLeft

```tsx
readonly maximumLeft: number;
```

實際 viewport 預算；UI 提交仍須與邏輯 min/max 求交集。

### maximumRight

```tsx
readonly maximumRight: number;
```



### maximumBottom

```tsx
readonly maximumBottom: number;
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpDockRect](klp-dock-rect.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-geometry.ts)；來源位置不作為 consumer import。
