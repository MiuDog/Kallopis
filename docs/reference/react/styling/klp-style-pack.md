# KlpStylePack

React · 0.1 · 未發布 npm · 語意風格

## 主要職責

定義完整且不可變的風格包，供產品與公開 API 共用。

## 公開入口

- `@kallopis/react`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```tsx
import { type KlpStylePack } from '@kallopis/react';

// 產品資料沿用公開型別，避免維護第二份資料契約。
type ProductValue = KlpStylePack;
```

<!-- reference-api:start -->

## 公開簽名

```tsx
export interface KlpStylePack extends KlpStyleIdentity {

	/** schemaVersion：只接受已支援的交換版本。 */
	schemaVersion: 1;
	/** primitives：值原料，不擁有用途或數值安全界限。 */
	primitives: Record<string, KlpStylePrimitive>;
	/** semantics：用途對應四 mode 的安全表達式。 */
	semantics: Record<string, Record<KlpStyleMode, string>>;
	/** recipes：視覺配方及繼承，不包含事件或行為。 */
	recipes: Record<string, KlpStyleRecipe>;
	/** descriptions：保留文件說明，不複製風格值。 */
	primitiveDescriptions: Record<string, string>;
	semanticDescriptions: Record<string, string>;
}
```

## 成員與方法

### schemaVersion

```tsx
schemaVersion: 1;
```

schemaVersion：只接受已支援的交換版本。

### primitives

```tsx
primitives: Record<string, KlpStylePrimitive>;
```

primitives：值原料，不擁有用途或數值安全界限。

### semantics

```tsx
semantics: Record<string, Record<KlpStyleMode, string>>;
```

semantics：用途對應四 mode 的安全表達式。

### recipes

```tsx
recipes: Record<string, KlpStyleRecipe>;
```

recipes：視覺配方及繼承，不包含事件或行為。

### primitiveDescriptions

```tsx
primitiveDescriptions: Record<string, string>;
```

descriptions：保留文件說明，不複製風格值。

### semanticDescriptions

```tsx
semanticDescriptions: Record<string, string>;
```



### id

```tsx
id: string
```

id：風格身份，與元件或產品身份分離。

### version

```tsx
version: string
```

version：風格資料版本，不是交換 schema 版本。

<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../react/src/style-runtime/index.d.mts)；來源位置不作為 consumer import。
