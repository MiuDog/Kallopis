# KlpThemePreviewMode

Flutter · Stable · 語意風格

## 主要職責

可由主題預覽磚呈現的中性顏色模式。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpThemePreviewMode.dark;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpThemePreviewMode
```

## 建構子 KlpThemePreviewMode



```dart
const KlpThemePreviewMode()
```



## 成員與方法

### dark

```dart
static const KlpThemePreviewMode dark
```



### light

```dart
static const KlpThemePreviewMode light
```



### system

```dart
static const KlpThemePreviewMode system
```



### transparent

```dart
static const KlpThemePreviewMode transparent
```



### ultraDark

```dart
static const KlpThemePreviewMode ultraDark
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/theme/klp_theme_preview_mode.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/theme/klp_theme_preview_mode.dart`。
