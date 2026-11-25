# KlpDateGridItem

Flutter · Stable · 資料與型別

## 主要職責

日期格內容；只描述顯示資料，不擁有行事曆領域規則。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDateGridItem createExample(String label) => KlpDateGridItem(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDateGridItem
```

## 建構子 KlpDateGridItem



```dart
const KlpDateGridItem({
	required String label,
	List<String> lines = const [],
	bool selected = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `lines` | `List<String>` | 否 | const [] | 依公開型別提供此輸入。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/date_grid/klp_date_grid_item.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/date_grid/klp_date_grid_item.dart`。
