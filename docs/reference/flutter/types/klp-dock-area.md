# KlpDockArea

Flutter · Stable · 資料與型別

## 主要職責

固定 Stage 周圍的三個停靠區，不改寫既有 Widget 模型。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpDockArea.bottom;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpDockArea
```

## 建構子 KlpDockArea



```dart
const KlpDockArea()
```



## 成員與方法

### bottom

```dart
static const KlpDockArea bottom
```



### left

```dart
static const KlpDockArea left
```



### right

```dart
static const KlpDockArea right
```



<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_operations.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_operations.dart`。
