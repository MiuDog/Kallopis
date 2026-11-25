# KlpLayoutLinearProps

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義 KlpLayoutLinear 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpLayoutLinearProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpLayoutLinearProps;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpLayoutLinearProps extends KlpLayoutPaneProps {
	spacing?: 'standard' | 'none';
	alignment?: 'start' | 'end';
	/** fill 需要 enclosing definite CSS 尺寸；content 明確要求自然主軸。 */
	sizing?: 'fill' | 'content';
}
```

## 成員與方法

### spacing

```tsx
spacing?: 'standard' | 'none';
```



### alignment

```tsx
alignment?: 'start' | 'end';
```



### sizing

```tsx
sizing?: 'fill' | 'content';
```

fill 需要 enclosing definite CSS 尺寸；content 明確要求自然主軸。

### flex

```tsx
flex?: number | undefined
```

flex 與 bounds 是父 compound 的主軸限制，沒有產品狀態。

### bounds

```tsx
bounds?: KlpLayoutBounds | undefined
```



### ref

```tsx
ref?: Ref<HTMLDivElement> | undefined
```

存取公開的原生宿主。

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpLayoutBounds](klp-layout-bounds.md)
- [KlpLayoutPaneProps](klp-layout-pane-props.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/workbench-layout.tsx)；來源位置不作為 consumer import。
