# KlpDockLayoutProps

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義 KlpDockLayout 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockLayoutProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockLayoutProps;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockLayoutProps extends Omit<HTMLAttributes<HTMLDivElement>, 'children'> {
	/** layout 是唯一保存權威；panels 提供當前清冊；stage／contentHeader 是產品內容槽。 */
	layout: KlpDockLayoutData;
	panels: readonly KlpDockPanel[];
	stage: ReactNode;
	contentHeader?: ReactNode;
	/** 三區限制屬於產品邏輯；缺省 Bottom 僅允許隱藏且空，實際配額另由有限宿主解算。 */
	leftConstraints: KlpDockAreaConstraints;
	rightConstraints: KlpDockAreaConstraints;
	bottomConstraints?: KlpDockAreaConstraints;
	/** collapseThresholds 是產品拖移收合門檻，缺省0；不回寫低於門檻的小尺寸。 */
	collapseThresholds?: Partial<Record<KlpDockArea, number>>;
	/** changed 才通知一次；onCloseError 讓產品呈現批准錯誤，未提供則交宿主。 */
	onLayoutChanged: (layout: KlpDockLayoutData) => void;
	onCloseError?: (error: unknown, panelId: string) => void;
	/** label／areaLabels 是可及與本地化名称；ref 指向有限布局宿主。 */
	label?: string;
	areaLabels?: Partial<Record<KlpDockArea, string>>;
	ref?: Ref<HTMLDivElement>;
}
```

## 成員與方法

### layout

```tsx
layout: KlpDockLayoutData;
```

layout 是唯一保存權威；panels 提供當前清冊；stage／contentHeader 是產品內容槽。

### panels

```tsx
panels: readonly KlpDockPanel[];
```



### stage

```tsx
stage: ReactNode;
```



### contentHeader

```tsx
contentHeader?: ReactNode;
```



### leftConstraints

```tsx
leftConstraints: KlpDockAreaConstraints;
```

三區限制屬於產品邏輯；缺省 Bottom 僅允許隱藏且空，實際配額另由有限宿主解算。

### rightConstraints

```tsx
rightConstraints: KlpDockAreaConstraints;
```



### bottomConstraints

```tsx
bottomConstraints?: KlpDockAreaConstraints;
```



### collapseThresholds

```tsx
collapseThresholds?: Partial<Record<KlpDockArea, number>>;
```

collapseThresholds 是產品拖移收合門檻，缺省0；不回寫低於門檻的小尺寸。

### onLayoutChanged

```tsx
onLayoutChanged: (layout: KlpDockLayoutData) => void;
```

changed 才通知一次；onCloseError 讓產品呈現批准錯誤，未提供則交宿主。

### onCloseError

```tsx
onCloseError?: (error: unknown, panelId: string) => void;
```



### label

```tsx
label?: string;
```

label／areaLabels 是可及與本地化名称；ref 指向有限布局宿主。

### areaLabels

```tsx
areaLabels?: Partial<Record<KlpDockArea, string>>;
```



### ref

```tsx
ref?: Ref<HTMLDivElement>;
```

存取公開的原生宿主。

<!-- reference-api:end -->

## 使用限制與關聯

- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpDockArea](klp-dock-area.md)
- [KlpDockAreaConstraints](klp-dock-area-constraints.md)
- [KlpDockLayoutData](klp-dock-layout-data.md)
- [KlpDockPanel](klp-dock-panel.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/workbench-dock.tsx)；來源位置不作為 consumer import。
