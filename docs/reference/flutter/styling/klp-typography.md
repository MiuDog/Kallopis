# KlpTypography

Flutter · Stable · 語意風格

## 主要職責

舊版 static const 字型階梯；新元件必須改讀 context.klp.type。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpTypography.body;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpTypography
```

## 建構子 KlpTypography



```dart
KlpTypography()
```



## 成員與方法

### body

```dart
static const double body
```



### bodyFallback

```dart
static const List<String> bodyFallback
```



### bodyFamily

```dart
static const String bodyFamily
```



### bodyLineHeight

```dart
static const double bodyLineHeight
```



### bold

```dart
static const FontWeight bold
```



### caption

```dart
static const double caption
```



### captionLineHeight

```dart
static const double captionLineHeight
```



### display

```dart
static const double display
```



### displayLetterSpacing

```dart
static const double displayLetterSpacing
```



### displayLineHeight

```dart
static const double displayLineHeight
```



### editorHeading

```dart
static const double editorHeading
```



### extraBold

```dart
static const FontWeight extraBold
```



### h1

```dart
static const double h1
```



### h1LineHeight

```dart
static const double h1LineHeight
```



### h2

```dart
static const double h2
```



### h2LineHeight

```dart
static const double h2LineHeight
```



### h3

```dart
static const double h3
```



### h3LineHeight

```dart
static const double h3LineHeight
```



### h4

```dart
static const double h4
```



### h4LineHeight

```dart
static const double h4LineHeight
```



### heading

```dart
static const double heading
```



### headingSmall

```dart
static const double headingSmall
```



### headline

```dart
static const double headline
```



### hero

```dart
static const double hero
```



### labelLetterSpacing

```dart
static const double labelLetterSpacing
```



### lead

```dart
static const double lead
```



### leadLineHeight

```dart
static const double leadLineHeight
```



### medium

```dart
static const FontWeight medium
```



### micro

```dart
static const double micro
```



### microLineHeight

```dart
static const double microLineHeight
```



### monoFallback

```dart
static const List<String> monoFallback
```



### monoFamily

```dart
static const String monoFamily
```



### regular

```dart
static const FontWeight regular
```



### sansFallback

```dart
static const List<String> sansFallback
```



### sansFamily

```dart
static const String sansFamily
```



### section

```dart
static const double section
```



### semibold

```dart
static const FontWeight semibold
```



### small

```dart
static const double small
```



### sub

```dart
static const double sub
```



### subLineHeight

```dart
static const double subLineHeight
```



### title

```dart
static const double title
```



### uiBaselineOffset

```dart
static const double uiBaselineOffset
```



### uiFallback

```dart
static const List<String> uiFallback
```



### uiFamily

```dart
static const String uiFamily
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_metrics/klp_metrics.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_metrics/klp_metrics.dart`。
