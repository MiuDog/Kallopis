# KlpDockActionResult

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義布局操作的結果，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpDockActionResult } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpDockActionResult;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpDockActionResult {
	/** 深層不可變，與 caller 及其後續修改隔離。 */
	readonly layout: KlpDockLayoutData;
	/** 比較完整保存值，no-op 仍回傳隔離快照。 */
	readonly changed: boolean;
}
```

## 成員與方法

### layout

```tsx
readonly layout: KlpDockLayoutData;
```

深層不可變，與 caller 及其後續修改隔離。

### changed

```tsx
readonly changed: boolean;
```

比較完整保存值，no-op 仍回傳隔離快照。

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpDockLayoutData](klp-dock-layout-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/dock-layout-operations.ts)；來源位置不作為 consumer import。
