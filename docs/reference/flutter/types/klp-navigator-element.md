# KlpNavigatorElement

Flutter · Stable · 資料與型別

## 主要職責

可在根層或分類內出現，並可遞迴包含子元素的 Navigator 節點。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpNavigatorElement createExample(String id, String label) => KlpNavigatorElement(id: id, label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpNavigatorElement extends KlpNavigatorItem
```

## 建構子 KlpNavigatorElement



```dart
const KlpNavigatorElement({
	required String id,
	required String label,
	KlpIconData? icon,
	List<KlpNavigatorElement> children = const [],
	bool expandable = false,
	bool expanded = false,
	bool selected = false,
	String? badge,
	Widget? trailing,
	Object? data,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |
| `children` | `List<KlpNavigatorElement>` | 否 | const [] | 產品提供的子內容。 |
| `expandable` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `expanded` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `badge` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |
| `data` | `Object?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### isBranch

```dart
bool get isBranch
```



<!-- reference-api:end -->

## 使用限制與關聯

- 繼承／實作：[KlpNavigatorItem](klp-navigator-item.md)。
- [KlpNavigatorItem](klp-navigator-item.md)
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/navigator/klp_navigator_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/navigator/klp_navigator_models.dart`。
