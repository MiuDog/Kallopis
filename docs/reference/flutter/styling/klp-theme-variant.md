# KlpThemeVariant

Flutter · Stable · 語意風格

## 主要職責

內建主題變體的識別；透明度能力與宿主視窗仍由產品決定。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

final value = KlpThemeVariant.dark;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpThemeVariant
```

## 建構子 KlpThemeVariant



```dart
const KlpThemeVariant()
```



## 成員與方法

### dark

```dart
static const KlpThemeVariant dark
```



### light

```dart
static const KlpThemeVariant light
```



### transparent

```dart
static const KlpThemeVariant transparent
```



### ultraDark

```dart
static const KlpThemeVariant ultraDark
```



<!-- reference-api:end -->

## 使用限制與關聯

- [匯入共通風格檔](../../../guides/flutter/01-klp-style-pack.md)：跨元件使用流程。
- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_theme_variant.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_theme_variant.dart`。
