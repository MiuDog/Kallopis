# KlpStylePack

Flutter · Stable · 語意風格

## 主要職責

不可變的共通風格交換資料；不持有產品 tree、handler 或布局狀態。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpStylePack createExample() => KlpStylePack.defaults();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpStylePack
```

## 建構子 KlpStylePack.defaults



```dart
KlpStylePack.defaults()
```



## 建構子 KlpStylePack.parse



```dart
KlpStylePack.parse(Object? input)
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `input` | `Object?` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### applyOverrides

```dart
KlpStylePack applyOverrides(Map<String, Object?> overrides)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `overrides` | `Map<String, Object?>` | 是 | — | 依公開型別提供此輸入。 |


### data

```dart
final Map<String, Object?> data
```

data：與 caller 隔離的完整交換資料及配方原文。

### resolve

```dart
Map<String, Object?> resolve(KlpThemeVariant variant)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `variant` | `KlpThemeVariant` | 是 | — | 依公開型別提供此輸入。 |


### toVisualStyle

```dart
KlpVisualStyle toVisualStyle(KlpThemeVariant variant)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `variant` | `KlpThemeVariant` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [匯入共通風格檔](../../../guides/flutter/01-klp-style-pack.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpThemeVariant](klp-theme-variant.md)
- [KlpVisualStyle](klp-visual-style.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/style_pack/klp_style_pack.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/style_pack/klp_style_pack.dart`。
