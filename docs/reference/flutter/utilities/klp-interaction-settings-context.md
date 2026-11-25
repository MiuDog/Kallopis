# KlpInteractionSettingsContext

Flutter · Stable · 工具函式

## 主要職責

提供BuildContext 上的互動設定存取；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

Object? readExample(BuildContext value) => KlpInteractionSettingsContext(value).klpLongPressThreshold;
```

<!-- reference-api:start -->

## 公開簽名

```dart
extension KlpInteractionSettingsContext on BuildContext
```

## 成員與方法

### klpLongPressThreshold

```dart
Duration get klpLongPressThreshold
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/klp_interaction_settings.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/klp_interaction_settings.dart`。
