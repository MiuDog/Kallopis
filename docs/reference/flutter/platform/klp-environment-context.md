# KlpEnvironmentContext

Flutter · Stable · 平台整合

## 主要職責

讓元件直接讀取平台環境，不訂閱 App 控制狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

Object? readExample(BuildContext value) => KlpEnvironmentContext(value).klpPlatform;
```

<!-- reference-api:start -->

## 公開簽名

```dart
extension KlpEnvironmentContext on BuildContext
```

## 成員與方法

### klpPlatform

```dart
KlpPlatformInfo get klpPlatform
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)。
- [KlpPlatformInfo](klp-platform-info.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/platform/klp_environment_context.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/platform/klp_environment_context.dart`。
