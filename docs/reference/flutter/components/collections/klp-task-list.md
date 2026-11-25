# KlpTaskList

Flutter · Stable · 資料呈現

## 主要職責

帶有核取狀態與輔助資訊的待辦清單。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTaskList createExample(List<KlpTaskItemData> items) => KlpTaskList(items: items);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTaskList extends StatelessWidget
```

## 建構子 KlpTaskList



```dart
const KlpTaskList({
	Key? key,
	required List<KlpTaskItemData> items,
	void Function(int, bool)? onChanged,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `items` | `List<KlpTaskItemData>` | 是 | — | 由產品提供的項目。 |
| `onChanged` | `void Function(int, bool)?` | 否 | null | 將值的變更交回產品。 |


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
- [KlpTaskItemData](../../types/klp-task-item-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/agenda/klp_task_list.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/agenda/klp_task_list.dart`。
