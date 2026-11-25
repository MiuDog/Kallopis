# KlpRegisteredCommandToolbar

React · 0.1 · 未發布 npm · 操作元件

## 主要職責

依產品排列呈現 registry 命令，維持命令狀態與啟動入口一致。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import type { ComponentProps } from 'react';
import { KlpRegisteredCommandToolbar } from '@kallopis/react';

// 產品提供下表列出的必要 props；在 KlpThemeProvider 內呈現。
export function Example(props: ComponentProps<typeof KlpRegisteredCommandToolbar>) {
	return <KlpRegisteredCommandToolbar {...props} />;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpRegisteredCommandToolbar<C = unknown>(props: KlpRegisteredCommandToolbarProps<C>): import("react").JSX.Element
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `registry` | `KlpCommandRegistry<C>` | 是 | — | 借用共用命令登錄表。 |
| `getContext` | `() => C` | 是 | — | 取得當次產品執行上下文。 |
| `items` | `readonly KlpCommandReference[]` | 是 | — | 由產品提供的項目。 |
| `label` | `string` | 是 | — | 顯示標籤。 |
| `onResult` | `(result: KlpCommandExecutionResult) => void` | 是 | — | 接收執行結果。 |
| `className` | `string \| undefined` | 否 | undefined | 外部宿主 class；不取代內部語意樣式。 |
| `id` | `string \| undefined` | 否 | undefined | 穩定識別，用於查詢或回報。 |
| `style` | `CSSProperties \| undefined` | 否 | undefined | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [React 命令工具列與選單](../../../../guides/react/12-klp-registered-command-toolbar.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpCommandExecutionResult](../../types/klp-command-execution-result.md)
- [KlpCommandReference](../../types/klp-command-reference.md)
- [KlpCommandRegistry](../../controllers/klp-command-registry.md)
- [KlpRegisteredCommandToolbarProps](../../types/klp-registered-command-toolbar-props.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/command-entries.tsx)；來源位置不作為 consumer import。
