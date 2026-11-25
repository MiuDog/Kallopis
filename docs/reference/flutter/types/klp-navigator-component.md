# KlpNavigatorComponent

Flutter · Stable · 資料與型別

## 主要職責

不受 Navigator 固定列高限制的任意元件插槽。

搜尋框、虛線分隔線、按鈕列表等元件保留自己的高度、狀態與事件。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpNavigatorComponent createExample(String id, Widget child) => KlpNavigatorComponent(id: id, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpNavigatorComponent extends KlpNavigatorItem
```

## 建構子 KlpNavigatorComponent



```dart
const KlpNavigatorComponent({required String id, required Widget child})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 繼承／實作：[KlpNavigatorItem](klp-navigator-item.md)。
- [KlpNavigatorItem](klp-navigator-item.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/navigator/klp_navigator_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/navigator/klp_navigator_models.dart`。
