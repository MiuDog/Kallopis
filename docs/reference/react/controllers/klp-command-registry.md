# KlpCommandRegistry

React · 0.1 · 未發布 npm · 控制與生命週期

## 主要職責

集中命令註冊、狀態查詢、執行與通知；不擁有產品 context 或業務副作用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { KlpCommandRegistry } from '@kallopis/react';

const commands = new KlpCommandRegistry<{ canSave: boolean }>();
const unregister = commands.register({
	id: 'document.save',
	label: '儲存',
	isEnabled: context => context.canSave,
	handler: () => { /* 接入產品儲存流程。 */ },
});
const result = await commands.execute('document.save', { canSave: true });
// 產品卸載時，由擁有者釋放。
unregister();
commands.dispose();
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export class KlpCommandRegistry<C = unknown>
```

## 建構子 constructor



```tsx
constructor(private readonly onObserverError?: (error: unknown) => void)
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `onObserverError` | `(error: unknown) => void` | 否 | undefined | 依公開型別提供此輸入。 |


## 成員與方法

### version

```tsx
get version(): number
```



### isDisposed

```tsx
get isDisposed(): boolean
```



### register

```tsx
register(definition: KlpCommandDefinition<C>): () => void
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `definition` | `KlpCommandDefinition<C>` | 是 | — | 依公開型別提供此輸入。 |


### getState

```tsx
getState(id: string, context: C): KlpCommandState | null
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | — | 穩定識別，用於查詢或回報。 |
| `context` | `C` | 是 | — | 依公開型別提供此輸入。 |


### list

```tsx
list(context: C): readonly KlpCommandState[]
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `C` | 是 | — | 依公開型別提供此輸入。 |


### execute

```tsx
async execute(id: string, context: C): Promise<KlpCommandExecutionResult>
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | — | 穩定識別，用於查詢或回報。 |
| `context` | `C` | 是 | — | 依公開型別提供此輸入。 |


### subscribe

```tsx
subscribe(listener: () => void): () => void
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `listener` | `() => void` | 是 | — | 依公開型別提供此輸入。 |


### refresh

```tsx
refresh(): void
```



### dispose

```tsx
dispose(): void
```

釋放此物件擁有的資源；由建立者管理生命週期。

<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 快捷鍵純核心](../../../guides/react/15-klp-command-keymap.md)：跨元件使用流程。
- [React 命令核心](../../../guides/react/11-klp-command-registry.md)：跨元件使用流程。

- [KlpCommandDefinition](../types/klp-command-definition.md)
- [KlpCommandExecutionResult](../types/klp-command-execution-result.md)
- [KlpCommandState](../types/klp-command-state.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-registry.ts)；來源位置不作為 consumer import。
