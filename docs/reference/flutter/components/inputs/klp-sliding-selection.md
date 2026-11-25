# KlpSlidingSelection

Flutter · Stable · 輸入元件

## 主要職責

提供滑動式選取呈現；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSlidingSelection createExample(String label, int selectedIndex, List<KlpSelectionOption> options, void Function(int)? onSelected) => KlpSlidingSelection(label: label, selectedIndex: selectedIndex, options: options, onSelected: onSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSlidingSelection extends StatelessWidget
```

## 建構子 KlpSlidingSelection



```dart
const KlpSlidingSelection({
	Key? key,
	required String label,
	required int selectedIndex,
	required List<KlpSelectionOption> options,
	required ValueChanged<int>? onSelected,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `selectedIndex` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `options` | `List<KlpSelectionOption>` | 是 | — | 依公開型別提供此輸入。 |
| `onSelected` | `void Function(int)?` | 是 | — | 將選取意圖交回產品。 |


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
- [KlpSelectionOption](../../types/klp-selection-option.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/selection/klp_sliding_selection.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_sliding_selection.dart`。
