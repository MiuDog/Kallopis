# KlpSegmentedControl

Flutter · Stable · 內容元件

## 主要職責

提供分段選取控制；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSegmentedControl createExample(List<String> items, int selected, void Function(int) onSelected) => KlpSegmentedControl(items: items, selected: selected, onSelected: onSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSegmentedControl extends StatelessWidget
```

## 建構子 KlpSegmentedControl



```dart
const KlpSegmentedControl({
	Key? key,
	required List<String> items,
	required int selected,
	required ValueChanged<int> onSelected,
	List<KlpIconData>? icons,
	List<Key?>? itemKeys,
	bool expanded = false,
	bool dense = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `items` | `List<String>` | 是 | — | 由產品提供的項目。 |
| `selected` | `int` | 是 | — | 由產品持有的選取狀態。 |
| `onSelected` | `void Function(int)` | 是 | — | 將選取意圖交回產品。 |
| `icons` | `List<KlpIconData>?` | 否 | null | 依公開型別提供此輸入。 |
| `itemKeys` | `List<Key?>?` | 否 | null | 依公開型別提供此輸入。 |
| `expanded` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `dense` | `bool` | 否 | false | 依公開型別提供此輸入。 |


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
- [KlpIconData](../../types/klp-icon-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/selection/klp_segmented_control.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_segmented_control.dart`。
