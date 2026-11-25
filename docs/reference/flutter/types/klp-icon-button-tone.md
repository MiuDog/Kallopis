# KlpIconButtonTone

Flutter · Stable · 資料與型別

## 主要職責

圖示按鈕在版面中的角色，不是外觀參數。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpIconButtonTone.inline;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpIconButtonTone
```

## 建構子 KlpIconButtonTone



```dart
const KlpIconButtonTone()
```



## 成員與方法

### inline

```dart
static const KlpIconButtonTone inline
```

嵌在既有表面上：靜置透明，只在互動或選取時浮出底色。

### standalone

```dart
static const KlpIconButtonTone standalone
```

獨立控制項：靜置時就有底色，讓它在空白區域中可辨識。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/button/klp_icon_button_tone.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/button/klp_icon_button_tone.dart`。
