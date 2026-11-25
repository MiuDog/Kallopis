# KlpCardProps

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義 KlpCard 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpCardProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpCardProps;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpCardProps extends KlpSurfaceProps {
	header?: ReactNode;
	footer?: ReactNode;
}
```

## 成員與方法

### header

```tsx
header?: ReactNode;
```

標頭內容。

### footer

```tsx
footer?: ReactNode;
```

頁尾內容。

### tone

```tsx
tone?: "base" | "component" | "inset" | "muted" | "raised" | "stage" | undefined
```

選擇語意呈現。

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpSurfaceProps](klp-surface-props.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/components.tsx)；來源位置不作為 consumer import。
