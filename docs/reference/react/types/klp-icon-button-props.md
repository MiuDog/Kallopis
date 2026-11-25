# KlpIconButtonProps

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義 KlpIconButton 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpIconButtonProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpIconButtonProps;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpIconButtonProps extends Omit<KlpButtonProps, 'tone'> {
	label: string;
	tone?: 'standalone' | 'inline' | 'window';
}
```

## 成員與方法

### label

```tsx
label: string;
```

顯示標籤。

### tone

```tsx
tone?: 'standalone' | 'inline' | 'window';
```

選擇語意呈現。

### size

```tsx
size?: "lg" | "md" | "sm" | "xl" | "xs" | undefined
```

尺寸選擇。

### selected

```tsx
selected?: boolean | undefined
```

由產品持有的選取狀態。

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpButtonProps](klp-button-props.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/components.tsx)；來源位置不作為 consumer import。
