# KlpScheduleList

Flutter · Stable · 資料呈現

## 主要職責

固定時間欄、標題與選填標籤的排程清單。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpScheduleList createExample(List<KlpScheduleItemData> items) => KlpScheduleList(items: items);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpScheduleList extends StatelessWidget
```

## 建構子 KlpScheduleList



```dart
const KlpScheduleList({Key? key, required List<KlpScheduleItemData> items})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `items` | `List<KlpScheduleItemData>` | 是 | — | 由產品提供的項目。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpScheduleItemData](../../types/klp-schedule-item-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/agenda/klp_schedule_list.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/agenda/klp_schedule_list.dart`。
