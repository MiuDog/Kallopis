# KlpNavigationRailFrame

Flutter · Stable · 導覽元件

## 主要職責

Rail 的獨立表面相容配方。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpNavigationRailFrame createExample(Widget child) => KlpNavigationRailFrame(child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpNavigationRailFrame extends KlpPanelFrame
```

## 建構子 KlpNavigationRailFrame



```dart
const KlpNavigationRailFrame({Key? key, required Widget child})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 繼承／實作：[KlpPanelFrame](../layout/klp-panel-frame.md)。
- [KlpPanelFrame](../layout/klp-panel-frame.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/composition/klp_navigation_rail_frame.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/composition/klp_navigation_rail_frame.dart`。
