# KlpNavigationRail

Flutter · Stable · 導覽元件

## 主要職責

Workbench 的主要圖示導覽軌。

分組模式只接受 [KlpRailItemGroup]；群組之間自動加入分隔線，項目只能在
原群組內排序。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpNavigationRail createExample(KlpRailItemGroup top, KlpRailItemGroup center, KlpRailItemGroup bottom) => KlpNavigationRail(top: top, center: center, bottom: bottom);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpNavigationRail extends StatefulWidget
```

## 建構子 KlpNavigationRail



```dart
const KlpNavigationRail({
	Key? key,
	required KlpRailItemGroup top,
	required KlpRailItemGroup center,
	required KlpRailItemGroup bottom,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `top` | `KlpRailItemGroup` | 是 | — | 依公開型別提供此輸入。 |
| `center` | `KlpRailItemGroup` | 是 | — | 依公開型別提供此輸入。 |
| `bottom` | `KlpRailItemGroup` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpNavigationRail> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpRailItemGroup](../../types/klp-rail-item-group.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/rail/klp_navigation_rail.dart`。
