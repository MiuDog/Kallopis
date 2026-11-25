# KlpTaskItemData

Flutter · Stable · 資料與型別

## 主要職責

待辦項目的視圖資料契約。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTaskItemData createExample(String title, String detail) => KlpTaskItemData(title: title, detail: detail);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTaskItemData
```

## 建構子 KlpTaskItemData



```dart
const KlpTaskItemData({
	String id = '',
	required String title,
	required String detail,
	bool checked = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 否 | '' | 穩定識別，用於查詢或回報。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `detail` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `checked` | `bool` | 否 | false | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/agenda/klp_task_item_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/agenda/klp_task_item_data.dart`。
