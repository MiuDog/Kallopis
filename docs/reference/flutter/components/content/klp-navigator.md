# KlpNavigator

Flutter · Stable · 內容元件

## 主要職責

Sidebar 的通用導覽組成。

Category 與 Element 沿用 Kallopis Catalog 目錄的視覺與高度；Component 是
不受固定列高限制的插槽。產品只提供資料、受控狀態與事件。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpNavigator createExample(List<KlpNavigatorItem> items) => KlpNavigator(items: items);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpNavigator extends StatefulWidget
```

## 建構子 KlpNavigator



```dart
const KlpNavigator({
	Key? key,
	required List<KlpNavigatorItem> items,
	Set<String>? expandedCategoryIds,
	Set<String>? expandedElementIds,
	String? selectedElementId,
	ValueChanged<String>? onCategoryToggle,
	ValueChanged<String>? onElementToggle,
	ValueChanged<String>? onElementSelected,
	KlpSurfaceTone surfaceTone = KlpSurfaceTone.inset,
	Key? scrollKey,
	ScrollController? scrollController,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `items` | `List<KlpNavigatorItem>` | 是 | — | 由產品提供的項目。 |
| `expandedCategoryIds` | `Set<String>?` | 否 | null | 依公開型別提供此輸入。 |
| `expandedElementIds` | `Set<String>?` | 否 | null | 依公開型別提供此輸入。 |
| `selectedElementId` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onCategoryToggle` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `onElementToggle` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `onElementSelected` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `surfaceTone` | `KlpSurfaceTone` | 否 | KlpSurfaceTone.inset | 依公開型別提供此輸入。 |
| `scrollKey` | `Key?` | 否 | null | 依公開型別提供此輸入。 |
| `scrollController` | `ScrollController?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpNavigator> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpNavigatorItem](../../types/klp-navigator-item.md)
- [KlpSurfaceTone](../../types/klp-surface-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/navigator/klp_navigator.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/navigator/klp_navigator.dart`。
