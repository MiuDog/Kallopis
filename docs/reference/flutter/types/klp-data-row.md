# KlpDataRow

Flutter · Stable · 資料與型別

## 主要職責

提供資料表的列資料；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDataRow createExample(String id, Map<String, Object> cells) => KlpDataRow(id: id, cells: cells);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDataRow
```

## 建構子 KlpDataRow



```dart
const KlpDataRow({required String id, required Map<String, Object> cells})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `cells` | `Map<String, Object>` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/advanced/models/klp_advanced_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/advanced/models/klp_advanced_models.dart`。
