# KlpPanelHeaderDragRegionBuilder

Flutter · Stable · 資料與型別

## 主要職責

將面板標題內容包裝成平台拖曳區的建構契約。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpPanelHeaderDragRegionBuilder value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
typedef KlpPanelHeaderDragRegionBuilder = Widget Function(Widget)
```

<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/panel/klp_panel_header_drag_region_builder.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/panel/klp_panel_header_drag_region_builder.dart`。
