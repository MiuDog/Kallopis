# KlpRepeaterItem

Flutter · Stable · 資料與型別

## 主要職責

[KlpRepeaterField] 裡的一個項目：識別碼加上該項目自己的輸入內容。

[child] 是整個項目的內容 widget（例如一組欄位），[id] 只用來在
[KlpRepeaterField.onRemove] 回報要刪除哪一項，與顯示內容無關。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRepeaterItem createExample(String id, Widget child) => KlpRepeaterItem(id: id, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRepeaterItem
```

## 建構子 KlpRepeaterItem



```dart
const KlpRepeaterItem({required String id, required Widget child})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/structured/klp_repeater_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/structured/klp_repeater_field.dart`。
