# KlpActionRegionStyle

Flutter · Stable · 資料與型別

## 主要職責

動作區域解析後提供給內容的視覺介面。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpActionRegionStyle createExample(Color foreground) => KlpActionRegionStyle(foreground: foreground);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpActionRegionStyle
```

## 建構子 KlpActionRegionStyle



```dart
const KlpActionRegionStyle({required Color foreground})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `foreground` | `Color` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/klp_action_region_style.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/klp_action_region_style.dart`。
