# KlpCommandKeymapOptions

React · 0.1 · 未發布 npm · 資料與型別

## 主要職責

定義keymap 的平台及建立選項，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpCommandKeymapOptions } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpCommandKeymapOptions;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpCommandKeymapOptions {

	/* platform 投影 primary；chordTimeoutMs 是每一步的毫秒期限；now 可注入 monotonic clock。 */
	readonly platform?: KlpShortcutPlatform;
	readonly chordTimeoutMs?: number;
	readonly now?: () => number;
}
```

## 成員與方法

### platform

```tsx
readonly platform?: KlpShortcutPlatform;
```



### chordTimeoutMs

```tsx
readonly chordTimeoutMs?: number;
```



### now

```tsx
readonly now?: () => number;
```



<!-- reference-api:end -->

## 使用限制與關聯


- [KlpShortcutPlatform](klp-shortcut-platform.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/command-keymap.ts)；來源位置不作為 consumer import。
