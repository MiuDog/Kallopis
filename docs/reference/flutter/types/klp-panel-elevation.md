# KlpPanelElevation

Flutter · Stable · 資料與型別

## 主要職責

面板表面層次；raised 使用既有微立體陰影與亮邊。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpPanelElevation.flat;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpPanelElevation
```

## 建構子 KlpPanelElevation



```dart
const KlpPanelElevation()
```



## 成員與方法

### flat

```dart
static const KlpPanelElevation flat
```



### raised

```dart
static const KlpPanelElevation raised
```



<!-- reference-api:end -->

## 使用限制與關聯

- [3. 投影狀態與回傳事件](../../../guides/flutter/04-klp-panel-frame.md)：跨元件使用流程。
- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/panel/klp_panel_frame.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/panel/klp_panel_frame.dart`。
