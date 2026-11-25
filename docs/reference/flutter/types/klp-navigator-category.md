# KlpNavigatorCategory

Flutter · Stable · 資料與型別

## 主要職責

可展開與收合的一組 Navigator 項目。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpNavigatorCategory createExample(String id, String label) => KlpNavigatorCategory(id: id, label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpNavigatorCategory extends KlpNavigatorItem
```

## 建構子 KlpNavigatorCategory



```dart
const KlpNavigatorCategory({
	required String id,
	required String label,
	List<KlpNavigatorItem> items = const [],
	bool expanded = true,
	bool collapsible = true,
	Widget? trailing,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `items` | `List<KlpNavigatorItem>` | 否 | const [] | 由產品提供的項目。 |
| `expanded` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `collapsible` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 繼承／實作：[KlpNavigatorItem](klp-navigator-item.md)。
- [KlpNavigatorItem](klp-navigator-item.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/navigator/klp_navigator_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/navigator/klp_navigator_models.dart`。
