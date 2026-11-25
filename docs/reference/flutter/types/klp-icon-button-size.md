# KlpIconButtonSize

Flutter · Stable · 資料與型別

## 主要職責

圖示按鈕的語意尺寸。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpIconButtonSize.standard;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpIconButtonSize
```

## 建構子 KlpIconButtonSize



```dart
const KlpIconButtonSize()
```



## 成員與方法

### standard

```dart
static const KlpIconButtonSize standard
```

一般控制項尺寸。

### window

```dart
static const KlpIconButtonSize window
```

視窗標題列尺寸，與 App icon 的正方形槽位一致。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/button/klp_icon_button_size.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/button/klp_icon_button_size.dart`。
