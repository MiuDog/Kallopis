# KlpFilterBar

Flutter · Stable · 內容元件

## 主要職責

篩選工具列。支援標籤、鍵值對、移除按鈕與新增篩選動作。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFilterBar createExample(List<KlpFilterOption> filters, String? selectedId, void Function(String) onSelected) => KlpFilterBar(filters: filters, selectedId: selectedId, onSelected: onSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFilterBar extends StatelessWidget
```

## 建構子 KlpFilterBar



```dart
const KlpFilterBar({
	Key? key,
	required List<KlpFilterOption> filters,
	required String? selectedId,
	required ValueChanged<String> onSelected,
	ValueChanged<String>? onRemove,
	VoidCallback? onAddFilter,
	VoidCallback? onClearAll,
	String addLabel = '+ Filter',
	String clearAllLabel = 'Clear all',
	Widget? leading,
	Widget? trailing,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `filters` | `List<KlpFilterOption>` | 是 | — | 依公開型別提供此輸入。 |
| `selectedId` | `String?` | 是 | — | 產品持有的選取識別。 |
| `onSelected` | `void Function(String)` | 是 | — | 將選取意圖交回產品。 |
| `onRemove` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `onAddFilter` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onClearAll` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `addLabel` | `String` | 否 | '+ Filter' | 依公開型別提供此輸入。 |
| `clearAllLabel` | `String` | 否 | 'Clear all' | 依公開型別提供此輸入。 |
| `leading` | `Widget?` | 否 | null | 前方內容。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |


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
- [KlpFilterOption](../../types/klp-filter-option.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/interaction/filter/klp_filter_bar.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/filter/klp_filter_bar.dart`。
