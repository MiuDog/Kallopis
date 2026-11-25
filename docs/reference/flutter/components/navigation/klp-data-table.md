# KlpDataTable

Flutter · Stable · 導覽元件

## 主要職責

結構化資料表格：固定欄位、可選排序與多選。

不做分頁或虛擬捲動。選取與排序狀態由呼叫端持有，元件只回報意圖。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDataTable createExample(List<KlpDataColumn> columns, List<KlpDataRow> rows) => KlpDataTable(columns: columns, rows: rows);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDataTable extends StatelessWidget
```

## 建構子 KlpDataTable



```dart
const KlpDataTable({
	Key? key,
	required List<KlpDataColumn> columns,
	required List<KlpDataRow> rows,
	ValueChanged<String>? onRowPressed,
	bool selectable = false,
	Set<String> selectedIds = const {},
	KlpDataSort? sort,
	ValueChanged<Set<String>>? onSelected,
	ValueChanged<String>? onSort,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `columns` | `List<KlpDataColumn>` | 是 | — | 依公開型別提供此輸入。 |
| `rows` | `List<KlpDataRow>` | 是 | — | 依公開型別提供此輸入。 |
| `onRowPressed` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `selectable` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `selectedIds` | `Set<String>` | 否 | const {} | 依公開型別提供此輸入。 |
| `sort` | `KlpDataSort?` | 否 | null | 依公開型別提供此輸入。 |
| `onSelected` | `void Function(Set<String>)?` | 否 | null | 將選取意圖交回產品。 |
| `onSort` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpDataColumn](../../types/klp-data-column.md)
- [KlpDataRow](../../types/klp-data-row.md)
- [KlpDataSort](../../types/klp-data-sort.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/advanced/klp_advanced_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/advanced/klp_advanced_data.dart`。
