# KlpWindowControlsStyle

Flutter · Stable · 資料與型別

## 主要職責

視窗控制按鈕的平台排列策略。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpWindowControlsStyle.adaptive;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpWindowControlsStyle
```

## 建構子 KlpWindowControlsStyle



```dart
const KlpWindowControlsStyle()
```



## 成員與方法

### adaptive

```dart
static const KlpWindowControlsStyle adaptive
```

交由 KlpAdaptive 判斷平台。

### macOS

```dart
static const KlpWindowControlsStyle macOS
```

macOS／iOS 排列。

### windows

```dart
static const KlpWindowControlsStyle windows
```

Windows／Linux 排列。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。
- [KlpAdaptive](../components/content/klp-adaptive.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/window/klp_window_controls_style.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/window/klp_window_controls_style.dart`。
