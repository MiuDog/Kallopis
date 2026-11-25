# KlpCommandShortcutHostProps

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義 KlpCommandShortcutHost 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpCommandShortcutHostProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpCommandShortcutHostProps<unknown>;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpCommandShortcutHostProps<C = unknown> {

	/* keymap 借用解析權威；getContext／getFocus 投影當次產品資料及原生 target，不保存第二份產品狀態。 */
	readonly keymap: KlpCommandKeymap<C>;
	readonly getContext: () => C;
	readonly getFocus: (target: EventTarget | null) => KlpShortcutFocus;
	/* onHandling 回原解析結果供產品呈現；onResult 回原 execution；children 保留原生結構與布局。 */
	readonly onHandling: (handling: KlpShortcutHandling) => void;
	readonly onResult: (result: KlpCommandExecutionResult) => void;
	readonly children: ReactNode;
}
```

## 成員與方法

### keymap

```tsx
readonly keymap: KlpCommandKeymap<C>;
```



### getContext

```tsx
readonly getContext: () => C;
```

取得當次產品執行上下文。

### getFocus

```tsx
readonly getFocus: (target: EventTarget | null) => KlpShortcutFocus;
```



### onHandling

```tsx
readonly onHandling: (handling: KlpShortcutHandling) => void;
```



### onResult

```tsx
readonly onResult: (result: KlpCommandExecutionResult) => void;
```

接收執行結果。

### children

```tsx
readonly children: ReactNode;
```

產品提供的子內容。

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpCommandExecutionResult](klp-command-execution-result.md)
- [KlpCommandKeymap](../controllers/klp-command-keymap.md)
- [KlpShortcutFocus](klp-shortcut-focus.md)
- [KlpShortcutHandling](klp-shortcut-handling.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-shortcut-host.tsx)；來源位置不作為 consumer import。
