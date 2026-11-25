# KlpThemeContext

Flutter · Stable · 語意風格

## 主要職責

讓元件寫 `context.klp.space.base`。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_theme.dart';

Object? readExample(BuildContext value) => KlpThemeContext(value).klp;
```

<!-- reference-api:start -->

## 公開簽名

```dart
extension KlpThemeContext on BuildContext
```

## 成員與方法

### klp

```dart
KlpTheme get klp
```

全部 token 層。新程式碼一律用這個。

### klpColors

```dart
KlpThemeData get klpColors
```

只取色彩層的捷徑。色彩是最常單獨使用的一層，因此保留這個縮寫，
但它不是取得其他 token 的途徑——間距、圓角、動畫都必須經由 [klp]。

*它委派給 [klp]，不自己解析。** 先前這裡有一份獨立的
`extension<KlpThemeData>() ?? KlpThemeData.light`，與 [KlpTheme.of] 裡的那份
是同一條規則的兩份實作——改了其中一份的回退行為，另一份不會報錯，只是不一致。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)。
- [KlpTheme](klp-theme.md)
- [KlpThemeData](klp-theme-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_theme_scope.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_theme_scope.dart`。
