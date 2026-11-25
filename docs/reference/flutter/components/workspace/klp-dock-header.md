# KlpDockHeader

Flutter · Stable · 工作區元件

## 主要職責

Dock Group 專用的緊湊 Header。

左側區域可由 Layout 包成拖曳來源；右側 actions 是獨立 clickable 區域，
因此操作按鈕不會誤觸 panel 拖曳。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockHeader createExample(Widget leading) => KlpDockHeader(leading: leading);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockHeader extends StatefulWidget
```

## 建構子 KlpDockHeader



```dart
const KlpDockHeader({
	Key? key,
	required Widget leading,
	List<KlpDockHeaderAction> actions = const [],
	KlpDockHeaderDragRegionBuilder? dragRegionBuilder,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `leading` | `Widget` | 是 | — | 前方內容。 |
| `actions` | `List<KlpDockHeaderAction>` | 否 | const [] | 依公開型別提供此輸入。 |
| `dragRegionBuilder` | `Widget Function(Widget)?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpDockHeader> createState()
```

由 Flutter 建立此元件的 State。

### extent

```dart
static const double extent
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpDockHeaderAction](../../types/klp-dock-header-action.md)
- [KlpDockHeaderDragRegionBuilder](../../types/klp-dock-header-drag-region-builder.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_header.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_header.dart`。
