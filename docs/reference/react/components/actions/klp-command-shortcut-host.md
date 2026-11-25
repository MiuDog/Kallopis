# KlpCommandShortcutHost

React · 0.1 · 未發布 npm · 操作元件

## 主要職責

把原生鍵盤與焦點事件轉交既有 keymap；產品仍持有命令 registry 與上下文。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import type { ComponentProps } from 'react';
import { KlpCommandShortcutHost } from '@kallopis/react';

// 產品提供下表列出的必要 props；在 KlpThemeProvider 內呈現。
export function Example(props: ComponentProps<typeof KlpCommandShortcutHost>) {
	return <KlpCommandShortcutHost {...props} />;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function KlpCommandShortcutHost<C>(props: KlpCommandShortcutHostProps<C>): ReactNode
```

## Props 與事件

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `keymap` | `KlpCommandKeymap<C>` | 是 | — | 依公開型別提供此輸入。 |
| `getContext` | `() => C` | 是 | — | 取得當次產品執行上下文。 |
| `getFocus` | `(target: EventTarget \| null) => KlpShortcutFocus` | 是 | — | 依公開型別提供此輸入。 |
| `onHandling` | `(handling: KlpShortcutHandling) => void` | 是 | — | 依公開型別提供此輸入。 |
| `onResult` | `(result: KlpCommandExecutionResult) => void` | 是 | — | 接收執行結果。 |
| `children` | `ReactNode` | 是 | — | 產品提供的子內容。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [原生快捷鍵宿主](../../../../guides/react/16-klp-command-shortcut-host.md)：跨元件使用流程。
- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpCommandExecutionResult](../../types/klp-command-execution-result.md)
- [KlpCommandKeymap](../../controllers/klp-command-keymap.md)
- [KlpCommandShortcutHostProps](../../types/klp-command-shortcut-host-props.md)
- [KlpShortcutFocus](../../types/klp-shortcut-focus.md)
- [KlpShortcutHandling](../../types/klp-shortcut-handling.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../react/src/command-shortcut-host.tsx)；來源位置不作為 consumer import。
