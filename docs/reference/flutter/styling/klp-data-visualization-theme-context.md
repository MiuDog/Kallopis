# KlpDataVisualizationThemeContext

Flutter · Stable · 語意風格

## 主要職責

提供BuildContext 上的資料視覺化風格存取；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_theme.dart';

Object? readExample(BuildContext value) => KlpDataVisualizationThemeContext(value).klpDataVisualization;
```

<!-- reference-api:start -->

## 公開簽名

```dart
extension KlpDataVisualizationThemeContext on BuildContext
```

## 成員與方法

### klpDataVisualization

```dart
KlpDataVisualizationTheme get klpDataVisualization
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)。
- [KlpDataVisualizationTheme](klp-data-visualization-theme.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_data_visualization_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_data_visualization_theme.dart`。
