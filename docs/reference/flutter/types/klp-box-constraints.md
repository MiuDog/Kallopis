# KlpBoxConstraints

Flutter · Stable · 資料與型別

## 主要職責

約束排版原語使用的型別化幾何介面。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpBoxConstraints createExample() => KlpBoxConstraints();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpBoxConstraints
```

## 建構子 KlpBoxConstraints



```dart
const KlpBoxConstraints({
	double minWidth = 0,
	double maxWidth = double.infinity,
	double minHeight = 0,
	double maxHeight = double.infinity,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `minWidth` | `double` | 否 | 0 | 依公開型別提供此輸入。 |
| `maxWidth` | `double` | 否 | double.infinity | 依公開型別提供此輸入。 |
| `minHeight` | `double` | 否 | 0 | 依公開型別提供此輸入。 |
| `maxHeight` | `double` | 否 | double.infinity | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/layout/klp_box_constraints.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_box_constraints.dart`。
