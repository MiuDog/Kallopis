# KlpCommandExecutionResult

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義命令執行的結果聯集，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpCommandExecutionResult } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpCommandExecutionResult;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export type KlpCommandExecutionResult =
	/* commandId 保留執行目標；status 決定 value 或 error/phase 的合法可達性。 */
	| Readonly<{ commandId: string; status: 'executed'; value: unknown }>
	| Readonly<{ commandId: string; status: 'missing' | 'hidden' | 'disabled' | 'busy' | 'disposed' }>
	| Readonly<{ commandId: string; status: 'error'; error: unknown; phase: 'condition' | 'handler' }>;
```

## 成員與方法

### commandId

```tsx
commandId: string
```



### status

```tsx
status: "busy" | "disabled" | "disposed" | "error" | "executed" | "hidden" | "missing"
```



<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-registry.ts)；來源位置不作為 consumer import。
