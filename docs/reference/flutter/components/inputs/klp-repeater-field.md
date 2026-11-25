# KlpRepeaterField

Flutter · Stable · 輸入元件

## 主要職責

可新增／刪除項目的重複欄位群組（例如「新增一組聯絡方式」）。

不維護項目清單的狀態——[items] 由呼叫端持有，新增／刪除都只是透過
[onAdd]／[onRemove] 回報意圖，實際要不要新增一項、刪哪一項由呼叫端決定
並重新傳入新的 [items]。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRepeaterField createExample(String label, String addLabel, String removeLabel, List<KlpRepeaterItem> items, void Function()? onAdd, void Function(String)? onRemove) => KlpRepeaterField(label: label, addLabel: addLabel, removeLabel: removeLabel, items: items, onAdd: onAdd, onRemove: onRemove);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRepeaterField extends StatelessWidget
```

## 建構子 KlpRepeaterField



```dart
const KlpRepeaterField({
	Key? key,
	required String label,
	required String addLabel,
	required String removeLabel,
	required List<KlpRepeaterItem> items,
	required VoidCallback? onAdd,
	required ValueChanged<String>? onRemove,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `addLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `removeLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `items` | `List<KlpRepeaterItem>` | 是 | — | 由產品提供的項目。 |
| `onAdd` | `void Function()?` | 是 | — | 依公開型別提供此輸入。 |
| `onRemove` | `void Function(String)?` | 是 | — | 依公開型別提供此輸入。 |


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
- [KlpRepeaterItem](../../types/klp-repeater-item.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/structured/klp_repeater_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/structured/klp_repeater_field.dart`。
