# KlpThemeProviderProps

React · 0.1 · 未發布 npm · 語意風格

## 主要職責

定義 KlpThemeProvider 的產品輸入與事件介面；本庫成員如下，框架繼承屬性連至官方文件。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpThemeProviderProps } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpThemeProviderProps;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpThemeProviderProps extends HTMLAttributes<HTMLDivElement> {
	mode?: KlpMode;
	/** stylePack：此 scope 的完整風格；缺省沿用正式預設。 */
	stylePack?: KlpStylePack;
}
```

## 成員與方法

### mode

```tsx
mode?: KlpMode;
```

風格模式。

### stylePack

```tsx
stylePack?: KlpStylePack;
```

stylePack：此 scope 的完整風格；缺省沿用正式預設。

<!-- reference-api:end -->

## 使用限制與關聯

- 原生事件與繼承屬性：[React DOM 元件](https://react.dev/reference/react-dom/components/common)。
- [KlpMode](klp-mode.md)
- [KlpStylePack](klp-style-pack.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/theme.tsx)；來源位置不作為 consumer import。
