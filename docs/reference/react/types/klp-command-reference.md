# KlpCommandReference

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義命令入口引用的 ID 與呈現種類，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpCommandReference } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpCommandReference;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpCommandReference {
	/* commandId 引用registry；kind 只決定原生呈現語意，不擁有handler或狀態。 */
	readonly commandId: string;
	readonly kind?: 'action' | 'toggle';
}
```

## 成員與方法

### commandId

```tsx
readonly commandId: string;
```



### kind

```tsx
readonly kind?: 'action' | 'toggle';
```



<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-entries.tsx)；來源位置不作為 consumer import。
