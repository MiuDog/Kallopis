# klpStyleParameters

Flutter · Stable · 語意風格

## 主要職責

共通型別與限制由 catalog 擁有，不隨 consumer 風格變更。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

final productKlpStyleParameters = klpStyleParameters;
```

<!-- reference-api:start -->

## 公開簽名

```dart
Map<String, Object?> klpStyleParameters
```

<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/style_pack/klp_style_pack.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/style_pack/klp_style_pack.dart`。
