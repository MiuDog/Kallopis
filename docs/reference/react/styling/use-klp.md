# useKlp

React · 0.1 · 未發布 npm · 語意風格

## 主要職責

取得最近 KlpThemeProvider 的語意風格；缺少 Provider 時拋出錯誤。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { useKlp } from '@kallopis/react';

// 此元件必須位於 KlpThemeProvider 之下。
export function ProductInset() {
	const theme = useKlp();
	return <div style={{ padding: Number(theme.semantic('theme.spacing.contentInset')) }}>內容</div>;
}
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export function useKlp(): KlpTheme
```

<!-- reference-api:end -->

## 使用限制與關聯


- [KlpTheme](klp-theme.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/theme.tsx)；來源位置不作為 consumer import。
