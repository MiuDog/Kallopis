# KlpRailItemGroup

Flutter · Stable · 資料與型別

## 主要職責

提供導覽列群組資料；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRailItemGroup createExample(String id, List<KlpRailEntry> items) => KlpRailItemGroup(id: id, items: items);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRailItemGroup
```

## 建構子 KlpRailItemGroup



```dart
const KlpRailItemGroup({
	required String id,
	required List<KlpRailEntry> items,
	KlpRailGroupReorderCallback? onReorder,
	bool isReorderable = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `items` | `List<KlpRailEntry>` | 是 | — | 由產品提供的項目。 |
| `onReorder` | `void Function(int, int)?` | 否 | null | 依公開型別提供此輸入。 |
| `isReorderable` | `bool` | 否 | true | 是否允許此群組內的項目拖曳排序。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpRailEntry](klp-rail-entry.md)
- [KlpRailGroupReorderCallback](klp-rail-group-reorder-callback.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/rail/klp_rail_item_group.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/rail/klp_rail_item_group.dart`。
