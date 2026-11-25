# KlpCommandPopupAnchor

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義viewport 中的錨定矩形，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpCommandPopupAnchor } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpCommandPopupAnchor;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpCommandPopupAnchor {

	/* x/y 是同視窗邏輯 viewport 座標；width/height 為非負尺寸，零尺寸表示 context point。 */
	readonly x: number;
	readonly y: number;
	readonly width: number;
	readonly height: number;
}
```

## 成員與方法

### x

```tsx
readonly x: number;
```



### y

```tsx
readonly y: number;
```



### width

```tsx
readonly width: number;
```



### height

```tsx
readonly height: number;
```



<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-popup.tsx)；來源位置不作為 consumer import。
