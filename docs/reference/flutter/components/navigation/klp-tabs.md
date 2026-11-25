# KlpTabs

Flutter · Stable · 導覽元件

## 主要職責

分頁列。`selected` 是索引，`tabs` 是顯示文字；本元件不持有狀態。

*鍵盤**：任一分頁取得焦點後，`←`／`→` 會在分頁之間移動並直接切換選取
（在頭尾之間循環），沿用 [KlpRovingIndex]，與 [KlpMenu]、[KlpCombobox] 共用
同一套索引移動規則。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTabs createExample(List<String> tabs, int selected, void Function(int) onSelected) => KlpTabs(tabs: tabs, selected: selected, onSelected: onSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTabs extends StatelessWidget
```

## 建構子 KlpTabs



```dart
const KlpTabs({
	Key? key,
	required List<String> tabs,
	required int selected,
	required ValueChanged<int> onSelected,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `tabs` | `List<String>` | 是 | — | 依公開型別提供此輸入。 |
| `selected` | `int` | 是 | — | 由產品持有的選取狀態。 |
| `onSelected` | `void Function(int)` | 是 | — | 將選取意圖交回產品。 |


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

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/tabs/klp_tabs.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/tabs/klp_tabs.dart`。
