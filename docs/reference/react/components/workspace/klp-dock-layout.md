# KlpDockLayout

React · 0.1 · 未發布 npm · 工作區元件

## 主要職責

呈現受控停靠布局，將操作意圖交回產品更新布局資料。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import type { ComponentProps } from 'react';
import { KlpDockLayout } from '@kallopis/react';

// 產品提供下表列出的必要 props；在 KlpThemeProvider 內呈現。
export function Example(props: ComponentProps<typeof KlpDockLayout>) {
	return <KlpDockLayout {...props} />;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpDockLayout(props: KlpDockLayoutProps): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `layout` | `KlpDockLayoutData` | 是 | — | layout 是唯一保存權威；panels 提供當前清冊；stage／contentHeader 是產品內容槽。 |
| `panels` | `readonly KlpDockPanel[]` | 是 | — | 依公開型別提供此輸入。 |
| `stage` | `ReactNode` | 是 | — | 依公開型別提供此輸入。 |
| `contentHeader` | `ReactNode` | 否 | undefined | 依公開型別提供此輸入。 |
| `leftConstraints` | `KlpDockAreaConstraints` | 是 | — | 三區限制屬於產品邏輯；缺省 Bottom 僅允許隱藏且空，實際配額另由有限宿主解算。 |
| `rightConstraints` | `KlpDockAreaConstraints` | 是 | — | 依公開型別提供此輸入。 |
| `bottomConstraints` | `KlpDockAreaConstraints \| undefined` | 否 | undefined | 依公開型別提供此輸入。 |
| `collapseThresholds` | `Partial<Record<KlpDockArea, number>> \| undefined` | 否 | undefined | collapseThresholds 是產品拖移收合門檻，缺省0；不回寫低於門檻的小尺寸。 |
| `onLayoutChanged` | `(layout: KlpDockLayoutData) => void` | 是 | — | changed 才通知一次；onCloseError 讓產品呈現批准錯誤，未提供則交宿主。 |
| `onCloseError` | `((error: unknown, panelId: string) => void) \| undefined` | 否 | undefined | 依公開型別提供此輸入。 |
| `label` | `string \| undefined` | 否 | undefined | label／areaLabels 是可及與本地化名称；ref 指向有限布局宿主。 |
| `areaLabels` | `Partial<Record<KlpDockArea, string>> \| undefined` | 否 | undefined | 依公開型別提供此輸入。 |
| `ref` | `Ref<HTMLDivElement> \| undefined` | 否 | undefined | 存取公開的原生宿主。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [React Dock 元件](../../../../guides/react/10-klp-dock-layout.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpDockArea](../../types/klp-dock-area.md)
- [KlpDockAreaConstraints](../../types/klp-dock-area-constraints.md)
- [KlpDockLayoutData](../../types/klp-dock-layout-data.md)
- [KlpDockLayoutProps](../../types/klp-dock-layout-props.md)
- [KlpDockPanel](../../types/klp-dock-panel.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/workbench-dock.tsx)；來源位置不作為 consumer import。
