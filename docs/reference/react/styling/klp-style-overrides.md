# KlpStyleOverrides

React · 0.1 · 未發布 npm · 語意風格

## 主要職責

定義對正式 primitive／semantic 的局部覆寫，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpStyleOverrides } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpStyleOverrides;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpStyleOverrides {

	/** primitives：只可替換已有原料，所有 mode 都必須重新驗證。 */
	primitives?: Record<string, KlpStylePrimitive>;
	/** semantics：只可覆寫已有用途的部分 mode，不新增身份。 */
	semantics?: Record<string, Partial<Record<KlpStyleMode, string>>>;
}
```

## 成員與方法

### primitives

```tsx
primitives?: Record<string, KlpStylePrimitive>;
```

primitives：只可替換已有原料，所有 mode 都必須重新驗證。

### semantics

```tsx
semantics?: Record<string, Partial<Record<KlpStyleMode, string>>>;
```

semantics：只可覆寫已有用途的部分 mode，不新增身份。

<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/style-runtime/index.d.mts)；來源位置不作為 consumer import。
