# KlpCommandKeymap

React · 0.1 · 未發布 npm · 控制與生命週期

## 主要職責

將快捷鍵、作用域及產品覆寫對應到同一 registry 的命令。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { KlpCommandKeymap } from '@kallopis/react';

const create = (...args: ConstructorParameters<typeof KlpCommandKeymap>) => new KlpCommandKeymap(...args);
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export class KlpCommandKeymap<C = unknown>
```

## 建構子 constructor



```tsx
constructor(registry: KlpCommandRegistry<C>, options: KlpCommandKeymapOptions = {})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `registry` | `KlpCommandRegistry<C>` | 是 | — | 借用共用命令登錄表。 |
| `options` | `KlpCommandKeymapOptions` | 否 | {} | 依公開型別提供此輸入。 |


## 成員與方法

### platform

```tsx
readonly platform: KlpShortcutPlatform;
```



### chordTimeoutMs

```tsx
readonly chordTimeoutMs: number;
```



### isDisposed

```tsx
get isDisposed(): boolean
```



### isRecording

```tsx
get isRecording(): boolean
```



### pendingSequence

```tsx
get pendingSequence(): readonly KlpShortcutStroke[]
```



### recordedSequence

```tsx
get recordedSequence(): readonly KlpShortcutStroke[]
```



### register

```tsx
register(binding: KlpShortcutBinding<C>): () => void
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `binding` | `KlpShortcutBinding<C>` | 是 | — | 依公開型別提供此輸入。 |


### handle

```tsx
handle(input: KlpShortcutInput, focus: KlpShortcutFocus, context: C): KlpShortcutHandling
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `input` | `KlpShortcutInput` | 是 | — | 依公開型別提供此輸入。 |
| `focus` | `KlpShortcutFocus` | 是 | — | 依公開型別提供此輸入。 |
| `context` | `C` | 是 | — | 依公開型別提供此輸入。 |


### cancelChord

```tsx
cancelChord(): boolean
```



### expireChord

```tsx
expireChord(): boolean
```



### conflicts

```tsx
conflicts(focus: KlpShortcutFocus, context: C): readonly KlpShortcutConflict[]
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `focus` | `KlpShortcutFocus` | 是 | — | 依公開型別提供此輸入。 |
| `context` | `C` | 是 | — | 依公開型別提供此輸入。 |


### setOverride

```tsx
setOverride(id: string, sequence: readonly KlpShortcutStroke[] | null): void
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | — | 穩定識別，用於查詢或回報。 |
| `sequence` | `readonly KlpShortcutStroke[] \| null` | 是 | — | 依公開型別提供此輸入。 |


### restore

```tsx
restore(id: string): void
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | — | 穩定識別，用於查詢或回報。 |


### exportOverrides

```tsx
exportOverrides(): KlpShortcutOverrides
```



### importOverrides

```tsx
importOverrides(value: unknown): void
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `value` | `unknown` | 是 | — | 目前值。 |


### beginRecording

```tsx
beginRecording(focusId: string): void
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `focusId` | `string` | 是 | — | 依公開型別提供此輸入。 |


### finishRecording

```tsx
finishRecording(): readonly KlpShortcutStroke[]
```



### cancelRecording

```tsx
cancelRecording(): void
```



### dispose

```tsx
dispose(): void
```

釋放此物件擁有的資源；由建立者管理生命週期。

<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 快捷鍵純核心](../../../guides/react/15-klp-command-keymap.md)：跨元件使用流程。

- [KlpCommandKeymapOptions](../types/klp-command-keymap-options.md)
- [KlpCommandRegistry](klp-command-registry.md)
- [KlpShortcutBinding](../types/klp-shortcut-binding.md)
- [KlpShortcutConflict](../types/klp-shortcut-conflict.md)
- [KlpShortcutFocus](../types/klp-shortcut-focus.md)
- [KlpShortcutHandling](../types/klp-shortcut-handling.md)
- [KlpShortcutInput](../types/klp-shortcut-input.md)
- [KlpShortcutOverrides](../types/klp-shortcut-overrides.md)
- [KlpShortcutPlatform](../types/klp-shortcut-platform.md)
- [KlpShortcutStroke](../types/klp-shortcut-stroke.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-keymap.ts)；來源位置不作為 consumer import。
