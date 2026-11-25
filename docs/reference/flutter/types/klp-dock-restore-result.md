# KlpDockRestoreResult

Flutter · Stable · 資料與型別

## 主要職責

載入成功後的布局與清冊差異，由產品決定是否採用。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpDockRestoreResult value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockRestoreResult
```

## 成員與方法

### availablePanelIds

```dart
final List<String> availablePanelIds
```

按清冊順序列出可由產品開啟的未放置面板。

### layout

```dart
final KlpDockLayoutData layout
```

深層不可變快照，不持有產品原始列表。

### missingPanelIds

```dart
final List<String> missingPanelIds
```

按保存區域、群組與分頁順序列出不存在的面板。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpDockLayoutData](klp-dock-layout-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_codec.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_codec.dart`。
