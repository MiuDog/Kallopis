# KlpRegisteredCommandPalette

React · 0.1 · 未發布 npm · 操作元件

## 主要職責

在受控開啟狀態下搜尋、選取並執行 registry 命令。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import type { ComponentProps } from 'react';
import { KlpRegisteredCommandPalette } from '@kallopis/react';

// 產品提供下表列出的必要 props；在 KlpThemeProvider 內呈現。
export function Example(props: ComponentProps<typeof KlpRegisteredCommandPalette>) {
	return <KlpRegisteredCommandPalette {...props} />;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpRegisteredCommandPalette<C = unknown>(props: KlpRegisteredCommandPaletteProps<C>): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `registry` | `KlpCommandRegistry<C>` | 是 | — | 借用共用命令登錄表。 |
| `getContext` | `() => C` | 是 | — | 取得當次產品執行上下文。 |
| `open` | `boolean` | 是 | — | 產品持有的開啟狀態。 |
| `label` | `string` | 是 | — | 顯示標籤。 |
| `searchLabel` | `string` | 是 | — | 依公開型別提供此輸入。 |
| `emptyLabel` | `string` | 是 | — | 依公開型別提供此輸入。 |
| `onResult` | `(result: KlpCommandExecutionResult) => void` | 是 | — | 接收執行結果。 |
| `onDismiss` | `(reason: KlpCommandDismissReason) => void` | 是 | — | 向產品提出關閉意圖。 |
| `id` | `string \| undefined` | 否 | undefined | 穩定識別，用於查詢或回報。 |
| `className` | `string \| undefined` | 否 | undefined | 外部宿主 class；不取代內部語意樣式。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [React 專屬元件展示](../../../../guides/react/17-klp-button.md)：跨元件使用流程。
- [React 命令面板](../../../../guides/react/13-klp-registered-command-palette.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpCommandDismissReason](../../types/klp-command-dismiss-reason.md)
- [KlpCommandExecutionResult](../../types/klp-command-execution-result.md)
- [KlpCommandRegistry](../../controllers/klp-command-registry.md)
- [KlpRegisteredCommandPaletteProps](../../types/klp-registered-command-palette-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/command-palette.tsx)；來源位置不作為 consumer import。
