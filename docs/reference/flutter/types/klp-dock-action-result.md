# KlpDockActionResult

Flutter · Stable · 資料與型別

## 主要職責

操作結果由產品採用，no-op 也提供隔離快照。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpDockActionResult value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockActionResult
```

## 成員與方法

### changed

```dart
final bool changed
```

完整保存值是否改變。

### layout

```dart
final KlpDockLayoutData layout
```

深層不可變布局，不持有 caller 的可變列表。

<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpDockLayoutData](klp-dock-layout-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_operations.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_operations.dart`。
