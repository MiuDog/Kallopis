# KlpPasswordRequirement

Flutter · Stable · 資料與型別

## 主要職責

密碼規則要求項。包含檢核描述與是否滿足之狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPasswordRequirement createExample(String label, bool satisfied) => KlpPasswordRequirement(label: label, satisfied: satisfied);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPasswordRequirement
```

## 建構子 KlpPasswordRequirement



```dart
const KlpPasswordRequirement({required String label, required bool satisfied})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `satisfied` | `bool` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/input/klp_password_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/input/klp_password_field.dart`。
