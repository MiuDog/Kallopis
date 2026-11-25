# KlpScheduleItemData

Flutter · Stable · 資料與型別

## 主要職責

排程項目的視圖資料契約。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpScheduleItemData createExample(String time, String title) => KlpScheduleItemData(time: time, title: title);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpScheduleItemData
```

## 建構子 KlpScheduleItemData



```dart
const KlpScheduleItemData({
	String id = '',
	required String time,
	required String title,
	String? tag,
	KlpFeedbackTone tone = KlpFeedbackTone.neutral,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 否 | '' | 穩定識別，用於查詢或回報。 |
| `time` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `tag` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `tone` | `KlpFeedbackTone` | 否 | KlpFeedbackTone.neutral | 選擇語意呈現。 |


## 成員與方法

### label

```dart
String get label
```

顯示標籤。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpFeedbackTone](klp-feedback-tone.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/agenda/klp_schedule_item_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/agenda/klp_schedule_item_data.dart`。
