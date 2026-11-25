# resolveKlpLinearLayout

React · 0.1 · 未發布 npm · 工具函式

## 主要職責

按 minimum、preferred、maximum 與 flex 在有限主軸上分配尺寸。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { resolveKlpLinearLayout } from '@kallopis/react';

const layout = resolveKlpLinearLayout({
	extent: 800,
	gutter: 0,
	gutterCount: 0,
	items: [{ minimum: 100, preferred: 200, maximum: 600, flex: 1 }],
});
// gutter 為此示例的無間距布局；產品有間距時從當前 theme 取值。
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function resolveKlpLinearLayout(input: {
	readonly extent: number;
	readonly gutter: number;
	readonly gutterCount: number;
	readonly items: readonly KlpLinearItem[];
}): KlpLinearLayoutResult
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `input` | `{<br>	readonly extent: number;<br>	readonly gutter: number;<br>	readonly gutterCount: number;<br>	readonly items: readonly KlpLinearItem[];<br>}` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯


- [KlpLinearItem](../types/klp-linear-item.md)
- [KlpLinearLayoutResult](../types/klp-linear-layout-result.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/linear-layout.ts)；來源位置不作為 consumer import。
