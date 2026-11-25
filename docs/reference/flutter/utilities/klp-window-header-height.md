# klpWindowHeaderHeight

Flutter · Stable · 工具函式

## 主要職責

解析 Header 的版面占位高度。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final productKlpWindowHeaderHeight = klpWindowHeaderHeight;
```

<!-- reference-api:start -->

## 公開簽名

```dart
double klpWindowHeaderHeight(KlpGeometryTheme geometry, {double? windowHeaderMargin})
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `geometry` | `KlpGeometryTheme` | 是 | — | 依公開型別提供此輸入。 |
| `windowHeaderMargin` | `double?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯


- [KlpGeometryTheme](../styling/klp-geometry-theme.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/window/klp_window_header_height.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/window/klp_window_header_height.dart`。
