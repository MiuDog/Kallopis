# KlpActionRegion

Flutter · Stable · 操作元件

## 主要職責

統一封裝按鈕語意、hover、focus 與可點擊表面的互動原語。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpActionRegion createExample(String label, void Function()? onPressed, Widget Function(BuildContext, KlpActionRegionStyle) builder) => KlpActionRegion(label: label, onPressed: onPressed, builder: builder);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpActionRegion extends StatelessWidget
```

## 建構子 KlpActionRegion



```dart
const KlpActionRegion({
	Key? key,
	required String label,
	required VoidCallback? onPressed,
	required Widget Function(BuildContext, KlpActionRegionStyle) builder,
	KlpActionRegionTone tone = KlpActionRegionTone.neutral,
	bool selected = false,
	bool active = false,
	bool? toggled,
	bool? expanded,
	KlpActionRegionShape shape = KlpActionRegionShape.card,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()?` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `builder` | `Widget Function(BuildContext, KlpActionRegionStyle)` | 是 | — | 依公開型別提供此輸入。 |
| `tone` | `KlpActionRegionTone` | 否 | KlpActionRegionTone.neutral | 選擇語意呈現。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `active` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `toggled` | `bool?` | 否 | null | 依公開型別提供此輸入。 |
| `expanded` | `bool?` | 否 | null | 依公開型別提供此輸入。 |
| `shape` | `KlpActionRegionShape` | 否 | KlpActionRegionShape.card | 依公開型別提供此輸入。 |


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
- [KlpActionRegionShape](../../types/klp-action-region-shape.md)
- [KlpActionRegionStyle](../../types/klp-action-region-style.md)
- [KlpActionRegionTone](../../types/klp-action-region-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/interaction/klp_action_region.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/klp_action_region.dart`。
